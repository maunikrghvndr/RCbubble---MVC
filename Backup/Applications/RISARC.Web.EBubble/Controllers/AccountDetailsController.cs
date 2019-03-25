using RISARC.Common.ExceptionHandling;
using RISARC.Common.Model;
using RISARC.Documents.Model;
using RISARC.Documents.Service;
using RISARC.Emr.Web.DataTypes;
using RISARC.Emr.Web.Extensions;
using RISARC.eTAR.Model;
using RISARC.eTAR.Service;
using RISARC.Files.Model;
using RISARC.Files.Service;
using RISARC.Membership.Model;
using RISARC.Membership.Service;
using RISARC.Setup.Implementation.Repository;
using RISARC.Web.EBubble.Models.Binders;
using SpiegelDg.Security.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using System.Web.Routing;

namespace RISARC.Web.EBubble.Controllers
{
    public class AccountDetailsController : Controller
    {
        #region Private Variables

        private IAccountDetailsService _AccountDetailsService;
        private IFilesService _FilesService;
        private IDocumentTypesRepository _DocumentTypesRepository;
        private IDocumentsAdminService _DocumentsAdminService;
        private IRMSeBubbleMempershipService _MembershipService;
        private IUserDocumentsService _UserDocumentsService;
        private ITimeTrackerService _TimeTrackerService;

        #endregion Private Variables

        #region Constructor

        public AccountDetailsController(IAccountDetailsService accountDetailsService, IFilesService filesService, IDocumentsAdminService adminService,
            IDocumentTypesRepository documentTypesRepository, IRMSeBubbleMempershipService membershipService, IUserDocumentsService userDocumentService, ITimeTrackerService timeTrackerService)
        {
            this._AccountDetailsService = accountDetailsService;
            this._FilesService = filesService;
            this._DocumentTypesRepository = documentTypesRepository;
            this._DocumentsAdminService = adminService;
            this._MembershipService = membershipService;
            this._UserDocumentsService = userDocumentService;
            this._TimeTrackerService = timeTrackerService;
        }

        #endregion Constructor

        public ActionResult AccountDetailsMaster([ModelBinder(typeof(EncryptedIntegerBinder))]int? TCNIdentificationID, string AccountNo, [ModelBinder(typeof(EncryptedShortBinder))]short? SenderProviderID, string TCNNo, short? sourceFlag,
           [ModelBinder(typeof(EncryptedIntegerBinder))]int? AccountSubmissionDetailsID, DateTime? DeadLineDate, bool? IsTCNSubmitted, [ModelBinder(typeof(EncryptedIntegerBinder))]int? DocumentFileId, long? eNoteID = null, [ModelBinder(typeof(EncryptedLongBinder))]long? DocumentID = null, [ModelBinder(typeof(EncryptedIntegerBinder))]int? PatientId = null)
        {

            AccountDetailsMain accountDetailsMain = new AccountDetailsMain();
            accountDetailsMain.SenderProviderID = SenderProviderID;
            accountDetailsMain.DocumentID = DocumentID;
            
            //if condition for PQRS QUESTION ANSWER modile in document in the document viewer:
            if (PatientId.HasValue)
            {
                accountDetailsMain.PatientId = PatientId;
                ViewData["QuesAnsPending"] = "ApplyQues";   
            }
          
            // ends 

            //if condition for screens requiring single document to be viewed.
            if (DocumentFileId.HasValue)
            {
                accountDetailsMain.SenderProviderID = SenderProviderID;
                accountDetailsMain.DocumentFileID = DocumentFileId;
                ViewData["ViewDocumentReadyToDownload"] = "ViewDocument";
                string path = Request.UrlReferrer.AbsolutePath.ToString();
                ViewData["ReferringPath"] = "~" + path;
                if (path.Contains("MyDownloadedDocuments"))
                {
                    _UserDocumentsService.UpdateDocumentViewDate(Convert.ToInt32(accountDetailsMain.DocumentID));
                }
                return View(accountDetailsMain);
            }
            
            accountDetailsMain.AccountNo = AccountNo;
            accountDetailsMain.TCNNo = TCNNo;
            accountDetailsMain.DeadLineDate = DeadLineDate;
            accountDetailsMain.TCNIdentificationID = TCNIdentificationID;
            accountDetailsMain.AccountSubmissionDetailsID = AccountSubmissionDetailsID;
            accountDetailsMain.IsTCNSubmitted = IsTCNSubmitted;

            if (sourceFlag == null || (sourceFlag != null && sourceFlag == 2))
            {
                
                List<RISARC.eTAR.Model.DocumentType> documentTypeList = new List<RISARC.eTAR.Model.DocumentType>();
                documentTypeList = _AccountDetailsService.GetDocumentTypeByTCN(accountDetailsMain);

                _UserDocumentsService.UpdateDocumentDownloadDateByAccountNumber(AccountSubmissionDetailsID);
                foreach (var item in documentTypeList)
                {
                    _UserDocumentsService.UpdateactionLog(item.DocumentID, item.DocumentTypeName, item.SenderProviderId);
                }
            }

            //sourceFlag = 1;//Is to be removed
            if (sourceFlag != null && sourceFlag == 1)
            {
                accountDetailsMain.providerinformation = _AccountDetailsService.GetProviderInfromation(Convert.ToInt32(SenderProviderID));
                accountDetailsMain.IsProviderEtar_SenderProvider = accountDetailsMain.providerinformation.IsETar ?? false;
            }
            if (!String.IsNullOrEmpty(AccountNo))
            {
                accountDetailsMain.patientInformation = _AccountDetailsService.GetPatientInfromation(AccountNo);
            }
            ViewData["sourceFlag"] = sourceFlag;
            if (sourceFlag == 1)
                accountDetailsMain.tcnDocumentType = _AccountDetailsService.GetDocumentTypeForViewer(TCNNo, Convert.ToInt64(AccountSubmissionDetailsID), Convert.ToInt32(SenderProviderID));
            else
                accountDetailsMain.tcnDocumentType = _AccountDetailsService.GetDocumentTypeForViewer(TCNNo, Convert.ToInt64(AccountSubmissionDetailsID), null);

            //Get assymetric keys for logged in user and RISARC super admin.
            _MembershipService.GetRSAKeysForUserAndSuperAdmin(User.Identity.Name, DocumentFileProcessor.EnableTCNFileEncryption);

            return View(accountDetailsMain);
        }

