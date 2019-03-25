using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Ajax;
using RISARC.Web.EBubble.Models.Binders;
using RISARC.Encryption.Service;
using RISARC.Documents.Service;
using RISARC.Emr.Web.DataTypes;
using RISARC.Documents.Model;
using RISARC.Documents.Model.PatientIdentification;
using SpiegelDg.Common.Web.Extensions;
using SpiegelDg.Common.Validation;
using Microsoft.Practices.EnterpriseLibrary.ExceptionHandling;
using SpiegelDg.Security.Model;
using System.Collections.ObjectModel;
using RISARC.Common.Model;
using RISARC.Documents.Model.Payment;
using RISARC.Payment.Model;
using RISARC.Files.Model;
using RISARC.Setup.Implementation.Repository;
using RISARC.Setup.Model;
using RISARC.Files.Service;
using RISARC.Documents.Implementation.Service;
using RISARC.Common;

namespace RISARC.Web.EBubble.Controllers
{
    public class DocumentController : Controller
    {
        private IUserDocumentsService _UserDocumentsService;
        private IDocumentsRetrievalService _RetrievalService;
        private IDocumentTypesRepository _DocumentTypesRepository;
        private IProviderRepository _ProviderRepository;
        private IFilesService _FilesService;
        private IDocumentsAdminService _DocumentsAdminService;

        // used for changing header when downloading a file
        private const string _FileHeaderKey = "content-disposition";
        private const string _FileHeaderFormat = "attachment; filename={0}";

        public DocumentController(IUserDocumentsService userDocumentsService,
            IDocumentsRetrievalService retrievalService,
            IDocumentTypesRepository documentTypesRepository,
            IProviderRepository providerRepository,
            IFilesService filesService,
            IDocumentsAdminService adminService)
        {
            this._UserDocumentsService = userDocumentsService;
            this._RetrievalService = retrievalService;
            this._DocumentTypesRepository = documentTypesRepository;
            this._ProviderRepository = providerRepository;
            this._FilesService = filesService;
            this._DocumentsAdminService = adminService;
        }

        /// <summary>
        /// Directs user to proper view for state of document
        /// </summary>
        /// <returns></returns>
        [AuditingAuthorize("Index",Roles ="user")]
        public ActionResult Index([ModelBinder(typeof(EncryptedStringBinder))] string documentId)
        {
            // this method is bound to the route, while only works with a string.
            int actualDocumentId;

            actualDocumentId = Convert.ToInt32(documentId);

            return Index(actualDocumentId);

        }


        /// <summary>
        /// Directs user to proper view for state of document
        /// </summary>
        /// <returns></returns>
        private ActionResult Index(int documentId)
        {
            DocumentStatus status;

            status = _RetrievalService.GetDocumentStatus(documentId);
            
            switch (status)
            {
                case DocumentStatus.AwaitingVerification:
                    return VerifyIdentification(documentId);
                case DocumentStatus.LockedOutFromAttemptedVerifications:
                    return VerificationLockedOut();
                case DocumentStatus.ReadyForCompliance:
                    return ComplianceCompleteUploadDoc(documentId);
                case DocumentStatus.AwaitingComplianceApproval:
                    return AwaitingComplianceApproval();
                case DocumentStatus.ReadyForPurchase:
                    return PayByCreditCard(documentId);
                case DocumentStatus.ReadyForDownload:
                    return Download(documentId);
                    //return ViewDocumentinViewer(documentId); 
                case DocumentStatus.Expired:
                    return Expired();
                default:
                    throw new InvalidOperationException("No proper state for document");

            }
        }

        public ActionResult DownloadDocumentById(string DownloadDocumentId)
        {
            int? decodedDocId = null;

            if (!string.IsNullOrEmpty(DownloadDocumentId))
                decodedDocId = CryptoBase32.DecodeBase32ToInt(DownloadDocumentId);

            if (!decodedDocId.HasValue || decodedDocId == 0)
            {
                return RedirectToAction( "Members","Home");
            }
            else
                return Index(decodedDocId.Value);
        }

        #region Compliance        

