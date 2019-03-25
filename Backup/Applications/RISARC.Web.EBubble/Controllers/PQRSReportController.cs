using DevExpress.Web.Mvc;
using RISARC.ACO;
using RISARC.ACO.Model;
using RISARC.ACO.Service;
using RISARC.Common;
using RISARC.Common.Model;
using RISARC.Documents.Implementation.Service;
using RISARC.Documents.Service;
using RISARC.Emr.Web.Extensions;
using RISARC.Files.Model;
using RISARC.Files.Service;
using RISARC.Membership.Service;
using RISARC.Web.EBubble.Models.Binders;
using RISARC.Web.EBubble.Models.DevxControlSettings;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Mvc;
using RISARC.Common.Enumaration;
using XMLSerializer;
using RISARC.Web.EBubble.Models.DevxCommonModels;
using RISARC.ACO.Repository;
using RISARC.Documents.Model;

namespace RISARC.Web.EBubble.Controllers
{
    public class PQRSReportController : Controller
    {
        //
        // GET: /PQRSReport/
        private IMembershipAdministrationService _MembershipAdministrationService;
        private IRMSeBubbleMempershipService _MembershipService;
        private IDocumentsAdminService _DocumentsAdminService;
        private IFilesService _FileService;
        private IPQRSDocumentsAdminService _PQRSDocumentsAdminService;
        private IPQRSService _PQRSService;
        private IUserDocumentsService _UserDocumentsService;


        public PQRSReportController(
            IMembershipAdministrationService membershipAdministrationService, IUserDocumentsService userDocumentsService,IRMSeBubbleMempershipService membershipService, IDocumentsAdminService documentsAdminService, IFilesService filesService,
            IPQRSDocumentsAdminService pqrsdocumentService, IPQRSService pqrsService
            )
        {

            this._MembershipAdministrationService = membershipAdministrationService;
            this._MembershipService = membershipService;
            this._DocumentsAdminService = documentsAdminService;
            this._FileService = filesService;
            this._PQRSDocumentsAdminService = pqrsdocumentService;
            this._PQRSService = pqrsService;
            this._UserDocumentsService = userDocumentsService;
        }

        public ActionResult ParentChildProviderDropdown(int? IsCompleted)
        {
            #region ... Prev Code commented by Ashwini S on 22.01.15...
            //  string userName;
            //  short? providerId;
            //  int UserIndex;
            //  userName = User.Identity.Name;
            //  providerId = _MembershipService.GetUsersProviderId(userName, true);
            //  UserIndex = _MembershipService.GetUserIndex(userName);
            ////  List<RISARC.Setup.Model.ACOProvider> providersTest;
            //  // providers that user's provider has access to
            //  if (!providerId.HasValue) // this would be the case of a non-member
            //  {
            //      throw new InvalidOperationException("Logged in user must have a provider");
            //  }
            //  else
            //  {
            //      // providersTest = _MembershipAdministrationService.GetParentChildProviderList(UserIndex);
            //    //  providersTest = _MembershipAdministrationService.GetACOProviderList();
            //  } 
            #endregion

            //two lines added

            short providerId;

            providerId = _MembershipService.GetUsersProviderId(base.User.Identity.Name, true).Value;

            List<Providers> lstProviders = new List<Providers>();
            lstProviders = _PQRSService.GetProviders(IsCompleted,providerId);
            return PartialView(lstProviders);
        }

        public ActionResult MeasuresDropdown()
        {
            List<Measures> lstMeasures = new List<Measures>();
            lstMeasures = _PQRSService.GetMeasures();
            return PartialView(lstMeasures);
        }

        public ActionResult PendingWorkBucket()
        {
            //For fetching Pending Data's Providers
            Session["ProviderIds"] = null;
            ViewData["IsCompleted"] = (int)Enumerators.BucketDataStatus.Pending;
            return View();
        }

