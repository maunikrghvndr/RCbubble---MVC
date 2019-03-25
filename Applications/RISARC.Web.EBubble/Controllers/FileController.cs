using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Ajax;
using RISARC.Documents.Model;
using RISARC.Documents.Service;
using SpiegelDg.Security.Model;
using RISARC.Web.EBubble.Models.Binders;
using RISARC.Files.Model;
using RISARC.Files.Service;
using RISARC.Setup.Model;
using SpiegelDg.Common.Validation;
using Microsoft.Practices.EnterpriseLibrary.ExceptionHandling;
using SpiegelDg.Common.Web.Extensions;
using RISARC.Membership.Service;
using RISARC.Setup.Implementation.Repository;
using System.IO;
using DevExpress.Web.Mvc;
using System.Text;
using RISARC.Emr.Web.Extensions;
using RISARC.Web.EBubble.Models.DevxControlSettings;
using System.Web.Helpers;
using DevExpress.Web.ASPxUploadControl;
using RISARC.Documents.Implementation.Service;
using DevExpress.Web.ASPxFileManager;
using System.Configuration;
using RISARC.Common.Model;
using System.Security.Principal;
using System.Security.AccessControl;
using RISARC.Encryption.Model;
using RISARC.Encryption;
using RISARC.Common;

namespace RISARC.Web.EBubble.Controllers
{
    public class FileController : Controller
    {
        //private IFilesService _FilesService;
        private const string _FileHeaderKey = "content-disposition";
        private const string _FileHeaderFormat = "attachment; filename={0}";
        //
        // GET: /DocumentFile/
        private IUserDocumentsService _UserDocumentService;
        private IFilesService _FilesService;
        private IDocumentsRetrievalService _DocumentsRetrievalService = null;
        private IDocumentsAdminService _DocumentsAdminService;
        private IRMSeBubbleMempershipService _MembershipService;
        private IProviderRepository _ProviderRepository;

        public FileController(IUserDocumentsService userDocumentsService, IDocumentsAdminService documentsAdminService, IFilesService filesService,
            IRMSeBubbleMempershipService membershipService, IProviderRepository providerRepository)
        {
            this._UserDocumentService = userDocumentsService;
            this._DocumentsAdminService = documentsAdminService;
            this._FilesService = filesService;
            this._MembershipService = membershipService;
            this._ProviderRepository = providerRepository;
        }



        /// <summary>
        /// Previews a file that has been uploaded.  Can only be previews by person who uploaded it
        /// </summary>
        /// <param name="documentFileId"></param>
        /// <returns></returns>
        [AuditingAuthorizeAttribute("PreviewFileLink")]
        public ActionResult PreviewFileLink([ModelBinder(typeof(EncryptedIntegerBinder))] int documentFileId)
        {
            DocumentFile documentFile;

            documentFile = _UserDocumentService.PreviewFile(documentFileId, false);

            ViewData["DocumentFileId"] = documentFileId;

            return View(documentFile);
        }

        /// <summary>
        /// Remove file from physical location and database.
        /// </summary>
        /// <param name="documentFileId">Encrypted Id of file.</param>
        /// <returns>Status of deletion: Object of type bool</returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 12/17/2013 | Gurudatta   | Created
        /// </RevisionHistory>
        [AcceptVerbs("GET")]
        //[AuditingAuthorizeAttribute("RemoveUploadedFile", Roles = "User")]
        public object RemoveUploadedFile([ModelBinder(typeof(EncryptedIntegerBinder))] int documentFileId)
        {
            bool status = _DocumentsAdminService.DeleteDocumentFile(documentFileId,false);
            JsonResult jsonResult = new JsonResult
            {
                Data = status,
                JsonRequestBehavior = JsonRequestBehavior.AllowGet
            };
            return jsonResult.Data;
        }

        [AcceptVerbs("GET")]
        //[AuditingAuthorizeAttribute("RemoveTCNUploadedFile", Roles = "User")]
        public object RemoveTCNUploadedFile([ModelBinder(typeof(EncryptedIntegerBinder))] int documentFileId, long accountNumberId)
        {
            Session["RecipientProviderId"] = _DocumentsAdminService.GetRecipientProviderId(accountNumberId);
            bool status = _DocumentsAdminService.DeleteDocumentFile(documentFileId, true);
            JsonResult jsonResult = new JsonResult
            {
                Data = status,
                JsonRequestBehavior = JsonRequestBehavior.AllowGet
            };
            return jsonResult.Data;
        }

        /// <summary>
        /// Removes Response Letter from Physical Location and Database
        /// </summary>
        /// <param name="documentFileId">Encrypted Id of file.</param>
        /// <returns>Status of deletion: Object of type bool</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 09/09/2014 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        [AcceptVerbs("GET")]
        public object RemoveRLUploadedFile([ModelBinder(typeof(EncryptedIntegerBinder))] int documentFileId)
        {
          
            bool status = _DocumentsAdminService.DeleteDocumentFile(documentFileId, false,false,true);
            JsonResult jsonResult = new JsonResult
            {
                Data = documentFileId, // This id is sent to ajax method to clear document viewr depending on conditions
                JsonRequestBehavior = JsonRequestBehavior.AllowGet
            };
            return jsonResult.Data;
          
        }


        /// <summary>
        /// Removes Response Letter from Physical Location and Database 
        /// </summary>
        /// <param name="documentFileId">Encrypted Id of file.</param>
        /// <returns>Status of deletion: Object of type bool</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 18/09/2014 | Surekha   | Created
        /// </RevisionHistory>
     
        public object _RemoveRLUploadedFile( int documentFileId)
        {
            bool status = _DocumentsAdminService.DeleteDocumentFile(documentFileId, false, false, true);
            JsonResult jsonResult = new JsonResult
            {
                Data = status,
                JsonRequestBehavior = JsonRequestBehavior.AllowGet
            };
            return jsonResult.Data;
        }