        /// <summary>
        /// Renders view where user can upload a compliance document and submit it
        /// </summary>
        /// <param name="documentId"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ViewResult ComplianceCompleteUploadDoc([ModelBinder(typeof(EncryptedIntegerBinder))] int documentId)
        {
            short providerId;

            providerId = _RetrievalService.GetDocumentProviderId(documentId);
            ViewData["ProviderId"] = providerId;
            ViewData["DocumentId"] = documentId;
            //Clear file collection
            _DocumentsAdminService.DeleteUploadedButNotSentDocuments();
            return View("ComplianceCompleteUploadDoc");
        }

        ///// <summary>
        ///// For an ajax upload of completed compliance document, to send to a provider.  Will not actually submit the release form for the document.
        ///// </summary>
        ///// <param name="documentId"></param>
        ///// <param name="FileUpload"></param>
        ///// <returns></returns>
        ///// <RevisionHistory>
        ///// Date       | Owner     | Particulars
        ///// ----------------------------------------------------------------------------------------
        ///// 12/09/2013 | Viresh   | Created
        ///// 12/09/2013 | Viresh   | Commented the unused variable documentFile.
        ///// </RevisionHistory>
        //[AcceptVerbs(HttpVerbs.Post)]
        //[ValidateAntiForgeryToken]
        //[AuditingAuthorizeAttribute("ComplianceCompleteUploadDocForProvider", Roles = "User")]
        //public ViewResult ComplianceCompleteUploadDocForProvider([ModelBinder(typeof(EncryptedShortBinder))]short providerId, HttpPostedFileBase FileUpload)
        //{
        //    //DocumentFile documentFile;
        //    Provider provider;
        //    int? insertedFileId;

        //    if (FileUpload == null)
        //        ModelState.AddModelError("FileToUpload", "You must choose a file to send");
        //    else
        //    {
        //        //documentFile = new DocumentFile(FileUpload.ContentType,
        //        //    FileUpload.FileName,
        //        //    FileUpload.InputStream);

        //        try
        //        {
        //            provider = _ProviderRepository.GetProvider(providerId);
        //            insertedFileId = _FilesService.UploadFile(FileUpload, User.Identity.Name, FileType.FilledOutComlianceDocument, provider.DocumentFilesFolderName, DocumentsAdminService.GetAllowedFileExtensions()); 

        //            if (!insertedFileId.HasValue)
        //                throw new InvalidOperationException("No file id generated");

        //            ViewData["DocumentFileId"] = insertedFileId;
        //            ViewData["DocumentFileName"] = FileUpload.FileName;
        //        }
        //        catch (Exception ex)
        //        {
        //            // hack - since called in iframe, just set uploaded file id to null, which
        //            // will cause an error message to occur
        //            ExceptionPolicy.HandleException(ex, "Global Policy");
        //            ViewData["DocumentFileId"] = (int?)null;
        //            ViewData["ErrorMessage"] = "An unexpected error occured when file was uploaded.";
        //        }
        //    }

        //    return View("~/Views/File/UploadFileFormIFrame.aspx");
        //}

        /// <summary>
        /// For user to submit the uploaded compliance document for the document
        /// </summary>
        /// <param name="documentId"></param>
        /// <param name="uploadedDocumentFileId"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ValidateAntiForgeryToken]
        public ViewResult ComplianceCompleteUploadDoc([ModelBinder(typeof(EncryptedIntegerBinder))] int documentId, [ModelBinder(typeof(EncryptedIntegerBinder))] int? submittedComplianceFileId)
        {
            DocumentStatus newDocumentStatus;

            if (!submittedComplianceFileId.HasValue)
                ModelState.AddModelError("DocumentFileRequired", "Required");
            else
            {
                // set compliance document to have been submitted
                newDocumentStatus = _UserDocumentsService.SetComplianceDocSubmitted(documentId, submittedComplianceFileId.Value);
                ViewData.SetValue(GlobalViewDataKey.DocumentStatus, newDocumentStatus);
            }

            if (ModelState.IsValid)
                return View("ComplianceCompleteSubmitSuccess");
            else
            {
                ViewData["SubmittedComplianceFileId"] = submittedComplianceFileId;
                return ComplianceCompleteUploadDoc(documentId);
            }
        }

        

        private ViewResult AwaitingComplianceApproval()
        {
            return View("AwaitingComplianceApproval");
        }

        #region partial views

        [AuditingAuthorizeAttribute("FaxInstructions", Roles = "User")]
        public ViewResult FaxInstructions([ModelBinder(typeof(EncryptedIntegerBinder))]int documentId)
        {
            FaxInstructions faxInstructions;

            faxInstructions = _RetrievalService.GetFaxInstructions(documentId);

            return View(faxInstructions);
        }