        public ActionResult _gvPendingWorkBucket(String ProviderIdList)
        {   //IsCompleted is "0" for fetching pending bucket data
            int IsCompleted = (int)Enumerators.BucketDataStatus.Pending;

            if (!string.IsNullOrEmpty(ProviderIdList))
            {
                if (ProviderIdList != "0")
                {
                    Session["ProviderIds"] = ProviderIdList;
                    ViewData["ProviderIds"] = ProviderIdList;
                }
            }

            List<PendingBucket> pendingbucket = new List<PendingBucket>();
            pendingbucket = _PQRSService.GetPendingBucketData(Convert.ToString(Session["ProviderIds"]), IsCompleted);
            
            //Session["ProviderIds"] = null;
            return PartialView(pendingbucket);
        }

        public ActionResult _gvGroupStatus(int patientId,int? isViwer=0)
        {
            List<GroupStatus> lstGroupStatus = new List<GroupStatus>();

            if (isViwer == 0)
            {
                lstGroupStatus = _PQRSService.GetGroupStatus();
                return PartialView(lstGroupStatus);
            }
            else
            {
                //  lstGroupStatus = _PQRSService.GetGroupStatus(patientId);
                lstGroupStatus = _PQRSService.GetGroupStatus(patientId);
                return PartialView("_gvViwerGroupStatus", lstGroupStatus);
            }

        }


        public ActionResult ClosedWorkBucket()
        {
            Session["ProviderIds"] = null;
            ViewData["IsCompleted"] = (int)Enumerators.BucketDataStatus.Closed;
            return View();

        }

        public ActionResult _gvClosedWorkBucket(String ProviderIdList)
        {
            int IsCompleted = (int)Enumerators.BucketDataStatus.Closed; //it will 1 for fetching closed bucket data
            if (!string.IsNullOrEmpty(ProviderIdList))
            {
                if (ProviderIdList != "0")
                {
                    Session["ProviderIds"] = ProviderIdList;
                }
            }

            List<PendingBucket> Closegbucket = new List<PendingBucket>();
            Closegbucket = _PQRSService.GetPendingBucketData(Convert.ToString(Session["ProviderIds"]), IsCompleted);
            return PartialView("_gvClosedWorkBucket", Closegbucket);
        }

        public ActionResult QuestionsWizardButtons()
        {
            return View();
        }

        public ActionResult QustionsAnswers(string uniqueId)
        {
            //Get all measures for the ID
            List<string> measures = new List<string>();
            ViewData["Measures"] = measures;

            //Return the measures to bind it to drop down list
            return View();
        }


        /// <summary>
        /// This method is called for fetching question each time.
        /// </summary>
        /// <param name="PatientId">Patient ID comming from pending bucket</param>
        /// <param name="baseQid">baseQid: sending from document viewer</param>
        /// <param name="baseOid">sending from document viewer</param>
        /// <param name="answerValue">Base question answer from document viewer</param>
        /// <param name="AttributeOptionValue">Attribute question option & value in formate "option:value"</param>
        /// <param name="measureName">selected measure name </param>
        /// <param name="Viewer"></param>
        /// <returns></returns>
        public ActionResult _QuestionsList(int PatientId, int? baseQid, int? baseOid, string answerValue, string AttributeOptionValue, string measureName, int Viewer = 0)
        {
            //here find mesureID depending on question id.
            //
            Question q = new Question();
            //if (Viewer == 0)
            if (Viewer == 1)
            {
                q = _PQRSService.GetBaseQuestion("carefalls", PatientId);
            }
            else
            {
                if (string.IsNullOrEmpty(measureName))
                {
                    int userIndex = _MembershipService.GetUserIndex(User.Identity.Name);
                    q = _PQRSService.UpdateAnswerAndGetNext(PatientId, userIndex, baseQid, baseOid, answerValue, AttributeOptionValue);
                }
                else
                {
                    measureName = measureName.Replace("count", "");
                    q = _PQRSService.GetBaseQuestion(measureName, PatientId);
                }

            }
            return PartialView("QuestionsCallbackPanel", q);
        }