        public ActionResult RemoveFile([ModelBinder(typeof(EncryptedIntegerBinder))] int documentFileId, bool IsSignedComplainceDocumentUpload = false)
        {
            var yourList = new List<int>();
            yourList = (List<Int32>)Session["DocumentFileID"];
            //var itemtoremove = yourList.Where(item => item == 1).First();

            int s1;

            s1 = yourList.Where(s => s == documentFileId).Single();

            //Remove that student from the list. 
            yourList.Remove(s1);
            if (yourList.Count == 0)
            {
                yourList = null;
                ViewData["DocumentFileID"] = null;
                Session["DocumentFileID"] = null;
            }
            else
            {
                Session["DocumentFileID"] = yourList;
            }


            yourList = (List<Int32>)Session["DocumentFileID"];
            //// ViewData["DocumentFileId"];
            //FileStreamResult result;

            //DocumentFile documentFile;

            //documentFile = _UserDocumentService.PreviewFile(documentFileId, true);

            //// make sure so that they download it rather then it takes them to new url
            //HttpContext.Response.AddHeader(_FileHeaderKey,
            //    String.Format(_FileHeaderFormat, documentFile.FileName));

            ////HttpContext.Response.AddHeader("content-disposition",
            ////    "attachment; filename=form.pdf");

            //result = new FileStreamResult(documentFile.Stream, documentFile.ContentType);
            if(IsSignedComplainceDocumentUpload)
                return View("UploadFileFormIFrame2");

            return View("UploadMedicalDocumentForm");
        }

        [AuditingAuthorizeAttribute("GetPreviewedFile")]
        public FileStreamResult GetPreviewedFile([ModelBinder(typeof(EncryptedIntegerBinder))] int documentFileId,bool? isResponceLetter=false)
        {
            FileStreamResult result;

            DocumentFile documentFile;

            documentFile = _UserDocumentService.PreviewFile(documentFileId, true, isResponceLetter);

            // make sure so that they download it rather then it takes them to new url
            HttpContext.Response.AddHeader(_FileHeaderKey,
                String.Format(_FileHeaderFormat, documentFile.FileName));

            //HttpContext.Response.AddHeader("content-disposition",
            //    "attachment; filename=form.pdf");

            result = new FileStreamResult(documentFile.Stream, documentFile.ContentType);

            return result;
        }