        /// <summary>
        /// Renders link to get the compliance doc for a document.  Just shows the link and the href property will
        /// have the download link
        /// </summary>
        /// <param name="documentId"></param>
        /// <returns></returns>
        [AuditingAuthorizeAttribute("ComplianceDocLink", Roles = "User")]
        public ViewResult ComplianceDocLink([ModelBinder(typeof(EncryptedIntegerBinder))] int documentId)
        {
            DocumentFile documentFile;

            documentFile = _UserDocumentsService.GetComlianceDoc(documentId, false);

            ViewData["FileName"] = documentFile.FileName;
            ViewData["DocumentId"] = documentId;

            return View();
        }

        /// <summary>
        /// Renders link to get the compliance doc for a provider.  Just shows the link and the href property will
        /// have the download link
        /// </summary>
        /// <param name="documentId"></param>
        /// <returns></returns>
        [AuditingAuthorizeAttribute("ProvidersComplianceDocLink", Roles = "User")]
        public ViewResult ProvidersComplianceDocLink(short providerId)
        {
            DocumentFile documentFile;
            ProviderConfiguration providerConfiguration;

            providerConfiguration = _ProviderRepository.GetProviderConfiguration(providerId);
            documentFile = _FilesService.GetFile(providerConfiguration.ComplianceDocumentFileId, false);

            ViewData["ProviderId"] = providerId;

            return View(documentFile);
        }

        #endregion

        /// <summary>
        /// Gets the compliance document needed to be filled out by the user in order to purchase and download the document
        /// </summary>
        /// <param name="documentId"></param>
        /// <returns></returns>
        [AuditingAuthorizeAttribute("GetComplianceDoc", Roles = "User")]
        public FileStreamResult GetComplianceDoc([ModelBinder(typeof(EncryptedIntegerBinder))]int documentId)
        {
            FileStreamResult result;
            DocumentFile documentFile;

            documentFile = _UserDocumentsService.GetComlianceDoc(documentId, true);
            
            // make sure so that they download it rather then it takes them to new url
            HttpContext.Response.AddHeader(_FileHeaderKey,
                String.Format(_FileHeaderFormat, documentFile.FileName));

            result = new FileStreamResult(documentFile.Stream, documentFile.ContentType);

            return result;
        }

        /// <summary>
        /// Renders link to get the compliance doc for a provider.  Just shows the link and the href property will
        /// have the download link
        /// </summary>
        /// <param name="documentId"></param>
        /// <returns></returns>
        [AuditingAuthorizeAttribute("GetProvidersComplianceDocLink", Roles = "User")]
        public FileStreamResult GetProvidersComplianceDocLink([ModelBinder(typeof(EncryptedShortBinder))] short providerId)
        {
            FileStreamResult result;
            DocumentFile documentFile;
            ProviderConfiguration providerConfiguration;

            providerConfiguration = _ProviderRepository.GetProviderConfiguration(providerId);
            documentFile = _FilesService.GetFile(providerConfiguration.ComplianceDocumentFileId, true);

            // make sure so that they download it rather then it takes them to new url
            HttpContext.Response.AddHeader(_FileHeaderKey,
                String.Format(_FileHeaderFormat, documentFile.FileName));

            result = new FileStreamResult(documentFile.Stream, documentFile.ContentType);

            return result;
        }

        

        #endregion

        #region Verification        

        /// <summary>
        /// For a user to confirm they are the valid recipient of the document
        /// </summary>
        /// <param name="documentId"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ViewResult VerifyIdentification([ModelBinder(typeof(EncryptedIntegerBinder))] int documentId)
        {
            IEnumerable<Type> availableIdentificationOptions;

            // these were determined based on what was checked when the document was sent.
            availableIdentificationOptions = _UserDocumentsService.GetPossibleIdentificationMethods(documentId);
            if (availableIdentificationOptions.Count() == 0)
                throw new InvalidOperationException("No identification options exist for document.");
            ViewData["AvailableIdentificationOptions"] = availableIdentificationOptions;
            ViewData["DocumentId"] = documentId;

            return View("VerifyIdentification");
        }
        
