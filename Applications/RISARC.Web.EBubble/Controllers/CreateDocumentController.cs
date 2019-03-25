using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Ajax;
using RISARC.Membership.Implementation.Service;
using SpiegelDg.Security.Model;
using RISARC.Documents.Model;
using RISARC.Emr.Web.DataTypes;
using SpiegelDg.Common.Validation;
using RISARC.Documents.Service;
using RISARC.Membership.Service;
using SpiegelDg.Common.Web.Extensions;
using RISARC.Documents.Model.PatientIdentification;
using Microsoft.Practices.EnterpriseLibrary.ExceptionHandling;
using RISARC.Web.EBubble.Models.Binders;
using RISARC.Setup.Implementation.Repository;
using RISARC.Files.Model;
using System.Collections.ObjectModel;
using RISARC.Membership.Model;
using RISARC.Setup.Model;
using System.IO;
using RISARC.Files.Service;
using RISARC.Web.EBubble.Models.DevxControlSettings;
using DevExpress.Web.Mvc;
using RISARC.Common.Model;
using RISARC.Web.EBubble.Models.DevxCommonModels;
using System.Text.RegularExpressions;


namespace RISARC.Web.EBubble.Controllers
{
    public class CreateDocumentController : Controller
    {
        private IProviderRepository _ProviderRepository;
        private IDocumentsAdminService _DocumentsAdminService;
        private IUserDocumentsService _UserDocumentsService;
        private IDocumentsRetrievalService _DocumentsRetrievalService;
        private IRMSeBubbleMempershipService _MembershipService;
        private IDocumentTypesRepository _DocumentTypesRepository;
        public CreateDocumentController(IDocumentsAdminService adminService, IUserDocumentsService userDocumentsService, IDocumentsRetrievalService documentsRetrievalService, IRMSeBubbleMempershipService membershipService, IProviderRepository providerRepository,
            IDocumentTypesRepository documentTypesRepository)
        {
            this._UserDocumentsService = userDocumentsService;
            this._DocumentsAdminService = adminService;
            this._DocumentsRetrievalService = documentsRetrievalService;
            this._MembershipService = membershipService;
            this._ProviderRepository = providerRepository;
            this._DocumentTypesRepository = documentTypesRepository;

        }
        #region Send Request

        [AcceptVerbs(HttpVerbs.Get)]
        [AuditingAuthorizeAttribute("SendRequestGet", Roles = "User")]
        public ActionResult SendRequest()
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.SendRequest);

            if (_MembershipService.IsProviderMember(User.Identity.Name, true))

