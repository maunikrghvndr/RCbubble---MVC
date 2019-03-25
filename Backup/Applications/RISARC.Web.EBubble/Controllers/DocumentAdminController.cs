using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Ajax;
using RISARC.Documents.Model;
using RISARC.Web.EBubble.Models.Binders;
using RISARC.Documents.Service;
using RISARC.Encryption.Service;
using Microsoft.Practices.EnterpriseLibrary.ExceptionHandling;
using SpiegelDg.Common.Validation;
using SpiegelDg.Common.Web.Extensions;
using RISARC.Membership.Service;
using System.Web.Security;
using RISARC.Emr.Web.DataTypes;
using SpiegelDg.Common.Web.Model;
using System.Web.Routing;
using System.Collections.ObjectModel;
using RISARC.Setup.Service;
using RISARC.Common.Model;
using RISARC.Setup.Model;
using SpiegelDg.Security.Model;
using RISARC.Common.Utilities;
using CommonExceptionHandling = RISARC.Common.ExceptionHandling;
using RISARC.Documents.Model.PatientIdentification;
using RISARC.Files.Model;
using RISARC.Files.Service;

namespace RISARC.Web.EBubble.Controllers
{
    public class DocumentAdminController : Controller
    {
        private IDocumentsAdminService _DocumentsAdminService;
        private IDocumentsRetrievalService _DocumentsRetrievalService;
        private IRMSeBubbleMempershipService _MembershipService;
        private const string _FileHeaderKey = "content-disposition";
        private const string _FileHeaderFormat = "attachment; filename={0}";

        public DocumentAdminController(IDocumentsAdminService adminService, IDocumentsRetrievalService documentsRetrievalService, IRMSeBubbleMempershipService membershipService)
        {
            this._DocumentsAdminService = adminService;
            this._DocumentsRetrievalService = documentsRetrievalService;
            this._MembershipService = membershipService;
        }

        #region Document Related

        [AuditingAuthorizeAttribute("AdministrateDocument", Roles = "DocumentAdmin")]
        public ActionResult Index([ModelBinder(typeof(EncryptedStringBinder))] string documentId)
        {
            int actualDocumentId;
            DocumentStatus status;

            actualDocumentId = Convert.ToInt32(documentId);

            status = _DocumentsRetrievalService.GetDocumentStatus(actualDocumentId);

            switch (status)
            {
                case DocumentStatus.LockedOutFromAttemptedVerifications:
                    return UnlockVerification(actualDocumentId);
                case DocumentStatus.AwaitingComplianceApproval:
                    return ReviewCompliance(actualDocumentId);
                default:
                    throw new InvalidOperationException("Cannot get view for document state " + status.ToString() + ".");

            }
        }       

        #region Verification Unlocking