        /// <summary>
        /// For a user to confirm they are the valid recipient of the document
        /// </summary>
        /// <param name="documentId"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ValidateAntiForgeryToken]
        [AuditingAuthorizeAttribute("VerifyIdentificationPost", Roles = "User")]
        public ActionResult VerifyIdentification([ModelBinder(typeof(EncryptedIntegerBinder))] int documentId,
            [ModelBinder(typeof(PatientIdentificationBinder))] APatientIdentification patientIdentification)
        {
            IEnumerable<Type> availableIdentificationOptions;
            DocumentStatus newDocumentStatus;

            try
            {
                // will throw a rule exception if verification failed.  If locked out or succeeded, returns new document status
                newDocumentStatus = _UserDocumentsService.VerifyIdentificationForDocument(documentId, patientIdentification);
            }
            catch (RuleException ex)
            {
                newDocumentStatus = DocumentStatus.ReadyForCompliance;
                ex.CopyToModelState(ModelState);
            }

            // model state will be valid if locked out or successfully verified, in which case can advance to next appropriate view
            if (ModelState.IsValid)
            {
                ViewData.SetValue(GlobalViewDataKey.DocumentStatus, newDocumentStatus);
                if (newDocumentStatus == DocumentStatus.LockedOutFromAttemptedVerifications)
                    return VerificationLockedOut();
                else 
                    // will advance to next state
                    //02/20/2011 removed by Jacob....
            //        return Index(documentId.ToString());
                    //added 
                    return SuccessfullyVerified(documentId);
            }
            else
            {
                availableIdentificationOptions = _UserDocumentsService.GetPossibleIdentificationMethods(documentId);
                ViewData["AvailableIdentificationOptions"] = availableIdentificationOptions;
                ViewData["DocumentId"] = documentId;

                return View(patientIdentification);
            }
             

        }

        private ViewResult SuccessfullyVerified(int documentId)
        {
            ViewData["DocumentId"] = documentId;

            return View("SuccessfullyVerified");
        }

        private ViewResult VerificationLockedOut()
        {
            return View("VerificationLockedOut");
        }

        //public ViewResult AlreadyVerified()
        //{
        //    return View("AlreadyVerified");
        //}

        #endregion

        #region Payment


        [AcceptVerbs(HttpVerbs.Get)]
     
        public ActionResult PayByCreditCard([ModelBinder(typeof(EncryptedIntegerBinder))] int documentId)
        {
            // get document cost and put in view data
            PaymentInstructions paymentInstructions;

            paymentInstructions = _UserDocumentsService.GetPaymentInstructionsForDocument(documentId);
            ViewData["DocumentId"] = documentId;
            ViewData["RequiredPaymentAmount"] = paymentInstructions.RequiredPaymentAmount;

            return View("PayByCreditCard", new CreditCardPaymentInfo());
        }
        
        [AcceptVerbs(HttpVerbs.Post)]
        [ValidateAntiForgeryToken]

        public ActionResult PayByCreditCard([ModelBinder(typeof(EncryptedIntegerBinder))] int documentId, CreditCardPaymentInfo payment)
        {
            DocumentStatus newDocumentStatus;
            PaymentInstructions paymentInstructions;

            try
            {
                // if payment fails, will throw rule exception.
                newDocumentStatus = _UserDocumentsService.PayByCreditCard(documentId, payment);
            }
            catch (RuleException ex)
            {
                newDocumentStatus = DocumentStatus.ReadyForPurchase;
                ex.CopyToModelState(ModelState);
            }

            // model state will be valid when payment succeeds
            if (ModelState.IsValid)
            {
                return DocumentPaymentSuccess(documentId, newDocumentStatus);
            }
            else
            {
                ViewData["DocumentId"] = documentId;
                paymentInstructions = _UserDocumentsService.GetPaymentInstructionsForDocument(documentId);
                ViewData["RequiredPaymentAmount"] = paymentInstructions.RequiredPaymentAmount;

                return View("PayByCreditCard", payment);
            } 
        }

        

        private ActionResult DocumentPaymentSuccess(int documentId, DocumentStatus newDocumentStatus)
        {
            ViewData.SetValue(GlobalViewDataKey.DocumentStatus, newDocumentStatus);
            ViewData["DocumentId"] = documentId;

            return View("DocumentPaymentSuccess");
        }

        #endregion

        #region Download
         [AuditingAuthorize("Index", false)]
        private ViewResult Download([ModelBinder(typeof(EncryptedIntegerBinder))] int documentId)
        {
            ViewData["DocumentId"] = documentId;

            return View("Download");
        }