        /// <summary>
        /// Uploading patient XML files
        /// </summary>
        /// <param name="dates">From and To Dates</param>
        /// <returns></returns>
        public ActionResult UploadPatientData(Dates dates)
        {
            ModelState.Clear();
            Session["UploadedFilesList"] = null;
            return View(dates);
        }

        public ActionResult XMLFileUpload()
        {
            FileUploadControlSettingsXML fileUploadControlSettings = new FileUploadControlSettingsXML();
            UploadControlExtension.GetUploadedFiles("ClaimFileUpload", fileUploadControlSettings.ValidationSettings, XMLFileUploadComplete); ;
            return null;
        }

        public void XMLFileUploadComplete(object sender, DevExpress.Web.ASPxUploadControl.FileUploadCompleteEventArgs e)
        {
            int? insertedFileId = 0;
            string encryptedFileId;
            HtmlHelper htmlHelper = RISARC.Common.Extensions.HtmlHelperExtensions.GetHtmlHelper(this);
            try
            {
                if (e.UploadedFile.IsValid)
                {
                    insertedFileId = _PQRSDocumentsAdminService.UploadClaimFile(e.UploadedFile);

                    //Session["DocumentUploadedFileID"] = insertedFileId;

                    encryptedFileId = EncryptionExtensions.Encrypt(htmlHelper, insertedFileId);
                    //Send back the HTML string for File name and remove link
                    string callbackHtmlString = string.Empty;
                    string previewLink = string.Format("<div><a class=iconLink-icon href='{0}'><IMG alt={1} src='{2}'></a><a href='{0}'>{1}</a>"
                                                        , Url.Action("GetPreviewedFile", new { documentFileId = encryptedFileId })
                                                        , e.UploadedFile.FileName, Url.Content("~/Images/icons/icon_attachment.gif"));
                    string removeLink = string.Format("<a class='removeFile' encid='{0}' onclick='removeUploadedFile(\"{0}\");' href='#'><img height='17' title='Remove File' style='vertical-align: middle;' alt='remove' src='{1}'/></a></div>",
                                                      encryptedFileId, Url.Content("~/images/remove.png"));

                    callbackHtmlString = string.Concat(previewLink, removeLink);

                    // Add file ids to collection
                    DocumentsAdminService.AddFilesToCollection(Convert.ToInt32(insertedFileId), callbackHtmlString);

                    // Added by Dnyaneshwar
                    DocumentsAdminService.AddFilesToGrid(new UploadedFiles()
                    {
                        FileID = Convert.ToInt64(insertedFileId),
                        FileName = e.UploadedFile.FileName,
                        UploadedFrom = ConstantManager.FileUploadConstants.UploadFromNetworkFolder,
                        DeleteLink = string.Format("<a class='removeFile' encid='{0}' onclick='removeUploadedFile(\"{0}\");' href='#'><img height='17' title='Remove File' style='vertical-align: middle;' alt='remove' src='{1}'/></a>", encryptedFileId, Url.Content("~/images/remove.png")),
                        PreViewLink = string.Format("<a href='{0}'>{1}</a>", Url.Action("GetPreviewedFile", new { documentFileId = encryptedFileId }), e.UploadedFile.FileName),
                        SendToProviderId = Session["ProviderID_ETAR"] != null ? Convert.ToInt16(Session["ProviderID_ETAR"]) : (short?)null,
                        SendToProviderIsETAR = Session["ProviderIseTAr_ETAR"] != null ? Convert.ToBoolean(Session["ProviderIseTAr_ETAR"]) : false
                    });
                    // End Added

                    e.CallbackData = Convert.ToString(GetUploadedFilesCallbackString());
                }
            }
            catch (Exception ex)
            {
                Common.ExceptionHandling.ExceptionUtility.LogException(ex, "FileController.FileUplaodComplete");
            }
        }