        public ActionResult ViewDocumentInViewer([ModelBinder(typeof(EncryptedIntegerBinder))]int DocumentFileId)
        {
            ViewData["DocumentFileId"] = DocumentFileId;
            AccountDetailsMain Test = new AccountDetailsMain();

            return View("AccountDetailsMaster");
        }

        public ActionResult ReassignTaskContent(AccountDetailsMain accountDetailsMain)
        {
            accountDetailsMain.ReviewerInformationList = _AccountDetailsService.GetReAssignReviewerList(accountDetailsMain);

            return PartialView("ReassignTaskContent", accountDetailsMain);
        }

        public ActionResult TCNDocumentCombo(string TCNNo, long AccountSubmissionDetailsID, short? SenderProviderID)
        {
            AccountDetailsMain accountDetailsMain = new AccountDetailsMain();
            if (string.IsNullOrEmpty(TCNNo))
                TCNNo = null;
            //if no of tcn doc is equal to 1 Send a flag in view data to Show the TCN as selected.

            accountDetailsMain.tcnDocumentType = _AccountDetailsService.GetDocumentTypeForViewer(TCNNo, Convert.ToInt64(AccountSubmissionDetailsID), Convert.ToInt32(SenderProviderID));
            if (accountDetailsMain.tcnDocumentType.Count != 0 && accountDetailsMain.tcnDocumentType.Where(a => a.DocumentTypeName.Contains("TCN Summary")).Count() == 1)
                ViewData["Defaultselection"] = 1;
            return PartialView(accountDetailsMain);
        }

        public ActionResult AccountNotesPopup(AccountDetailsMain accountDetailsMain, int? enoteID = null, long? DocumentID = null, bool eNoteSearchFlag = false)
        {
            if (eNoteSearchFlag == true && enoteID != null)
            {
                ViewData["eNoteSearchFlag"] = true;
                ViewData["enoteID"] = enoteID;
                ViewData["DocumentID"] = DocumentID;
            }
            return PartialView("AccountNotesPopup", accountDetailsMain);
        }

        public ActionResult DocumentViewerPartial()
        {
            return PartialView("DocumentViewerPartial");
        }

        public ActionResult TCNFormPartial(string TCNNo, long? AccountSubmissionDetailsID, short? SenderProviderID, int documentId, int? recieverProviderID)
        {
            if (documentId == 0)
            {
                AccountDetailsMain accountDetailsMain = new AccountDetailsMain();
                if (string.IsNullOrEmpty(TCNNo))
                    TCNNo = null;
                accountDetailsMain.tcnDocumentType = _AccountDetailsService.GetDocumentTypeForViewer(TCNNo, Convert.ToInt64(AccountSubmissionDetailsID), Convert.ToInt32(SenderProviderID));
                if (accountDetailsMain.tcnDocumentType.Count != 0 && accountDetailsMain.tcnDocumentType.Where(a => a.DocumentTypeName.Contains("TCN Summary")).Count() == 1)
                    documentId = (int)accountDetailsMain.tcnDocumentType[0].DocumentID;
            }
            DocumentFile documentFile;
            if (documentId != 0)
            {
                documentFile = _UserDocumentsService.GetDocumentFile(documentId, loadStream: true, isTCNFile: true);
                ViewData["HtmlFileStream"] = documentFile.Stream;
            }
            return PartialView("TCNFormPartial");
        }

        public ActionResult AttachOrRemoveTCNPopup()
        {
            return PartialView("AttachOrRemoveTCNPopup");
        }

        public ActionResult TCNFormPopupContent(AccountDetailsMain accountDetailsMain, bool IsClearSession = false)
        {
            // Add session data for TCN file Upload
            if(IsClearSession)
                Session["UploadedTCNFilesList"] = null;

            if (Session["UploadedTCNFilesList"] == null)
            {
                HtmlHelper htmlHelper = RISARC.Common.Extensions.HtmlHelperExtensions.GetHtmlHelper(this);
                ICollection<UploadedFiles> uploadedTcnFiles = _DocumentsAdminService.GetTCNFiles(accountDetailsMain.AccountSubmissionDetailsID, accountDetailsMain.SenderProviderID);
                foreach (var item in uploadedTcnFiles)
                {
                    item.DeleteLink = string.Format("<a class='removeFile' encid='{0}' onclick='removeTcnFile(\"{0}\");' href='#'><img height='17' title='Remove File' style='vertical-align: middle;' alt='remove' src='{1}'/></a></div>", EncryptionExtensions.Encrypt(htmlHelper, item.FileID), Url.Content("~/images/remove.png"));
                    _DocumentsAdminService.AddTCNFilesToGrid(item);
                }
            }
            // End Session Data Add.
            var model = _DocumentsAdminService.UploadedTCNFilesList.OrderBy(tn => tn.TCNNumber).ThenBy(id => id.FileID).ToList<UploadedFiles>();
            return PartialView("TCNFormPopupContent", model);
        }