        [AuditingAuthorizeAttribute("RequestDetails", Roles = "DocumentAdmin")]
        public ViewResult RequestDetails([ModelBinder(typeof(EncryptedIntegerBinder))] int requestId)
        {
            DocumentRequest requestInfo;

            requestInfo = _DocumentsRetrievalService.GetDocumentRequest(requestId);

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
        /// Renders the uplooad medical document form for a document id.  
        /// </summary>
        /// <param name="documentId"></param>
        /// <param name="documentFileId">If file was already uploaded, file id of uploaded file</param>
        /// <returns></returns>
        //[AuditingAuthorizeAttribute("UploadMedicalDocumentForm", Roles = "User")]
        public ViewResult UploadMedicalDocumentForm([ModelBinder(typeof(EncryptedIntegerBinder))] int? documentFileId, short? providerIdToSubmitTo)
        {
            ViewData["DocumentFileId"] = documentFileId;
            ViewData["ProviderId"] = providerIdToSubmitTo;
            Session["providerIdToSubmitTo"] = providerIdToSubmitTo;
            return View();
        }

        public ActionResult Upload()
        {
            if (Request.Files.Count > 0)
            {
                if (Request.Files[0].ContentLength > 0)
                {

                    var hFile = Request.Files[0];
                    ViewData["theFileName"] = "<div style=\"font-weight: bold; font-size: 1.2em; padding: 24px 0;\">" + hFile.FileName + "</div>";
                    //Request.Files[0].SaveAs(@"C:\TESTFolder");
                }
            }
            //Do some other stuff

            //return View("~/Views/File/UploadFileFormIFrame2.aspx");
            return View("UploadFileFormIFrame2");
        }
        [AcceptVerbs(HttpVerbs.Post)]
       // [AuditingAuthorizeAttribute("UploadDocumentFile", Roles = "User")]
        public ActionResult UploadMedicalDocument(HttpPostedFileBase FileUpload, short? providerIdToSubmitTo)
        {

            ViewData["DocumentFileId"] = Session["DocumentFileID"];


            var yourList = new List<int>();
            if (Session["DocumentFileID"] != null)
                yourList = (List<Int32>)Session["DocumentFileID"];

            if (Request.Files.Count > 0)
            {

                if (Request.Files[0].ContentLength > 0)
                {
                    int filecount;
                    filecount = Request.Files.Count;
                    for (int i = 0; i <= filecount - 1; i++)
                    {

                        var hFile = Request.Files[i];
                        //DocumentFile documentFile;
                        int? insertedFileId;
                        //string encryptedInsertedFileId;
                        //FrontEndEnrypter encrypter;

                        if (hFile == null)
                            ModelState.AddModelError("FileToUpload", "You must select a file to upload");
                        else
                        {
                            //documentFile = new DocumentFile(FileUpload.ContentType,
                            //    FileUpload.FileName,
                            //    FileUpload.InputStream);
                            try
                            {
                                short providerID;
                                if (Session["providerIdToSubmitTo"] != null)
                                {
                                    providerID = (short)Session["providerIdToSubmitTo"];
                                    insertedFileId = _UserDocumentService.SubmitCompletedComplianceDoc(providerID, Request.Files[0]);
                                }
                                else

                                    insertedFileId = _DocumentsAdminService.UploadDocumentFile(hFile);


                                if (!insertedFileId.HasValue)
                                    throw new InvalidOperationException("No file id generated");
                                yourList.Add(Convert.ToInt32(insertedFileId));
                                ViewData["DocumentFileName"] = Path.GetFileName(hFile.FileName);
                                Session["providerIdToSubmitTo"] = null;
                                ViewData["DocumentFileId"] = yourList;//insertedFileId;
                                ViewData["DocumentFileName"] = hFile.FileName;
                                Session["DocumentFileID"] = insertedFileId;

                            }
                            catch (RuleException ex)
                            {
                                ex.CopyToModelState(ModelState);
                            }
                            catch (Exception ex)
                            {
                                // hack - since called in iframe, just set uploaded file id to null, which
                                // will cause an error message to occur
                                ExceptionPolicy.HandleException(ex, "Controller Level Policy");
                                ViewData["DocumentFileId"] = (int?)null;
                                ViewData["ErrorMessage"] = "An unexpected error occured when file was uploaded.";
                            }
                        }
                    }
                }
            }

            return View("~/Views/File/UploadFileFormIFrame2.aspx", ViewData["ProviderId"]);
        }
        public ActionResult Save(IEnumerable<HttpPostedFileBase> attachments)
        {            // The Name of the Upload component is "attachments"           
            //foreach (var file in attachments)
            //{
            //    // Some browsers send file names with full path. This needs to be stripped.                
            //    var fileName = Path.GetFileName(file.FileName);
            //    var physicalPath = Path.Combine(Server.MapPath("~/App_Data"), fileName);
            // The files are not actually saved in this demo               
            // file.SaveAs(physicalPath); 
            var yourList = new List<int>();
            if (Request.Files.Count > 0)
            {

                if (Request.Files[0].ContentLength > 0)
                {
                    int filecount;
                    filecount = Request.Files.Count;
                    for (int i = 0; i <= filecount - 1; i++)
                    {

                        var hFile = Request.Files[i];
                        //DocumentFile documentFile;
                        int? insertedFileId;
                        //string encryptedInsertedFileId;
                        //FrontEndEnrypter encrypter;

                        if (hFile == null)
                            ModelState.AddModelError("FileToUpload", "You must select a file to upload");
                        else
                        {
                            try
                            {
                                short providerID;

                                //if (Session["providerIdToSubmitTo"] != null) removed 11/09/2011 
                                if (Session["Compliance"] != null)
                                {
                                    //loggedInUser = _UserNameGrabber.GetUserName();
                                    Provider provider;
                                    // make sure logged in user can access method
                                    //_MembershipService.EnsureIsInRoles(loggedInUser, new string[] { "DocumentAdmin" });
                                    providerID = _MembershipService.GetUsersProviderId(User.Identity.Name, true).Value;
                                    provider = _ProviderRepository.GetProvider(providerID);
                                    //providerId = _MembershipService.GetUsersProviderId(loggedInUser, true);
                                    //providerID = (short)Session["providerIdToSubmitTo"];
                                    insertedFileId = _UserDocumentService.SubmitCompletedComplianceDoc(providerID, Request.Files[0]);
                                    if (!insertedFileId.HasValue)
                                        throw new InvalidOperationException("No file id generated");
                                    _ProviderRepository.SetComplianceDocumentFileId(providerID, insertedFileId.Value);
                                    Session["Compliance"] = null;
                                }
                                else

                                    insertedFileId = _DocumentsAdminService.UploadDocumentFile(hFile);


                                if (!insertedFileId.HasValue)
                                    throw new InvalidOperationException("No file id generated");
                                yourList.Add(Convert.ToInt32(insertedFileId));
                                ViewData["DocumentFileName"] = Path.GetFileName(hFile.FileName);
                                Session["providerIdToSubmitTo"] = null;
                                ViewData["DocumentFileId"] = yourList;//insertedFileId;
                                ViewData["DocumentFileName"] = hFile.FileName;
                                Session["DocumentFileID"] = insertedFileId;

                            }
                            catch (RuleException ex)
                            {
                                ex.CopyToModelState(ModelState);
                            }
                            catch (Exception ex)
                            {
                                // hack - since called in iframe, just set uploaded file id to null, which
                                // will cause an error message to occur
                                ExceptionPolicy.HandleException(ex, "Controller Level Policy");
                                ViewData["DocumentFileId"] = (int?)null;
                                ViewData["ErrorMessage"] = "An unexpected error occured when file was uploaded.";
                            }
                        }
                    }
                }
            }

            Json(new { documentID = ViewData["DocumentFileId"] }, "text/plain");
            //return View("~/Views/File/UploadFileFormIFrame2.aspx", ViewData["ProviderId"]);

            //}
            //// Return an empty string to signify success            
            return Content("");
            //  
        }
        public ActionResult SyncUpload()
        {
            return View();
        }
        public ActionResult SyncUploadResult()
        {
            return View("~/Views/File/UploadFileFormIFrame2.aspx", ViewData["ProviderId"]);
        }

        [HttpPost]
        public ActionResult ProcessSubmit(IEnumerable<HttpPostedFileBase> attachments)
        {
            if (attachments != null)
            {
                TempData["UploadedAttachments"] = GetFileInfo(attachments);
            }
            return View();//RedirectToAction("SyncUploadResult");
        }

        private IEnumerable<string> GetFileInfo(IEnumerable<HttpPostedFileBase> attachments)
        {
            return
                from a in attachments
                where a != null
                select string.Format("{0} ({1} bytes)", Path.GetFileName(a.FileName), a.ContentLength);
        }

        public ActionResult Remove(string[] fileNames)
        {            // The parameter of the Remove action must be called "fileNames"            
            foreach (var fullName in fileNames)
            {
                var fileName = Path.GetFileName(fullName);
                var physicalPath = Path.Combine(Server.MapPath("~/App_Data"), fileName);
                // TODO: Verify user permissions              
                if (System.IO.File.Exists(physicalPath))
                {                    // The files are not actually removed in this demo                    
                    // System.IO.File.Delete(physicalPath);                
                }
            }            // Return an empty string to signify success 
            return Content("");
        }
        /// <summary>
        /// Renders the form to upload a release form for a document.  Really just gets the provider id of the document, and then
        /// gets provider id of that document
        /// </summary>
        /// <param name="documentId"></param>
        /// <param name="documentFileId">If file was already uploaded, file id of uploaded file</param>
        /// <returns></returns>
        [AuditingAuthorizeAttribute("UploadCompletedComplianceDocForDocumentForm", Roles = "User")]
        public ViewResult UploadCompletedComplianceDocForDocumentForm([ModelBinder(typeof(EncryptedIntegerBinder))] int documentId, [ModelBinder(typeof(EncryptedIntegerBinder))] int? documentFileId)
        {
            short providerId;

            providerId = _DocumentsRetrievalService.GetDocumentProviderId(documentId);

            return UploadCompletedComplianceDocForm(providerId, documentFileId);
        }


        /// <summary>
        /// Renders the form to upload a release form to the provider.  
        /// </summary>
        /// <param name="documentId"></param>
        /// <param name="documentFileId">If file was already uploaded, file id of uploaded file</param>
        /// <returns></returns>
        [AuditingAuthorizeAttribute("UploadCompletedComplianceDocForm", Roles = "User")]
        public ViewResult UploadCompletedComplianceDocForm([ModelBinder(typeof(EncryptedShortBinder))] short providerIdToSubmitTo, [ModelBinder(typeof(EncryptedIntegerBinder))] int? documentFileId)
        {
            ViewData["ProviderId"] = providerIdToSubmitTo;
            Session["providerIdToSubmitTo"] = providerIdToSubmitTo;
            ViewData["DocumentFileId"] = documentFileId;

            return View("UploadCompletedComplianceDocForm");
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [ValidateAntiForgeryToken]
        [AuditingAuthorizeAttribute("UploadCompletedComplianceDoc", Roles = "User")]
        public ActionResult UploadCompletedComplianceDoc([ModelBinder(typeof(EncryptedShortBinder))] short providerId, HttpPostedFileBase FileUpload)
        {
            //DocumentFile documentFile;
            int? insertedFileId;
            //string encryptedInsertedFileId;
            //FrontEndEnrypter encrypter;
            Session["providerIdToSubmitTo"] = providerId;
            if (FileUpload == null)
                ModelState.AddModelError("FileToUpload", "You must select a file to upload");
            else
            {
                //documentFile = new DocumentFile(FileUpload.ContentType,
                //    FileUpload.FileName,
                //    FileUpload.InputStream);
                try
                {
                    insertedFileId = _UserDocumentService.SubmitCompletedComplianceDoc(providerId, FileUpload);
                    if (!insertedFileId.HasValue)
                        throw new InvalidOperationException("No file id generated");


                    ViewData["DocumentFileId"] = insertedFileId;
                    ViewData["DocumentFileName"] = FileUpload.FileName;
                }
                catch (RuleException ex)
                {
                    ex.CopyToModelState(ModelState);
                }
                catch (Exception ex)
                {
                    // hack - since called in iframe, just set uploaded file id to null, which
                    // will cause an error message to occur
                    ExceptionPolicy.HandleException(ex, "Controller Level Policy");
                    ViewData["DocumentFileId"] = (int?)null;
                    ViewData["ErrorMessage"] = "An unexpected error occured when file was uploaded.";
                }
            }

            return View("~/Views/File/UploadFileFormIFrame.aspx");
        }

        /// <summary>
        /// Will render form where provider can upload release form for users to download
        /// </summary>
        /// <param name="documentFileId"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        [AuditingAuthorizeAttribute("UploadProviderComplianceForm", Roles = "ProviderAdmin")]
        public ViewResult UploadProviderComplianceForm([ModelBinder(typeof(EncryptedIntegerBinder))] int? documentFileId)
        {
            ViewData["DocumentFileId"] = documentFileId;

            return View("UploadProviderComplianceForm");
        }
        /// <summary>
        /// Sets providers release form to file that is uploaded
        /// </summary>
        /// <param name="FileUpload"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ValidateAntiForgeryToken]
        [AuditingAuthorizeAttribute("UploadProviderCompliance", Roles = "ProviderAdmin")]
        public ViewResult UploadProviderCompliance(HttpPostedFileBase FileUpload)
        {
            //DocumentFile documentFile;
            int? insertedFileId;
            short providerId;
            Provider provider;
            RSAKeyPair senderRSAKey;
            if (FileUpload == null)
                ModelState.AddModelError("FileToUpload", "You must select a file to upload");
            else
            {
                //documentFile = new DocumentFile(FileUpload.ContentType,
                //    FileUpload.FileName,
                //    FileUpload.InputStream);
                try
                {
                    providerId = _MembershipService.GetUsersProviderId(User.Identity.Name, true).Value;
                    provider = _ProviderRepository.GetProvider(providerId);
                    //Get sender's RSA keys to encrypt symmtric key by sender's key and to generate hash using sender's private key
                    if (Session[EncryptionConstantManager.CryptoConstants.RSAKeyPair] != null)
                        senderRSAKey = (RSAKeyPair)Session[EncryptionConstantManager.CryptoConstants.RSAKeyPair];
                    else
                        senderRSAKey = _MembershipService.GetAsymmetricKeysForUser(User.Identity.Name);

                    insertedFileId = _FilesService.UploadFile(FileUpload, User.Identity.Name, FileType.ComplianceDocument, provider.DocumentFilesFolderName, DocumentsAdminService.GetAllowedFileExtensions(), senderRSAKey);

                    if (!insertedFileId.HasValue)
                        throw new InvalidOperationException("No file id generated");

                    _ProviderRepository.SetComplianceDocumentFileId(providerId, insertedFileId.Value);

                    //encrypter = new FrontEndEnrypter();
                    //encryptedInsertedFileId = encrypter.Encrypt(insertedFileId.Value.ToString());

                    ViewData["DocumentFileId"] = insertedFileId;
                    ViewData["DocumentFileName"] = FileUpload.FileName;
                }
                catch (RuleException ex)
                {
                    ex.CopyToModelState(ModelState);
                }
                catch (Exception ex)
                {
                    // hack - since called in iframe, just set uploaded file id to null, which
                    // will cause an error message to occur
                    ExceptionPolicy.HandleException(ex, "Controller Level Policy");
                    ViewData["DocumentFileId"] = (int?)null;
                    ViewData["ErrorMessage"] = "An unexpected error occured when file was uploaded.";
                }
            }

            return View("~/Views/File/UploadFileFormIFrame.aspx");
        }

        /// <summary>
        /// Callback handler for multi-select file upload control.
        /// </summary>
        /// <returns></returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 11/27/2013 | Gurudatta   | Created
        /// </RevisionHistory>
        [AcceptVerbs(HttpVerbs.Post)]
        [AuditingAuthorizeAttribute("UploadDocumentFile", Roles = "User")]
        public ActionResult MultiSelectUploadControlUpload()
        {
            FileUploadControlSettings fileUploadControlSettings = new FileUploadControlSettings();
            UploadControlExtension.GetUploadedFiles("MultiSelectUploadControl", fileUploadControlSettings.ValidationSettings, FileUploadComplete); ;
            return null;
        }

        public ActionResult FileManager()
        {
            string rootpath = null;
            try
            {
                rootpath = _MembershipService.GetFTPFolderPath(_MembershipService.GetUsersProviderId(User.Identity.Name, true), _MembershipService.GetUserIndex(User.Identity.Name));

                if (!String.IsNullOrEmpty(rootpath) && !Directory.Exists(rootpath))
                {
                    if (DirectoryCanListFiles(rootpath))
                    {
                        Directory.CreateDirectory(rootpath);
                    }
                    else
                    {
                        ViewData["ErrorText"] = "SFTP path is not Accessible.";
                        rootpath = null;
                    }
                }
                else
                {
                    ViewData["ErrorText"] = "SFTP path is not Configured.";
                }
            }
            catch (Exception ex)
            {
                if (String.IsNullOrEmpty(rootpath))
                    ViewData["ErrorText"] = "SFTP path is not Configured.";
                else
                    ViewData["ErrorText"] = "SFTP path is not Accessible.";

                rootpath = null;
                // To Do: Log error to file
            }
            return PartialView("_FileManagerPartial", rootpath);
        }

        /// <summary>
        /// Checks for directory path is accessible to logged in user of Not.
        /// </summary>
        /// <param name="folder">Full folder Path</param>
        /// <returns>True if directory is accessible else false.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 02/27/2014 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        private bool DirectoryCanListFiles(string folder)
        {
            bool hasAccess = false;
            string currentUser = System.Security.Principal.WindowsIdentity.GetCurrent().Name;
            NTAccount ntAccount = new NTAccount(currentUser);
            SecurityIdentifier securityIdentifier = ntAccount.Translate(typeof(SecurityIdentifier)) as SecurityIdentifier;
            DirectorySecurity directorySecurity = Directory.GetAccessControl(folder);

            AuthorizationRuleCollection authorizationRuleCollection = directorySecurity.GetAccessRules(true, true, typeof(SecurityIdentifier));

            foreach (FileSystemAccessRule fileSystemAccessRule in authorizationRuleCollection)
            {
                if (securityIdentifier.CompareTo(fileSystemAccessRule.IdentityReference as SecurityIdentifier) == 0)
                {
                    var fileSystemRights = fileSystemAccessRule.FileSystemRights;
                    Console.WriteLine(fileSystemRights);
                    if (fileSystemRights == FileSystemRights.Read ||
                        fileSystemRights == FileSystemRights.ReadAndExecute ||
                        fileSystemRights == FileSystemRights.ReadData ||
                        fileSystemRights == FileSystemRights.ListDirectory)
                    {
                        hasAccess = true;
                    }
                }
            }
            return hasAccess;
        }

        /// <summary>
        /// Upload SFTP files.
        /// </summary>
        /// <param name="files">FileNames Array</param>
        /// <param name="UploadFolderPath">Upload folder path is upload folder clicked.</param>
        /// <returns>Return Json Data.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 02/27/2014 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        [HttpPost]
        public ActionResult UploadServerFiles(string[] files, string UploadFolderPath = null)
        {
            int? insertedFileId = 0;
            string encryptedFileId;
            HtmlHelper htmlHelper = RISARC.Common.Extensions.HtmlHelperExtensions.GetHtmlHelper(this);
            string rootPath = _MembershipService.GetFTPFolderPath(_MembershipService.GetUsersProviderId(User.Identity.Name, true), _MembershipService.GetUserIndex(User.Identity.Name));
            if (String.IsNullOrEmpty(rootPath) || !Directory.Exists(rootPath))
                return Json("FTP path not configured for the Provider or User.");
            string FileNameUploading = "";
            try
            {
                if (UploadFolderPath != null)
                {
                    List<string> fileExtentions = new List<string>();
                    fileExtentions = DocumentsAdminService.GetAllowedFileExtensions().ToList();
                    files = Directory.GetFiles(Directory.GetParent(rootPath).FullName + @"\" + UploadFolderPath).Where(file => fileExtentions.Any(exten => file.EndsWith(exten, StringComparison.OrdinalIgnoreCase))).ToArray();
                }

                if (files == null || files.Length <= 0)
                {
                    Dictionary<string, object> error = new Dictionary<string, object>();
                    error.Add("ErrorCode", -1);
                    error.Add("ErrorMessage", "Please select files to attach.");

                    return Json(error);
                }

                foreach (string FileName in files)
                {

                    if (Session["providerIdToSubmitTo"] == null)
                    {
                        if (!String.IsNullOrEmpty(UploadFolderPath))
                            FileNameUploading = FileName;
                        else
                            FileNameUploading = Directory.GetParent(rootPath).FullName + @"\" + FileName;
                        insertedFileId = _DocumentsAdminService.UploadDocumentServerFile(FileNameUploading);
                    }


                    encryptedFileId = EncryptionExtensions.Encrypt(htmlHelper, insertedFileId);

                    string callbackHtmlString = string.Empty;
                    string previewLink = string.Format("<div><a class=iconLink-icon href='{0}'><IMG alt={1} src='{2}'></a><a href='{0}'>{1}</a>"
                                                        , Url.Action("GetPreviewedFile", new { documentFileId = encryptedFileId })
                                                        , Path.GetFileName(FileNameUploading), Url.Content("~/Images/icons/icon_attachment.gif"));
                    string removeLink = string.Format("<a class='removeFile' encid='{0}' onclick='removeFile(\"{0}\");' href='#'><img height='17' title='Remove File' style='vertical-align: middle;' alt='remove' src='{1}'/></a></div>",
                                                      encryptedFileId, Url.Content("~/images/remove.png"));
                    callbackHtmlString = string.Concat(previewLink, removeLink);

                    DocumentsAdminService.AddFilesToCollection(Convert.ToInt32(insertedFileId), callbackHtmlString);
                    // Added by Dnyaneshwar
                    DocumentsAdminService.AddFilesToGrid(new UploadedFiles()
                    {
                        FileID = Convert.ToInt64(insertedFileId),
                        FileName = Path.GetFileName(FileNameUploading),
                        UploadedFrom = "FTP Folder",
                        DeleteLink = string.Format("<a class='removeFile' encid='{0}' onclick='removeFile(\"{0}\");' href='#'><img height='17' title='Remove File' style='vertical-align: middle;' alt='remove' src='{1}'/></a>", encryptedFileId, Url.Content("~/images/remove.png")),
                        PreViewLink = string.Format("<a href='{0}'>{1}</a>", Url.Action("GetPreviewedFile", new { documentFileId = encryptedFileId }), Path.GetFileName(FileNameUploading)),
                        SendToProviderId = Session["ProviderID_ETAR"] != null ? Convert.ToInt16(Session["ProviderID_ETAR"]) : (short?)null,
                        SendToProviderIsETAR = Session["ProviderIseTAr_ETAR"] != null ? Convert.ToBoolean(Session["ProviderIseTAr_ETAR"]) : false
                    });
                    // End Added
                }
                string requestData = Convert.ToString(GetUploadedFilesCallbackString());
                return Json(requestData, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(ex.Message);
            }
        }

        public ActionResult UploadedDocument()
        {
            List<UploadedFiles> uploadedFiles = null;
            try
            {
                if (Session["UploadedFilesList"] != null)
                    uploadedFiles = Session["UploadedFilesList"] as List<UploadedFiles>;
                return PartialView("_UploadedDocument", uploadedFiles);
                
            }
            catch (Exception ex)
            {
                RISARC.Common.ExceptionHandling.ExceptionUtility.LogException(ex);
                return PartialView("_UploadedDocument", null);
            }
        }

        /// <summary>
        /// This is the grid which will show patient uploaded document of PQRS
        /// </summary>
        /// <returns>PQRS uploaded Documents</returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 21/01/2015 | Surekha   | Created
        /// </RevisionHistory>
        
        public ActionResult PatientsUploadedDocument() {

            List<UploadedFiles> uploadedFiles = null;
            try
            {
                if (Session["UploadedFilesList"] != null)
                    uploadedFiles = Session["UploadedFilesList"] as List<UploadedFiles>;
                return PartialView("PatientsUploadedDocument", uploadedFiles);

            }
            catch (Exception ex)
            {
                RISARC.Common.ExceptionHandling.ExceptionUtility.LogException(ex);
                return PartialView("PatientsUploadedDocument", null);
            }
        }

        /// <summary>
        /// Fills Response Letter uploaded files grid.
        /// </summary>
        /// <returns>Partial View.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 09/09/2014 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public ActionResult UploadedRLDocument(long? AccountSubmissionDetailsID, bool IsClearSession = false)
        {
            List<UploadedFiles> uploadedFiles = null;
            try
            {
                if(IsClearSession)
                    _DocumentsAdminService.CleareSessionForRLUpload();

                if (Session["UploadedRLFilesList"] == null && AccountSubmissionDetailsID != null)
                { 
                    // Fetch Data For Previously uploaded documents.
                    HtmlHelper htmlHelper = RISARC.Common.Extensions.HtmlHelperExtensions.GetHtmlHelper(this);
                    short? SenderProviderID = _MembershipService.GetUsersProviderId(base.User.Identity.Name, true).Value;
                    ICollection<UploadedFiles> uploadedTcnFiles = _DocumentsAdminService.GetTCNFiles(AccountSubmissionDetailsID, SenderProviderID);
                    //Filter for only Response Letter
                    short? DocumentTypeId = _DocumentsAdminService.GetDocumentTypeIDFromName("Response Letter");
                    uploadedTcnFiles = uploadedTcnFiles.Where(docType => docType.DocumentTypeId == DocumentTypeId).ToList();
                    foreach (var item in uploadedTcnFiles)
                    {
                        item.PreViewLink = string.Format("<a href='{0}'>{1}</a>", Url.Action("GetPreviewedFile", new { documentFileId = EncryptionExtensions.Encrypt(htmlHelper, item.FileID) }), Path.GetFileName(item.FileName));
                        item.DeleteLink = string.Format("<a class='removeFile' encid='{0}' onclick='removeRLFile(\"{0}\");' href='#'><img height='17' title='Remove File' style='vertical-align: middle;' alt='remove' src='{1}'/></a></div>", EncryptionExtensions.Encrypt(htmlHelper, item.FileID), Url.Content("~/images/remove.png"));
                        _DocumentsAdminService.AddRLFilesToGrid(item);
                    }
                }

                if (Session["UploadedRLFilesList"] != null)
                    uploadedFiles = Session["UploadedRLFilesList"] as List<UploadedFiles>;
                if (uploadedFiles != null && uploadedFiles.Count > 0)
                    return PartialView("_UploadedRLDocument", uploadedFiles);
                else
                    return PartialView("_UploadedRLDocument", null);
            }
            catch (Exception ex)
            {
                RISARC.Common.ExceptionHandling.ExceptionUtility.LogException(ex);
                return PartialView("_UploadedRLDocument", null);
            }
        }

        // Added by Dnyaneshwar

        public JsonResult UpdateDocumentType(int? FileID, int? DocumentTypeId, bool IsTcnFileType, string DocumentTypeName)
        {
            List<UploadedFiles> uploadedFiles = null;
            string keyName = "UploadedFilesList";
            if (IsTcnFileType)
                keyName = "UploadedTCNFilesList";

            try
            {
                if (Session[keyName] != null)
                {
                    uploadedFiles = Session[keyName] as List<UploadedFiles>;
                    uploadedFiles.Where(item => item.FileID == FileID).ToList().ForEach(setVal => setVal.DocumentTypeId = DocumentTypeId);
                    uploadedFiles.Where(item => item.FileID == FileID).ToList().ForEach(setVal => setVal.DocumentTypeName = DocumentTypeName);

                    ////update TCN Number
                    //if (!string.IsNullOrEmpty(TCNNumber))
                    //    uploadedFiles.Where(item => item.FileID == FileID).ToList().ForEach(setVal => setVal.TCNNumber = TCNNumber);

                    Session[keyName] = uploadedFiles;
                }
            }
            catch (Exception)
            {
                return Json("Error", JsonRequestBehavior.AllowGet);
            }
            return Json("Success", JsonRequestBehavior.AllowGet);
        }

        // End Added

        /// <summary>
        /// Get uplaoded files dynamic HTML string after the send document page is submitted with invalid fileds.
        /// </summary>
        /// <returns>Formatted HTML string for uploaded files.</returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 12/17/2013 | Gurudatta   | Created
        /// </RevisionHistory>
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


        /// <summary>
        /// Callback handler for multi-select file upload control.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 11/27/2013 | Gurudatta   | Created
        /// </RevisionHistory>
        public void FileUploadComplete(object sender, DevExpress.Web.ASPxUploadControl.FileUploadCompleteEventArgs e)
        {
            int? insertedFileId = 0;
            string encryptedFileId;
            HtmlHelper htmlHelper = RISARC.Common.Extensions.HtmlHelperExtensions.GetHtmlHelper(this);
            try
            {
                if (e.UploadedFile.IsValid)
                {
                    short providerID;
                    if (Session["providerIdToSubmitTo"] != null)
                    {
                        providerID = (short)Session["providerIdToSubmitTo"];
                        insertedFileId = _UserDocumentService.SubmitCompletedComplianceDoc(providerID, e.UploadedFile);
                    }
                    else
                        insertedFileId = _DocumentsAdminService.UploadDocumentFile(e.UploadedFile);



                    encryptedFileId = EncryptionExtensions.Encrypt(htmlHelper, insertedFileId);
                    //Send back the HTML string for File name and remove link
                    string callbackHtmlString = string.Empty;
                    string previewLink = string.Format("<div><a class=iconLink-icon href='{0}'><IMG alt={1} src='{2}'></a><a href='{0}'>{1}</a>"
                                                        , Url.Action("GetPreviewedFile", new { documentFileId = encryptedFileId })
                                                        , e.UploadedFile.FileName, Url.Content("~/Images/icons/icon_attachment.gif"));
                    string removeLink = string.Format("<a class='removeFile' encid='{0}' onclick='removeFile(\"{0}\");' href='#'><img height='17' title='Remove File' style='vertical-align: middle;' alt='remove' src='{1}'/></a></div>",
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
                        DeleteLink = string.Format("<a class='removeFile' encid='{0}' onclick='removeFile(\"{0}\");' href='#'><img height='17' title='Remove File' style='vertical-align: middle;' alt='remove' src='{1}'/></a>", encryptedFileId, Url.Content("~/images/remove.png")),
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

        /// <summary>
        /// Callback handler for multi-select file upload control.
        /// </summary>
        /// <returns></returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 11/27/2013 | Gurudatta   | Created
        /// </RevisionHistory>
        //[AuditingAuthorizeAttribute("SingleFileUploadControlUpload", Roles = "ProviderAdmin")]
        public ActionResult SingleFileUploadControlUpload()
        {
            FileUploadControlSettings fileUploadControlSettings = new FileUploadControlSettings();
            UploadControlExtension.GetUploadedFiles("SingleFileUploadControl", fileUploadControlSettings.ValidationSettings, SingleFileUploadComplete);
            return null;
        }

        /// <summary>
        /// Event handler for single file upload control. Sets providers release form to file that is uploaded
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 11/27/2013 | Gurudatta   | Created
        /// </RevisionHistory>
        public void SingleFileUploadComplete(object sender, DevExpress.Web.ASPxUploadControl.FileUploadCompleteEventArgs e)
        {
            int? insertedFileId = 0;
            string encryptedFileId;
            Provider provider;
            ProviderConfiguration providerConfiguration;
            HtmlHelper htmlHelper = RISARC.Common.Extensions.HtmlHelperExtensions.GetHtmlHelper(this);

            if (e.UploadedFile.IsValid)
            {
                short providerId;
                RSAKeyPair providersRSAKey = null;
                RSAKeyPair senderRSAKeys = null;
                string providersPublicKey = string.Empty;
                AESKeyVector aesKeyVector = new AESKeyVector();
                try
                {
                    providerId = _MembershipService.GetUsersProviderId(User.Identity.Name, true).Value;
                    provider = _ProviderRepository.GetProvider(providerId);

                    //Overwrite previously uploaded ROI file and mark it's IsDeleted status to True.
                    providerConfiguration = _ProviderRepository.GetProviderConfiguration(providerId);
                    _DocumentsAdminService.DeleteDocumentFile(providerConfiguration.ComplianceDocumentFileId,false,false);
                    // ROI should be uplaoded using Provider's public key
                    //SendersEncryptedKey will be stored at the time of file upload
                    if (DocumentFileProcessor.EnableFileEncryption)
                    {
                        //Get the symmetric key encrypted by Organization's public key
                        providersRSAKey = _MembershipService.GetAsymmetricKeysForProvider(providerId);
                        providersPublicKey = providersRSAKey.PublicKey;
                        senderRSAKeys = _MembershipService.GetAsymmetricKeysForUser(User.Identity.Name);
                        //encrypt symmetric key using provider's public key and create digital signature using sender's private key.
                        senderRSAKeys.PublicKey = providersPublicKey;
                    }
                    insertedFileId = _FilesService.UploadROIFile(e.UploadedFile, User.Identity.Name, FileType.ComplianceDocument, provider.DocumentFilesFolderName, ref aesKeyVector, senderRSAKeys);
                    if (!insertedFileId.HasValue)
                        throw new InvalidOperationException("No file id generated");

                    //Update ComplianceFileId field with uploaded file id for a provider.
                    _ProviderRepository.SetComplianceDocumentFileId(providerId, insertedFileId.Value);

                }
                catch (RuleException ex)
                {
                    ex.CopyToModelState(ModelState);
                }
                catch (Exception ex)
                {
                    // hack - since called in iframe, just set uploaded file id to null, which
                    // will cause an error message to occur
                    ExceptionPolicy.HandleException(ex, "Controller Level Policy");
                    ViewData["DocumentFileId"] = (int?)null;
                    ViewData["ErrorMessage"] = "An unexpected error occured when file was uploaded.";
                }

                encryptedFileId = EncryptionExtensions.Encrypt(htmlHelper, insertedFileId);
                //Send back the HTML string for File name and remove link
                string callbackHtmlString = string.Empty;
                string previewLink = string.Format("<div><a class=iconLink-icon href='{0}'><IMG alt={1} src='{2}'></a><a href='{0}'>{1}</a>"
                                                    , Url.Action("GetPreviewedFile", new { documentFileId = encryptedFileId })
                                                    , e.UploadedFile.FileName, Url.Content("~/Images/icons/icon_attachment.gif"));

                callbackHtmlString = previewLink;
                e.CallbackData = callbackHtmlString;
            }
        }

        /// <summary>
        /// Callback handler for multi-select file upload control.
        /// </summary>
        /// <returns></returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 11/27/2013 | Gurudatta   | Created
        /// </RevisionHistory>
        [AcceptVerbs(HttpVerbs.Post)]
       // [AuditingAuthorizeAttribute("UploadTCNFile", Roles = "User")]
        public ActionResult MultiSelectTCNFileUploadControlUpload()
        {
            FileUploadControlSettings fileUploadControlSettings = new FileUploadControlSettings();
            UploadControlExtension.GetUploadedFiles("TCNMultiSelectUploadControl", fileUploadControlSettings.ValidationSettings, TCNFileUploadComplete);
            return null;
        }

        /// <summary>
        /// Callback handler for multi-select file upload control.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 11/27/2013 | Gurudatta   | Created
        /// </RevisionHistory>
        public void TCNFileUploadComplete(object sender, DevExpress.Web.ASPxUploadControl.FileUploadCompleteEventArgs e)
        {
            int? insertedFileId = 0;
            string encryptedFileId;
            HtmlHelper htmlHelper = RISARC.Common.Extensions.HtmlHelperExtensions.GetHtmlHelper(this);
            if (e.UploadedFile.IsValid)
            {
                insertedFileId = _DocumentsAdminService.UploadDocumentFile(e.UploadedFile, isTCNType: true);

                encryptedFileId = EncryptionExtensions.Encrypt(htmlHelper, insertedFileId);
                //Send back the HTML string for File name and remove link
                string callbackHtmlString = string.Empty;
                string previewLink = string.Format("<div><a class=iconLink-icon href='{0}'><IMG alt={1} src='{2}'></a><a href='{0}'>{1}</a>"
                                                    , Url.Action("GetPreviewedFile", new { documentFileId = encryptedFileId })
                                                    , e.UploadedFile.FileName, Url.Content("~/Images/icons/icon_attachment.gif"));
                string removeLink = string.Format("<a class='removeFile' encid='{0}' onclick='removeTcnFile(\"{0}\");' href='#'><img height='17' title='Remove File' style='vertical-align: middle;' alt='remove' src='{1}'/></a></div>",
                                                  encryptedFileId, Url.Content("~/images/remove.png"));

                callbackHtmlString = string.Concat(previewLink, removeLink);

                // Add file ids to collection
                _DocumentsAdminService.AddTCNFilesToCollection(Convert.ToInt32(insertedFileId), callbackHtmlString);

                // Added by Guru
                _DocumentsAdminService.AddTCNFilesToGrid(new UploadedFiles()
                {
                    FileID = Convert.ToInt64(insertedFileId),
                    FileName = e.UploadedFile.FileName,
                    FileExtension = _FilesService.ExtractFileExtension(e.UploadedFile.FileName),
                    UploadedFrom = ConstantManager.FileUploadConstants.UploadFromNetworkFolder,
                    DeleteLink = removeLink,//string.Format("<a class='removeFile' encid='{0}' onclick='removeTcnFile(\"{0}\");' href='#'><img height='17' title='Remove File' style='vertical-align: middle;' alt='remove' src='{1}'/></a>", encryptedFileId, Url.Content("~/images/remove.png")),
                    PreViewLink = string.Format("<a href='{0}'>{1}</a>", Url.Action("GetPreviewedFile", new { documentFileId = encryptedFileId }), e.UploadedFile.FileName),
                    TCNNumber = Convert.ToString(Session["TCNNumber"]),
                    DateUploaded = DateTime.UtcNow
                });
                // End Added

                ////Clear TCN Number and Recipient peorvider id
                //Session["TCNNumber"] = null;
                //Session["RecipientProviderId"] = null;

                e.CallbackData = "true";
            }
        }

        /// <summary>
        /// Callback handler for multi-select file upload control to Upload Response Letter
        /// </summary>
        /// <returns></returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 09/05/2014 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public ActionResult MultiSelectRLFileUploadControlUpload()
        {
            FileUploadControlSettings fileUploadControlSettings = new FileUploadControlSettings();
            UploadControlExtension.GetUploadedFiles("RLMultiSelectUploadControl", fileUploadControlSettings.ValidationSettings, RLFileUploadComplete);
            return null;
        }

        /// <summary>
        /// Callback handler for multi-select file upload control to Upload Response Letter
        /// </summary>
        /// <param name="sender">Dev express upload control object.</param>
        /// <param name="e">Dev express FileUploadCompleteEventArgs event object.</param>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 09/08/2014 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public void RLFileUploadComplete(object sender, DevExpress.Web.ASPxUploadControl.FileUploadCompleteEventArgs e)
        {
            int? insertedFileId = 0;
            string encryptedFileId;
            HtmlHelper htmlHelper = RISARC.Common.Extensions.HtmlHelperExtensions.GetHtmlHelper(this);
            if (e.UploadedFile.IsValid)
            {
                insertedFileId = _DocumentsAdminService.UploadDocumentFile(e.UploadedFile, isTCNType: false, isResponseLetter:true);
                encryptedFileId = EncryptionExtensions.Encrypt(htmlHelper, insertedFileId);
                string callbackHtmlString = string.Empty;
                string previewLink = string.Format("<div><a class=iconLink-icon href='{0}'><IMG alt={1} src='{2}'></a><a href='{0}'>{1}{3}</a>"
                                                    , Url.Action("GetPreviewedFile", new { documentFileId = encryptedFileId, isResponceLetter=true })
                                                    , e.UploadedFile.FileName, Url.Content("~/Images/icons/icon_attachment.gif"), e.UploadedFile.ContentLength / 1024);
                string removeLink = string.Format("<a class='removeFile' encid='{0}' onclick='removeRLFile(\"{0}\");' href='#'><img height='17' title='Remove File' style='vertical-align: middle;' alt='remove' src='{1}'/></a>", encryptedFileId, Url.Content("~/images/remove.png"));
                callbackHtmlString = string.Concat(previewLink, removeLink);
                _DocumentsAdminService.AddRLFilesToCollection(Convert.ToInt32(insertedFileId), callbackHtmlString);
                _DocumentsAdminService.AddRLFilesToGrid(new UploadedFiles()
                {
                    FileID = Convert.ToInt64(insertedFileId),
                    FileName = e.UploadedFile.FileName,
                    FileExtension = _FilesService.ExtractFileExtension(e.UploadedFile.FileName),
                    UploadedFrom = ConstantManager.FileUploadConstants.UploadFromNetworkFolder,
                    DeleteLink = removeLink,
                    PreViewLink = string.Format("<a href='{0}'>{1}</a>", Url.Action("GetPreviewedFile", new { documentFileId = encryptedFileId, isResponceLetter = true }), e.UploadedFile.FileName),
                    DateUploaded = DateTime.UtcNow
                });
                e.CallbackData = "true";
            }
        }
    }
}