        [AcceptVerbs("GET")]
        [OutputCache(VaryByParam = "*", Duration = 0, NoStore = true)]
        public object GetUploadedFilesCallbackString()
        {
            //string encryptedFileId;
            StringBuilder callbackHtmlString = new StringBuilder();
            Dictionary<Int32, String> uploadedFiles = (Dictionary<Int32, String>)Session["UploadedFileInfo"];
            HtmlHelper htmlHelper = RISARC.Common.Extensions.HtmlHelperExtensions.GetHtmlHelper(this);
            // Added by Dnyaneshwar
            if (uploadedFiles == null) return null;
            // End Added
            //Prepare callback HTML string as per the order of file id.
            foreach (var file in uploadedFiles.OrderBy(id => id.Key))
            {
                callbackHtmlString.Append(file.Value).Append("<br/>");
            }
            JsonResult jsonResult = new JsonResult
            {
                Data = callbackHtmlString.ToString(),
                JsonRequestBehavior = JsonRequestBehavior.AllowGet
            };
            return jsonResult.Data;
        }

        [AcceptVerbs("GET")]
        //[AuditingAuthorizeAttribute("RemoveUploadedFile", Roles = "User")]
        public object RemoveUploadedFile([ModelBinder(typeof(EncryptedIntegerBinder))] int documentFileId)
        {
            bool status = _PQRSDocumentsAdminService.DeleteDocumentFile(documentFileId, false);
            JsonResult jsonResult = new JsonResult
            {
                Data = status,
                JsonRequestBehavior = JsonRequestBehavior.AllowGet
            };
            return jsonResult.Data;
        }

        /// <summary>
        /// Final validation of uploaded patient XML files.
        /// </summary>
        /// <param name="obj">From and to Dates</param>
        /// <returns></returns>
        public ActionResult ValidateUploadedFiles(Dates obj)
        {
               if (_PQRSService.CheckIfAlreadyUploaded())
            {
                ModelState.AddModelError("upload", "Files already uploaded for this fiscal");
            }
            else
            {
                List<UploadedFiles> uploadedFiles = Session["UploadedFilesList"] as List<UploadedFiles>;
                if (uploadedFiles != null && uploadedFiles.Count == 5)
                {
                    for (int i = 0; i < 5; i++)
                    {
                        UploadedFiles file = uploadedFiles.Find(x => x.DocumentTypeId == i + 1);
                        if (file == null)
                        {
                            ModelState.AddModelError("upload", "Please check if you have uploaded or selected all file types.");
                            break;
                        }
                    }
                }
                else
                {
                    ModelState.AddModelError("upload", "Please check if you have uploaded or selected all file types.");
                }

                if (ModelState.IsValid)
                {

                    _PQRSService.FinalSaveXMLFiles(uploadedFiles, obj.FromDate.ToString(), obj.ToDate.ToString());

                    List<FileInfo> lstFiles =  _PQRSService.GetFilesInfo(System.DateTime.Now.Year-1);

                    try
                    {
                        foreach (var file in lstFiles)
                        {

                            string filename = ConfigurationManager.AppSettings["MedicalDocumentsBaseDirectory"].ToString() + "\\PQRS\\" + file.FileName;//.Replace(".bat", ".xml");
                            if (file.FileTypeCode == (int)XMLFileType.PatientFile)
                            {
                                XMLImportExport.ImportXML(filename, 1);
                            }
                            else if (file.FileTypeCode == (int)XMLFileType.PatientRankingFile)
                            {
                                XMLImportExport.ImportXML(filename, 2);
                            }
                            else if (file.FileTypeCode == (int)XMLFileType.PatientDischargeFile)
                            {
                                XMLImportExport.ImportXML(filename, 3);
                            }
                            else if (file.FileTypeCode == (int)XMLFileType.ProvidersFile)
                            {
                                XMLImportExport.ImportXML(filename, 4);
                            }

                            else if (file.FileTypeCode == (int)XMLFileType.ClinicFile)
                            {
                                XMLImportExport.ImportXML(filename, 5);
                            }
                        }

                        ViewData["Success"] = "Uploaded Successfully";
                        Session["UploadedFilesList"] = null;
                    }
                    catch (Exception ex)
                    {
                        //ViewData["Success"] = "Xml file parsing failed ";
                        ModelState.AddModelError("upload", "Xml file parsing failed");
                        _PQRSService.DeleteFileOnFailed(uploadedFiles);
                    }
                }
            }
            return View("UploadPatientData", obj);
        }