        public ViewResult ViewDocumentInViewer([ModelBinder(typeof(EncryptedIntegerBinder))]int DocumentFileId)
        {
            ViewData["DocumentFileId"] = DocumentFileId;

            return View("ViewDocumentInViewer");
        }


        /// <summary>
        /// Actually downloads file for user
        /// </summary>
        /// <param name="documentId"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        [AuditingAuthorizeAttribute("GetDocumentFile", Roles = "User")]
        public FileStreamResult GetDocumentFile([ModelBinder(typeof(EncryptedIntegerBinder))] int documentId, bool isTCNfile = false)
        {
            FileStreamResult fileStreamResult;
            DocumentFile documentFile;

            // get file with stream.  this will also set the document as downloaded
            documentFile = _UserDocumentsService.GetDocumentFile(documentId, true, isTCNfile);
           
            // make sure so that they download it rather then it takes them to new url
            HttpContext.Response.AddHeader(_FileHeaderKey,
                String.Format(_FileHeaderFormat, documentFile.FileName));

            fileStreamResult = new FileStreamResult(documentFile.Stream, documentFile.ContentType);

            return fileStreamResult;
        }

        #endregion

        #region Post Download

        private ActionResult Expired()
        {
            return View("Expired");
        }

        #endregion

        #region Partial Views


        [AuditingAuthorizeAttribute("DocumentTypesDropDown", Roles = "User")]
        public ActionResult DocumentTypesDropDown(string fieldName, string emptyOptionText, int? selectedValue)
        {
            IEnumerable<SelectListItem> selectListItems;
            IEnumerable<KeyValuePair<short, string>> documentTypes;

            ViewData.SetValue(GlobalViewDataKey.FieldName, fieldName);
            ViewData.SetValue(GlobalViewDataKey.OptionText, emptyOptionText);

            documentTypes = _DocumentTypesRepository.GetAllDocumentTypes();

            selectListItems = from docType in documentTypes
                              select new SelectListItem
                              {
                                  Text = docType.Value,
                                  Value = docType.Key.ToString(),
                                  Selected = docType.Key == selectedValue
                              };

            return View("DropDown", selectListItems);
        }

      //  [AcceptVerbs(HttpVerbs.Get)]
        [AuditingAuthorizeAttribute("Download", Roles = "User")]
        public ViewResult DownloadDocumentLink([ModelBinder(typeof(EncryptedIntegerBinder))] int documentId)
        {
            DocumentFile documentFile;

            // get file info without loading the stream, so can render information
            documentFile = _UserDocumentsService.GetDocumentFile(documentId, false);
            ViewData["DocumentId"] = documentId;
            ViewData["DocumentName"] = documentFile.FileName;

            return View();
        }

       


        #endregion

        #region Not Used
        
        [Obsolete("User never pays by invoice.  Provider is always invoiced.")]
        [AcceptVerbs(HttpVerbs.Post)]
        [ValidateAntiForgeryToken]
        [AuditingAuthorizeAttribute("PayByInvoice", Roles = "User")]
        public ActionResult PayByInvoice([ModelBinder(typeof(EncryptedIntegerBinder))] int documentId, InvoiceInfo payment)
        {
            PaymentResult paymentResult;

            PaymentInstructions paymentInstructions;
            IEncryptionService encryptionService;
            string encryptedDocumentId;

            paymentResult = null;
            try
            {
                paymentResult = _UserDocumentsService.PayByInvoice(documentId, payment);
            }
            catch (RuleException ex)
            {
                ex.CopyToModelState(ModelState);
            }

            // model state will be valid when payment succeeds
            if (ModelState.IsValid)
            {
                encryptionService = new FrontEndEnrypter();
                encryptedDocumentId = encryptionService.Encrypt(documentId.ToString());
                return DocumentPaymentSuccess(documentId, DocumentStatus.ReadyForDownload);
            }
            else
            {
                ViewData["DocumentId"] = documentId;
                paymentInstructions = _UserDocumentsService.GetPaymentInstructionsForDocument(documentId);
                ViewData["RequiredPaymentAmount"] = paymentInstructions.RequiredPaymentAmount;

                return View(payment);
            }
        }