                return MemberRequestSelectProvider();
            else
                return NonMemberRequestSelectProvider();
        }

        /// <summary>
        /// Returns view for non members to select a provider when requesting.  Will have cascading provider filters, which allows non-members to request
        /// from any provider
        /// </summary>
        /// <returns></returns>
        private ActionResult NonMemberRequestSelectProvider()
        {
            ViewData.SetValue(GlobalViewDataKey.PageDesc, "To request a document, select the State, City and Provider from the drop down list.");
            return View("NonMemberRequestSelectProvider");
        }

        /// <summary>
        /// Returns view for non members to select a provider when requesting
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [AuditingAuthorizeAttribute("NonMemberRequestSelectProvider", Roles = "User")]
        public ActionResult NonMemberRequestSelectProvider(string providerState, string providerCity, short? ProviderToRequestFromId)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.SendRequest);

            if (String.IsNullOrEmpty(providerCity))
                ModelState.AddModelError("ProviderCityRequired", "Required");
            if (String.IsNullOrEmpty(providerState))
                ModelState.AddModelError("ProviderStateRequired", "Required");
            if (!ProviderToRequestFromId.HasValue)
                ModelState.AddModelError("ProviderIdRequired", "Required");

            if (!ModelState.IsValid)
            {
                ViewData["SelectedProviderState"] = providerState;
                ViewData["SelectedProviderCity"] = providerCity;
                ViewData["SelectedProviderId"] = ProviderToRequestFromId;
                return View("NonMemberRequestSelectProvider");
            }
            else
                return NonMemberSendRequest(ProviderToRequestFromId.Value);
        }
        /// <summary>
        /// Will take the selected provider and direct to the next page, where non-member sends a request to a provider
        /// </summary>
        /// <param name="selectedCityState"></param>
        /// <param name="selectedProviderId"></param>
        /// <returns></returns>
        private ActionResult NonMemberSendRequest(short providerIdToRequestFrom)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.SendRequest);
            DocumentRequestSend requestSend;
            // non member requests always relate to patient.  Never allow that option
            ViewData["AllowRelatesToPatientOption"] = false;
            requestSend = new DocumentRequestSend
            {
                ProviderId = providerIdToRequestFrom
            };
            return View("NonMemberSendRequest", requestSend);
        }
        [AcceptVerbs(HttpVerbs.Post)]
        [AuditingAuthorize("NonMemberSendRequest", Roles = "User")]
        [ValidateAntiForgeryToken]
        public ActionResult NonMemberSendRequest([Bind(Exclude = "SubmittedComplianceFileId")] DocumentRequestSend requestSend)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.SendRequest);

            // non member requests always relate to patient.  Never allow that option
            ViewData["AllowRelatesToPatientOption"] = false;

            try
            {
                // overwrite settings for standard non member request settings
                requestSend.DocumentRelatesToPatient = true;
                _UserDocumentsService.RequestDocument(requestSend, SenderClassification.NonMember);
            }
            catch (RuleException ex)
            {
                //ExceptionPolicy.HandleException(ex, "Global Policy");
                ViewData.SetValue(GlobalViewDataKey.ErrorMessage, "Please fix all errors below");
                // hack - necessary to pass this through so can manually add errors in render partial with new viewstate
                ViewData["ModelStateErrors"] = ex.Errors;
                ex.CopyToModelState(ModelState);
            }
            if (ModelState.IsValid)
            {
                return View("RequestSuccess");
            }
            else
                return View("NonMemberSendRequest", requestSend);
        }
        private ActionResult MemberRequestSelectProvider()
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.SendRequest);
            ViewData.SetValue(GlobalViewDataKey.PageDesc, "Complete the information below to send out a request to an organization. Fill out information completely and submit document request.");
            return View("MemberRequestSelectProvider");
        }
        /// <summary>
        /// Returns view for members to select a provider in their network when requesting
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [AuditingAuthorizeAttribute("MemberRequestSelectProvider", Roles = "DocumentAdmin")]
        public ActionResult MemberRequestSelectProvider(short? ProviderToRequestFromId)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.SendRequest);

            if (!ProviderToRequestFromId.HasValue)
                ModelState.AddModelError("ProviderIdRequired", "Required");

            if (!ModelState.IsValid)
            {
                ViewData["SelectedProviderId"] = ProviderToRequestFromId;
                return View("MemberRequestSelectProvider");
            }
            else
                return MemberSendRequest(ProviderToRequestFromId.Value);
        }
        private ActionResult MemberSendRequest(short providerIdToRequestFrom)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.SendRequest);

            DocumentRequestSend requestSend;


            requestSend = new DocumentRequestSend
            {
                ProviderId = providerIdToRequestFrom
            };

            // when members request a document, they are allowed to select if a document relates to a patient
            ViewData["AllowRelatesToPatientOption"] = true;

            AttachEDSRequestSenderConfiguration();


            return View("MemberSendRequest", requestSend);
        }
        [AcceptVerbs(HttpVerbs.Post)]
        [ValidateAntiForgeryToken]
        [AuditingAuthorizeAttribute("SendRequest", Roles = "User")]
        public ActionResult MemberSendRequest([Bind(Exclude = "SubmittedComplianceFileId")] DocumentRequestSend request)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.SendRequest);

            // when members request a document, they are allowed to select if a document relates to a patient
            ViewData["AllowRelatesToPatientOption"] = true;
            //ViewData["AvailableIdentificationOptions"] = PatientIdentificationFactory.GetAllPatientIdentificationTypes();

            //my previous test, optomiszed below var selectEmailList = this.HttpContext.Request.Form["recipientEmailAddress"].Split(',');

            IEnumerable<string> recipientEmailAddresses = null;
            var checkBox = Request.Form["chkSendToEveryOne"];

            if (this.HttpContext.Request.Form["recipientEmailAddress"] != null)
            {
                recipientEmailAddresses = this.HttpContext.Request.Form["recipientEmailAddress"].Split(',');
            }

            //if ((this.HttpContext.Request.Form["recipientEmailAddress"] == null) && (checkBox == "false"))
            //{
            //    ViewData.SetValue(GlobalViewDataKey.ErrorMessage, "Please fix all errors below");
            //}
            //else
            //{
            //    if (checkBox == "false")
            //    {
            //        //try
            //        //{
            //        if (this.HttpContext.Request.Form["recipientEmailAddress"].Split(',') != null)
            //        {
            //            recipientEmailAddresses = this.HttpContext.Request.Form["recipientEmailAddress"].Split(',');
            //        }
            //        else
            //        {
            //            ViewData.SetValue(GlobalViewDataKey.ErrorMessage, "Please fix all errors below and select recipient(s)");
            //        }
            //        //}
            //        //catch (RuleException ex)
            //        //{
            //        //    //ExceptionPolicy.HandleException(ex, "Global Policy");
            //        //    ViewData.SetValue(GlobalViewDataKey.ErrorMessage, "Please fix all errors below");
            //        //    // hack - necessary to pass this through so can manually add errors in render partial with new viewstate
            //        //    ViewData["ModelStateErrors"] = ex.Errors;
            //        //    ex.CopyToModelState(ModelState);
            //        //}

            //    }
            //}



            //  request.
            try
            {
                //Sends Request To Users In Provider.
                if (checkBox == "false") //recipientEmailAddresses == null)
                {
                    _UserDocumentsService.RequestDocument(request, SenderClassification.Member, recipientEmailAddresses);
                }
                else
                {
                    _UserDocumentsService.RequestDocument(request, SenderClassification.Member); // Send everyone
                }


            }
            catch (RuleException ex)
            {
                //ExceptionPolicy.HandleException(ex, "Global Policy");
                ViewData.SetValue(GlobalViewDataKey.ErrorMessage, "Please fix all errors below");
                // hack - necessary to pass this through so can manually add errors in render partial with new viewstate
                ViewData["ModelStateErrors"] = ex.Errors;
                ex.CopyToModelState(ModelState);
            }
            if (ModelState.IsValid)
            {
                return View("RequestSuccess");
            }
            else
            {
                AttachEDSRequestSenderConfiguration();
                return View("MemberSendRequest", request);
            }
        }

        /// <summary>
        /// Attaches properties for eds request sendign to view data
        /// </summary>
        private void AttachEDSRequestSenderConfiguration()
        {
            RMSeBubbleMembershipUser user;
            ProviderConfiguration requesterProviderConfiguration;
            // see if member's provider is acn requester.  If so, allow option to manually enter acn
            user = _MembershipService.GetUser(User.Identity.Name, true);
            requesterProviderConfiguration = _ProviderRepository.GetProviderConfiguration(user.ProviderMembership.ProviderId);
            if (requesterProviderConfiguration.IsEDSRequestSender)
                ViewData["IsEDSRequestSender"] = true;
            else
                ViewData["IsEDSRequestSender"] = false;
        }

        #endregion

        #region Send Document

        /// <summary>
        /// For sending a document
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        [AuditingAuthorizeAttribute("SendDocumentGet", Roles = "DocumentAdmin")]
        public ActionResult Send()
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.Send);
            IDictionary<short, ProviderInNetwork> providersInNetwork;

            short? providerId;
            string userName;

            userName = User.Identity.Name;
            providerId = _MembershipService.GetUsersProviderId(userName, true);
            if (!providerId.HasValue)
                throw new InvalidOperationException("Logged in user must have a provider");

            // if accessible providers exist, then get view that allows to choose accessible provider
            providersInNetwork = _ProviderRepository.GetProvidersInNetwork(providerId.Value, true);

            if (providersInNetwork.Count() > 0)
            {
                return View("SelectDocumentSendingMethod");
            }
            else
                return SendToEmail(providerId.Value);

        }

        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SelectDocumentSendingMethod()
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.Send);
            return View("SelectDocumentSendingMethod");
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [AuditingAuthorizeAttribute("SelectDocumentSendingMethod", Roles = "DocumentAdmin")]
        public ActionResult SelectDocumentSendingMethod(string DocumentSendingMethod)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.Send);
            short? usersProviderId;
            if (String.IsNullOrEmpty(DocumentSendingMethod))
            {
                ModelState.AddModelError("DocumentSendingMethodRequired", "Required");
                return View("SelectDocumentSendingMethod");
            }
            else
            {
                usersProviderId = _MembershipService.GetUsersProviderId(User.Identity.Name, true);
                if (!usersProviderId.HasValue)
                    throw new InvalidOperationException("Logged in user must have a provider");

                if (DocumentSendingMethod == "SendToEmail")
                {
                    return SendToEmail(usersProviderId.Value);
                }
                else if (DocumentSendingMethod == "SendToProviderMember")
                {
                    return SendToProviderMember(usersProviderId.Value);
                }
                else if (DocumentSendingMethod == "SendToProvider")
                {
                    return SendToProvider(usersProviderId.Value);
                }
                else
                {
                    throw new ArgumentException("Unknown DocumentSendingMethod type", "DocumentSendingMethod");
                }
            }
        }

        //Added by Dnyaneshwar
        //public ActionResult GetRecipientEmailsCallback()
        //{
        //    int? ProviderId;
        //    ProviderId = _MembershipService.GetUsersProviderId(User.Identity.Name, true);
        //    if (ProviderId.HasValue)
        //        ViewData["RecipientEmailAddressList"] = _DocumentsAdminService.GetRecipientEmails(ProviderId.Value);
        //    return PartialView("AutoCompleteEmail", ViewData["RecipientEmailAddressList"]);
        //}
        // End Added

        private ActionResult SendToEmail(short usersProviderId)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.Send);

            // Delete all unsent documents.
            _DocumentsAdminService.DeleteUploadedButNotSentDocuments();

            //Get assymetric keys for logged in user and RISARC super admin.
            _MembershipService.GetRSAKeysForUserAndSuperAdmin(User.Identity.Name, DocumentFileProcessor.EnableFileEncryption);

            return View("SendToEmail",
                       new DocumentSend() { SentFromProviderId = usersProviderId }
                       );
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [ValidateAntiForgeryToken]
        [AuditingAuthorizeAttribute("SendDocument", Roles = "DocumentAdmin")]
        public ActionResult SendToEmail([Bind(Exclude = "DocumentFileId")] DocumentSend documentSend, string recipientEmailAddress, string recipientEmailAddressRetype, string recipientPhoneNumber)
        {
            //long? recipientPhoneNumbervalue = null;
            //long temp;
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.Send);
            ViewData["RecipientEmailAddress"] = recipientEmailAddress;
            // Added by Dnyaneshwar
            ViewData["RecipientPhoneNumber"] = recipientPhoneNumber;
            // End Added
            var yourList = (List<Int32>)Session["DocumentFileID"];
            
            try
            {
                if (yourList != null)
                {
                    for (int i = 0; i <= yourList.Count - 1; i++)
                    {
                        documentSend.DocumentFileId = yourList[i];
                        _DocumentsAdminService.SendDocumentToEmail(documentSend, recipientEmailAddress, recipientEmailAddressRetype, recipientPhoneNumber);
                        
                    }
                    //Clear file collection
                    _DocumentsAdminService.ClearFileCollections();
                }
            }
                   
            catch (RuleException ex)
               {
                   
                ex.CopyToModelState(ModelState);
            }

            if (ModelState.IsValid)
            {
                return DocumentSendSuccess();
            }
            else
                return View("SendToEmail", documentSend);
        }

        /// <summary>
        /// Redirects to send documents, and displays status message that was successfully sent
        /// </summary>
        /// <returns></returns>
        private ActionResult DocumentSendSuccess()
        {
            string statusMessage = "Document successfully sent";

            return RedirectToAction(
                "MySentDocuments",
                "ViewDocuments",
                new
                {
                    pageNumber = 1,
                    statusMessage = statusMessage
                });
        }


        private ActionResult SendToProviderMember(short sendersProviderId)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.Send);
            // set default document settings for sending to provider member
            ViewData["DocumentSettings"] = new DocumentSettings
            {
                DocumentRelatesToPatient = true,
                PatientIdentificationVerificationRequired = true,
                ReleaseFormsRequired = true
            };

            // Delete all unsent documents.
            _DocumentsAdminService.DeleteUploadedButNotSentDocuments();

            //Get assymetric keys for logged in user and RISARC super admin.
            _MembershipService.GetRSAKeysForUserAndSuperAdmin(User.Identity.Name, DocumentFileProcessor.EnableFileEncryption);
            return View("SendToProviderMember",
                new DocumentSend() { SentFromProviderId = sendersProviderId }
                       );
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [ValidateAntiForgeryToken]
        [AuditingAuthorizeAttribute("SendToProviderMember", Roles = "DocumentAdmin")]
        public ActionResult SendToProviderMember([Bind(Exclude = "DocumentFileId")] DocumentSend documentSend, DocumentSettings documentSettings, short? recipientProviderId, string recipientEmailAddress, FormCollection form)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.Send);
            ViewData["RecipientProviderId"] = recipientProviderId;
            ViewData["RecipientEmailAddress"] = recipientEmailAddress;
            ViewData["DocumentSettings"] = documentSettings;
            short recipientProviderIdToSend;

            if (!recipientProviderId.HasValue)
                ModelState.AddModelError("RecipientProviderRequired", "Required");

            //"HICNUMBER" 
            if (!recipientProviderId.HasValue)
            {
                ModelState.AddModelError("RecipientProviderRequired", "Required");
            }
            //"DCN NUMBER" 
            if (!recipientProviderId.HasValue)
                ModelState.AddModelError("RecipientProviderRequired", "Required");


            if (!recipientProviderId.HasValue)
                ModelState.AddModelError("RecipientProviderRequired", "Required");
            try
            {

                var yourList = (List<Int32>)Session["DocumentFileID"];
                if (yourList == null)
                {
                    recipientProviderIdToSend = recipientProviderId ?? 0;
                    _DocumentsAdminService.SendDocumentToProviderMember(documentSend, documentSettings, recipientProviderIdToSend, form["recipientEmailAddress"]);
                }
                else
                    for (int i = 0; i <= yourList.Count - 1; i++)
                    {
                        documentSend.DocumentFileId = yourList[i];
                        recipientProviderIdToSend = recipientProviderId ?? 0;
                        _DocumentsAdminService.SendDocumentToProviderMember(documentSend, documentSettings, recipientProviderIdToSend, form["recipientEmailAddress"]);
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
                return DocumentSendSuccess();
            }
            else
                return View("SendToProviderMember", documentSend);
        }

        /// <summary>
        /// Display Multi select reviver list.
        /// </summary>
        /// <returns>PArtial tree view</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 05/15/2014 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public ActionResult DocumentReviewers(DocumentSettings documentSettings)
        {
            IDictionary<short, ProviderInNetwork> providers;
            IEnumerable<ProviderInNetwork> providerInNetwork = null;
            if (documentSettings.DocumentReviewerRequired)
            {
                short? ProviderID = _MembershipService.GetUsersProviderId(User.Identity.Name, true);
                providers = _ProviderRepository.GetProvidersInNetwork(ProviderID.Value);
                providerInNetwork = from provider in providers
                                        select new ProviderInNetwork
                                        {
                                            ProviderId = provider.Key,
                                            ProviderName = (GetProviderInNetworkOptionText(provider.Value, true)),
                                            IseTAR = provider.Value.IseTAR,
                                            BAAExists = provider.Value.BAAExists
                                        };
            }

            return View(providerInNetwork);
        }

        private ActionResult SendToProvider(short sendersProviderId)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.Send);
            // set default document settings for sending to provider member
            ViewData["DocumentSettings"] = new DocumentSettings
            {
                DocumentRelatesToPatient = true,
                PatientIdentificationVerificationRequired = true,
                ReleaseFormsRequired = true
            };
            // Delete all unsent documents.
            _DocumentsAdminService.DeleteUploadedButNotSentDocuments();

            //Get assymetric keys for logged in user and RISARC super admin.
            _MembershipService.GetRSAKeysForUserAndSuperAdmin(User.Identity.Name, DocumentFileProcessor.EnableFileEncryption);
            return View("SendToProvider",
                new DocumentSend() { SentFromProviderId = sendersProviderId }
                       );
        }

        /// <summary>
        /// Action that will return required data for validation of ACN / HIC / DCN / ICN / CameID numbers
        /// </summary>
        /// <param name="providerDocTypeValidation">Require Provider Id and Document Type Id to get data</param>
        /// <returns>Json serialize string for ProviderDocTypeValidation Model object</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 06/26/2014 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public ActionResult GetProviderDocTypeValidation(ProviderDocTypeValidation providerDocTypeValidation)
        {
            _DocumentsAdminService.GetProviderDocTypeValidation(providerDocTypeValidation);
            return Json(providerDocTypeValidation, JsonRequestBehavior.AllowGet);
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [ValidateAntiForgeryToken]
        [AuditingAuthorizeAttribute("SendToProvider", Roles = "DocumentAdmin")]
        public ActionResult SendToProvider([Bind(Exclude = "DocumentFileId")] DocumentSend documentSend, DocumentSettings documentSettings, short? recipientProviderId)
        {
            bool MultipleFiles = false;
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.Send);
            ViewData["RecipientProviderId"] = recipientProviderId;
            ViewData["DocumentSettings"] = documentSettings;
           
            if (!recipientProviderId.HasValue)
                ModelState.AddModelError("RecipientProviderRequired", "Required");

            try
            {
                var yourList = (List<Int32>)Session["DocumentFileID"];
                if (yourList == null)
                {
                    _DocumentsAdminService.SendDocumentToProvider(documentSend, documentSettings, recipientProviderId.HasValue ? recipientProviderId.Value : (short)0, false);
                }
                else
                {
                    for (int i = 0; i <= yourList.Count - 1; i++)
                    {
                        documentSend.DocumentFileId = yourList[i];
                        if (yourList.Count > 1)
                            MultipleFiles = true;

                        // Added by dnyaneshwar
                        
                        if (documentSend.ProviderIsEtar == null ? false : documentSend.ProviderIsEtar.Value)
                        {
                            DateTime? AccountNoFrom = null;
                            DateTime? AccountNoTo = null;
                            DateTime AccountNoFromTemp;
                            DateTime AccountNoToTemp;

                            if (DateTime.TryParse(Convert.ToString(Request["PatientInformation.PatientIdentificationMethods.AccountNumberIdentification.AccountDateOfServiceFrom"]), out AccountNoFromTemp))
                                AccountNoFrom = AccountNoFromTemp;

                            if (DateTime.TryParse(Convert.ToString(Request["PatientInformation.PatientIdentificationMethods.AccountNumberIdentification.AccountDateOfServiceTo"]), out AccountNoToTemp))
                                AccountNoTo = AccountNoToTemp;
                            
                            var documentTypeData = Session["UploadedFilesList"] as List<UploadedFiles>;

                            var Count = 0;
                            Count = documentTypeData.Where(clause => clause.DocumentTypeId == null).Count();
                            if (Count > 0)
                            {
                                ICollection<ErrorInfo> errors = new HashSet<ErrorInfo>();
                                errors.Add("eTARDocumentTypeNotAssigned", "Please select document type for the documents.");
                                
                                //This code commented because of null date Date issue 
                                //25-Sep-2014
                                //Set the Data
                                //var AccountNoFrom = Request["PatientInformation.PatientIdentificationMethods.AccountNumberIdentification.AccountDateOfServiceFrom"] == "MM/dd/yyyy" ? (DateTime?)null : Convert.ToDateTime(Request["PatientInformation.PatientIdentificationMethods.AccountNumberIdentification.AccountDateOfServiceFrom"]);
                                //var AccountNoTo = Request["PatientInformation.PatientIdentificationMethods.AccountNumberIdentification.AccountDateOfServiceTo"] == "MM/dd/yyyy" ? (DateTime?)null : Convert.ToDateTime(Request["PatientInformation.PatientIdentificationMethods.AccountNumberIdentification.AccountDateOfServiceTo"]);

                                if (documentSend.PatientInformation.PatientIdentificationMethods.AccountNumberIdentification == null)
                                    documentSend.PatientInformation.PatientIdentificationMethods.AccountNumberIdentification = new AccountNumberIdentification()
                                    {
                                        AccountNumber = Request["PatientInformation.PatientIdentificationMethods.AccountNumberIdentification.AccountNumber"],
                                        AccountDateOfServiceFrom = AccountNoFrom,
                                        AccountDateOfServiceTo = AccountNoTo
                                    };
                                throw new RuleException(errors);
                            }

                            //Count of Document type "Other"
                            //If Document type "Other" is there then Document Description is required
                            //Added on 10-Feb-2015
                            //Added by Abhishek
                            int OtherDocTypeCount = documentTypeData.Where(type => type.DocumentTypeId == 10).Count();
                            if(OtherDocTypeCount > 0 && documentSend.DocumentDescription==null)
                            {
                                ICollection<ErrorInfo> errors = new HashSet<ErrorInfo>();
                                errors.Add("DescriptionRequired", "Required");
                                throw new RuleException(errors);
                            }
                            //End Added

                            if (documentTypeData != null && documentTypeData.Count == yourList.Count)
                            {
                                // Set Disabled Data that is required for sending Document
                                documentSettings.DocumentRelatesToPatient = true;
                                documentSend.BillingMethod = BillingMethod.InvoiceProvider;

                                //This code commented because of null date Date issue 
                                //25-Sep-2014
                                //var AccountNoFrom = Request["PatientInformation.PatientIdentificationMethods.AccountNumberIdentification.AccountDateOfServiceFrom"] == "MM/dd/yyyy" ? (DateTime?)null : Convert.ToDateTime(Request["PatientInformation.PatientIdentificationMethods.AccountNumberIdentification.AccountDateOfServiceFrom"]);
                                //var AccountNoTo = Request["PatientInformation.PatientIdentificationMethods.AccountNumberIdentification.AccountDateOfServiceTo"] == "MM/dd/yyyy" ? (DateTime?)null : Convert.ToDateTime(Request["PatientInformation.PatientIdentificationMethods.AccountNumberIdentification.AccountDateOfServiceTo"]);

                                if (documentSend.PatientInformation.PatientIdentificationMethods.AccountNumberIdentification == null)
                                    documentSend.PatientInformation.PatientIdentificationMethods.AccountNumberIdentification = new AccountNumberIdentification()
                                    {
                                        AccountNumber = Request["PatientInformation.PatientIdentificationMethods.AccountNumberIdentification.AccountNumber"],
                                        AccountDateOfServiceFrom = AccountNoFrom,
                                        AccountDateOfServiceTo = AccountNoTo
                                    };
                                // End Set Data
                                documentSend.DocumentTypeId = documentTypeData.Where(clause => clause.FileID == documentSend.DocumentFileId).Select(sel => sel.DocumentTypeId).Count() > 0 ? Convert.ToInt16(documentTypeData.Where(clause => clause.FileID == documentSend.DocumentFileId).Select(sel => sel.DocumentTypeId).First()) : documentSend.DocumentTypeId;
                            }
                        }
                        // End Added
                        _DocumentsAdminService.SendDocumentToProvider(documentSend, documentSettings, recipientProviderId.HasValue ? recipientProviderId.Value : (short)0, MultipleFiles);
                        //    ViewData["DocumentFileId"] = Session["DocumentFileID"];
                        //  Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "PreviewFileLink", "File", new { documentFileId = Html.Encrypt(yourList[i]) });//ViewData["DocumentFileId"]) });
                    }
                }
                int acnAssignment = 0;
                if (MultipleFiles == true && recipientProviderId == 14)

                    for (int i = 0; i <= yourList.Count - 1; i++)
                    {


                        if (i == 0)
                        {
                            //We need to get the first document ID in order to retrive the ACN number that was generated......
                            acnAssignment = _DocumentsAdminService.GetACNAssignmentID(yourList[i]);
                            //Method for retriving the acnassignment
                        }
                        else
                            //Update Files to the first ACN that was generated....
                            _DocumentsAdminService.UpdateMultipleACN(acnAssignment, yourList[i]);

                    }
                //Update ACN Numbers


                //

                // pass 0 as recipient provider id to method if none selected.   Important to call method in order to get all validation errors

                //Clear file collection
                _DocumentsAdminService.ClearFileCollections();
            }
            catch (RuleException ex)
            {
                ex.CopyToModelState(ModelState);
            }

            if (ModelState.IsValid)
            {
                return DocumentSendSuccess();

            }
            else
                return View("SendToProvider", documentSend);
        }

        #endregion

        //#region Logging
        //public JsonResult CreateTrackUser(string activityType, string activityValue, string reason)
        //{
        //    var memUser = System.Web.Security.Membership.GetUser();
        //    if (memUser != null)
        //    {
        //        var db = new RMSeBUBBLELoggingDataContext();
        //        var create = new ActivityUserLog { UserId = memUser.ProviderUserKey.ToString(), UserName = memUser.UserName, ActivityType = activityType, ActivityValue = activityValue, ActivityDate = DateTime.Now, Reason = reason };
        //        db.ActivityUserLogs.InsertOnSubmit(create);
        //        db.SubmitChanges();

        //        return Json("Success");
        //    }
        //    else
        //    {
        //        return Json("Error...");
        //    }
        //}
        //#endregion

        #region Partial Views



        // MIKE 12/31/2012 - BEGINING


        //[AuditingAuthorizeAttribute("ProvidersAndUserTypeDropDown", Roles = "User")]
        //public ViewResult ProvidersAndUserTypeDropDown(string fieldName, string emptyOptionText, short? selectedValue, bool showNetworkSettings)
        //{
        //    //IEnumerable<SelectListItem> selectedListItems;
        //    //IDictionary<short, ProviderInNetwork> providers;
        //    string userName;
        //    short? providerId;

        //    //ViewData.SetValue(GlobalViewDataKey.FieldName, fieldName);
        //    //ViewData.SetValue(GlobalViewDataKey.OptionText, emptyOptionText);
        //    //ViewData.SetValue(GlobalViewDataKey.ClassName, "ProvidersInNetworkDropDown"); // change to 

        //    // get users provider id. 
        //    userName = User.Identity.Name;
        //    providerId = _MembershipService.GetUsersProviderId(userName, true);
        //    //// providers that user's provider has access to
        //    if (!providerId.HasValue) // this would be the case of a non-member
        //    {
        //        throw new InvalidOperationException("Logged in user must have a type");
        //        //var allProvidersInNetworkQuery = from provider in _ProviderRepository.GetAllProviders()
        //        //                                 select new ProviderInNetwork(provider.Id, provider.ProviderInfo.Name, false);

        //        //    //providers = allProvidersInNetworkQuery.ToDictionary(x => x.ProviderId);
        //    }
        //    else
        //    {
        //        //    providers = _ProviderRepository.GetProvidersInNetwork(providerId.Value);
        //    }
        //    int ProvID = Convert.ToInt32("0" + (short?)ViewData["RecipientProviderId"]); //39
        //    int DocTypeID = Convert.ToInt32("0" + (string)ViewData["RecipientEmailAddress"]); //3
        //    string[] movies = new string[] { "a", "b", "c" };
        //    //movies = Model.ToArray;
        //    List<string> Lst = new List<string>();

        //    // clsDB xDB = new clsDB();
        //    //xDB.Connection.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["RMSeBUBBLE"].ConnectionString;
        //    //xDB.AddParameter("@ProvID", ProvID);
        //    //xDB.AddParameter("@DocTypeID", DocTypeID);
        //    //System.Data.IDataReader dr = xDB.ExecuteReader("[RMSeBUBBLE2].[dbo].[ListUserByProviderAndDocumentType]");
        //    //while (dr.Read())
        //    //{
        //    //    Lst.Add(dr["UserName"].ToString());
        //    //};
        //    //movies = Lst.ToArray();
        //    //selectedListItems = from provider in 
        //    //                    select new SelectListItem
        //    //                    {
        //    //                        /* provider name will include BAA if BAA exists */
        //    //                        Text = GetProviderInNetworkOptionText(provider.Value, showNetworkSettings),
        //    //                        Value = provider.Key.ToString(),
        //    //                        Selected = provider.Key == selectedValue
        //    //                    };

        //    //if (selectedListItems.Count() == 0)
        //    //{
        //    //    ViewData.SetValue(GlobalViewDataKey.OptionText, "No providers exist in your provider's network.  Please contact your provider's administrator.");
        //    //}
        //    //11/19/2010 Mike

        //    //return View("DropDown", selectedListItems);
        //    //return View("DropDownWithAttributes", selectedListItems);
        //    return View("DropDownWithAttibutes", movies);
        //}


        // MIKE END












        [AuditingAuthorizeAttribute("ProvidersInNetworkDropDown1", Roles = "User")]
        public ViewResult ProvidersInNetworkDropDown1(string fieldName, string emptyOptionText, short? selectedValue, bool showNetworkSettings)
        {
            IEnumerable<SelectListItem> selectedListItems;
            IDictionary<short, ProviderInNetwork> providers;
            string userName;
            short? providerId;

            ViewData.SetValue(GlobalViewDataKey.FieldName, fieldName);
            ViewData.SetValue(GlobalViewDataKey.OptionText, emptyOptionText);
            ViewData.SetValue(GlobalViewDataKey.ClassName, "ProvidersInNetworkDropDown");

            // get users provider id. 
            userName = User.Identity.Name;
            providerId = _MembershipService.GetUsersProviderId(userName, true);
            // providers that user's provider has access to
            if (!providerId.HasValue) // this would be the case of a non-member
            {
                throw new InvalidOperationException("Logged in user must have a provider");
                //var allProvidersInNetworkQuery = from provider in _ProviderRepository.GetAllProviders()
                //                                 select new ProviderInNetwork(provider.Id, provider.ProviderInfo.Name, false);

                //providers = allProvidersInNetworkQuery.ToDictionary(x => x.ProviderId);
            }
            else
            {
                providers = _ProviderRepository.GetProvidersInNetwork(providerId.Value);
            }

            selectedListItems = from provider in providers
                                select new SelectListItem
                                {
                                    /* provider name will include BAA if BAA exists */
                                    Text = GetProviderInNetworkOptionText(provider.Value, showNetworkSettings),
                                    Value = provider.Key.ToString(),
                                    Selected = provider.Key == selectedValue
                                };

            if (selectedListItems.Count() == 0)
            {
                ViewData.SetValue(GlobalViewDataKey.OptionText, "No providers exist in your provider's network.  Please contact your provider's administrator.");
            }
            //11/19/2010 Mike
            //return View("DropDown", selectedListItems);
            return View("DropDownWithAttributes", selectedListItems);
        }

        /// <summary>
        /// Renders drop down with providers in logged in user's network
        /// </summary>
        /// <param name="fieldName"></param>
        /// <param name="emptyOptionText"></param>
        /// <param name="selectedValue"></param>
        /// <param name="showNetworkSettings"></param>
        /// <returns></returns>
        [AuditingAuthorizeAttribute("ProvidersInNetworkDropDown", Roles = "User")]
        public ViewResult ProvidersInNetworkDropDown(string fieldName, string emptyOptionText, short? selectedValue, bool showNetworkSettings, bool? AllowIseTAR = false)
        {
            IEnumerable<SelectListItem> selectedListItems;
            IDictionary<short, ProviderInNetwork> providers;
            string userName;
            short? providerId;

            ViewData.SetValue(GlobalViewDataKey.FieldName, fieldName);
            ViewData.SetValue(GlobalViewDataKey.OptionText, emptyOptionText);
            ViewData.SetValue(GlobalViewDataKey.ClassName, "ProvidersInNetworkDropDown");
            
            if (AllowIseTAR != null && AllowIseTAR.Value)
            {
                ViewData.SetValue(GlobalViewDataKey.Disabled, true);
            }
            // get users provider id. 
            userName = User.Identity.Name;
            providerId = _MembershipService.GetUsersProviderId(userName, true);
            // providers that user's provider has access to
            if (!providerId.HasValue) // this would be the case of a non-member
            {
                throw new InvalidOperationException("Logged in user must have a provider");
                //var allProvidersInNetworkQuery = from provider in _ProviderRepository.GetAllProviders()
                //                                 select new ProviderInNetwork(provider.Id, provider.ProviderInfo.Name, false);

                //providers = allProvidersInNetworkQuery.ToDictionary(x => x.ProviderId);
            }
            else
            {
                providers = _ProviderRepository.GetProvidersInNetwork(providerId.Value, AllowIseTAR.Value);
            }

            selectedListItems = from provider in providers
                                select new SelectListItem
                                {
                                    /* provider name will include BAA if BAA exists */
                                    Text = GetProviderInNetworkOptionText(provider.Value, showNetworkSettings),
                                    Value = provider.Key.ToString(),
                                    Selected = provider.Key == selectedValue
                                };

            if (selectedListItems.Count() == 0)
            {
                ViewData.SetValue(GlobalViewDataKey.OptionText, "No providers exist in your provider's network.  Please contact your provider's administrator.");
            }
            //11/19/2010 Mike
            //return View("DropDown", selectedListItems);
            return View("DropDownWithAttributes", selectedListItems);
        }

        private const string _ProviderWithBAAFormat = "{0} (BAA Exists)";
        /// <summary>
        /// 
        /// </summary>
        /// <param name="providerInNetwork"></param>
        /// <param name="showNetworkSettings">If to show settings from provider in network</param>
        /// <returns></returns>
        private string GetProviderInNetworkOptionText(ProviderInNetwork providerInNetwork, bool showNetworkSettings)
        {
            string providerInNetworkText;

            if (showNetworkSettings)
            {
                if (providerInNetwork.BAAExists)
                    providerInNetworkText = String.Format(_ProviderWithBAAFormat, providerInNetwork.ProviderName);
                else
                    providerInNetworkText = providerInNetwork.ProviderName;
            }
            else
                providerInNetworkText = providerInNetwork.ProviderName;

            return providerInNetworkText;
        }
        [AuditingAuthorizeAttribute("ProvidersOtherFacilityDropDown", Roles = "User")]
        public ViewResult ProvidersOtherFacilityDropDown(string fieldName, string emptyOptionText, short? selectedValue, bool showNetworkSettings)
        {
            IEnumerable<SelectListItem> selectedListItems;
            IDictionary<int, ProviderInNetworkTest> providersTest;
            string userName;
            short? providerId;
            int UserIndex;
            ViewData.SetValue(GlobalViewDataKey.FieldName, fieldName);
            ViewData.SetValue(GlobalViewDataKey.OptionText, emptyOptionText);
            ViewData.SetValue(GlobalViewDataKey.ClassName, "ProvidersOtherFacilityDropDown");

            // get users provider id. 
            userName = User.Identity.Name;
            providerId = _MembershipService.GetUsersProviderId(userName, true);
            UserIndex = _MembershipService.GetUserIndex(userName);
            // providers that user's provider has access to
            if (!providerId.HasValue) // this would be the case of a non-member
            {
                throw new InvalidOperationException("Logged in user must have a provider");
            }
            else
            {
                providersTest = _ProviderRepository.GetProvidersInNetworkTest(UserIndex);
            }

            selectedListItems = from provider in providersTest
                                select new SelectListItem
                                {
                                    /* provider name will include BAA if BAA exists */
                                    Text = GetProviderInNetworkOptionTextTest(provider.Value, showNetworkSettings),
                                    Value = provider.Key.ToString(),
                                    Selected = provider.Key == selectedValue
                                };

            if (selectedListItems.Count() == 0)
            {
                ViewData.SetValue(GlobalViewDataKey.OptionText, "No providers exist in your provider's network.  Please contact your provider's administrator.");

                //providerId = ViewData["RecipientProviderId"];
            }

            return View("dropdown", selectedListItems);
        }
        //good code for next version 
        private const string _UserDisplayFormat = "{1} {2} ({3}) {0}";
        //private const string _UserDisplayFormat = "{2} {3} ({1}) {0}";
        [AuditingAuthorizeAttribute("ProviderMembersDropDown", Roles = "DocumentAdmin")]
        public ViewResult ProvidersMembersDropDown(string fieldName, string emptyOptionText, short? selectedProviderId, string selectedUserName)
        {
            IEnumerable<SelectListItem> selectedListItems;
            ICollection<RMSeBubbleMembershipUser> membershipUsers;
            string optionText;

            ViewData.SetValue(GlobalViewDataKey.FieldName, fieldName);
            ViewData.SetValue(GlobalViewDataKey.ClassName, "ProvidersMembersDropDown");

            if (selectedProviderId.HasValue)
            {
                membershipUsers = _MembershipService.GetUsersOfProvider(selectedProviderId.Value);

                if (membershipUsers.Count == 0)
                {
                    ViewData.SetValue(GlobalViewDataKey.Disabled, true);
                    selectedListItems = new Collection<SelectListItem>();
                    optionText = "No members exist for provider. Please select another provider.";
                }
                else
                {
                    optionText = emptyOptionText;
                    selectedListItems = from user in membershipUsers.OrderBy(user => user.PersonalInformation.LastName)
                                        select new SelectListItem
                                        {
                                            Text = String.Format(_UserDisplayFormat, user.PersonalInformation.Title, user.PersonalInformation.FirstName, user.PersonalInformation.LastName,
                                            user.UserName),
                                            Value = user.UserName,
                                            Selected = user.UserName == selectedUserName
                                        };
                }
            }
            else
            {
                optionText = "-Select Provider-";
                ViewData.SetValue(GlobalViewDataKey.Disabled, true);
                selectedListItems = new Collection<SelectListItem>();
            }

            ViewData.SetValue(GlobalViewDataKey.OptionText, optionText);

            return View("Dropdown", selectedListItems);
        }

        //[AuditingAuthorizeAttribute("UserDocumentTypesDropDown", Roles = "DocumentAdmin")]
        //public ViewResult UserDocumentTypesDropDown(string fieldName, string emptyOptionText, string selectedUserName, short selectedDocumentType)

        public ViewResult ProvidersMembersByDocTypeListBox(string fieldName, string emptyOptionText, short? selectedProviderId, short? selectedDocumentType)//,string selectedUserName removed , add for request page though)
        {
            IEnumerable<SelectListItem> selectedListItems;
            ICollection<RMSeBubbleMembershipUser> membershipUsers;
            string optionText;

            ViewData.SetValue(GlobalViewDataKey.FieldName, fieldName);
            ViewData.SetValue(GlobalViewDataKey.ClassName, "ProvidersMembersDropDown");

            if (selectedProviderId.HasValue)
            {
                membershipUsers = _MembershipService.GetUsersOfProvider(selectedProviderId.Value);

                if (membershipUsers.Count == 0)
                {
                    // Dropdown for memebers , follow this mike
                    ViewData.SetValue(GlobalViewDataKey.Disabled, true);
                    selectedListItems = new Collection<SelectListItem>();
                    optionText = "No members exist for provider. Please select another provider.";
                }
                else
                {
                    optionText = emptyOptionText;

                    //MIKES NOTES: Original code...trying to isolate userdoctype and providerid must bwe true to view the user
                    /*
                    selectedListItems = from user in membershipUsers.OrderBy(user => user.PersonalInformation.LastName)
                                        select new SelectListItem
                                        {
                                            Text = String.Format(_UserDisplayFormat, user.PersonalInformation.Title, user.PersonalInformation.FirstName, user.PersonalInformation.LastName,
                                            user.UserName),
                                            Value = user.UserName,
                                            Selected = user.UserName == selectedUserName
                                        };
                    */

                    //MIKE NOTE: THIS IS THE LIST
                    //selectedListItems = from user in membershipUsers.OrderBy(user => user.PersonalInformation.LastName)
                    //                    select new SelectListItem
                    //                    {
                    //                        Text = String.Format(_UserDisplayFormat, user.PersonalInformation.Title, user.PersonalInformation.FirstName, user.PersonalInformation.LastName,
                    //                        user.UserName),
                    //                        Value = user.UserName,
                    //                        Selected = user.UserName == selectedUserName
                    //                    };



                    // has one error???
                    string[] FileListType = new string[] { };
                    //movies = Model.ToArray;
                    //List<string> Lst = new List<string>();
                    List<SelectListItem> Lst = new List<SelectListItem>();
                    if (selectedDocumentType.HasValue == true) // && selectedProviderId.Value != null)
                    {
                        try
                        {

                            System.Data.SqlClient.SqlConnection con = new System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["RMSeBUBBLE"].ConnectionString);
                            System.Data.SqlClient.SqlCommand command = new System.Data.SqlClient.SqlCommand("[dbo].[ListUserByProviderAndDocumentType]", con);
                            con.Open();
                            command.CommandType = System.Data.CommandType.StoredProcedure;
                            command.Parameters.Add(new System.Data.SqlClient.SqlParameter("@ProvID", System.Data.SqlDbType.Int)).Value = Convert.ToInt32("0" + selectedProviderId.Value);
                            command.Parameters.Add(new System.Data.SqlClient.SqlParameter("@DocTypeID", System.Data.SqlDbType.Int)).Value = Convert.ToInt32("0" + selectedDocumentType.Value); //15;
                            System.Data.IDataReader dr = command.ExecuteReader(System.Data.CommandBehavior.CloseConnection);

                            while (dr.Read())
                            {
                                //Lst.Add(Text = String.Format();
                                //selectedListItems = new SelectListItem { Text = dr["UserName"].ToString(), Value = dr["UserName"].ToString(), Selected = (dr["UserName"].ToString() == selectedUserName) }; //user.UserName == selectedUserName};
                                SelectListItem itm = new SelectListItem();
                                itm.Text = dr["UserName"].ToString();
                                itm.Value = dr["UserName"].ToString();
                                itm.Selected = (dr["UserName"].ToString() == selectedDocumentType.ToString());
                                //selectedListItems = itm;
                                Lst.Add(itm);
                            };
                            //FileListType = Lst.ToArray();
                            con.Close();
                        }
                        catch (Exception Ex)
                        {
                            // Add empty list caption or error list
                        }
                    }

                    //selectedListItems = FileListType.All;
                    selectedListItems = Lst;
                }
            }
            else
            {
                optionText = "-Select Provider-";
                ViewData.SetValue(GlobalViewDataKey.Disabled, true);
                selectedListItems = new Collection<SelectListItem>();
            }

            ViewData.SetValue(GlobalViewDataKey.OptionText, optionText);
            return View("ListBox", selectedListItems);
        }


        //// this is the original ProvidersMembersListBox
        //public ViewResult OriginalProvidersMembersListBox(string fieldName, string emptyOptionText, short? selectedProviderId, string selectedUserName, short? selectedDocumentType)  
        public ViewResult ProvidersMembersListBoxByType(string fieldName, string emptyOptionText, short? selectedProviderId, string selectedUserName, short? selectedDocumentType)
        {
            IEnumerable<SelectListItem> selectedListItems;
            ICollection<RMSeBubbleMembershipUser> membershipUsers;
            string optionText;

            ViewData.SetValue(GlobalViewDataKey.FieldName, fieldName);
            ViewData.SetValue(GlobalViewDataKey.ClassName, "ProvidersMembersDropDown");

            if (selectedProviderId.HasValue)
            {
                membershipUsers = _MembershipService.GetUsersOfProvider(selectedProviderId.Value);

                if (membershipUsers.Count == 0)
                {
                    // Dropdown for memebers , follow this mike
                    ViewData.SetValue(GlobalViewDataKey.Disabled, true);
                    selectedListItems = new Collection<SelectListItem>();
                    optionText = "No members exist for provider. Please select another provider.";
                }
                else
                {
                    optionText = emptyOptionText;

                    // //MIKES NOTES: Original code...trying to isolate userdoctype and providerid must bwe true to view the user
                    // // Original Code

                    // selectedListItems = from user in membershipUsers.OrderBy(user => user.PersonalInformation.LastName)
                    //                    select new SelectListItem
                    //                    {
                    //                        Text = String.Format(_UserDisplayFormat, user.PersonalInformation.Title, user.PersonalInformation.FirstName, user.PersonalInformation.LastName,
                    //                        user.UserName),
                    //                        Value = user.UserName,
                    //                        Selected = user.UserName == selectedUserName
                    //                    };

                    // End Original Code
                    //MIKE NOTE: THIS IS THE LIST

                    System.Data.SqlClient.SqlConnection con = new System.Data.SqlClient.SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["RMSeBUBBLE"].ConnectionString);
                    System.Data.SqlClient.SqlCommand command = new System.Data.SqlClient.SqlCommand("[dbo].[ListUserByProviderAndDocumentType]", con);
                    con.Open();
                    command.CommandType = System.Data.CommandType.StoredProcedure;
                    command.Parameters.Add(new System.Data.SqlClient.SqlParameter("@ProvID", System.Data.SqlDbType.Int)).Value = Convert.ToInt32("0" + selectedProviderId.Value);
                    if (selectedDocumentType.HasValue == true)
                    {
                        command.Parameters.Add(new System.Data.SqlClient.SqlParameter("@DocTypeID", System.Data.SqlDbType.Int)).Value = Convert.ToInt32("0" + selectedDocumentType.Value); //15;

                    }
                    else
                    {
                        command.Parameters.Add(new System.Data.SqlClient.SqlParameter("@DocTypeID", System.Data.SqlDbType.Int)).Value = 0; // Convert.ToInt32("0" + selectedDocumentType.Value); //15;
                    }
                    System.Data.IDataReader dr = command.ExecuteReader(System.Data.CommandBehavior.CloseConnection);
                    List<SelectListItem> Lst = new List<SelectListItem>();
                    while (dr.Read())
                    {
                        //Lst.Add(Text = String.Format();
                        //selectedListItems = new SelectListItem { Text = dr["UserName"].ToString(), Value = dr["UserName"].ToString(), Selected = (dr["UserName"].ToString() == selectedUserName) }; //user.UserName == selectedUserName};
                        SelectListItem itm = new SelectListItem();
                        itm.Text = dr["FirstName"].ToString() + " " + dr["LastName"].ToString() + " (" + dr["UserName"].ToString() + ") " + dr["Title"].ToString();
                        itm.Value = dr["UserName"].ToString();
                        itm.Selected = (dr["UserName"].ToString() == selectedUserName);// selectedDocumentType.ToString());
                        //selectedListItems = itm;
                        Lst.Add(itm);

                    };
                    //FileListType = Lst.ToArray();
                    con.Close();
                    //selectedListItems = FileListType.All;
                    selectedListItems = Lst;

                }
            }
            else
            {
                optionText = "-Select Provider-";
                ViewData.SetValue(GlobalViewDataKey.Disabled, true);
                selectedListItems = new Collection<SelectListItem>();
            }

            ViewData.SetValue(GlobalViewDataKey.OptionText, optionText);

            return View("ListBox", selectedListItems);

        }

        //Original Dropdown

        public ViewResult ProvidersMembersListBox(string fieldName, string emptyOptionText, short? selectedProviderId, string selectedUserName)
        {
            IEnumerable<SelectListItem> selectedListItems;
            ICollection<RMSeBubbleMembershipUser> membershipUsers;
            string optionText;

            ViewData.SetValue(GlobalViewDataKey.FieldName, fieldName);
            ViewData.SetValue(GlobalViewDataKey.ClassName, "ProvidersMembersDropDown");

            if (selectedProviderId.HasValue)
            {
                membershipUsers = _MembershipService.GetUsersOfProvider(selectedProviderId.Value);

                if (membershipUsers.Count == 0)
                {
                    ViewData.SetValue(GlobalViewDataKey.Disabled, true);
                    selectedListItems = new Collection<SelectListItem>();
                    optionText = "No members exist for provider. Please select another provider.";
                }
                else
                {
                    optionText = emptyOptionText;
                    selectedListItems = from user in membershipUsers.OrderBy(user => user.PersonalInformation.LastName)
                                        select new SelectListItem
                                        {
                                            Text = String.Format(_UserDisplayFormat, user.PersonalInformation.Title, user.PersonalInformation.FirstName, user.PersonalInformation.LastName,
                                            user.UserName),
                                            Value = user.UserName,
                                            Selected = user.UserName == selectedUserName
                                        };
                }
            }
            else
            {
                optionText = "-Select Provider-";
                ViewData.SetValue(GlobalViewDataKey.Disabled, true);
                selectedListItems = new Collection<SelectListItem>();
            }

            ViewData.SetValue(GlobalViewDataKey.OptionText, optionText);

            return View("ListBox", selectedListItems);

        }

        //Original ListBox for 





        private string GetProviderInNetworkOptionTextTest(ProviderInNetworkTest providerInNetworkTest, bool showNetworkSettings)
        {
            string providerInNetworkText;

            if (showNetworkSettings)
            {
                providerInNetworkText = providerInNetworkTest.ProviderName;
            }
            else
                providerInNetworkText = providerInNetworkTest.ProviderName;

            return providerInNetworkText;
        }



        [AuditingAuthorizeAttribute("UserDocumentTypesDropDown", Roles = "DocumentAdmin")]
        public ViewResult UserDocumentTypesDropDown(string fieldName, string emptyOptionText, string selectedUserName, short selectedDocumentType)
        {
            IEnumerable<SelectListItem> selectedListItems;
            IDictionary<short, string> documentTypes;
            string optionText;

            ViewData.SetValue(GlobalViewDataKey.FieldName, fieldName);
            ViewData.SetValue(GlobalViewDataKey.ClassName, "UserDocumentTypesDropDown");
            int userIndex;
            int UserProviderID;
            if (!String.IsNullOrEmpty(selectedUserName))
            {
                userIndex = _MembershipService.GetUserIndex(selectedUserName);
                UserProviderID = Convert.ToInt16(_MembershipService.GetUsersProviderId(selectedUserName, false));
                documentTypes = _DocumentTypesRepository.GetUsersDocumentTypes(userIndex, UserProviderID);

                if (documentTypes.Count == 0)
                {
                    optionText = "Provider member cannot accept documents. Please select another member.";
                    ViewData.SetValue(GlobalViewDataKey.Disabled, true);
                    selectedListItems = new Collection<SelectListItem>();
                }
                else
                {
                    optionText = emptyOptionText;
                    selectedListItems = from documentType in documentTypes.OrderBy(d => d.Value)
                                        select new SelectListItem
                                        {
                                            Text = documentType.Value,
                                            Value = documentType.Key.ToString(),
                                            Selected = documentType.Key == selectedDocumentType
                                        };
                }
            }
            else
            {
                optionText = "-Select Provider Member-";
                ViewData.SetValue(GlobalViewDataKey.Disabled, true);
                selectedListItems = new Collection<SelectListItem>();
            }

            ViewData.SetValue(GlobalViewDataKey.OptionText, optionText);

            return View("DropDown", selectedListItems);

        }

        [AuditingAuthorizeAttribute("ProviderDocumentTypesDropDown")]
        public ViewResult ProviderDocumentTypesDropDown(string fieldName, string emptyOptionText, short? selectedProviderId, short selectedDocumentType)
        {
            IEnumerable<SelectListItem> selectedListItems;
            IDictionary<short, string> documentTypes;
            string optionText;

            ViewData.SetValue(GlobalViewDataKey.FieldName, fieldName);
            ViewData.SetValue(GlobalViewDataKey.ClassName, "ProviderDocumentTypesDropDown");
            ViewData.SetValue(GlobalViewDataKey.Disabled, false); //defualt setting is true because settign is false error

            if (selectedProviderId.HasValue)
            {
                if (selectedProviderId.Value == 0)
                {
                    optionText = "-Select Provider-";
                    ViewData.SetValue(GlobalViewDataKey.Disabled, true);
                    selectedListItems = new Collection<SelectListItem>();
                }
                else
                {
                    documentTypes = _DocumentTypesRepository.GetProvidersDocumentTypes(selectedProviderId.Value);

                    if (documentTypes.Count == 0)
                        ViewData.SetValue(GlobalViewDataKey.OptionText, "Provider cannot accept documents.");

                    selectedListItems = from documentType in documentTypes.OrderBy(d => d.Value)
                                        select new SelectListItem
                                        {
                                            Text = documentType.Value,
                                            Value = documentType.Key.ToString(),
                                            Selected = documentType.Key == selectedDocumentType
                                        };

                    optionText = emptyOptionText;
                }
            }
            else
            {
                optionText = "-Select Provider-";
                ViewData.SetValue(GlobalViewDataKey.Disabled, true);
                selectedListItems = new Collection<SelectListItem>();
            }

            ViewData.SetValue(GlobalViewDataKey.Disabled, false);
            ViewData.SetValue(GlobalViewDataKey.OptionText, optionText);
            return View("DropDown", selectedListItems);
        }

        public ActionResult GetETARSatatusForProvider(short? selectedProviderId)
        {
            bool IseTAR = false;
            IseTAR = _DocumentTypesRepository.IseTAROrganization(selectedProviderId.Value);
            Session["ProviderID_ETAR"] = selectedProviderId;
            Session["ProviderIseTAr_ETAR"] = IseTAR;

            if (Session["UploadedFilesList"] != null)
            {
                List<UploadedFiles> UploadedFilesList = Session["UploadedFilesList"] as List<UploadedFiles>;
                Session["UploadedFilesList"] = UploadedFilesList.Select(c => { c.SendToProviderId = selectedProviderId; return c; }).ToList();
                Session["UploadedFilesList"] = UploadedFilesList.Select(c => { c.SendToProviderIsETAR = IseTAR; return c; }).ToList();
            }
            return Json(IseTAR, JsonRequestBehavior.AllowGet);
        }

        public ActionResult ProviderDocumentTypeDropDownDevExp(Action<ComboBoxSettings> comboBoxSettings, short? selectedProviderId, short? selectedDocumentType)
        {
            DevExpressComboModel devExpressComboModel = new DevExpressComboModel();
            IDictionary<short, string> documentTypes;
            documentTypes = _DocumentTypesRepository.GetProvidersDocumentTypes((selectedProviderId != null ? selectedProviderId.Value : (short)0));

            //if (documentTypes.Count == 0)
            //    ViewData.SetValue(GlobalViewDataKey.OptionText, "Provider cannot accept documents.");

            devExpressComboModel.Items = from documentType in documentTypes.OrderBy(d => d.Value)
                                         select new SelectListItem
                                         {
                                             Text = documentType.Value,
                                             Value = documentType.Key.ToString(),
                                             Selected = documentType.Key == selectedDocumentType
                                         };
            devExpressComboModel.cmbSettings = comboBoxSettings;
            devExpressComboModel.SelectedValue = selectedDocumentType;

            return PartialView("CommonDropDown", devExpressComboModel);
        }

        #endregion

        #region Helper Methods
        //private void GetRSAKeysForUserAndSuperAdmin()
        //{
        //    //If File encryption is enabled, get the key pair of logged in user and superadmin - added by Guru
        //    if (DocumentFileProcessor.EnableFileEncryption)
        //    {
        //        string userName = User.Identity.Name;
        //        //Check if asymmetric key pair is generated for this user.
        //        //If not then genrerate the RSA keypair and store it in database.
        //        _MembershipService.GetAsymmetricKeysForUser(userName);

        //        //Check if asymmetric key pair for SuperAdmin 
        //        _MembershipService.GetAsymmetricKeysForSuperAdmin();
        //    }
        //} 
        #endregion
    }
}