        //[HttpPost, ValidateInput(false)]
        public ActionResult BatchUpdatePartial(MVCxGridViewBatchUpdateValues<RaiseRequest, int> batchValues)
        {
           
            //if (ModelState.IsValid)
            //{
                try
                {

                    foreach (var requestData in batchValues.Update)
                    {
                        if (batchValues.IsValid(requestData))
                            _UserDocumentsService.RaiseDocumentRequest(GetRequestSend(requestData), SenderClassification.Member, new string[] { requestData.PhysicianName }, requestData.PatientId);
                        else
                        {
                            batchValues.SetErrorText(requestData, "Correct validation errors");

                        }
                    }
                    ViewData["StatusFlag"] = "Request raised successfully";

                }
                catch (Exception e)
                {
                    ViewData["EditError"] = e.Message;
                    ViewData["StatusFlag"] = "Error occured for Raise Request";
                }
            //}
            //else
            //    ViewData["EditError"] = "Please, correct all errors.";
           
            RaiseRequest request = new RaiseRequest();
            List<RaiseRequest> raiseRequestList = _PQRSService.GetRaiseRequestData(request);
            return PartialView("_gvRequestDocument", raiseRequestList);
        }

        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult RaiseRequest()
        {
            
            return View();//"RequestDocument"
        }
        public ActionResult BatchYearComboBox()
        {
            return PartialView();
        }

       

        private DocumentRequestSend GetRequestSend(RaiseRequest requestData)
        {
            DocumentRequestSend request = new DocumentRequestSend();

            request.ProviderId = requestData.ProviderId;
            request.DocumentTypeId = 1;
            request.DocumentDescription = "CMS Verification Description";
            request.Comments = "PQRS Urgent Patient Document";
            request.RequestDueBy = requestData.ResponseDueDate;
            
            request.DocumentRelatesToPatient = true;
            string[] pName = requestData.PatientName.Split(' ');
            request.PatientInformation.PatientFirstName = pName[0];
            request.PatientInformation.PatientLastName = pName[1];
            RISARC.ACO.Model.PatientInfo patientInfo = _PQRSService.GetPatientInfo(requestData.PatientId);
            request.PatientInformation.PatientIdentificationMethods.MedicalRecordNoIdentification = new Documents.Model.PatientIdentification.MedicalRecordNoIdentification()
            {
                MedicalRecordNumber = patientInfo.MedicareId,
                DateOfServiceTo =  requestData.ToServiceDate,
                DateOfServiceFrom =  requestData.FromServiceDate
            };

            request.PatientInformation.PatientIdentificationMethods.DateOfBirthIdentification = new Documents.Model.PatientIdentification.DateOfBirthIdentification(patientInfo.DOB)
                {
                    IsDOBVerificationRequired=false,
                    
                };

            return request;
        }
        public ActionResult _gvRequestDocument(RaiseRequest request)
        {
            List<RaiseRequest> raiseRequestList = _PQRSService.GetRaiseRequestData(request);
            return PartialView("_gvRequestDocument", raiseRequestList);
        }

        public ActionResult ExportXML(ControllerContext context, string type)
        {
            object obj = XMLImportExport.ExportXML(type);
            return new XMLResult(obj, type);
            //return View();
        }

        /// <summary>
        /// Getting the patient XML document types for binding it to drop down list.
        /// </summary>
        /// <param name="comboBoxSettings">Drop down control</param>
        /// <param name="selectedDocumentType">selected document type</param>
        /// <returns></returns>
        public ActionResult XMLDocumentTypeDropDownDevExp(Action<ComboBoxSettings> comboBoxSettings, short? selectedDocumentType)
        {
            DevExpressComboModel devExpressComboModel = new DevExpressComboModel();
            IDictionary<short, string> documentTypes;
            documentTypes = _PQRSService.GetXMLDocumentTypes();

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
    }
}