        /// <summary>
        /// Fill DocumentTypeDropdown
        /// </summary>
        /// <param name="comboBoxSettings"></param>
        /// <returns></returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 03/25/2014 | Surekha   | Created
        /// </RevisionHistory>
        public ActionResult TCNDocumentTypeDropDownDevExp(Action<DevExpress.Web.Mvc.ComboBoxSettings> comboBoxSettings, short? selectedDocumentType)
        {
            RISARC.Web.EBubble.Models.DevxCommonModels.DevExpressComboModel devExpressComboModel = new RISARC.Web.EBubble.Models.DevxCommonModels.DevExpressComboModel();
            IDictionary<short, string> documentTypes;
            documentTypes = _DocumentTypesRepository.GetTCNDocumentTypes();

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

        public ActionResult ProviderPatientInfoData(AccountDetailsMain accountDetailsMain)
        {
            return PartialView("ProviderPatientInfoData", accountDetailsMain);
        }

        public ActionResult InternalExternalENote(AccountDetailsMain accountDetailsMain)
        {
            if (Request.QueryString["eNoteID"] != null)
            {
                accountDetailsMain.enote.eNoteID = Convert.ToInt64(Request.QueryString["eNoteID"]);
                accountDetailsMain.enote.ReplyToeNoteID = Convert.ToInt64(Request.QueryString["eNoteID"]);
            }
            accountDetailsMain.HasExternalNoteAccess = _AccountDetailsService.GetCurrentConfiguration().HasExternalNoteAccess;
            accountDetailsMain.IsProviderEtar_LoggedInUser = _AccountDetailsService.GetProviderInfromation(Convert.ToInt32(_MembershipService.GetUsersProviderId(base.User.Identity.Name, true))).IsETar ?? false;
            AddNoteTabs(accountDetailsMain);
            return PartialView("InternalExternalENote", accountDetailsMain);
        }

        #region Internal / External / e Note Common

        public ActionResult InternalExternalENote_Callback(AccountDetailsMain accountDetailsMain)
        {
            AddNoteTabs(accountDetailsMain);
            return PartialView("InternalExternalENote", accountDetailsMain);
        }

        private void AddNoteTabs(AccountDetailsMain accountDetailsMain)
        {
            HtmlHelper htmlHelper = RISARC.Common.Extensions.HtmlHelperExtensions.GetHtmlHelper(this);
            bool isTabVisible = true;
            if (accountDetailsMain.enote.eNoteID != null)
            {
                isTabVisible = false;
            }
            if (Request["extFlag"] == "1")
            {
                accountDetailsMain.NoteTabs.Add(new NoteTabsModel()
                {
                    TabText = "Add TAR Language",
                    TabName = "Comments",
                    ActionMethodName = "GetComments",
                    ControllerName = "AccountDetails",
                    RoutDirectoryData = new RouteValueDictionary { { "AccountSubmissionDetailsID", accountDetailsMain.AccountSubmissionDetailsID } },
                    IsRenderAction = true,
                    IsPartialView = false,
                });
                accountDetailsMain.NoteTabs.Add(new NoteTabsModel()
                {
                    TabText = "Additional TAR Language",
                    TabName = "Additional TAR Language",
                    ActionMethodName = "GetAdditionalTARLanguage",
                    ControllerName = "AccountDetails",
                    RoutDirectoryData = new RouteValueDictionary { { "AccountSubmissionDetailsID", accountDetailsMain.AccountSubmissionDetailsID } },
                    IsRenderAction = true,
                    IsPartialView = false,
                });
                accountDetailsMain.NoteTabs.Add(new NoteTabsModel()
                {
                    TabText = "Internal Note",
                    TabName = "Internal Note",
                    ActionMethodName = "InternalNoteCallbackPanel",
                    ControllerName = "AccountDetails",
                    RoutDirectoryData = new RouteValueDictionary { { "DocumentID", accountDetailsMain.DocumentID } },
                    IsRenderAction = true,
                    IsPartialView = false
                });
                if ((accountDetailsMain.HasExternalNoteAccess || accountDetailsMain.IsProviderEtar_LoggedInUser))
                {
                    accountDetailsMain.NoteTabs.Add(new NoteTabsModel()
                    {
                        TabText = "External Note",
                        TabName = "External Note",
                        PartialViewName = "ExternalNoteContent",
                        PartialViewModel = accountDetailsMain,
                        IsRenderAction = false,
                        IsPartialView = true,
                        IsTabVisible = isTabVisible,
                        SelectedPageIndex = 2
                    });
                }
            }
            else if (accountDetailsMain.TCNIdentificationID != null)
            {
                accountDetailsMain.NoteTabs.Add(new NoteTabsModel()
                {
                    TabText = "Internal Note",
                    TabName = "Internal Note",
                    ActionMethodName = "InternalNoteCallbackPanel",
                    ControllerName = "AccountDetails",
                    RoutDirectoryData = new RouteValueDictionary { { "DocumentID", accountDetailsMain.DocumentID } },
                    IsRenderAction = true,
                    IsPartialView = false
                });
                if ((accountDetailsMain.HasExternalNoteAccess || accountDetailsMain.IsProviderEtar_LoggedInUser))
                {
                    accountDetailsMain.NoteTabs.Add(new NoteTabsModel()
                    {
                        TabText = "External Note",
                        TabName = "External Note",
                        PartialViewName = "ExternalNoteContent",
                        PartialViewModel = accountDetailsMain,
                        IsRenderAction = false,
                        IsPartialView = true,
                        IsTabVisible = isTabVisible,
                    });
                }
                accountDetailsMain.NoteTabs.Add(new NoteTabsModel()
                {
                    TabText = "e-Note",
                    TabName = "e-Note",
                    ActionMethodName = "eNoteCallbackPanel",
                    ControllerName = "AccountDetails",
                    RoutDirectoryData = new RouteValueDictionary { { "DocumentID", accountDetailsMain.DocumentID }, { "enote.eNoteID", accountDetailsMain.enote.eNoteID } },
                    IsRenderAction = true,
                    IsPartialView = false,
                });
            }
            else if (accountDetailsMain.DocumentID != null && accountDetailsMain.enote.eNoteID != null)
            {
                accountDetailsMain.NoteTabs.Add(new NoteTabsModel()
                {
                    TabText = "Internal Note",
                    TabName = "Internal Note",
                    ActionMethodName = "InternalNoteCallbackPanel",
                    ControllerName = "AccountDetails",
                    RoutDirectoryData = new RouteValueDictionary { { "DocumentID", accountDetailsMain.DocumentID } },
                    IsRenderAction = true,
                    IsPartialView = false
                });
                accountDetailsMain.NoteTabs.Add(new NoteTabsModel()
                {
                    TabText = "e-Note",
                    TabName = "e-Note",
                    ActionMethodName = "eNoteCallbackPanel",
                    ControllerName = "AccountDetails",
                    RoutDirectoryData = new RouteValueDictionary { { "DocumentID", accountDetailsMain.DocumentID }, { "enote.eNoteID", accountDetailsMain.enote.eNoteID } },
                    IsRenderAction = true,
                    IsPartialView = false,
                    SelectedPageIndex = 1
                });
            }
            else
            {
                accountDetailsMain.NoteTabs.Add(new NoteTabsModel()
                {
                    TabText = "Add TAR Language",
                    TabName = "Comments",
                    ActionMethodName = "GetComments",
                    ControllerName = "AccountDetails",
                    RoutDirectoryData = new RouteValueDictionary { { "AccountSubmissionDetailsID", accountDetailsMain.AccountSubmissionDetailsID } },
                    IsRenderAction = true,
                    IsPartialView = false,
                });
                accountDetailsMain.NoteTabs.Add(new NoteTabsModel()
                {
                    TabText = "Additional TAR Language",
                    TabName = "Additional TAR Language",
                    ActionMethodName = "GetAdditionalTARLanguage",
                    ControllerName = "AccountDetails",
                    RoutDirectoryData = new RouteValueDictionary { { "AccountSubmissionDetailsID", accountDetailsMain.AccountSubmissionDetailsID } },
                    IsRenderAction = true,
                    IsPartialView = false,
                });
                accountDetailsMain.NoteTabs.Add(new NoteTabsModel()
                {
                    TabText = "Internal Note",
                    TabName = "Internal Note",
                    ActionMethodName = "InternalNoteCallbackPanel",
                    ControllerName = "AccountDetails",
                    RoutDirectoryData = new RouteValueDictionary { { "DocumentID", accountDetailsMain.DocumentID } },
                    IsRenderAction = true,
                    IsPartialView = false
                });
                if ((accountDetailsMain.HasExternalNoteAccess || accountDetailsMain.IsProviderEtar_LoggedInUser))
                {
                    accountDetailsMain.NoteTabs.Add(new NoteTabsModel()
                    {
                        TabText = "External Note",
                        TabName = "External Note",
                        PartialViewName = "ExternalNoteContent",
                        PartialViewModel = accountDetailsMain,
                        IsRenderAction = false,
                        IsPartialView = true,
                        IsTabVisible = isTabVisible
                    });
                }
                accountDetailsMain.NoteTabs.Add(new NoteTabsModel()
                {
                    TabText = "e-Note",
                    TabName = "e-Note",
                    ActionMethodName = "eNoteCallbackPanel",
                    ControllerName = "AccountDetails",
                    RoutDirectoryData = new RouteValueDictionary { { "DocumentID", accountDetailsMain.DocumentID }, { "enote.eNoteID", accountDetailsMain.enote.eNoteID } },
                    IsRenderAction = true,
                    IsPartialView = false,
                });
            }
        }
        #endregion

        #region Internal Note

        /// <summary>
        /// Callback method for Internal Note
        /// </summary>
        /// <param name="internalNote">InternalNote Model / data entity.</param>
        /// <param name="controlFlag">Flag for pop up and normal control id.</param>
        /// <returns>Internal PArtial view</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 06/19/2014 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public ActionResult InternalNoteCallbackPanel(AccountDetailsMain accountDetailsMain)
        {
            return PartialView("InternalNoteContent", accountDetailsMain);
        }

        /// <summary>
        /// Return all the Internal Note specific to TCN Identifier.
        /// </summary>
        /// <param name="internalNote">InternalNote Model / data entity.</param>
        /// <returns>Partial view for Internal Note display Grid.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 03/14/2014 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public ActionResult InternalNoteGridCallback(InternalNote internalNote)
        {
            if (internalNote.DocumentID.HasValue)
            {
                internalNote.CreatedByUserName = User.Identity.Name;
                _AccountDetailsService.GetInternalNotes(internalNote);
            }
            return PartialView("InternalNoteGrid", internalNote);
        }

        /// <summary>
        /// Add Internal Note for the selected TCN Identifier.
        /// </summary>
        /// <param name="internalNote">InternalNote Model / data entity.</param>
        /// <returns>Json result for the added data.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 03/14/2014 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public ActionResult AddInternalNote(InternalNote internalNote)
        {
            internalNote.CreatedByUserName = User.Identity.Name;
            _AccountDetailsService.AddInternalNote(internalNote);
            return Json("Success", JsonRequestBehavior.AllowGet);
        }

        #endregion Internal Note

        #region External Note

        /// <summary>
        /// Fills Dropdown of TCN No.
        /// </summary>
        /// <param name="tcnDropDown">TCNDropDown Model / data entity.</param>
        /// <returns>Partial view for displaying drop down</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 06/23/2014 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public ActionResult TCNNumberDropDown(TCNDropDown tcnDropDown)
        {
            if (tcnDropDown.AccountSubmissionDetailsID.HasValue)
                _AccountDetailsService.GetTCNNumbers(tcnDropDown);

            return PartialView("_TCNNumberDropDown", tcnDropDown);
        }

        /// <summary>
        /// Return all the External Note specific to Account Number / TCN No And Sender Provider No.
        /// </summary>
        /// <param name="externalNote">ExternalNote Model / data entity.</param>
        /// <returns>Partial view for Internal Note display Grid.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 03/19/2014 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public ActionResult ExternalNoteGridCallback(ExternalNote externalNote, bool controlFlag = false)
        {
            ViewData["controlFlag"] = controlFlag;
            // if(externalNote.TCNIdentificationID.HasValue)
            _AccountDetailsService.GetExternalNotes(externalNote);

            return PartialView("ExternalNoteGrid", externalNote);
        }

        /// <summary>
        /// Add External Note for the selected TCN Identifier.
        /// </summary>
        /// <param name="externalNote">ExternalNote Model / data entity.</param>
        /// <returns>Json result for the added data.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 03/19/2014 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public ActionResult AddExternalNote(ExternalNote externalNote)
        {
            externalNote.CreatedByUserName = User.Identity.Name;
            _AccountDetailsService.AddExternalNote(externalNote);
            return Json("Success", JsonRequestBehavior.AllowGet);
        }

        #endregion External Note

        #region Comments

        /// <summary>
        /// Gets comments respective to the AccountSubmissionDetailsId
        /// </summary>
        /// <param name="accountSubmissionDetails">AccountSubmissionDetails model / data entity.</param>
        /// <returns>Partial view.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 03/26/2014 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public ActionResult GetComments(RISARC.eTAR.Model.AccountSubmissionDetails accountSubmissionDetails)
        {
            _AccountDetailsService.GetComment(accountSubmissionDetails);
            return PartialView("CommentsCallbackPartial", accountSubmissionDetails);
        }

        /// <summary>
        /// Updates Details for the provided AccountSubmissionDetailsID
        /// </summary>
        /// <param name="accountSubmissionDetails">AccountSubmissionDetails Model / Data entity.</param>
        /// <returns>Json Data</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 03/26/2014 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public ActionResult AddComments(RISARC.eTAR.Model.AccountSubmissionDetails accountSubmissionDetails)
        {
            _AccountDetailsService.UpdateComment(accountSubmissionDetails);
            return Json("Success", JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// Gets AdditionalTARLanguage respective to the AccountSubmissionDetailsId
        /// </summary>
        /// <param name="accountSubmissionDetails">AccountSubmissionDetails model / data entity.</param>
        /// <returns>Partial view.</returns>
        /// <RevisionHistory>
        /// Date        | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 04-Feb-2015 | Abhishek   | Created
        /// </RevisionHistory>
        public ActionResult GetAdditionalTARLanguage(RISARC.eTAR.Model.AccountSubmissionDetails accountSubmissionDetails)
        {
            _AccountDetailsService.GetComment(accountSubmissionDetails);
            return PartialView("AdditionalTARLanguagePartial", accountSubmissionDetails);
        }

        /// <summary>
        /// Adds AdditionalTARLanguage respective to the AccountSubmissionDetailsId
        /// </summary>
        /// <param name="accountSubmissionDetails">AccountSubmissionDetails model / data entity.</param>
        /// <returns>Json Data</returns>
        /// <RevisionHistory>
        /// Date        | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 12-Feb-2015 | Abhishek   | Created
        /// </RevisionHistory>
        public ActionResult AddAdditionalTARLanguage(RISARC.eTAR.Model.AccountSubmissionDetails accountSubmissionDetails)
        {
            _AccountDetailsService.UpdateAdditionalTARLanguage(accountSubmissionDetails);
            return Json("Success", JsonRequestBehavior.AllowGet);
        }
        #endregion Comments

        #region e-Note

        /// <summary>
        /// Get Users list for specified provider.
        /// </summary>
        /// <param name="ProviderID"></param>
        /// <returns></returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 04/18/2014 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        private IEnumerable<SelectListItem> GetUsersForProvider(short? ProviderID)
        {
            if (!ProviderID.HasValue)
            {
                ProviderID = _MembershipService.GetUsersProviderId(User.Identity.Name, true);
            }
            ICollection<RMSeBubbleMembershipUser> membershipUsers = _MembershipService.GetUsersOfProvider(ProviderID.Value);
            List<SelectListItem> selectUsers = membershipUsers.Select(user => new SelectListItem() { Text = user.FullName, Value = Convert.ToString(user.UserIndex) }).ToList();

            return selectUsers;
        }

        private IEnumerable<SelectListItem> GetResponibleMembersAndReviewer(short? SenderProviderID, long? AccountSubmissionDetailsID, long? DocumentID = null)
        {
            ICollection<RMSeBubbleMembershipUser> membershipUsers = _MembershipService.GetResponsibleMembersAndReviewer(SenderProviderID, AccountSubmissionDetailsID, DocumentID);
            List<SelectListItem> selectUsers = membershipUsers.Select(user => new SelectListItem() { Text = user.FullName, Value = Convert.ToString(user.UserIndex) }).ToList();

            return selectUsers;
        }

        /// <summary>
        /// Gets eNote for the provided TCN#, AccountNo, SenderProviderNo, CreatedByUser and Reply to e-note.
        /// </summary>
        /// <param name="enote">eNote Model / data entity.</param>
        /// <returns>Return partial view to display data.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 04/19/2014 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public ActionResult eNotesCallbackMethod(eNote enote, bool PopUpEnoteFlag = false)
        {
            if (PopUpEnoteFlag)
                ViewData["PopUpEnoteGrid"] = true;

            if (enote.DocumentID.HasValue || enote.eNoteID.HasValue)
            {
                enote.CreatedByUserName = User.Identity.Name;
                enote.PresenteNotes = _AccountDetailsService.GeteNotes(enote);
            }

            return PartialView("ENoteGrid", enote);
        }

        public ActionResult eNotesRecipientsCallbackMethod(long? replyToeNoteID)
        {
            eNote enote = new eNote() { ReplyToeNoteID = replyToeNoteID, CreatedByUserName = User.Identity.Name };
            enote.PresenteNotes = _AccountDetailsService.GeteNotes(enote);
            return PartialView("eNoteRecipientsGrid", enote);
        }

        /// <summary>
        /// Added eNote for the specified TCN Identification ID.
        /// </summary>
        /// <param name="enote">eNote Model / data entity.</param>
        /// <returns>Json result.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 04/19/2014 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public ActionResult AddeNote(eNote enote, string RecipientUserIndex, int responceWithinDays)
        {
            int iRowAffected = -1;
            if (enote.ReplyToeNoteID == null)
            {
                List<int> Recipients = new List<int>();

                if (RecipientUserIndex != null)
                    Recipients = RecipientUserIndex.Split(',').Select(int.Parse).ToList();

                if (Recipients.Count < 0)
                    return Json("Error", JsonRequestBehavior.AllowGet);
                else
                    enote.enoteRecipients = Recipients.Select(user => new eNoteRecipient() { UserIndexTo = user, ResponceWithinDays = responceWithinDays }).ToList();
            }
            enote.CreatedByUserName = User.Identity.Name;
            iRowAffected = _AccountDetailsService.AddeNote(enote);
            if (iRowAffected > 0)
                return Json("Success", JsonRequestBehavior.AllowGet);
            else
                return Json("Error", JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// Callback panel for eNote Section
        /// </summary>
        /// <param name="accountDetailsMain">AccountDetailsMain model / data entity.</param>
        /// <returns>eNote Partial view to render</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 06/10/2014 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public ActionResult eNoteCallbackPanel(AccountDetailsMain accountDetailsMain)
        {
            if (accountDetailsMain.DocumentID.HasValue)
            {
                ViewData["SenderMemnerAndReviewer"] = GetResponibleMembersAndReviewer(null, null, accountDetailsMain.DocumentID);
                ViewData["SenderUserList"] = GetUsersForProvider(null);
            }
            accountDetailsMain.IsProviderEtar_LoggedInUser = _AccountDetailsService.GetProviderInfromation(Convert.ToInt32(_MembershipService.GetUsersProviderId(base.User.Identity.Name, true))).IsETar ?? false;
            return PartialView("AddeNoteContent", accountDetailsMain);
        }

        #endregion e-Note

        public ActionResult InterExtNoteStatus(AccountDetailsMain accountDetailsMain, long? enoteID, long? DocumentID, bool eNoteSearchFlag = false)
        {
            if (eNoteSearchFlag && enoteID.HasValue)
            {
                ViewData["eNoteSearchFlag"] = true;
                ViewData["enoteID"] = enoteID;
                ViewData["DocumentID"] = DocumentID;
                //ViewData["SenderUserList"] = GetUsersForProvider(null);
                //ViewData["SenderMemnerAndReviewer"] = GetResponibleMembersAndReviewer(null, null, DocumentID);
            }
            else { ViewData["eNoteSearchFlag"] = false; }
            accountDetailsMain.TcnStatusList = _AccountDetailsService.GetTcnStatus();
            accountDetailsMain.CurrentTcnStatus = _AccountDetailsService.GetCurrentStatus(accountDetailsMain.TCNIdentificationID, accountDetailsMain.AccountSubmissionDetailsID);
            accountDetailsMain.HasExternalNoteAccess = _AccountDetailsService.GetCurrentConfiguration().HasExternalNoteAccess;
            accountDetailsMain.IsProviderEtar_LoggedInUser = _AccountDetailsService.GetProviderInfromation(Convert.ToInt32(_MembershipService.GetUsersProviderId(base.User.Identity.Name, true))).IsETar ?? false;
            return PartialView("InterExtNoteStatus", accountDetailsMain);
        }

        public bool SubmitTcnStatus(long accountSubmissionId, long TCNIdentificationId, short statusId, bool flag = false, string TCNNumber = null)
        {
            _AccountDetailsService.InsertTcnStatus(accountSubmissionId, TCNIdentificationId, statusId, flag);
            if(accountSubmissionId != null && TCNNumber != null)
                SendResponseLetter(accountSubmissionId, null, TCNNumber);
            return true;
        }

        //Save and Exit Button on Field officer screen
        //Added on 02-Feb-2015
        //Pending or Approved button click from "Save & Exit" link of field officer screen
        public bool SaveOrSubmitTCNStatus(long accountSubmissionId, long TCNIdentificationId, string ButtonText, bool flag = false, string TCNNumber = null)
        {
            if (ButtonText == "Save")
                _AccountDetailsService.InsertTcnStatus(accountSubmissionId, TCNIdentificationId, 4, flag); //StatusId=4 : Modified
            if (ButtonText == "Submit")
                _AccountDetailsService.InsertTcnStatus(accountSubmissionId, TCNIdentificationId, 1, flag); //StatusId=1 : Approved
            if (accountSubmissionId != null && TCNNumber != null)
                SendResponseLetter(accountSubmissionId, null, TCNNumber);
            return true;
        }
        //End Added

        [OutputCacheAttribute(VaryByParam = "*", Duration = 0, NoStore = true)]
        public void CleareSessionForRLUpload()
        {
            _DocumentsAdminService.CleareSessionForRLUpload();
        }

        public ActionResult RMSDocumentsCombo(AccountDetailsMain accountDetailsMain)
        {
            accountDetailsMain.DocumentTypeList = _AccountDetailsService.GetDocumentTypeNameByTCN(accountDetailsMain);
            return PartialView("RMSDocumentsCombo", accountDetailsMain);
        }

        /// <summary>
        /// Action Method to render the Documnet Type Grid on Documnet Viewer grid
        /// </summary>
        /// <param name="documentTypeID">DocumentTypeId</param>
        /// <param name="TCNNo">Tcnno</param>
        /// <param name="AccountSubmissionDetailsID">AccountSubmissionId</param>
        /// <param name="SenderProviderID">ID of Senders provider</param>
        /// <returns>RMSDocumentsGrid Grid Partial view</returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 03/20/2014 | Abdul   | Created
        /// </RevisionHistory>
        public ActionResult RMSDocumentsGrid(AccountDetailsMain accountDetailsMain)
        {
            if (!String.IsNullOrEmpty(Request.Params["documentTypeIdvalue"]))
                accountDetailsMain.DocumentTypeID = Convert.ToInt32(Request.Params["documentTypeIdvalue"]);

            //to show all docs
            if (accountDetailsMain.DocumentTypeID == -1)
                accountDetailsMain.DocumentTypeID = null;
            List<RISARC.eTAR.Model.DocumentType> filteredDocumentTypeList = new List<RISARC.eTAR.Model.DocumentType>();
            List<RISARC.eTAR.Model.DocumentType> documentTypeList = new List<RISARC.eTAR.Model.DocumentType>();
            documentTypeList = _AccountDetailsService.GetDocumentTypeByTCN(accountDetailsMain);
            if (AddRemoveLink(documentTypeList))
            {
                ViewData["ResponseLetterFound"] = true;
            }
            if (accountDetailsMain.DocumentTypeID == null)
            {
                accountDetailsMain.DocumentTypeList = documentTypeList;
                return PartialView("RMSDocumentsGrid", accountDetailsMain);
            }
            filteredDocumentTypeList = documentTypeList.Where(m => m.DocumentTypeID == accountDetailsMain.DocumentTypeID).ToList();
            accountDetailsMain.DocumentTypeList = filteredDocumentTypeList;
            
            return PartialView("RMSDocumentsGrid", accountDetailsMain);
        }

        private bool AddRemoveLink(List<RISARC.eTAR.Model.DocumentType> documentTypeList)
        {  bool result = false;
            HtmlHelper htmlHelper = RISARC.Common.Extensions.HtmlHelperExtensions.GetHtmlHelper(this);
            for (int i = 0; i < documentTypeList.Count(); i++)
            {
                if (documentTypeList[i].DocumentTypeID == _DocumentsAdminService.GetDocumentTypeIDFromName("Response Letter") && documentTypeList[i].SenderProviderId == _MembershipService.GetUsersProviderId(base.User.Identity.Name, true).Value)
                {
                    documentTypeList[i].DocumentRemoveLink = string.Format("<a class='removeFile' encid='{0}' onclick='removeRLFile_DocumentGrid(\"{0}\");'href='#'><img height='17' title='Remove File' style='vertical-align: middle;' alt='remove' src='{1}'/></a>", EncryptionExtensions.Encrypt(htmlHelper, documentTypeList[i].DocumentID), Url.Content("~/images/remove.png"));
                    result = true;
                }
            }
            
            return result;
        }

        /// <summary>
        /// Get list of document indexes and their page numbers.
        /// </summary>
        /// <param name="documentFileId">File id of the document.</param>
        /// <param name="tcnNumber">TCN Identification #</param>
        /// <returns>List<DocumentIndexInfo></returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 03/14/2014 | Gurudatta   | Created
        /// </RevisionHistory>
        private List<DocumentIndexInfo> GetDocumentIndexingInfo(int documentFileId, string tcnIdentificationId)
        {
            List<DocumentIndexInfo> lstDocumentIndexInfo =
                    lstDocumentIndexInfo = _AccountDetailsService.GetDocumentIndexInformation(documentFileId, tcnIdentificationId);
            return lstDocumentIndexInfo;
        }

        /// <summary>
        /// Get list of document indexes and their page numbers.
        /// </summary>
        /// <param name="documentFileId">File id of the document.</param>
        /// <param name="tcnNumber">TCN Identification #</param>
        /// <returns>List<DocumentIndexInfo></returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 03/14/2014 | Gurudatta   | Created
        /// </RevisionHistory>
        public ActionResult DocumentIndexGrid(int documentFileId, string tcnIdentificationId = null, bool visibilityFlag = true)
        {
            List<DocumentIndexInfo> lstDocumentIndexInfo = GetDocumentIndexingInfo(documentFileId, tcnIdentificationId);
            if (lstDocumentIndexInfo != null && lstDocumentIndexInfo.Count > 0)
            {
                ViewData["IsDocumentSubmitted"] = !(lstDocumentIndexInfo.Select(x => x.IsDocumentSubmitted).First()) && visibilityFlag;
            }

            return PartialView("DocumentIndexGrid", lstDocumentIndexInfo);
        }

        /// <summary>
        /// Loads document Callback panel for viewing Document
        /// </summary>
        /// <param name="documentFileId">Document file Id to get Document Information</param>
        /// <returns>Partial View for viewer</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 04/11/2014 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public ActionResult DocumentViewer(AccountDetailsMain accountDetailsMain, int? DocumentFileIDValue = null)
        {
            DocumentFileInfoForViewer documentFileInfoForViewer;
            if (DocumentFileIDValue.HasValue)
                documentFileInfoForViewer = new DocumentFileInfoForViewer { DocumentFileID = DocumentFileIDValue };
            // Added DocumentFileInfoForViewer model to remove circular dependency of eTar and Files
            else
                documentFileInfoForViewer = new DocumentFileInfoForViewer { DocumentFileID = accountDetailsMain.DocumentFileID };

            documentFileInfoForViewer = _FilesService.GetDocumentFileInfoForViewer(documentFileInfoForViewer);
            if (documentFileInfoForViewer != null && documentFileInfoForViewer.DocumentID.HasValue)
            {
                //get path of decrypted file for document viewer.
                documentFileInfoForViewer.DocumentFilePath = _UserDocumentsService.GetFilePathForDocumentViewer(documentFileInfoForViewer.DocumentID.Value);
                accountDetailsMain.documentViewer.DocumentFileName = documentFileInfoForViewer.DocumentFileName;
                accountDetailsMain.documentViewer.DocumentPath = documentFileInfoForViewer.DocumentFilePath;
                accountDetailsMain.documentViewer.NumberOfPages = documentFileInfoForViewer.NumberOfPages;
                accountDetailsMain.documentViewer.ContentType = documentFileInfoForViewer.ContentType;
            }

            if (DocumentFileIDValue.HasValue)
                return PartialView("DocumentViewer", accountDetailsMain);

            return Json(accountDetailsMain.documentViewer, JsonRequestBehavior.AllowGet);
        }

        public object RemoveFilesViewedByViewer()
        {
            bool result = false;
            result = _FilesService.EmptyTrashFolderForCurrentSession();
            JsonResult jsonResult = new JsonResult()
            {
                Data = result,
                JsonRequestBehavior = JsonRequestBehavior.AllowGet
            };

            return result;
        }

        /// <summary>
        /// Update the page numbers of category of the document.
        /// </summary>
        /// <param name="documentIndexInfo">Model of DocumentIndexInfo</param>
        /// <returns></returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 03/14/2014 | Gurudatta   | Created
        /// </RevisionHistory>
        [HttpPost, ValidateInput(false)]
        public ActionResult DocumentIndexGridUpdatePartial(DocumentIndexInfo documentIndexInfo)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    int? documentFileId = null;

                    if (!String.IsNullOrEmpty(Request.Params["documentFileId"]))
                        documentFileId = Convert.ToInt32(Request.Params["documentFileId"]);
                    documentIndexInfo.DocumentFileID = documentFileId;

                    int rowsAffected = _AccountDetailsService.UpdateDocumentCategoryIndex(documentIndexInfo);
                    if (rowsAffected == -1)
                        ViewData["EditError"] = "Error occured while updating record.";
                }
                catch (Exception e)
                {
                    ViewData["EditError"] = e.Message;
                }
            }
            else
                ViewData["EditError"] = "Please, correct all errors.";

            return DocumentIndexGrid(Convert.ToInt32(documentIndexInfo.DocumentFileID), documentIndexInfo.TCNNumber);
        }

        /// <summary>
        /// Update Documnet TCN submission status
        /// </summary>
        /// <param name="id">Id of the document.</param>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 03/21/2014 | Gurudatta   | Created
        /// </RevisionHistory>
        [AcceptVerbs("GET")]
        public object SubmitDocument([ModelBinder(typeof(EncryptedLongBinder))]long accountNumberId, string tcnNumbers)
        {
            bool result = false;
            //logic to update the record and action log entry
            int rowsAffected = _AccountDetailsService.UpdateAccountSubmissionStatus(accountNumberId, tcnNumbers);
            result = rowsAffected != -1;

            JsonResult jsonResult = new JsonResult
            {
                Data = result,
                JsonRequestBehavior = JsonRequestBehavior.AllowGet
            };
            return jsonResult.Data;
        }

        /// <summary>
        /// Set TCN Number in Session for which TCN file is uplaoded
        /// </summary>
        /// <param name="tcnNumber">Entered TCN Number</param>
        /// <returns>true/false</returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 03/25/2014 | Gurudatta   | Created
        /// </RevisionHistory>
        public object SetTCNNumberAndRecipientProviderId(string tcnNumber, long accountNumberId)
        {
            Session["TCNNumber"] = tcnNumber;
            Session["RecipientProviderId"] = _DocumentsAdminService.GetRecipientProviderId(accountNumberId);
            JsonResult jsonResult = new JsonResult()
            {
                Data = true,
                JsonRequestBehavior = JsonRequestBehavior.AllowGet
            };
            return jsonResult.Data;
        }

        /// <summary>
        /// Send TCN Forms to provider.
        /// </summary>
        /// <param name="AccountSubmissionDetailsID">id of account number</param>
        /// <param name="SenderProviderID">Provider id of the sender</param>
        /// <param name="TCNNo">TCN Number</param>
        /// <returns></returns>
        [HttpGet]
        public object SendTCNForms(long? AccountSubmissionDetailsID, short? SenderProviderID)
        {
            int? documentId = null;
            string result = "True";
            List<UploadedFiles> uploadedTcnFiles = _DocumentsAdminService.UploadedTCNFilesList;
            if (uploadedTcnFiles != null && uploadedTcnFiles.Count > 0)
            {
                //uploadedTcnFiles = uploadedTcnFiles.Where(file => file.IsDocumentSent.Equals(false)).ToList<UploadedFiles>();
                foreach (var tcnFile in uploadedTcnFiles)
                {
                    //check if valid TCN or T3 File uplaoded i.e. HTML file.
                    if (!(tcnFile.DocumentTypeName.Contains("TCN Summary")) && tcnFile.FileExtension.Contains("htm"))
                    {
                        result = "* Please select document type as TCN Summary for HTML files.";
                        break;
                    }
                    else if ((tcnFile.DocumentTypeName.Contains("TCN Summary")) && !tcnFile.FileExtension.Contains("htm"))
                    {
                        result = "* Please select document type as TCN Summary only for HTML files.";
                        break;
                    }
                    else
                    {
                        SenderProviderID = _MembershipService.GetUsersProviderId(base.User.Identity.Name, true).Value;
                        //save file in Dcouments, DocumentRecipient, TCN Ientification, DocumentsTCN
                        DocumentSend documentSend = new DocumentSend()
                        {
                            DocumentFileId = Convert.ToInt32(tcnFile.FileID),
                            DocumentTypeId = Convert.ToInt16(tcnFile.DocumentTypeId),
                            AccountSubmissionDetailsID = AccountSubmissionDetailsID,
                            SentFromProviderId = Convert.ToInt16(SenderProviderID),
                            TCNNumber = tcnFile.TCNNumber,
                            BillingMethod = BillingMethod.Free,
                            ProviderIsEtar = true
                        };
                        documentId = _DocumentsAdminService.SendTCNDocumentToProvider(documentSend);
                        //set document status. it will not consider this file next time.
                        tcnFile.IsDocumentSent = documentId.HasValue;
                    }
                }
            }
            JsonResult jsonResult = new JsonResult()
            {
                Data = result,
                JsonRequestBehavior = JsonRequestBehavior.AllowGet
            };

            return jsonResult.Data;
        }

        
        /// <summary>
        /// Send Response Letter from Field officer
        /// </summary>
        /// <param name="AccountSubmissionDetailsID">Account details Identifier.</param>
        /// <param name="SenderProviderID">IsETAR organization sending response letter Provider ID.</param>
        /// <returns>Return true if Response letter sent successfully.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 09/05/2014 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        [OutputCacheAttribute(VaryByParam = "*", Duration = 0, NoStore = true)]
        public dynamic SendResponseLetter(long? AccountSubmissionDetailsID, short? SenderProviderID, string tcnNumber)
        {
            int? documentId = null;
            int? documentFileID = null;
            //bool result = false;
            List<UploadedFiles> uploadedRLFiles = _DocumentsAdminService.UploadedRLFilesList;
            SenderProviderID = _MembershipService.GetUsersProviderId(base.User.Identity.Name, true).Value;
            short? DocumentTypeId = _DocumentsAdminService.GetDocumentTypeIDFromName("Response Letter");
           
            if (DocumentTypeId.HasValue)
            {
                foreach (var RLFile in uploadedRLFiles)
                {
                    if (RLFile.IsDocumentSent)
                        continue;
                    DocumentSend documentSend = new DocumentSend()
                    {
                        DocumentFileId = Convert.ToInt32(RLFile.FileID),
                        DocumentTypeId = DocumentTypeId.Value,
                        AccountSubmissionDetailsID = AccountSubmissionDetailsID,
                        SentFromProviderId = Convert.ToInt16(SenderProviderID),
                        BillingMethod = BillingMethod.Free,
                        ProviderIsEtar = false,
                        TCNNumber = tcnNumber,
                    };
                    documentId = _DocumentsAdminService.SendRLToProvider(documentSend);
                    RLFile.IsDocumentSent = documentId.HasValue;
                    if (documentSend != null && documentSend.DocumentFileId != null) { documentFileID = documentSend.DocumentFileId; }
                    //if (documentId != null)
                    //    result = true;
                }
                CleareSessionForRLUpload();
            }
            else {
                ExceptionUtility.LogException(new Exception("Document Type \"Response Letter\" not present."));
            }

            JsonResult jsonResult = new JsonResult()
            {
                Data = documentFileID,
                JsonRequestBehavior = JsonRequestBehavior.AllowGet
            };

            return jsonResult.Data;
        }

        [HttpGet]
        public object ClearTCNFilesCollection()
        {
            bool result = false;
            try
            {
                _DocumentsAdminService.ClearFileCollections(true);
                result = true;
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex);
            }
            JsonResult jsonResult = new JsonResult()
            {
                Data = result,
                JsonRequestBehavior = JsonRequestBehavior.AllowGet
            };
            return jsonResult.Data;
        }

        //New views added
        public ActionResult EtarProductiveControl()
        {
            ProductivityTimeTracker productivityTimeTracker;
            productivityTimeTracker = _TimeTrackerService.GetTcnAndENotesReviewStatistics();
            return PartialView("EtarProductiveControl", productivityTimeTracker);
        }

        public ActionResult TimeSpent(Boolean? popupFlag)
        {
            if (popupFlag == true)
            {
                ViewData["popupFlag"] = true;
            }

            return PartialView("TimeSpent");
        }

        [AuditingAuthorizeAttribute("DeadlineConfiguration", Roles = "User")]
        public ActionResult DeadlineConfiguration()
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.DeadlineConfiguration);
            ConfigurationDetails currentConfiguration = null;
            currentConfiguration = _AccountDetailsService.GetCurrentConfiguration();
            return PartialView("DeadlineConfiguration", currentConfiguration);
        }

        [HttpPost, ValidateInput(false)]
        public ActionResult DeadlineConfiguration(ConfigurationDetails currentConfiguration)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.DeadlineConfiguration);
            bool status = _AccountDetailsService.SetCurrentConfiguration(currentConfiguration);
            ViewData["Status"] = status;
            return PartialView("DeadlineConfiguration", currentConfiguration);
        }

        //=============== 16-May-2014 Surekha ====================
        //public ActionResult ShowCallbackPanel()
        //{
        //    return PartialView("_CallbackPanel");
        //}
    }
}