        /// <summary>
        /// Renders view where user can download the release form for a 
        /// </summary>
        /// <param name="documentId"></param>
        /// <returns></returns>
        private ViewResult SubmitCompletedComplianceDoc(int documentId)
        {
            IEnumerable<ComplianceSubmittalMode> complianceSubmittalModes;
            ViewData["DocumentId"] = documentId;

            // need to get view for comliance submittal mode.  if more than one exist,
            // return view that allows to choose options.  Otherwise, return specific view for option.
            complianceSubmittalModes = _RetrievalService.GetAvailableComplianceSubmittalModes(documentId);

            if (complianceSubmittalModes.Count() > 1)
            {
                return View("ComplianceCompleteSelect", complianceSubmittalModes);
            }
            else
            {
                // get only submittal mode and act like it was selected, returning proper view for it
                ComplianceSubmittalMode submittalMode = complianceSubmittalModes.First();
                return ComplianceCompleteSelect(documentId, submittalMode);
            }
        }

        /// <summary>
        /// Allows user to choose how to submit comliance docs.  Form post will redirect to appropriate submission method
        /// </summary>
        /// <param name="documentId"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ValidateAntiForgeryToken]
        [AuditingAuthorizeAttribute("ComplianceCompleteSelect", Roles = "User")]
        public ViewResult ComplianceCompleteSelect([ModelBinder(typeof(EncryptedIntegerBinder))]int documentId, ComplianceSubmittalMode? complianceSubmittalMode)
        {
            ViewData["DocumentId"] = documentId;

            // need to get view for comliance submittal mode.  if more than one exist,
            // return view that allows to choose options.  Otherwise, return specific view for option.
            if (!complianceSubmittalMode.HasValue)
            {
                ModelState.AddModelError("complianceSubmittalModeRequired", "Required");
                return View("ComplianceCompleteSelect");
            }
            else
            {
                if (complianceSubmittalMode == ComplianceSubmittalMode.Upload)
                {
                    return ComplianceCompleteUploadDoc(documentId);
                }
                else
                    return ComplianceCompleteFaxDoc(documentId);
            }

        }
        private ViewResult ComplianceCompleteFaxDoc(int documentId)
        {
            FaxInstructions faxInstructions;
            ViewData["DocumentId"] = documentId;

            faxInstructions = _RetrievalService.GetFaxInstructions(documentId);

            ViewData["FaxInstructions"] = faxInstructions;

            //ViewData["ProviderName"] = faxInstructions.ProviderName;
            //ViewData["ContactName"] = faxInstructions.ContactName;
            //ViewData["ProviderFax"] = faxInstructions.FaxNumber;

            return View("ComplianceCompleteFaxDoc");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="documentId"></param>
        /// <param name="faxHasBeenSubmitted"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ValidateAntiForgeryToken]
        [AuditingAuthorizeAttribute("ComplianceCompleteFaxDoc", Roles = "User")]
        public ViewResult ComplianceCompleteFaxDoc([ModelBinder(typeof(EncryptedIntegerBinder))]int documentId, bool faxHasBeenSubmitted)
        {
            if (!faxHasBeenSubmitted)
                ModelState.AddModelError("faxHasBeenSubmittedRequired", "Required");
            else
            {
                _UserDocumentsService.SetComplianceSubmittedByFax(documentId);
            }

            ViewData["DocumentId"] = documentId;
            if (ModelState.IsValid)
            {
                return View("ComplianceCompleteFaxDocSuccess");
            }
            else
                return ComplianceCompleteFaxDoc(documentId);
        }

      

        private ActionResult PurchaseDocument([ModelBinder(typeof(EncryptedIntegerBinder))] int documentId)
        {
            BillingMethod paymentMethod;
            PaymentInstructions instructions;

            instructions = _UserDocumentsService.GetPaymentInstructionsForDocument(documentId);

            ViewData["DocumentId"] = documentId;
            ViewData["RequiredPaymentAmount"] = instructions.RequiredPaymentAmount;

            switch (instructions.PaymentMethod)
            {
                case BillingMethod.CreditCard:
                    return View("PayByCreditCard", new CreditCardPaymentInfo());
                case BillingMethod.Invoice:
                    return View("PayByInvoice", new InvoiceInfo());
                default:
                    throw new InvalidOperationException("Unknown payment method of " + instructions.PaymentMethod.ToString() + ".");
            }
        }

        #endregion

    }
}