        [AcceptVerbs(HttpVerbs.Get)]
        [AuditingAuthorizeAttribute("UnlockVerification", Roles = "DocumentAdmin")]
        public ActionResult UnlockVerification([ModelBinder(typeof(EncryptedIntegerBinder))] int documentId)
        {
            Document document = _DocumentsRetrievalService.GetDocument(documentId);
            return View("UnlockVerification", document);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="postOverload">Both methods take same paramters, but here to allow same name for diff methods</param>
        /// <param name="documentId"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ValidateAntiForgeryToken]
        [AuditingAuthorizeAttribute("UnlockVerificationPost", Roles = "DocumentAdmin")]
        public ActionResult UnlockVerification(string postOverload, [ModelBinder(typeof(EncryptedIntegerBinder))] int documentId)
        {
            _DocumentsAdminService.ResetVerificationCount(documentId);
            return View("VerificationUnlocked");
        }

        #endregion

        #region Compliance

        /// <summary>
        /// Displays compliance forms for admin to review
        /// </summary>
        /// <param name="documentId"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        [AuditingAuthorizeAttribute("ReviewCompliance", Roles = "DocumentAdmin")]
        public ActionResult ReviewCompliance([ModelBinder(typeof(EncryptedIntegerBinder))] int documentId)
        {
            ViewData["DocumentId"] = documentId;
            ComplianceSubmittalMode complianceSubmittalMode;

            complianceSubmittalMode = _DocumentsRetrievalService.GetComplianceSubmittalMode(documentId);
            ViewData["ComplianceSubmittalMode"] = complianceSubmittalMode;
            
            return View("ReviewCompliance");
        }

        [AuditingAuthorizeAttribute("DownloadSubmittedCompliance", Roles = "DocumentAdmin")]
        public FileStreamResult DownloadSubmittedCompliance([ModelBinder(typeof(EncryptedIntegerBinder))] int documentId)
        {
            FileStreamResult fileStreamResult;
            DocumentFile documentFile;

            documentFile = _DocumentsAdminService.GetUsersSentInCompliance(documentId);
            fileStreamResult = new FileStreamResult(documentFile.Stream, documentFile.ContentType);

            // make sure so that they download it rather then it takes them to new url
            HttpContext.Response.AddHeader(_FileHeaderKey,
                String.Format(_FileHeaderFormat, documentFile.FileName));

            return fileStreamResult;
        }

        /// <summary>
        /// Allows document admin to either approve or reject the user's submitted compliance document
        /// </summary>
        /// <param name="documentId"></param>
        /// <param name="approve">If should approve or reject the document</param>
        /// <param name="reason"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ValidateAntiForgeryToken]
        [AuditingAuthorizeAttribute("ReviewCompliancePost", Roles = "DocumentAdmin")]
        public ActionResult ReviewCompliance([ModelBinder(typeof(EncryptedIntegerBinder))] int documentId, bool approve, string reason)
        {
            string statusMessage;
            ComplianceSubmittalMode complianceSubmittalMode;

            try
            {
                _DocumentsAdminService.SetComplianceDocApproval(documentId, approve, reason);
            }
            catch (RuleException ex)
            {
                ex.CopyToModelState(ModelState);
            }

            if (ModelState.IsValid)
            {
                // status message depends on if approved or dissaproved
                statusMessage = approve ? "User's release form has been approved and they have been notified" :
                    "USER’S RELEASE FORM HAS BEEN DENIED AND THEY HAVE BEEN NOTIFIED";

                // redirect back to outstanding release forms page
                return RedirectToAction("MyReleaseForms",
                    "ViewDocuments",
                    new
                    {
                        pageNumber = 1,
                        statusMessage = statusMessage
                    });
            }
            else
            {

                complianceSubmittalMode = _DocumentsRetrievalService.GetComplianceSubmittalMode(documentId);
                ViewData["ComplianceSubmittalMode"] = complianceSubmittalMode;
                ViewData["DocumentId"] = documentId;

                return View();
            }
        }

        #endregion

        #endregion

        #region Request Related

        /// <summary>
        /// Routes request admin to the proper state
        /// </summary>
        /// <param name="requestId"></param>
        /// <returns></returns>
        [AuditingAuthorizeAttribute("AdministrateDocument", Roles = "DocumentAdmin")]
        public ActionResult DocumentRequest([ModelBinder(typeof(EncryptedStringBinder))] string requestId)
        {
            int actualRequestId;

            actualRequestId = Convert.ToInt32(requestId);
            _MembershipService.GetRSAKeysForUserAndSuperAdmin(User.Identity.Name, DocumentFileProcessor.EnableFileEncryption);
            return DocumentRequest(actualRequestId);
        }

        private ActionResult DocumentRequest(int requestId)
        {
            DocumentStatus status;
            status = _DocumentsRetrievalService.GetDocumentRequestStatus(requestId);

            switch (status)
            {

                //case DocumentStatus.RequestSent:
                //    return RespondToRequest(actualRequestId);
                case DocumentStatus.AwaitingComplianceApproval:
                    return ReviewRequestCompliance(requestId);
                case DocumentStatus.RequestAwaitingDocument:
                    return SendDocumentForRequest(requestId);
                case DocumentStatus.RequestRespondedTo:
                    return RequestRespondedTo();
                case DocumentStatus.ComplianceRejected:
                    return RequestCancelled();
                case DocumentStatus.Cancelled:
                    return RequestCancelled();
                default:
                    throw new InvalidOperationException("No proper state for request");

            }
        }


        #region Request Response

        /// <summary>
        /// Displays compliance forms for admin to review
        /// </summary>
        /// <param name="documentId"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        [AuditingAuthorizeAttribute("ReviewRequestCompliance", Roles = "DocumentAdmin")]
        public ActionResult ReviewRequestCompliance([ModelBinder(typeof(EncryptedIntegerBinder))] int requestId)
        {
            ViewData["RequestId"] = requestId;

            return View("ReviewRequestCompliance");
        }

        [AuditingAuthorizeAttribute("DownloadSubmittedRequestCompliance", Roles = "DocumentAdmin")]
        public FileStreamResult DownloadSubmittedRequestCompliance([ModelBinder(typeof(EncryptedIntegerBinder))] int requestId)
        {
            FileStreamResult fileStreamResult;
            DocumentFile documentFile;

            documentFile = _DocumentsAdminService.GetUsersSentInRequestCompliance(requestId);
            fileStreamResult = new FileStreamResult(documentFile.Stream, documentFile.ContentType);

            // make sure so that they download it rather then it takes them to new url
            HttpContext.Response.AddHeader(_FileHeaderKey,
                String.Format(_FileHeaderFormat, documentFile.FileName));

            return fileStreamResult;
        }

        /// <summary>
        /// Allows document admin to either approve or reject the user's submitted compliance document
        /// </summary>
        /// <param name="documentId"></param>
        /// <param name="approve">If should approve or reject the document</param>
        /// <param name="reason"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ValidateAntiForgeryToken]
        [AuditingAuthorizeAttribute("ReviewRequestCompliancePost", Roles = "DocumentAdmin")]
        public ActionResult ReviewRequestCompliance([ModelBinder(typeof(EncryptedIntegerBinder))] int requestId, bool approve, string reason)
        {
            try
            {
                _DocumentsAdminService.SetRequestComplianceDocApproval(requestId, approve, reason);
            }
            catch (RuleException ex)
            {
                ex.CopyToModelState(ModelState);
            }                

            if (ModelState.IsValid)
            {
                // re-run Index to move to proper state
                return DocumentRequest(requestId);
            }
            else
            {
                ViewData["RequestId"] = requestId;
                return View();
            }
        }

        /// <summary>
        /// Renders view where can choose if to respond to a request or cancel it
        /// </summary>
        /// <param name="requestId"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        [AuditingAuthorizeAttribute("SendDocumentForRequest", Roles = "DocumentAdmin")]
        public ActionResult SendDocumentForRequest([ModelBinder(typeof(EncryptedIntegerBinder))] int requestId)
        {

            try
            {
                ViewData["RequestId"] = requestId;

                DocumentRequest requestInfo;
                string strDOB;
                requestInfo = _DocumentsRetrievalService.GetDocumentRequest(requestId);

                if (requestInfo.DateOfBirth != null)
                {
                    DateTime Dt = requestInfo.DateOfBirth.Value;
                    // set month
                    string mm = Dt.Month.ToString();
                    if (Dt.Month < 10)
                    {
                        mm = "0" + Dt.Month;
                    }
                    // set day
                    string dd = Dt.Day.ToString();
                    if (Dt.Day < 10)
                    {
                        dd = "0" + Dt.Day;
                    }
                    // set up DOB string  with MM/DD/YYYY
                    strDOB = mm + "/" + dd + "/" + Dt.Year.ToString();
                }
                else
                {
                    strDOB = null;
                }
                ViewData.SetValue(GlobalViewDataKey.DateOfBirth, strDOB);
                DocumentRequestResponse requestResponse;

                requestResponse = new DocumentRequestResponse
                {
                    DocumentRequestId = requestId
                };

                // Delete all unsent documents.
                _DocumentsAdminService.DeleteUploadedButNotSentDocuments();
                return View("SendDocumentForRequest", requestResponse);
            }
            catch (Exception Ex)
            {
                CommonExceptionHandling.ExceptionUtility.LogException(Ex);
                return null;
            }
        }

        /// <summary>
        /// Accepts post from respond to request view which will send a document for the request
        /// </summary>
        /// <param name="requestResponse"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ValidateAntiForgeryToken]
        [AuditingAuthorizeAttribute("SendDocumentForRequest", Roles = "DocumentAdmin")]
        public ActionResult SendDocumentForRequest([Bind(Exclude = "DocumentFileId")]DocumentRequestResponse requestResponse)
        {
            //Guru: set uploaded DocumentFileID in requestResponse model.
            var yourList = (List<Int32>)Session["DocumentFileID"];
            try
            {
                if (yourList != null)
                {
                    for (int i = 0; i <= yourList.Count - 1; i++)
                    {
                        requestResponse.DocumentFileId = yourList[i];
                        _DocumentsAdminService.SendDocumentForRequest(requestResponse);
                    }
                }
                //Clear file collection
                _DocumentsAdminService.ClearFileCollections();
            }
            catch (RuleException ex)
            {
                ex.CopyToModelState(ModelState);
            }

            if (ModelState.IsValid)
            {
                return RedirectToAction("MyOutstandingRequests",
                    "ViewDocuments",
                    new {
                            pageNumber = 1,
                            statusMessage = "Document Request Successfully Responded To"
                    });
            }
            else
                return View("SendDocumentForRequest", requestResponse);

        }

        [AcceptVerbs(HttpVerbs.Get)]
        [AuditingAuthorizeAttribute("CancelRequest", Roles = "DocumentAdmin")]
        public ViewResult CancelRequest([ModelBinder(typeof(EncryptedIntegerBinder))] int requestId)
        {
            ViewData["RequestId"] = requestId;
            return View("CancelRequest");
        }


        /// <summary>
        /// Accepts post from respond to request view which will cancel a request
        /// </summary>
        /// <param name="requestResponse"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ValidateAntiForgeryToken]
        [AuditingAuthorizeAttribute("CancelRequestPost", Roles = "DocumentAdmin")]
        public ViewResult CancelRequest([ModelBinder(typeof(EncryptedIntegerBinder))]int requestId, string reason)
        {
            try
            {
                _DocumentsAdminService.CancelRequest(requestId, reason);
            }
            catch (RuleException ex)
            {
                ex.CopyToModelState(ModelState);
            }

            if (ModelState.IsValid)
                return RequestCancelled();
            else
            {
                ViewData["Reason"] = reason;
                return CancelRequest(requestId);
            }
        }

        private ViewResult RequestRespondedTo()
        {
            return View("RequestRespondedTo");
        }

        private ViewResult RequestCancelled()
        {
            return View("RequestCancelled");
        }

        [AuditingAuthorizeAttribute("RequestDetails", Roles = "DocumentAdmin")]
        public ViewResult RequestDetails([ModelBinder(typeof(EncryptedIntegerBinder))] int requestId)
        {
            DocumentRequest requestInfo;
            requestInfo = _DocumentsRetrievalService.GetDocumentRequest(requestId);
            ViewData.SetValue(GlobalViewDataKey.DateOfBirth, requestInfo.DateOfBirth);
            return View(requestInfo);
        }

        [AuditingAuthorizeAttribute("RequestDetails2", Roles = "DocumentAdmin")]
        public ViewResult RequestDetails2([ModelBinder(typeof(EncryptedIntegerBinder))] int requestId)
        {
            DocumentRequest requestInfo;

            requestInfo = _DocumentsRetrievalService.GetDocumentRequest(requestId);

            return View(requestInfo);
        }
        /// <summary>
        /// Gets patient identification for document request and renders it
        /// </summary>
        /// <param name="documentRequestId"></param>
        /// <returns></returns>
        [AuditingAuthorizeAttribute("PatientIdentificationForRequest", Roles = "DocumentAdmin")]
        public ViewResult PatientIdentificationForRequest([ModelBinder(typeof(EncryptedIntegerBinder))] int patientIdDocumentRequestId)
        {
            PatientIdentificationMethods patientIdentificationMethods = _DocumentsRetrievalService.GetPatientIdentificationMethodForRequest(patientIdDocumentRequestId);
            //ICollection<APatientIdentification> patientIdCollection;
            //APatientIdentification patientIdentification;

            //patientIdCollection = patientIdentificationMethods.ToCollection();

            //if (patientIdCollection.Count == 0)
            //    throw new ArgumentException("No identification methods exist for request with id " + patientIdDocumentRequestId + ".", "documentRequestId");

            // render just single patient identification method, since requests only have one method
            //patientIdentification = patientIdCollection.First();

            // render common view that shows patient identification method
            return View("~/Views/PatientIdentification/ShowPatientIdentification.ascx", patientIdentificationMethods);
        }

        #endregion

        #endregion

        #region partial view methods

        /// <summary>
        /// Based on the logged in user's provider, will render billing method.  If provider's method document billing method varies by document,
        /// will give user option to select billing method.  Otherwise, will render empty label stating billing method, and billing method value
        /// will be grabbed when when sending document from provider.
        /// </summary>
        /// <returns></returns>
        [AuditingAuthorizeAttribute("DocumentBillingMethodOptions", Roles = "DocumentAdmin")]
        public ViewResult DocumentBillingMethodOptions(BillingMethod? selectedBillingMethod)
        {
            ICollection<BillingMethod> providerBillingMethods;
            BillingMethod billingMethod;

            // gets billing method based on the logged in user
            providerBillingMethods = _DocumentsAdminService.GetProviderBillingMethods();// GetProvidersBillingMethodMode();
            if (providerBillingMethods.Count == 0)
                throw new InvalidOperationException("No payment settings exist for provider");

            if (providerBillingMethods.Count() > 1)
            {
                return BillingMethodDropDown(providerBillingMethods, selectedBillingMethod);
            }
            else
            {
                billingMethod = providerBillingMethods.First();

                return BillingMethodHiddenFieldDisplay(billingMethod);
            }
        }

        private static IDictionary<BillingMethod, string> _BillingMethodOptions = new Dictionary<BillingMethod, string>
        {
            { BillingMethod.CreditCard, "Credit Card"},
            { BillingMethod.Invoice, "Invoice"},
            { BillingMethod.InvoiceProvider, "Invoice My Provider"},
            { BillingMethod.Free, "Document is Free"},
        };

        /// <summary>
        /// Displays drop down for billing method to be selected.  Will actually render custom view and pass available billing methods
        /// and selected method to it, which will then render a drop down with descriptions for each of those methods.
        /// </summary>
        /// <param name="selectedBillingMethod"></param>
        /// <returns></returns>
        public ViewResult BillingMethodDropDown(ICollection<BillingMethod> availableBillingMethods, BillingMethod? selectedBillingMethod)
        {
            ViewData["AvailableBillingMethods"] = availableBillingMethods;
            ViewData["SelectedBillingMethod"] = selectedBillingMethod;
            ViewData.SetValue(GlobalViewDataKey.FieldName, "BillingMethod");
            ViewData.SetValue(GlobalViewDataKey.OptionText, "-Select-");

            return View("BillingMethodDropDown");

            //IEnumerable<SelectListItem> billingMethodItems;

            // select only billing methods to display which are avaiable
            //billingMethodItems = from kvp in _BillingMethodOptions.Where(x => availableBillingMethods.Contains(x.Key))
                                 //select new SelectListItem
                                 //{
                                 //    Text = kvp.Value,
                                 //    Value = kvp.Key.ToString(),
                                 //    Selected = kvp.Key == selectedBillingMethod
                                 //};

            //ViewData.SetValue(GlobalViewDataKey.FieldName, "BillingMethod");
            //ViewData.SetValue(GlobalViewDataKey.OptionText, "-Select-");

            //return View("DropDown", billingMethodItems);
        }

        /// <summary>
        /// Has a hidden field with the billing method value, and displays the billing method
        /// </summary>
        /// <param name="selectedBillingMethod"></param>
        /// <returns></returns>
        private ViewResult BillingMethodHiddenFieldDisplay(BillingMethod providersBillingMethod)
        {
            string billingMethodString;

            billingMethodString = _BillingMethodOptions[providersBillingMethod];

            ViewData.SetValue(GlobalViewDataKey.FieldName, "BillingMethod");
            ViewData.SetValue(GlobalViewDataKey.FieldValue, providersBillingMethod);
            ViewData.SetValue(GlobalViewDataKey.LabelText, billingMethodString);

            return View("HiddenFieldLabel");
        }

        #endregion 

    }
}
