using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Ajax;
using RISARC.Documents.Model;
using System.Collections.ObjectModel;
using RISARC.Emr.Web.DataTypes;
using RISARC.Documents.Service;
using SpiegelDg.Security.Model;
using RISARC.Web.EBubble.Models.Binders;
using RISARC.Setup.Implementation.Repository;
using RISARC.Logging.Service;
using RISARC.Logging.Model;
using RISARC.Documents.Implementation.Repository;
using RISARC.Membership.Service;
using System.IO;
using NPOI.HSSF.UserModel;
using NPOI.HSSF.Util;
using Telerik.Web.Mvc.Examples;
using Telerik.Web.Mvc;
using iTextSharp.text;
using Telerik.Web.Mvc.Extensions;
using RISARC.Common.Model;
using RISARC.Common;
using DevExpress.Web.Mvc;
using DevExpress.Web.ASPxGridView;
using RISARC.Common.Enumaration;
using RISARC.Common.GenericDBProcedureCaller;

namespace RISARC.Web.EBubble.Controllers
{
    public class ViewDocumentsController : Controller
    {
        private RISARC.Setup.Implementation.Repository.IProviderRepository _ProviderRepository;
        private IDocumentsRetrievalService _RetrievalService;
        private ILoggingService _LoggingService;
        private IDocumentsRetrievalService _DocumentsRetrievalService;
        private IDocumentsAdminService _DocumentsAdminService;
        public ViewDocumentsController(IDocumentsRetrievalService documentsRetreivalService,
            ILoggingService loggingService, IDocumentsRetrievalService documentsRetrievalRepository, IDocumentsAdminService documentsAdminService, IProviderRepository providerRepository)
        {
            this._RetrievalService = documentsRetreivalService;
            this._ProviderRepository = providerRepository;
            this._DocumentsRetrievalService = documentsRetrievalRepository;
            this._LoggingService = loggingService;
            this._DocumentsAdminService = documentsAdminService;
        }

        [AuditingAuthorizeAttribute("MyDownloadedDocuments", Roles = "User")]
        public ActionResult MyDownloadedDocuments(
           DateTime? startDate,
           DateTime? endDate,
           int pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.MyDownloadedDocuments);

            ICollection<DocumentStatus> statuses;

            statuses = new Collection<DocumentStatus>{
                //DocumentStatus.Downloaded,
                DocumentStatus.ReadyForDownload,
                DocumentStatus.Expired
            };

            ViewData.SetValue(GlobalViewDataKey.PageTitle,
                "Documents Ready to Download");

            ViewData.SetValue(GlobalViewDataKey.ActionName,
                "MyDownloadedDocuments");
            ViewData.SetValue(GlobalViewDataKey.PageDesc,
                "To download, access and view a document, click on the Download Document link");


            return ViewForDocumentsDownloaded(statuses,
                startDate,
                endDate,
                pageNumber, acn, patientFName, patientLName, accountNo);
            //return GridViewForDocumentsDownloaded(statuses,
            //    startDate,
            //    endDate,
            //    pageNumber, acn, patientFName, patientLName, accountNo);
        }

        public ActionResult DocumentBillingMethodDescription()
        {
            BillingMethod billingMethod = RISARC.Common.Model.BillingMethod.CreditCard;
            if (billingMethod == BillingMethod.CreditCard)
                ViewData["BillingMethod"] = "Bill to receiver by credit/debit card";
            else if (billingMethod == BillingMethod.Free)
                ViewData["BillingMethod"] = "Bill to receiver by credit/debit card";
            else if (billingMethod == BillingMethod.InvoiceProvider)
                ViewData["BillingMethod"] = "Bill to sender";
            else if (billingMethod == BillingMethod.PaymentReceived)
                ViewData["BillingMethod"] = "Payment received";
            return View();

        }



        [AuditingAuthorize("MyReceivedDocuments", Roles = "User")]
        public ActionResult MyReceivedDocuments(
           DateTime? startDate,
           DateTime? endDate,
           int pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.MyReceivedDocuments);

            ICollection<DocumentStatus> statuses;

            statuses = new Collection<DocumentStatus>{
                DocumentStatus.AwaitingVerification,
                DocumentStatus.LockedOutFromAttemptedVerifications,
                DocumentStatus.ReadyForCompliance,
                DocumentStatus.ReadyForPurchase,
                //DocumentStatus.ReadyForDownload,
                DocumentStatus.AwaitingComplianceApproval
            };

            ViewData.SetValue(GlobalViewDataKey.PageTitle,
                "Received Documents (Action Required)");

            ViewData.SetValue(GlobalViewDataKey.ActionName,
                "MyReceivedDocuments");

            ViewData.SetValue(GlobalViewDataKey.PageDesc,
                "Click on the Document Link which will direct you to take the appropriate action to retrieve the document.");

            return ViewForDocuments(statuses,
                startDate,
                endDate,
                pageNumber, acn, patientFName, patientLName, accountNo);
        }

        //Added By Abhi for grdReceivedDocuments callback
        public ActionResult _MyReceivedDocuments(
           DateTime? startDate,
           DateTime? endDate,
           int pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.MyReceivedDocuments);

            ICollection<DocumentStatus> statuses;

            statuses = new Collection<DocumentStatus>{
                DocumentStatus.AwaitingVerification,
                DocumentStatus.LockedOutFromAttemptedVerifications,
                DocumentStatus.ReadyForCompliance,
                DocumentStatus.ReadyForPurchase,
                //DocumentStatus.ReadyForDownload,
                DocumentStatus.AwaitingComplianceApproval
            };

            int numberOfPages;
            IEnumerable<RISARC.Documents.Model.Document> documents;

            if (pageNumber == 0)
                pageNumber = 1; // hack - set to 1 by default

            documents = _RetrievalService.GetUsersInboundDocuments(
                statuses,
                startDate,
                endDate,
                pageNumber,
                out numberOfPages, acn, patientFName, patientLName, accountNo);

            //CopyToViewState(startDate, endDate, numberOfPages, pageNumber, acn, patientFName, patientLName, accountNo);


            return PartialView("_ViewReceivedDocuments", documents);
        }
        //End Added

        public RedirectResult ClearAllSearchCatch()//, string ClearSearchFlag)
        {
            _RetrievalService.ClearSearchFilters();
            ViewData["acn"] = null;
            ViewData["accountNo"] = null;
            ViewData["patientFName"] = null;
            ViewData["patientLName"] = null;
            ViewData["StartDate"] = null;
            ViewData["EndDate"] = null;
            return Redirect("../" + Request.QueryString["CurrentPage"]);
        }

      

        [AuditingAuthorizeAttribute("MySentDocuments", Roles = "DocumentAdmin")]
        public ActionResult MySentDocuments( DateTime? startDate,DateTime? endDate, int pageNumber, string acn,
            string patientFName, string patientLName, string accountNo)
        {
            ModelState.Clear();
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.MySentDocuments);
            ViewData.SetValue(GlobalViewDataKey.PageTitle, "Search Sent Documents");
            ViewData.SetValue(GlobalViewDataKey.ActionName, "MySentDocuments");
            ViewData.SetValue(GlobalViewDataKey.PageDesc,"Search sent document by any of the below category");

            ViewData["gridTitle"] = "Sent Documents";
            ViewData["gridSubTitle"] = "To view the summary of your sent document(s), click on the detail link.";
            ViewData["Acn"] = acn;
            CopyToViewState(startDate, endDate, null, 1, acn, patientFName, patientLName, accountNo);
          
            return View("ViewSentDocuments");
        }

        [AuditingAuthorizeAttribute("MyReleaseForms", Roles = "DocumentAdmin")]
        public ActionResult MyReleaseForms(
           DateTime? startDate,
           DateTime? endDate,
           int pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        {
            ModelState.Clear();
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.MyReleaseForms);
            ViewData.SetValue(GlobalViewDataKey.PageTitle,"Search Inbound Release Forms");
            ViewData.SetValue(GlobalViewDataKey.ActionName, "MyReleaseForms");
            ViewData.SetValue(GlobalViewDataKey.PageDesc, "Search release forms by any of the below category");
            ViewData["gridTitle"] = "Inbound Release Forms";
            ViewData["gridSubTitle"] = "To view the summary of your sent document(s), click on the detail link.";
            CopyToViewState(startDate, endDate, null, 1, acn, patientFName, patientLName, accountNo);

            //_RetrievalService.SetupSearchFilters(ConstantManager.ActionMethodNames.MyReleaseForms, ref startDate, ref endDate, ref acn, ref patientFName, ref patientLName, ref accountNo);

            return View("ViewSentDocuments");
        }


        #region Method Helper

        private ViewResult ViewForDocuments(IEnumerable<DocumentStatus> statuses,
             DateTime? startDate,
           DateTime? endDate,
           int pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        {
            int numberOfPages;
            IEnumerable<RISARC.Documents.Model.Document> documents;

            if (pageNumber == 0)
                pageNumber = 1; // hack - set to 1 by default

            documents = _RetrievalService.GetUsersInboundDocuments(
                statuses,
                startDate,
                endDate,
                pageNumber,
                out numberOfPages, acn, patientFName, patientLName, accountNo);

            CopyToViewState(startDate, endDate, numberOfPages, pageNumber, acn, patientFName, patientLName, accountNo);

            return View("ViewReceivedDocuments", documents);
        }

        private ViewResult ViewForDocumentsDownloaded(IEnumerable<DocumentStatus> statuses,
       DateTime? startDate,
     DateTime? endDate,
     int pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        {
            return View("ViewDocumentsToDownload");
        }

        // Added by Dnyaneshwar
        //[AuditingAuthorizeAttribute("MyDownloadedDocuments", Roles = "User")]
        public ActionResult GridViewForDocumentsDownloaded(DateTime? startDate, DateTime? endDate, int pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        {
            int numberOfPages;
            ICollection<DocumentStatus> statuses;

            statuses = new Collection<DocumentStatus>{
                DocumentStatus.ReadyForDownload,
                DocumentStatus.Expired
            };

            IEnumerable<RISARC.Documents.Model.Document> documents;

            if (pageNumber == 0)
                pageNumber = 1; // hack - set to 1 by default

            documents = _RetrievalService.GetUsersInboundDocuments(
                statuses,
                startDate,
                endDate,
                pageNumber,
                out numberOfPages, acn, patientFName, patientLName, accountNo);
            //Commented bu surekha 21.11.2014
           // CopyToViewState(startDate, endDate, numberOfPages, pageNumber, acn, patientFName, patientLName, accountNo);

            return PartialView("pvDownloadDocumentGrid", documents);
        }
        // End Added


        public ActionResult temp()
        {
           
             StoredProcedure P = new StoredProcedure();
             P.ProcedureName = "Setup.GetProvider";
             P.SetParam("@Id", System.Data.DbType.Int16, 39);
             //P.SetParam("@name", System.Data.DbType.String, "Abdul");
            System.Data.DataSet d =ExecuteProcedure.ExecueteProcedure(P, ConstantManager.ConnectionStringKeyConstants.RMSeBUBBLESetup);
            return null;
        }

        #region Methods related to Document pending for TCN and Review.
        [AuditingAuthorizeAttribute("MyDocumentsPendingForTcn", Roles = "User")]
        public ActionResult MyDocumentsPendingForTCN()
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.MyDocumentsPendingForTCN);
            return View("ViewDocumentsPendingForTCN", GetPendingDocuments());
        }

        [AuditingAuthorizeAttribute("MyErroneousRejectedDocuments", Roles = "User")]
        public ActionResult MyErroneousRejectedDocuments()
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.MyErroneousRejectedDocuments);
            return View("MyErroneousRejectedDocuments", GetErroneousRejectedDocuments());
        }

        public ActionResult GridViewForErroneousRejectedDocuments()
        {
            return PartialView("pvDocumentsRejectedByReviewer", GetErroneousRejectedDocuments());
        }

        [AuditingAuthorizeAttribute("GetPendingDocumentsForTCN", Roles = "User")]
        public ActionResult GridViewForDocumentPendingForTCN()
        {
            IEnumerable<RISARC.Documents.Model.Document> pendingDocuments = GetPendingDocuments();
            return PartialView("pvDocumentPendingForTCN", pendingDocuments);
        }

        /// <summary>
        /// Update Documnet TCN review status
        /// </summary>
        /// <param name="accountNumberId">UniqueId of an account.</param>
        /// <param name="id">Id of the document.</param>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 03/21/2014 | Gurudatta   | Created
        /// </RevisionHistory>
        [AcceptVerbs("GET")]
        public object UpdateReviewStatus([ModelBinder(typeof(EncryptedLongBinder))]long? accountNumberId, [ModelBinder(typeof(EncryptedIntegerBinder))]int? documentId, bool reviewStatus)
        {
            bool result = false;
            //logic to update the record and action log entry
            int rowsAffected = _DocumentsAdminService.UpdateReviewStatus(accountNumberId, documentId, reviewStatus);
            result = rowsAffected != -1;

            JsonResult jsonResult = new JsonResult
            {
                Data = result,
                JsonRequestBehavior = JsonRequestBehavior.AllowGet
            };
            return jsonResult.Data;
        } 

        /// <summary>
        /// Check whehter the user has access to view the documents based on the assigned document type and document format type.
        /// </summary>
        /// <param name="accountNumberId">UniqueId of an account.</param>
        /// <param name="documentFileId">Unique Id of document</param>
        /// <returns>True/False</returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 05/29/2014 | Gurudatta   | Created
        /// </RevisionHistory>
        [AcceptVerbs("GET")]
        public object CheckDocumentAccessByDocumentType([ModelBinder(typeof(EncryptedLongBinder))]long? accountNumberId, int? documentFileId,string documentid = null)
        {
            bool result = false;
            int? decodedDocId = null;

            if (!string.IsNullOrEmpty(documentid))
                decodedDocId = CryptoBase32.DecodeBase32ToInt(documentid);
            //Get status of document access for the user.
            result = _DocumentsAdminService.GetDocumentAccessStatus(accountNumberId, documentFileId, decodedDocId.Value);

            JsonResult jsonResult = new JsonResult
            {
                Data = result,
                JsonRequestBehavior = JsonRequestBehavior.AllowGet
            };
            return jsonResult.Data;
        }
        #endregion

        [AuditingAuthorizeAttribute("DocumentsReviewedByDHS", Roles = "User")]
        public ActionResult DocumentsReviewedByDHS()
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.DocumentsReviewedByDHS);
            return View("ViewDocumentsReviewedByDHS", GetDocumentsReviewedByDHS());
        }

        /// <summary>
        /// Bind DevExpress grid view to show data for documents reviewed by DHS.
        /// </summary>
        /// <returns>Partial View for Documents reviewed by DHS.</returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 04/07/2014 | Gurudatta   | Created
        /// </RevisionHistory>
        //[AuditingAuthorizeAttribute("GridViewForDocumentsReviewedByDHS", Roles = "User")]
        public ActionResult GridViewForDocumentsReviewedByDHS()
        {
            IEnumerable<RISARC.Documents.Model.Document> reviewedDocuments = GetDocumentsReviewedByDHS();
            return PartialView("pvDocumentsReviewedByDHS", reviewedDocuments);
        }

        #region Private Methods
        private IEnumerable<Documents.Model.Document> GetPendingDocuments()
        {
            IEnumerable<RISARC.Documents.Model.Document> pendingDocuments = null;
            pendingDocuments = _RetrievalService.GetDocumentsPendingForTCN();
            return pendingDocuments;
        }
        private IEnumerable<Documents.Model.Document> GetErroneousRejectedDocuments()
        {
            IEnumerable<RISARC.Documents.Model.Document> RejectedDocuments = null;
            RejectedDocuments = _RetrievalService.GetDocumentsRejectedByReviewer();
            return RejectedDocuments;
        }
        /// <summary>
        /// Get list of documents reviewed by DHS
        /// </summary>
        /// <returns>List of reviewed documents.</returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 04/07/2014 | Gurudatta   | Created
        /// </RevisionHistory>
        private IEnumerable<Documents.Model.Document> GetDocumentsReviewedByDHS()
        {
            IEnumerable<RISARC.Documents.Model.Document> reviewedDocuments = null;
            reviewedDocuments = _RetrievalService.GetDocumentsReviewedByDHS();
            return reviewedDocuments;
        }
        //marked obsolete by abdul
        [Obsolete]
        private ActionResult ViewForMySentDocuments(ICollection<DocumentStatus> statuses, DateTime? startDate, DateTime? endDate, int pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        {
            int numberOfPages;
            IEnumerable<RISARC.Documents.Model.Document> documents;

            if (pageNumber == 0)
                pageNumber = 1; // hack - set to 1 by default

            documents = _RetrievalService.GetUsersOutboundDocuments(
                statuses,
                startDate,
                endDate,
                pageNumber,
                out numberOfPages, acn, patientFName, patientLName, accountNo);

            CopyToViewState(startDate, endDate, numberOfPages, pageNumber, acn, patientFName, patientLName, accountNo);

            return View("ViewSentDocuments", documents);
        }

        public ActionResult grdSentDocuments_Callback(DateTime? startDate, DateTime? endDate, string acn, string patientFName, string patientLName, string accountNo,int actionStatusflag)
        {
            int numberOfPages;
            IEnumerable<RISARC.Documents.Model.Document> documents; 
            ViewData["Acn"] = acn;          
            if (actionStatusflag==0)
            {
                documents = _RetrievalService.GetUsersOutboundDocuments(
                DocumentStatusUtilities.AllStatuses,
                startDate,
                endDate,
                1,
                out numberOfPages, acn, patientFName, patientLName, accountNo);

            }
            else
            {
                Collection<DocumentStatus> statuses = new Collection<DocumentStatus> { DocumentStatus.AwaitingComplianceApproval};
                documents = _RetrievalService.GetUsersOutboundDocuments(
                    statuses,
                    startDate,
                    endDate,
                    1,
                    out numberOfPages, acn, patientFName, patientLName, accountNo);
            }
            CopyToViewState(startDate, endDate, numberOfPages, 1, acn, patientFName, patientLName, accountNo);

            return View("_ViewSentDocuments", documents);
        } 
        #endregion

        #endregion

        #region Method Helper

        public ActionResult DocumentActionLogHistory([ModelBinder(typeof(EncryptedIntegerBinder))] int documentId)
        {
            ICollection<ActionLogEntry> actionLogHistory;

            actionLogHistory = _LoggingService.GetActionHistoryForDocument(documentId);

            // will hide columns that show which document or request was performed on
            ViewData["HideDocumentColumns"] = true;
            return View("~/Views/AccountAdministration/ActionLogEntryTable.ascx", actionLogHistory);
        }

        private ActionResult ViewForSentRequests2(ICollection<DocumentStatus> statuses, DateTime? startDate, DateTime? endDate, int pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        {
            int numberOfPages;
            IEnumerable<DocumentRequest> requests;

            if (pageNumber == 0)
                pageNumber = 1; // hack - set to 1 by default

            requests = _RetrievalService.GetUsersOutboundRequests(
                statuses,
                startDate,
                endDate,
                pageNumber,
                out numberOfPages, acn, patientFName, patientLName, accountNo);

            CopyToViewState(startDate, endDate, numberOfPages, pageNumber, acn, patientFName, patientLName, accountNo);
            return View("ViewSentRequests2", requests);
        }


        private ActionResult ViewForSentRequests(ICollection<DocumentStatus> statuses, DateTime? startDate, DateTime? endDate, int pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        {
            int numberOfPages;
            IEnumerable<DocumentRequest> requests;

            if (pageNumber == 0)
                pageNumber = 1; // hack - set to 1 by default

            requests = _RetrievalService.GetUsersOutboundRequests(
                statuses,
                startDate,
                endDate,
                pageNumber,
                out numberOfPages, acn, patientFName, patientLName, accountNo);

            CopyToViewState(startDate, endDate, numberOfPages, pageNumber, acn, patientFName, patientLName, accountNo);

            return View("ViewSentRequests", requests);
        }

        #endregion

        [AuditingAuthorizeAttribute("MyOutstandingRequests", Roles = "DocumentAdmin")]
        public ActionResult MyOutstandingRequests(
           DateTime? startDate,
           DateTime? endDate,
           int pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.MyOutstandingRequests);


            ICollection<DocumentStatus> statuses;

            statuses = new Collection<DocumentStatus>
            {
                DocumentStatus.RequestAwaitingDocument,
                DocumentStatus.AwaitingComplianceApproval
            };

            ViewData.SetValue(GlobalViewDataKey.PageTitle,
                "Outstanding Requests");

            ViewData.SetValue(GlobalViewDataKey.ActionName,
                "MyOutstandingRequests");

            ViewData.SetValue(GlobalViewDataKey.PageDesc,
            "Search Outstanding requests by any of the below category");

            _RetrievalService.SetupSearchFilters(ConstantManager.ActionMethodNames.MyOutstandingRequests, ref startDate, ref endDate, ref acn, ref patientFName, ref patientLName, ref accountNo);

            return ViewForMyInboundRequests(statuses,
                startDate,
                endDate,
                pageNumber, acn, patientFName, patientLName, accountNo);
        }

        //Added By Abhi for  gvViewSentRequests  Callback 
        public ActionResult _MyOutstandingRequests(
           DateTime? startDate,
           DateTime? endDate,
           int pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        {
            ICollection<DocumentStatus> statuses;
            statuses = new Collection<DocumentStatus>
            {
                DocumentStatus.RequestAwaitingDocument,
                DocumentStatus.AwaitingComplianceApproval
            };
            ViewData.SetValue(GlobalViewDataKey.PageTitle,
                "Outstanding Requests");
            ViewData.SetValue(GlobalViewDataKey.ActionName,
                "MyOutstandingRequests");
            ViewData.SetValue(GlobalViewDataKey.PageDesc,
            "Requested documents that need to be responded to");
            _RetrievalService.SetupSearchFilters(ConstantManager.ActionMethodNames.MyOutstandingRequests, ref startDate, ref endDate, ref acn, ref patientFName, ref patientLName, ref accountNo);

            int numberOfPages;
            IEnumerable<DocumentRequest> requests;

            if (pageNumber == 0)
                pageNumber = 1; // hack - set to 1 by default

            requests = _RetrievalService.GetUsersInboundRequests(
                statuses,
                startDate,
                endDate,
                pageNumber,
                out numberOfPages, acn, patientFName, patientLName, accountNo);

            CopyToViewState(startDate, endDate, numberOfPages, pageNumber, acn, patientFName, patientLName, accountNo);
            return PartialView("_ViewReceivedRequests", requests);
            
        }
        //End Added


        [AuditingAuthorizeAttribute("ProvidersRespondedToRequests", Roles = "DocumentAdmin")]
        public ActionResult MySentRequests(
           DateTime? startDate,
           DateTime? endDate,
           int pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.MySentRequests);

            ICollection<DocumentStatus> statuses;

            statuses = new Collection<DocumentStatus>
            {
                DocumentStatus.RequestRespondedTo,
                DocumentStatus.Cancelled,
                DocumentStatus.ComplianceRejected,
                DocumentStatus.AwaitingComplianceApproval,
                DocumentStatus.RequestAwaitingDocument,
                //DocumentStatus.RequestRespondedTo,
                //DocumentStatus.RequestAwaitingDocument,
             };

            ViewData.SetValue(GlobalViewDataKey.PageTitle,
                "Sent Requests");

            ViewData.SetValue(GlobalViewDataKey.ActionName,
                "MySentRequests");

            ViewData.SetValue(GlobalViewDataKey.PageDesc,
                 "Sent Requests");

            return ViewForMyInboundRequestsTest(statuses,
                startDate,
                endDate,
                pageNumber, acn, patientFName, patientLName, accountNo);
        }
        //Added By Abhi for gvViewSentRequests callback
        public ActionResult _MySentRequests(
           DateTime? startDate,
           DateTime? endDate,
           int pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        {
            
            ICollection<DocumentStatus> statuses;

            statuses = new Collection<DocumentStatus>
            {
                DocumentStatus.RequestRespondedTo,
                DocumentStatus.Cancelled,
                DocumentStatus.ComplianceRejected,
                DocumentStatus.AwaitingComplianceApproval,
                DocumentStatus.RequestAwaitingDocument,
                //DocumentStatus.RequestRespondedTo,
                //DocumentStatus.RequestAwaitingDocument,
             };

            ViewData.SetValue(GlobalViewDataKey.PageTitle,
                "Sent Requests");

            ViewData.SetValue(GlobalViewDataKey.ActionName,
                "MySentRequests");

            ViewData.SetValue(GlobalViewDataKey.PageDesc,
                 "Sent Requests");

            int numberOfPages;
            IEnumerable<DocumentRequest> requests;

            if (pageNumber == 0)
                pageNumber = 1; // hack - set to 1 by default

            requests = _RetrievalService.GetUsersInboundRequestsSent(
                statuses,
                startDate,
                endDate,
                pageNumber,
                out numberOfPages, acn, patientFName, patientLName, accountNo);

            CopyToViewState(startDate, endDate, numberOfPages, pageNumber, acn, patientFName, patientLName, accountNo);


            return PartialView("_ViewSentRequests", requests);
        }
        
        //End Added


        [AuditingAuthorizeAttribute("ProvidersRespondedToRequests", Roles = "DocumentAdmin")]
        public ActionResult MyRespondedToRequests(
           DateTime? startDate,
           DateTime? endDate,
           int pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.MyRespondedToRequests);

            ICollection<DocumentStatus> statuses;

            statuses = new Collection<DocumentStatus>
            {
                DocumentStatus.RequestRespondedTo,
                DocumentStatus.Cancelled,
                DocumentStatus.ComplianceRejected
            };

            ViewData.SetValue(GlobalViewDataKey.PageTitle,
                "Requests Responded To");

            ViewData.SetValue(GlobalViewDataKey.ActionName,
                "MyRespondedToRequests");
            ViewData.SetValue(GlobalViewDataKey.PageDesc,
                "Search Requests Responded To by any of the belo category");

            _RetrievalService.SetupSearchFilters(ConstantManager.ActionMethodNames.MyRespondedToRequests, ref startDate, ref endDate, ref acn, ref patientFName, ref patientLName, ref accountNo);

            return ViewForMyInboundRequests(statuses,
                startDate,
                endDate,
                pageNumber, acn, patientFName, patientLName, accountNo);
        }

        //Added By Abhi for gvMyRespondedToRequests callback
        public ActionResult _MyRespondedToRequests(
           DateTime? startDate,
           DateTime? endDate,
           int pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        {
           ICollection<DocumentStatus> statuses;

            statuses = new Collection<DocumentStatus>
            {
                DocumentStatus.RequestRespondedTo,
                DocumentStatus.Cancelled,
                DocumentStatus.ComplianceRejected
            };

            ViewData.SetValue(GlobalViewDataKey.PageTitle,
                "Requests Responded To");

            ViewData.SetValue(GlobalViewDataKey.ActionName,
                "MyRespondedToRequests");
            ViewData.SetValue(GlobalViewDataKey.PageDesc,
                "Documents that have been reviewed and responded to");

            _RetrievalService.SetupSearchFilters(ConstantManager.ActionMethodNames.MyRespondedToRequests, ref startDate, ref endDate, ref acn, ref patientFName, ref patientLName, ref accountNo);


            int numberOfPages;
            IEnumerable<DocumentRequest> requests;

            if (pageNumber == 0)
                pageNumber = 1; // hack - set to 1 by default

            requests = _RetrievalService.GetUsersInboundRequests(
                statuses,
                startDate,
                endDate,
                pageNumber,
                out numberOfPages, acn, patientFName, patientLName, accountNo);

            CopyToViewState(startDate, endDate, numberOfPages, pageNumber, acn, patientFName, patientLName, accountNo);
            return PartialView("_MyRespondedToRequests", requests);
        }
        //End Added


        private ActionResult ViewForMyInboundRequestsTest(ICollection<DocumentStatus> statuses, DateTime? startDate, DateTime? endDate, int pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        {
            int numberOfPages;
            IEnumerable<DocumentRequest> requests;

            if (pageNumber == 0)
                pageNumber = 1; // hack - set to 1 by default

            requests = _RetrievalService.GetUsersInboundRequestsSent(
                statuses,
                startDate,
                endDate,
                pageNumber,
                out numberOfPages, acn, patientFName, patientLName, accountNo);

            CopyToViewState(startDate, endDate, numberOfPages, pageNumber, acn, patientFName, patientLName, accountNo);

            return View("ViewSentRequests", requests);
        }


        //Added by Abhi for ExportToExcel Functionality (29-Oct-2014)
        static GridViewSettings exportGridViewSettings;

        /// <summary>
        /// Export Grid data To Excel Sheet
        /// </summary>
        /// 
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 01/11/2014 | Abhishek    | Created
        /// </RevisionHistory>
        public ActionResult ExportExcelSentRequests(DateTime? startDate, DateTime? endDate, int pageNumber, string acn, string patientFName, string patientLName, string accountNo, int ReportType)
        {

            IEnumerable<DocumentRequest> requests = null;
            IEnumerable<RISARC.Documents.Model.Document> documents;
            ICollection<DocumentStatus> statuses;

            int numberOfPages;

            if (pageNumber == 0)
                pageNumber = 1; // hack - set to 1 by default

            exportGridViewSettings = null;
            if (ReportType == (int)ExportGridSetting.SentRequests)
            {
                statuses = new Collection<DocumentStatus>
                {
                    DocumentStatus.RequestRespondedTo,
                    DocumentStatus.Cancelled,
                    DocumentStatus.ComplianceRejected,
                    DocumentStatus.AwaitingComplianceApproval,
                    DocumentStatus.RequestAwaitingDocument,
                };

                requests = _RetrievalService.GetUsersInboundRequestsSent(
                   statuses,
                   startDate,
                   endDate,
                   pageNumber,
                   out numberOfPages, acn, patientFName, patientLName, accountNo);
                return GridViewExtension.ExportToXlsx(ExportGridViewSettings(ReportType), requests);
            }
            else if (ReportType == (int)ExportGridSetting.TransactionRequring)
            {
                statuses = new Collection<DocumentStatus>
                {
                    DocumentStatus.AwaitingVerification,
                    DocumentStatus.LockedOutFromAttemptedVerifications,
                    DocumentStatus.ReadyForCompliance,
                    DocumentStatus.ReadyForPurchase,
                    //DocumentStatus.ReadyForDownload,
                    DocumentStatus.AwaitingComplianceApproval
                };

                documents = _RetrievalService.GetUsersInboundDocuments(
                statuses,
                startDate,
                endDate,
                pageNumber,
                out numberOfPages, acn, patientFName, patientLName, accountNo);
                return GridViewExtension.ExportToXlsx(ExportGridViewSettings(ReportType), documents);
            }
            else if (ReportType == (int)ExportGridSetting.OutstandingRequests)
            {
                statuses = new Collection<DocumentStatus>
                {
                    DocumentStatus.RequestAwaitingDocument,
                    DocumentStatus.AwaitingComplianceApproval
                };
               _RetrievalService.SetupSearchFilters(ConstantManager.ActionMethodNames.MyOutstandingRequests, ref startDate, ref endDate, ref acn, ref patientFName, ref patientLName, ref accountNo);

                requests = _RetrievalService.GetUsersInboundRequests(
                    statuses,
                    startDate,
                    endDate,
                    pageNumber,
                    out numberOfPages, acn, patientFName, patientLName, accountNo);
                return GridViewExtension.ExportToXlsx(ExportGridViewSettings(ReportType), requests);
            }
            else if (ReportType == (int)ExportGridSetting.RequestsRespondedTo)
            {
                statuses = new Collection<DocumentStatus>
                {
                    DocumentStatus.RequestRespondedTo,
                    DocumentStatus.Cancelled,
                    DocumentStatus.ComplianceRejected
                };

                _RetrievalService.SetupSearchFilters(ConstantManager.ActionMethodNames.MyRespondedToRequests, ref startDate, ref endDate, ref acn, ref patientFName, ref patientLName, ref accountNo);

                requests = _RetrievalService.GetUsersInboundRequests(
                    statuses,
                    startDate,
                    endDate,
                    pageNumber,
                    out numberOfPages, acn, patientFName, patientLName, accountNo);
                return GridViewExtension.ExportToXlsx(ExportGridViewSettings(ReportType), requests);
            }
            else
            {
                return null;
            }
            
        }

        /// <summary>
        /// Export Grid View Settings
        /// </summary>
        /// 
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 01/11/2014 | Abhishek    | Created
        /// </RevisionHistory>
        public static GridViewSettings ExportGridViewSettings(int reporttype)
        {
        
                if (exportGridViewSettings == null)
                    exportGridViewSettings = GetGridSettings(reporttype);
                return exportGridViewSettings;
        }

        /// <summary>
        /// Get Grid Settings
        /// </summary>
        /// 
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 01/11/2014 | Abhishek    | Created
        /// </RevisionHistory>
        public static GridViewSettings GetGridSettings(int ReportType)
        {
            GridViewSettings settings = new GridViewSettings();
            
            if (ReportType == (int)ExportGridSetting.SentRequests)
            {
                settings.Name = "SentRequests";

                settings.Columns.Add(column =>
                {
                    column.Caption = "Sent Date";
                    column.FieldName = "RequestUTCDate";
                });

                settings.Columns.Add(column =>
                {
                    column.Caption = "Response Due By";
                    column.FieldName = "RequestUTCDueBy";

                });

                settings.Columns.Add(column =>
                {
                    column.Caption = "Requested Document Type";
                    column.FieldName = "DocumentTypeName";

                });

                settings.Columns.Add(column =>
                {
                    column.Caption = "Requested Document Description";
                    column.FieldName = "DocumentDescription";
                });

                settings.Columns.Add(column =>
                {
                    column.Caption = "Requested By";
                    column.FieldName = "RequestedBy";
                });

                settings.Columns.Add(column =>
                {
                    column.Caption = "Requested To";
                    column.FieldName = "RequestedTo";
                });

                settings.Columns.Add(column =>
                {
                    column.Caption = "Patient Document Requested For";
                    column.FieldName = "PatientDocumentRequestedFor";
                });

                settings.Columns.Add(column =>
                {
                    column.Caption = "Status";
                    column.FieldName = "DocumentStatusMessage";

                });
            }
            else if (ReportType == (int)ExportGridSetting.TransactionRequring)
            {
                settings.Name = "TransactionsRequiringDocument";

                settings.Columns.Add(column =>
                {
                    column.Caption = "Document Type";
                    column.FieldName = "DocumentTypeName";
                });
                settings.Columns.Add(column =>
                {
                    column.Caption = "Document Description";
                    column.FieldName = "DocumentDescription";
                });
                settings.Columns.Add(column =>
                {
                    column.Caption = "ACN Number";
                    column.FieldName = "ACN.ACNNumber";
                });

                settings.Columns.Add(column =>
                {
                    column.Caption = "Sent By (Provider)";
                    column.FieldName = "SentByProvider";

                });
                settings.Columns.Add(column =>
                {
                    column.Caption = "First name";
                    column.FieldName = "PatientFirstname";

                });
                settings.Columns.Add(column =>
                {
                    column.Caption = "Last name";
                    column.FieldName = "PatientLastname";
                });
                settings.Columns.Add(column =>
                {
                    column.Caption = "Sent on";
                    column.FieldName = "CreateUTCDate";
                });
                settings.Columns.Add(column =>
                {
                    column.FieldName = "ActionUTCTime";
                    column.Caption = "Downloaded";
                });
                settings.Columns.Add(column =>
                {
                    column.Caption = "Cost";
                    column.FieldName = "Cost";
                    column.PropertiesEdit.DisplayFormatString = "c";
                });
                settings.Columns.Add(column =>
                {
                    column.Caption = "Billing Method";
                    column.FieldName = "BillingMethodMessage";
                });
                settings.Columns.Add(column =>
                {
                    column.Caption = "Status";
                    column.FieldName = "DocumentStatusMessage";
                });
            }
            else if (ReportType == (int)ExportGridSetting.OutstandingRequests || ReportType == (int)ExportGridSetting.RequestsRespondedTo)
            {
                if (ReportType == (int)ExportGridSetting.OutstandingRequests)
                    settings.Name = "OutstandingRequests";
                else
                    settings.Name = "RequestRespondedTo";

                settings.Columns.Add(column =>
                {
                    column.Caption = "Request Date";
                    column.FieldName = "RequestUTCDate";
                });

                settings.Columns.Add(column =>
                {
                    column.Caption = "Response Due By";
                    column.FieldName = "RequestUTCDueBy";
                });


                settings.Columns.Add(column =>
                {
                    column.Caption = "Requested Document Type";
                    column.FieldName = "DocumentTypeName";
                });

                settings.Columns.Add(column =>
                {
                    column.Caption = "Requested Document Description";
                    column.FieldName = "DocumentDescription";
                });

                settings.Columns.Add(column =>
                {
                    column.Caption = "Requested By";
                    column.FieldName = "RequestedBy";
                });

                settings.Columns.Add(column =>
                {
                    column.Caption = "Requested To";
                    column.FieldName = "RequestedTo";
                });


                settings.Columns.Add(column =>
                {
                    column.Caption = "First Name";
                    column.FieldName = "PatientFirstName";
                });

                settings.Columns.Add(column =>
                {
                    column.Caption = "Last Name";
                    column.FieldName = "PatientLastName";
                });

                settings.Columns.Add(column =>
                {
                    column.Caption = "Status";
                    column.FieldName = "DocumentStatusMessage";
                });

            }
            return settings;
        }
        //End Added

        //[AuditingAuthorizeAttribute("ProvidersOutstandingRequests", Roles = "DocumentAdmin")]
        //public ActionResult ProvidersOutstandingRequests(
        //   DateTime? startDate,
        //   DateTime? endDate,
        //   int pageNumber)
        //{
        //    ICollection<DocumentStatus> statuses;

        //    statuses = new Collection<DocumentStatus>{
        //        DocumentStatus.RequestAwaitingDocument,
        //        DocumentStatus.AwaitingComplianceApproval
        //    };

        //    ViewData.SetValue(GlobalViewDataKey.PageTitle,
        //        "Provider's Outstanding Requests");

        //    ViewData.SetValue(GlobalViewDataKey.ActionName,
        //        "ProvidersOutstandingRequests");

        //    return ViewForProvidersInboundRequests(statuses,
        //        startDate,
        //        endDate,
        //        pageNumber);
        //}

        //[AuditingAuthorizeAttribute("ProvidersRespondedToRequests", Roles = "DocumentAdmin")]
        //public ActionResult ProvidersRespondedToRequests(
        //   DateTime? startDate,
        //   DateTime? endDate,
        //   int pageNumber)
        //{
        //    ICollection<DocumentStatus> statuses;

        //    statuses = new Collection<DocumentStatus>{
        //        DocumentStatus.RequestRespondedTo,
        //        DocumentStatus.Cancelled,
        //        DocumentStatus.ComplianceRejected
        //    };

        //    ViewData.SetValue(GlobalViewDataKey.PageTitle,
        //        "Provider's Responded to Requests");

        //    ViewData.SetValue(GlobalViewDataKey.ActionName,
        //        "ProvidersRespondedToRequests");

        //    return ViewForProvidersInboundRequests(statuses,
        //        startDate,
        //        endDate,
        //        pageNumber);
        //} 

        #region Method Helper

        private ActionResult ViewForMyInboundRequests(ICollection<DocumentStatus> statuses, DateTime? startDate, DateTime? endDate, int pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        {
            int numberOfPages;
            IEnumerable<DocumentRequest> requests;

            if (pageNumber == 0)
                pageNumber = 1; // hack - set to 1 by default

            requests = _RetrievalService.GetUsersInboundRequests(
                statuses,
                startDate,
                endDate,
                pageNumber,
                out numberOfPages, acn, patientFName, patientLName, accountNo);

            CopyToViewState(startDate, endDate, numberOfPages, pageNumber, acn, patientFName, patientLName, accountNo);
            return View("ViewReceivedRequests", requests);
        }




        //private ActionResult ViewForMyInboundRequeststest(ICollection<DocumentStatus> statuses, DateTime? startDate, DateTime? endDate, int pageNumber)
        //{
        //    int numberOfPages;
        //    IEnumerable<DocumentRequest> requests;

        //    if (pageNumber == 0)
        //        pageNumber = 1; // hack - set to 1 by default

        //    requests = _RetrievalService.GetUsersOutboundRequeststest(
        //        statuses,
        //        startDate,
        //        endDate,
        //        pageNumber,
        //        out numberOfPages);

        //    CopyToViewState(startDate, endDate, numberOfPages, pageNumber);

        //    return View("ViewReceivedRequests", requests);
        //} 


        [AcceptVerbs(HttpVerbs.Post)]

        public ActionResult DocumentTransaction1([ModelBinder(typeof(EncryptedIntegerBinder))] int documentId)
        {

            return View("PayByCreditCard");

        }

        public string GetStatus()
        {
            return "Status OK at " + DateTime.Now.ToLongTimeString();
        }

        public string UpdateForm(string textBox1)
        {
            if (textBox1 != "Enter text")
            {
                return "You entered: \"" + textBox1.ToString() + "\" at " +
                    DateTime.Now.ToLongTimeString();
            }

            return String.Empty;
        }
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Submit([ModelBinder(typeof(EncryptedIntegerBinder))] int documentId, string foo, string DeniedDate, string ApproveDate, DateTime? delay, DateTime? deliveryDate, DateTime? orderDateTime)
        {
            //if (delay == null) { ModelState.AddModelError("delay", "It is required to select a cake delay time."); }
            //if (deliveryDate == null) { ModelState.AddModelError("deliveryDate", "It is required to select a cake delivery                    date."); } 
            //if (orderDateTime == null) { ModelState.AddModelError("orderDateTime", "It is required to select a cake order                    date time."); }
            //if (ModelState.IsValid) { ViewData["delay"] = delay;
            //    ViewData["deliveryDate"] = deliveryDate; ViewData["orderDateTime"] = orderDateTime; }

            RISARC.Documents.Model.Document document;

            document = _DocumentsRetrievalService.GetDocument(documentId);
            _DocumentsAdminService.UpdateRACDATA(document);
            string statusMessage = "Update sucessful";

            return RedirectToAction(
                "MySentDocuments",
                "ViewDocuments",
                new
                {
                    pageNumber = 1,
                    statusMessage = statusMessage
                });
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult RacAppealsUpdate([ModelBinder(typeof(EncryptedIntegerBinder))] int documentId, RISARC.Documents.Model.Document document, string ComboBox, string AppealStatus)
        {
            //if (delay == null) { ModelState.AddModelError("delay", "It is required to select a cake delay time."); }
            //if (deliveryDate == null) { ModelState.AddModelError("deliveryDate", "It is required to select a cake delivery                    date."); } 
            //if (orderDateTime == null) { ModelState.AddModelError("orderDateTime", "It is required to select a cake order                    date time."); }
            //if (ModelState.IsValid) { ViewData["delay"] = delay;
            //    ViewData["deliveryDate"] = deliveryDate; ViewData["orderDateTime"] = orderDateTime; }

            switch (ComboBox)
            {
                case "":
                    document.AppealLevel = "";
                    break;
                case "1":
                    document.AppealLevel = "RAC";
                    break;
                case "2":
                    document.AppealLevel = "1st Appeal(F1/Mac Appeal)";
                    break;
                case "3":
                    document.AppealLevel = "2nd Appeal(QIC Appeal)";
                    break;
                case "4":
                    document.AppealLevel = "3rd Appeal(ALJ Appeal)";
                    break;
                case "5":
                    document.AppealLevel = "4th Appeal(Department Board Appeal)";
                    break;
                case "6":
                    document.AppealLevel = "5th Appeal(District Court Appeal)";
                    break;


            }

            switch (AppealStatus)
            {
                case "":
                    document.AppealStatus = "";
                    break;
                case "1":
                    document.AppealStatus = "Approved";
                    break;
                case "2":
                    document.AppealStatus = "Decision Pending";
                    break;
                case "3":
                    document.AppealStatus = "Denied";
                    break;

            }
            document.Id = documentId;
            _DocumentsAdminService.UpdateRACDATA(document);
            document = _DocumentsRetrievalService.GetDocument(documentId);
            string statusMessage = "RAC Update successful";

            return RedirectToAction(
                "MySentDocuments",
                "ViewDocuments",
                new
                {
                    pageNumber = 1,
                    statusMessage = statusMessage
                });
        }

        [AcceptVerbs(HttpVerbs.Post)]

        public ActionResult AnotherSubmission(string foo, string bar)
        {
            return View();

        }




        [AcceptVerbs(HttpVerbs.Get)]
        [AuditingAuthorize("DocumentTransactionUser")]
        public ActionResult DocumentTransactionuser([ModelBinder(typeof(EncryptedIntegerBinder))] int documentId)
        {
            RISARC.Documents.Model.Document document;

            document = _DocumentsRetrievalService.GetDocument(documentId);
            if (document == null)
                throw new ArgumentException("No document exists with id " + documentId + ".", "documentId");

            ViewData["ProviderName"] = _ProviderRepository.GetProviderName(document.SentFromProviderId);

            return View(document);
        }



        [AcceptVerbs(HttpVerbs.Get)]
        [AuditingAuthorize("DocumentTransaction")]
        public ActionResult DocumentTransaction([ModelBinder(typeof(EncryptedIntegerBinder))] int documentId)
        {
            RISARC.Documents.Model.Document document;
            var a = Request.UrlReferrer;
            document = _DocumentsRetrievalService.GetDocument(documentId);
            if (document == null)
                throw new ArgumentException("No document exists with id " + documentId + ".", "documentId");

            ViewData["ProviderName"] = _ProviderRepository.GetProviderName(document.SentFromProviderId);

            return View(document);
        }
        private ActionResult ViewForProvidersInboundRequests(ICollection<DocumentStatus> statuses, DateTime? startDate, DateTime? endDate, int pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        {
            int numberOfPages;
            IEnumerable<DocumentRequest> requests;

            if (pageNumber == 0)
                pageNumber = 1; // hack - set to 1 by default

            requests = _RetrievalService.GetProvidersInboundRequests(
                statuses,
                startDate,
                endDate,
                pageNumber,
                out numberOfPages, acn, patientFName, patientLName, accountNo);

            CopyToViewState(startDate, endDate, numberOfPages, pageNumber, acn, patientFName, patientLName, accountNo);

            return View("ViewReceivedRequests", requests);
        }

        #endregion






        [AuditingAuthorizeAttribute("ProvidersReleaseForms", Roles = "DocumentAdmin")]
        public ActionResult ProvidersReleaseForms(
           DateTime? startDate,
           DateTime? endDate,
           int pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        {
            ICollection<DocumentStatus> statuses;

            statuses = new Collection<DocumentStatus>
            {
                DocumentStatus.AwaitingComplianceApproval
            };

            ViewData.SetValue(GlobalViewDataKey.PageTitle,
                "Provider's Inbound Release Forms");

            ViewData.SetValue(GlobalViewDataKey.ActionName,
                "ProvidersReleaseForms");

            ViewData.SetValue(GlobalViewDataKey.PageDesc,
                "USER’S RELEASE FORM HAS BEEN DENIED AND THEY HAVE BEEN NOTIFIED");

            return ViewForProvidersSentDocuments(
                statuses,
                startDate,
                endDate,
                pageNumber, acn, patientFName, patientLName, accountNo);
        }

        #region Method Helper

        private ActionResult ViewForProvidersSentDocuments(ICollection<DocumentStatus> statuses, DateTime? startDate, DateTime? endDate, int pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        {
            int numberOfPages;
            IEnumerable<RISARC.Documents.Model.Document> documents;

            if (pageNumber == 0)
                pageNumber = 1; // hack - set to 1 by default

            documents = _RetrievalService.GetProvidersOutboundDocuments(
                statuses,
                startDate,
                endDate,
                pageNumber,
                out numberOfPages, acn, patientFName, patientLName, accountNo);

            CopyToViewState(startDate, endDate, numberOfPages, pageNumber, acn, patientFName, patientLName, accountNo);

            return View("ViewSentDocuments", documents);
        }

        #endregion


        private void CopyToViewState(DateTime? startDate, DateTime? endDate, int? numberOfPages, int pageNumber, string ACN, string patientFName, string patientLName, string accountNo)
        {
            ViewData["StartDate"] = startDate;
            ViewData["EndDate"] = endDate;
            ViewData.SetValue(GlobalViewDataKey.NumberOfPages, numberOfPages);
            ViewData.SetValue(GlobalViewDataKey.PageNumber, pageNumber);
            ViewData["PatientFName"] = patientFName;
            ViewData["PatientLName"] = patientLName;
            ViewData["AccountNo"] = accountNo;
        }
        [AcceptVerbs(HttpVerbs.Post)]
        [GridAction]
        public ActionResult IndexAjax()
        {
            DateTime? startDate = null;
            DateTime? endDate = null;
            int pageNumber = 0;
            string acn = null;
            string patientFName = null;
            string patientLName = null;
            string accountNo = null;
            ICollection<DocumentStatus> statuses;
            statuses = new Collection<DocumentStatus>{
                   DocumentStatus.ReadyForDownload,
                DocumentStatus.Expired
            };
            IEnumerable<RISARC.Documents.Model.Document> documents;

            int numberOfPages;
            if (pageNumber == 0)
                pageNumber = 1; // hack - set to 1 by default
            documents = _RetrievalService.GetUsersInboundDocuments(statuses, startDate, endDate, pageNumber, out numberOfPages, acn, patientFName, patientLName, accountNo);
            return View(new GridModel(documents));
        }
        //1
        public ActionResult Export(int page, string orderBy, string filter)
        {
            //Get the data representing the current grid state - page, sort and filter
            DateTime? startDate = null;
            DateTime? endDate = null;
            int pageNumber = 0;
            string acn = null;
            string patientFName = null;
            string patientLName = null;
            string accountNo = null;
            ICollection<DocumentStatus> statuses;

            statuses = new Collection<DocumentStatus>{
                   DocumentStatus.ReadyForDownload,
                DocumentStatus.Expired
            };
            IEnumerable<RISARC.Documents.Model.Document> documents;
            int numberOfPages;


            if (pageNumber == 0)
                pageNumber = 1; // hack - set to 1 by default
            //documents = _RetrievalService.GetUsersInboundDocuments(statuses,startDate,endDate,pageNumber,out 2,acn,patientFName,patientLName,accountNo);
            documents = _RetrievalService.GetUsersInboundDocuments(statuses, startDate, endDate, pageNumber, out numberOfPages, acn, patientFName, patientLName, accountNo);

            GridModel model = documents.AsQueryable().ToGridModel(page, 65000, orderBy, string.Empty, filter);



            var orders = model.Data.Cast<RISARC.Documents.Model.Document>();



            //Create new Excel workbook

            var workbook = new HSSFWorkbook();



            //Create new Excel sheet

            var sheet = workbook.CreateSheet();





            //(Optional) set the width of the columns

            sheet.SetColumnWidth(0, 10 * 256);

            sheet.SetColumnWidth(1, 50 * 256);

            sheet.SetColumnWidth(2, 50 * 256);

            sheet.SetColumnWidth(3, 50 * 256);

            HSSFRow row1 = sheet.CreateRow(0);
            HSSFCell cell = row1.CreateCell(0);

            cell.SetCellValue("Documents ready to download");
            HSSFCellStyle style = workbook.CreateCellStyle();
            style.Alignment = HSSFCellStyle.ALIGN_LEFT;
            HSSFFont font = workbook.CreateFont();
            font.FontHeight = 20 * 20;
            style.SetFont(font);
            cell.CellStyle = style;
            //merged cells on single row
            sheet.AddMergedRegion(new Region(0, 0, 0, 5));



            HSSFRow row2 = sheet.CreateRow(1);

            HSSFCell cell1 = row2.CreateCell(0);
            HSSFCellStyle style1 = workbook.CreateCellStyle();


            style1.Alignment = HSSFCellStyle.ALIGN_LEFT;

            HSSFFont font1 = workbook.CreateFont();
            font1.FontHeight = 15 * 15;
            style1.SetFont(font);
            cell1.CellStyle = style1;
            cell1.SetCellValue("Run date: " + DateTime.Now);

            //Create a header row

            var headerRow = sheet.CreateRow(2);


            //Set the column names in the header row
            headerRow.CreateCell(0).SetCellValue("Document Type");
            headerRow.CreateCell(1).SetCellValue("Document Description");
            headerRow.CreateCell(2).SetCellValue("ACN/ICN/DCN");
            headerRow.CreateCell(3).SetCellValue("First name");
            headerRow.CreateCell(4).SetCellValue("Last name");
            headerRow.CreateCell(5).SetCellValue("Sent on");
            headerRow.CreateCell(6).SetCellValue("Downloaded");
            headerRow.CreateCell(7).SetCellValue("Cost");
            //(Optional) freeze the header row so it is not scrolled

            sheet.CreateFreezePane(0, 1, 0, 1);

            int rowNumber = 3;


            //Populate the sheet with values from the grid data

            foreach (RISARC.Documents.Model.Document order in orders)
            {

                //Create a new row

                var row = sheet.CreateRow(rowNumber++);



                //Set values for the cells

                row.CreateCell(0).SetCellValue(order.DocumentTypeName);

                row.CreateCell(1).SetCellValue(order.DocumentDescription);

                row.CreateCell(2).SetCellValue(order.ACNGrid);
                row.CreateCell(3).SetCellValue(order.PatientFirstname);
                row.CreateCell(4).SetCellValue(order.PatientLastname);
                row.CreateCell(5).SetCellValue(order.CreateDate);
                row.CreateCell(6).SetCellValue(order.ActionTime.ToString());
                row.CreateCell(7).SetCellValue(order.Cost);

            }



            //Write the workbook to a memory stream

            MemoryStream output = new MemoryStream();

            workbook.Write(output);



            //Return the result to the end user



            return File(output.ToArray(),   //The binary data of the XLS file

                "application/vnd.ms-excel", //MIME type of Excel files

                "GridExcelExport.xls");     //Suggested file name in the "Save as" dialog which will be displayed to the end user

        }
        public ActionResult ExportToPdf(int page, string groupBy, string orderBy, string filter, DateTime? startDate,
        DateTime? endDate, int pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        {
            //Get the data representing the current grid state - page, sort and filter

            ICollection<DocumentStatus> statuses;

            statuses = new Collection<DocumentStatus>{
                   DocumentStatus.ReadyForDownload,
                DocumentStatus.Expired
            };
            IEnumerable<RISARC.Documents.Model.Document> documents;
            int numberOfPages;


            if (pageNumber == 0)
                pageNumber = 1; // hack - set to 1 by default
            //documents = _RetrievalService.GetUsersInboundDocuments(statuses,startDate,endDate,pageNumber,out 2,acn,patientFName,patientLName,accountNo);
            documents = _RetrievalService.GetUsersInboundDocuments(statuses, startDate, endDate, pageNumber, out numberOfPages, acn, patientFName, patientLName, accountNo);

            GridModel model = documents.AsQueryable().ToGridModel(page, 10, orderBy, string.Empty, filter);


            //var orders = model.Data.Cast<RISARC.Documents.Model.Document>();



            //dynamic customers = _repository.FindAllCustomers();
            //customers = customers.ToGridModel(page, 10, groupBy, orderBy, filter).Data;

            // step 1: creation of a document-object 
            iTextSharp.text.Document document = new iTextSharp.text.Document(PageSize.A4.Rotate(), 10, 10, 10, 10);

            //step 2: we create a memory stream that listens to the document
            MemoryStream output = new MemoryStream();
            iTextSharp.text.pdf.PdfWriter.GetInstance(document, output);


            //step 3: we open the document
            document.Open();

            //step 4: we add content to the document
            int numOfColumns = 11;
            iTextSharp.text.pdf.PdfPTable dataTable = default(iTextSharp.text.pdf.PdfPTable);
            dataTable = new iTextSharp.text.pdf.PdfPTable(numOfColumns);

            dataTable.DefaultCell.Padding = 1;

            // This will set the header width

            //     int[] headerwidths = {9, 4, 8, 10, 8, 11, 9, 7, 9, 10, 4, 10}; // percentage
            //datatable.setWidths(headerwidths);
            //datatable.setWidthPercentage(100); // percentage
            //Dim headerwidths() As Single = {9, 4, 8, 10, 11, 12, 13, 14}
            //'dataTable.SetWidths(headerwidths)
            //dataTable.SetWidthPercentage(headerwidths, PageSize.A4.Rotate)


            dataTable.DefaultCell.BorderWidth = 2;
            dataTable.DefaultCell.HorizontalAlignment = Element.ALIGN_CENTER;

            // Adding headers
            dataTable.AddCell("Document Type");
            dataTable.AddCell("Document Description");
            dataTable.AddCell("ACN Number");
            dataTable.AddCell("Sent By (Provider)");
            dataTable.AddCell("First Name");
            dataTable.AddCell("Last Name");
            dataTable.AddCell("Sent On");
            dataTable.AddCell("Downloaded");
            dataTable.AddCell("Cost");
            dataTable.AddCell("Billing method");
            dataTable.AddCell("Status");

            //dataTable.AddCell("City");
            //dataTable.AddCell("Phone");
            //dataTable.AddCell("Postal Code");
            //dataTable.AddCell("Region");
            dataTable.HeaderRows = 1;
            dataTable.DefaultCell.BorderWidth = 1;

            foreach (RISARC.Documents.Model.Document order in documents)
            {

                dataTable.AddCell(order.DocumentTypeName);
                dataTable.AddCell(order.DocumentDescription);
                dataTable.AddCell(order.ACNGrid);
                dataTable.AddCell(order.SentFromProviderName);
                dataTable.AddCell(order.PatientFirstname);
                dataTable.AddCell(order.PatientLastname);
                dataTable.AddCell(order.CreateDate.ToString());
                dataTable.AddCell(order.ActionTime.ToString());
                dataTable.AddCell(order.Cost.ToString());
                dataTable.AddCell(order.BillingMethod.ToString());
                dataTable.AddCell(order.DocumentStatus.ToString());
                //dataTable.AddCell(order.Comments);
                //dataTable.AddCell(order.Comments);
                //dataTable.AddCell(order.Comments);
            }

            // Add table to the document
            document.Add(dataTable);

            // This is important don't forget to close the document
            document.Close();

            //Return File(output, "mulitipart/form-data", "CustomerData.pdf")
            // this is something different, we used output.toarray(), because document is closed; you can't directly access the stream, though when you use toarray you can.. strange !!
            return File(output.ToArray(), "application/pdf", "CustomerData.pdf");

        }
        //2
        public ActionResult ExportToPdfReceivedDocuments(int page, string groupBy, string orderBy, string filter, DateTime? startDate,
        DateTime? endDate, int pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        {
            //Get the data representing the current grid state - page, sort and filter

            ICollection<DocumentStatus> statuses;

            statuses = new Collection<DocumentStatus>{
             DocumentStatus.AwaitingVerification,
                DocumentStatus.LockedOutFromAttemptedVerifications,
                DocumentStatus.ReadyForCompliance,
                DocumentStatus.ReadyForPurchase,
                //DocumentStatus.ReadyForDownload,
                DocumentStatus.AwaitingComplianceApproval
            };
            IEnumerable<RISARC.Documents.Model.Document> documents;
            int numberOfPages;


            if (pageNumber == 0)
                pageNumber = 1; // hack - set to 1 by default
            //documents = _RetrievalService.GetUsersInboundDocuments(statuses,startDate,endDate,pageNumber,out 2,acn,patientFName,patientLName,accountNo);
            documents = _RetrievalService.GetUsersInboundDocuments(statuses, startDate, endDate, pageNumber, out numberOfPages, acn, patientFName, patientLName, accountNo);

            GridModel model = documents.AsQueryable().ToGridModel(page, 10, orderBy, string.Empty, filter);


            //var orders = model.Data.Cast<RISARC.Documents.Model.Document>();



            //dynamic customers = _repository.FindAllCustomers();
            //customers = customers.ToGridModel(page, 10, groupBy, orderBy, filter).Data;

            // step 1: creation of a document-object 
            iTextSharp.text.Document document = new iTextSharp.text.Document(PageSize.A4.Rotate(), 10, 10, 10, 10);

            //step 2: we create a memory stream that listens to the document
            MemoryStream output = new MemoryStream();
            iTextSharp.text.pdf.PdfWriter.GetInstance(document, output);


            //step 3: we open the document
            document.Open();

            //step 4: we add content to the document
            int numOfColumns = 4;
            iTextSharp.text.pdf.PdfPTable dataTable = default(iTextSharp.text.pdf.PdfPTable);
            dataTable = new iTextSharp.text.pdf.PdfPTable(numOfColumns);

            dataTable.DefaultCell.Padding = 3;

            // This will set the header width

            //     int[] headerwidths = {9, 4, 8, 10, 8, 11, 9, 7, 9, 10, 4, 10}; // percentage
            //datatable.setWidths(headerwidths);
            //datatable.setWidthPercentage(100); // percentage
            //Dim headerwidths() As Single = {9, 4, 8, 10, 11, 12, 13, 14}
            //'dataTable.SetWidths(headerwidths)
            //dataTable.SetWidthPercentage(headerwidths, PageSize.A4.Rotate)


            dataTable.DefaultCell.BorderWidth = 2;
            dataTable.DefaultCell.HorizontalAlignment = Element.ALIGN_CENTER;

            // Adding headers
            dataTable.AddCell("Document Type");
            dataTable.AddCell("Document Description");
            dataTable.AddCell("ACN Number");
            dataTable.AddCell("Sent By (Provider)");
            //dataTable.AddCell("City");
            //dataTable.AddCell("Phone");
            //dataTable.AddCell("Postal Code");
            //dataTable.AddCell("Region");
            dataTable.HeaderRows = 1;
            dataTable.DefaultCell.BorderWidth = 1;

            foreach (RISARC.Documents.Model.Document order in documents)
            {

                dataTable.AddCell(order.DocumentTypeName);
                dataTable.AddCell(order.DocumentDescription);
                dataTable.AddCell(order.SentFromProviderName);
                dataTable.AddCell(order.SentFromProviderName);
                //dataTable.AddCell(order.Comments);
                //dataTable.AddCell(order.Comments);
                //dataTable.AddCell(order.Comments);
            }

            // Add table to the document
            document.Add(dataTable);

            // This is important don't forget to close the document
            document.Close();

            //Return File(output, "mulitipart/form-data", "CustomerData.pdf")
            // this is something different, we used output.toarray(), because document is closed; you can't directly access the stream, though when you use toarray you can.. strange !!
            return File(output.ToArray(), "application/pdf", "CustomerData.pdf");

        }
        public ActionResult ExportExcelRecievedDocuents(int page, string orderBy, string filter)
        {
            //Get the data representing the current grid state - page, sort and filter
            DateTime? startDate = null;
            DateTime? endDate = null;
            int pageNumber = 0;
            string acn = null;
            string patientFName = null;
            string patientLName = null;
            string accountNo = null;
            ICollection<DocumentStatus> statuses;

            statuses = new Collection<DocumentStatus>{
                 DocumentStatus.AwaitingVerification,
                DocumentStatus.LockedOutFromAttemptedVerifications,
                DocumentStatus.ReadyForCompliance,
                DocumentStatus.ReadyForPurchase,
                //DocumentStatus.ReadyForDownload,
                DocumentStatus.AwaitingComplianceApproval
            };
            IEnumerable<RISARC.Documents.Model.Document> documents;
            int numberOfPages;


            if (pageNumber == 0)
                pageNumber = 1; // hack - set to 1 by default
            //documents = _RetrievalService.GetUsersInboundDocuments(statuses,startDate,endDate,pageNumber,out 2,acn,patientFName,patientLName,accountNo);
            documents = _RetrievalService.GetUsersInboundDocuments(statuses, startDate, endDate, pageNumber, out numberOfPages, acn, patientFName, patientLName, accountNo);

            GridModel model = documents.AsQueryable().ToGridModel(page, 65000, orderBy, string.Empty, filter);



            var orders = model.Data.Cast<RISARC.Documents.Model.Document>();



            //Create new Excel workbook

            var workbook = new HSSFWorkbook();



            //Create new Excel sheet

            var sheet = workbook.CreateSheet();





            //(Optional) set the width of the columns

            sheet.SetColumnWidth(0, 10 * 256);

            sheet.SetColumnWidth(1, 50 * 256);

            sheet.SetColumnWidth(2, 50 * 256);

            sheet.SetColumnWidth(3, 50 * 256);

            HSSFRow row1 = sheet.CreateRow(0);
            HSSFCell cell = row1.CreateCell(0);

            cell.SetCellValue("Documents ready to download");
            HSSFCellStyle style = workbook.CreateCellStyle();
            style.Alignment = HSSFCellStyle.ALIGN_LEFT;
            HSSFFont font = workbook.CreateFont();
            font.FontHeight = 20 * 20;
            style.SetFont(font);
            cell.CellStyle = style;
            //merged cells on single row
            sheet.AddMergedRegion(new Region(0, 0, 0, 5));



            HSSFRow row2 = sheet.CreateRow(1);

            HSSFCell cell1 = row2.CreateCell(0);
            HSSFCellStyle style1 = workbook.CreateCellStyle();


            style1.Alignment = HSSFCellStyle.ALIGN_LEFT;

            HSSFFont font1 = workbook.CreateFont();
            font1.FontHeight = 15 * 15;
            style1.SetFont(font);
            cell1.CellStyle = style1;
            cell1.SetCellValue("Run date: " + DateTime.Now);

            //Create a header row

            var headerRow = sheet.CreateRow(2);


            //Set the column names in the header row
            headerRow.CreateCell(0).SetCellValue("Document Type");
            headerRow.CreateCell(1).SetCellValue("Document Description");
            headerRow.CreateCell(2).SetCellValue("Sent by");
            headerRow.CreateCell(3).SetCellValue("ACN/ICN/DCN");
            headerRow.CreateCell(4).SetCellValue("First name");
            headerRow.CreateCell(5).SetCellValue("Last name");
            headerRow.CreateCell(6).SetCellValue("Sent on");
            headerRow.CreateCell(7).SetCellValue("Downloaded");
            headerRow.CreateCell(8).SetCellValue("Cost");
            //(Optional) freeze the header row so it is not scrolled

            sheet.CreateFreezePane(0, 1, 0, 1);

            int rowNumber = 3;

            //Document Type
            //Document Description
            //Sent By
            //First Name
            //Last Name
            //Sent On
            //Downloaded
            //Cost
            //Billing Method
            //Status


            //Populate the sheet with values from the grid data

            foreach (RISARC.Documents.Model.Document order in orders)
            {

                //Create a new row

                var row = sheet.CreateRow(rowNumber++);



                //Set values for the cells

                row.CreateCell(0).SetCellValue(order.DocumentTypeName);

                row.CreateCell(1).SetCellValue(order.DocumentDescription);

                row.CreateCell(2).SetCellValue(order.ACNGrid);
                row.CreateCell(3).SetCellValue(order.PatientFirstname);
                row.CreateCell(4).SetCellValue(order.PatientLastname);
                row.CreateCell(5).SetCellValue(order.CreateDate);
                row.CreateCell(6).SetCellValue(order.ActionTime.ToString());
                row.CreateCell(7).SetCellValue(order.Cost);

            }



            //Write the workbook to a memory stream

            MemoryStream output = new MemoryStream();

            workbook.Write(output);



            //Return the result to the end user



            return File(output.ToArray(),   //The binary data of the XLS file

                "application/vnd.ms-excel", //MIME type of Excel files

                "GridExcelExport.xls");     //Suggested file name in the "Save as" dialog which will be displayed to the end user

        }
        //3
        public ActionResult ExportExcelSentDocuments(int page, string orderBy, string filter)
        {
            //Get the data representing the current grid state - page, sort and filter
            DateTime? startDate = null;
            DateTime? endDate = null;
            int pageNumber = 0;
            string acn = null;
            string patientFName = null;
            string patientLName = null;
            string accountNo = null;
            ICollection<DocumentStatus> statuses;

            statuses = DocumentStatusUtilities.AllStatuses;
            IEnumerable<RISARC.Documents.Model.Document> documents;
            int numberOfPages;


            if (pageNumber == 0)
                pageNumber = 1; // hack - set to 1 by default
            //documents = _RetrievalService.GetUsersInboundDocuments(statuses,startDate,endDate,pageNumber,out 2,acn,patientFName,patientLName,accountNo);
            documents = _RetrievalService.GetUsersOutboundDocuments(statuses, startDate, endDate, pageNumber, out numberOfPages, acn, patientFName, patientLName, accountNo);

            GridModel model = documents.AsQueryable().ToGridModel(page, 65000, orderBy, string.Empty, filter);



            var orders = model.Data.Cast<RISARC.Documents.Model.Document>();



            //Create new Excel workbook

            var workbook = new HSSFWorkbook();



            //Create new Excel sheet

            var sheet = workbook.CreateSheet();





            //(Optional) set the width of the columns

            sheet.SetColumnWidth(0, 10 * 256);

            sheet.SetColumnWidth(1, 50 * 256);

            sheet.SetColumnWidth(2, 50 * 256);

            sheet.SetColumnWidth(3, 50 * 256);

            HSSFRow row1 = sheet.CreateRow(0);
            HSSFCell cell = row1.CreateCell(0);

            cell.SetCellValue("Documents ready to download");
            HSSFCellStyle style = workbook.CreateCellStyle();
            style.Alignment = HSSFCellStyle.ALIGN_LEFT;
            HSSFFont font = workbook.CreateFont();
            font.FontHeight = 20 * 20;
            style.SetFont(font);
            cell.CellStyle = style;
            //merged cells on single row
            sheet.AddMergedRegion(new Region(0, 0, 0, 5));



            HSSFRow row2 = sheet.CreateRow(1);

            HSSFCell cell1 = row2.CreateCell(0);
            HSSFCellStyle style1 = workbook.CreateCellStyle();


            style1.Alignment = HSSFCellStyle.ALIGN_LEFT;

            HSSFFont font1 = workbook.CreateFont();
            font1.FontHeight = 15 * 15;
            style1.SetFont(font);
            cell1.CellStyle = style1;
            cell1.SetCellValue("Run date: " + DateTime.Now);

            //Create a header row

            var headerRow = sheet.CreateRow(2);


            //Set the column names in the header row
            headerRow.CreateCell(0).SetCellValue("Document Type");
            headerRow.CreateCell(1).SetCellValue("Document Description");
            headerRow.CreateCell(2).SetCellValue("ACN/ICN/DCN");
            headerRow.CreateCell(3).SetCellValue("First name");
            headerRow.CreateCell(4).SetCellValue("Last name");
            headerRow.CreateCell(5).SetCellValue("Sent on");
            headerRow.CreateCell(6).SetCellValue("Downloaded");
            headerRow.CreateCell(7).SetCellValue("Cost");
            headerRow.CreateCell(8).SetCellValue("Billing Method");
            headerRow.CreateCell(9).SetCellValue("Status");
            //(Optional) freeze the header row so it is not scrolled



            //            Document Type
            //Document Description
            //CAN/DCN/ICN
            //Sent By
            //First Name
            //Last Name
            //Sent on
            //Sent ot
            //Downloaded
            //cost
            //billing method
            //status

            sheet.CreateFreezePane(0, 1, 0, 1);

            int rowNumber = 3;


            //Populate the sheet with values from the grid data

            foreach (RISARC.Documents.Model.Document order in orders)
            {

                //Create a new row

                var row = sheet.CreateRow(rowNumber++);
                //Set values for the cells
                row.CreateCell(0).SetCellValue(order.DocumentTypeName);
                row.CreateCell(1).SetCellValue(order.DocumentDescription);
                row.CreateCell(2).SetCellValue(order.ACNGrid);
                row.CreateCell(3).SetCellValue(order.PatientFirstname);
                row.CreateCell(4).SetCellValue(order.PatientLastname);
                row.CreateCell(5).SetCellValue(order.CreateDate);
                row.CreateCell(6).SetCellValue(order.ActionTime.ToString());
                row.CreateCell(7).SetCellValue(order.Cost);
                row.CreateCell(8).SetCellValue(order.BillingMethod.ToString());
                row.CreateCell(9).SetCellValue(order.DocumentStatus.ToString());
            }

            //Write the workbook to a memory stream

            MemoryStream output = new MemoryStream();

            workbook.Write(output);



            //Return the result to the end user



            return File(output.ToArray(),   //The binary data of the XLS file

                "application/vnd.ms-excel", //MIME type of Excel files

                "GridExcelExport.xls");     //Suggested file name in the "Save as" dialog which will be displayed to the end user

        }
        public ActionResult ExportToPdfSentDocuments(int page, string groupBy, string orderBy, string filter, DateTime? startDate,
        DateTime? endDate, int pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        {
            //Get the data representing the current grid state - page, sort and filter

            ICollection<DocumentStatus> statuses;

            statuses = DocumentStatusUtilities.AllStatuses;
            IEnumerable<RISARC.Documents.Model.Document> documents;
            int numberOfPages;


            if (pageNumber == 0)
                pageNumber = 1; // hack - set to 1 by default
            //documents = _RetrievalService.GetUsersInboundDocuments(statuses,startDate,endDate,pageNumber,out 2,acn,patientFName,patientLName,accountNo);
            documents = _RetrievalService.GetUsersOutboundDocuments(statuses, startDate, endDate, pageNumber, out numberOfPages, acn, patientFName, patientLName, accountNo);

            GridModel model = documents.AsQueryable().ToGridModel(page, 10, orderBy, string.Empty, filter);


            //var orders = model.Data.Cast<RISARC.Documents.Model.Document>();



            //dynamic customers = _repository.FindAllCustomers();
            //customers = customers.ToGridModel(page, 10, groupBy, orderBy, filter).Data;

            // step 1: creation of a document-object 
            iTextSharp.text.Document document = new iTextSharp.text.Document(PageSize.A4.Rotate(), 10, 10, 10, 10);

            //step 2: we create a memory stream that listens to the document
            MemoryStream output = new MemoryStream();
            iTextSharp.text.pdf.PdfWriter.GetInstance(document, output);


            //step 3: we open the document
            document.Open();

            //step 4: we add content to the document
            int numOfColumns = 4;
            iTextSharp.text.pdf.PdfPTable dataTable = default(iTextSharp.text.pdf.PdfPTable);
            dataTable = new iTextSharp.text.pdf.PdfPTable(numOfColumns);

            dataTable.DefaultCell.Padding = 3;

            // This will set the header width

            //     int[] headerwidths = {9, 4, 8, 10, 8, 11, 9, 7, 9, 10, 4, 10}; // percentage
            //datatable.setWidths(headerwidths);
            //datatable.setWidthPercentage(100); // percentage
            //Dim headerwidths() As Single = {9, 4, 8, 10, 11, 12, 13, 14}
            //'dataTable.SetWidths(headerwidths)
            //dataTable.SetWidthPercentage(headerwidths, PageSize.A4.Rotate)


            dataTable.DefaultCell.BorderWidth = 2;
            dataTable.DefaultCell.HorizontalAlignment = Element.ALIGN_CENTER;

            // Adding headers
            dataTable.AddCell("Document Type");
            dataTable.AddCell("Document Description");
            dataTable.AddCell("ACN Number");
            dataTable.AddCell("Sent By (Provider)");
            //dataTable.AddCell("City");
            //dataTable.AddCell("Phone");
            //dataTable.AddCell("Postal Code");
            //dataTable.AddCell("Region");
            dataTable.HeaderRows = 1;
            dataTable.DefaultCell.BorderWidth = 1;

            foreach (RISARC.Documents.Model.Document order in documents)
            {

                dataTable.AddCell(order.DocumentTypeName);
                dataTable.AddCell(order.DocumentDescription);
                dataTable.AddCell(order.SentFromProviderName);
                dataTable.AddCell(order.SentFromProviderName);
                //dataTable.AddCell(order.Comments);
                //dataTable.AddCell(order.Comments);
                //dataTable.AddCell(order.Comments);
            }

            // Add table to the document
            document.Add(dataTable);

            // This is important don't forget to close the document
            document.Close();

            //Return File(output, "mulitipart/form-data", "CustomerData.pdf")
            // this is something different, we used output.toarray(), because document is closed; you can't directly access the stream, though when you use toarray you can.. strange !!
            return File(output.ToArray(), "application/pdf", "CustomerData.pdf");

        }
        //4 outstanding requests
        public ActionResult ExportExcelOutstandingRequests(int page, string orderBy, string filter)
        {
            //Get the data representing the current grid state - page, sort and filter
            DateTime? startDate = null;
            DateTime? endDate = null;
            int pageNumber = 0;
            string acn = null;
            string patientFName = null;
            string patientLName = null;
            string accountNo = null;
            ICollection<DocumentStatus> statuses;
            statuses = new Collection<DocumentStatus>
            {
                  DocumentStatus.RequestAwaitingDocument,
                DocumentStatus.AwaitingComplianceApproval
                //DocumentStatus.RequestRespondedTo,
                //DocumentStatus.RequestAwaitingDocument,
             };
            IEnumerable<DocumentRequest> requests;

            int numberOfPages;


            if (pageNumber == 0)
                pageNumber = 1; // hack - set to 1 by default


            if (pageNumber == 0)
                pageNumber = 1; // hack - set to 1 by default
            //documents = _RetrievalService.GetUsersInboundDocuments(statuses,startDate,endDate,pageNumber,out 2,acn,patientFName,patientLName,accountNo);
            requests = _RetrievalService.GetUsersInboundRequests(statuses, startDate, endDate, pageNumber, out numberOfPages, acn, patientFName, patientLName, accountNo);

            GridModel model = requests.AsQueryable().ToGridModel(page, 65000, orderBy, string.Empty, filter);



            var orders = model.Data.Cast<DocumentRequest>();



            //Create new Excel workbook

            var workbook = new HSSFWorkbook();



            //Create new Excel sheet

            var sheet = workbook.CreateSheet();





            //(Optional) set the width of the columns

            sheet.SetColumnWidth(0, 10 * 256);

            sheet.SetColumnWidth(1, 50 * 256);

            sheet.SetColumnWidth(2, 50 * 256);

            sheet.SetColumnWidth(3, 50 * 256);

            HSSFRow row1 = sheet.CreateRow(0);
            HSSFCell cell = row1.CreateCell(0);

            cell.SetCellValue("Outstanding requests");
            HSSFCellStyle style = workbook.CreateCellStyle();
            style.Alignment = HSSFCellStyle.ALIGN_LEFT;
            HSSFFont font = workbook.CreateFont();
            font.FontHeight = 20 * 20;
            style.SetFont(font);
            cell.CellStyle = style;
            //merged cells on single row
            sheet.AddMergedRegion(new Region(0, 0, 0, 5));



            HSSFRow row2 = sheet.CreateRow(1);

            HSSFCell cell1 = row2.CreateCell(0);
            HSSFCellStyle style1 = workbook.CreateCellStyle();


            style1.Alignment = HSSFCellStyle.ALIGN_LEFT;

            HSSFFont font1 = workbook.CreateFont();
            font1.FontHeight = 15 * 15;
            style1.SetFont(font);
            cell1.CellStyle = style1;
            cell1.SetCellValue("Run date: " + DateTime.Now);

            //Create a header row

            var headerRow = sheet.CreateRow(2);


            //Set the column names in the header row
            headerRow.CreateCell(0).SetCellValue("Request date");
            headerRow.CreateCell(1).SetCellValue("Response due by");
            headerRow.CreateCell(2).SetCellValue("Requested document type");
            headerRow.CreateCell(3).SetCellValue("Requested document description");
            headerRow.CreateCell(4).SetCellValue("First name");
            headerRow.CreateCell(5).SetCellValue("Last name");
            headerRow.CreateCell(6).SetCellValue("Status");
            //(Optional) freeze the header row so it is not scrolled


            //            Request Date
            //Response Due By
            //Request Document Type
            //Requested Document Descriptioin
            //Requested by
            //First Name
            //Last Name
            //Status


            sheet.CreateFreezePane(0, 1, 0, 1);

            int rowNumber = 3;


            //Populate the sheet with values from the grid data

            foreach (DocumentRequest order in orders)
            {

                //Create a new row

                var row = sheet.CreateRow(rowNumber++);
                //Set values for the cells
                row.CreateCell(0).SetCellValue(order.RequestDate);
                row.CreateCell(1).SetCellValue(order.RequestDueBy.ToString());
                row.CreateCell(2).SetCellValue(order.DocumentDescription);
                row.CreateCell(3).SetCellValue(order.CreatedByUserDescription.Email);
                row.CreateCell(4).SetCellValue(order.PatientFirstName);
                row.CreateCell(5).SetCellValue(order.PatientLastName);
                row.CreateCell(6).SetCellValue(order.DocumentStatus.ToString());

            }

            //Write the workbook to a memory stream

            MemoryStream output = new MemoryStream();

            workbook.Write(output);



            //Return the result to the end user



            return File(output.ToArray(),   //The binary data of the XLS file

                "application/vnd.ms-excel", //MIME type of Excel files

                "GridExcelExport.xls");     //Suggested file name in the "Save as" dialog which will be displayed to the end user

        }
        //5 Requeests Responded to
        public ActionResult ExportExcelRequestsRespondedTo(int page, string orderBy, string filter)
        {
            //Get the data representing the current grid state - page, sort and filter
            DateTime? startDate = null;
            DateTime? endDate = null;
            int pageNumber = 0;
            string acn = null;
            string patientFName = null;
            string patientLName = null;
            string accountNo = null;
            ICollection<DocumentStatus> statuses;
            statuses = new Collection<DocumentStatus>
            {
                DocumentStatus.RequestRespondedTo,
                DocumentStatus.Cancelled,
                DocumentStatus.ComplianceRejected
            };
            IEnumerable<DocumentRequest> requests;

            int numberOfPages;


            if (pageNumber == 0)
                pageNumber = 1; // hack - set to 1 by default


            if (pageNumber == 0)
                pageNumber = 1; // hack - set to 1 by default
            //documents = _RetrievalService.GetUsersInboundDocuments(statuses,startDate,endDate,pageNumber,out 2,acn,patientFName,patientLName,accountNo);
            requests = _RetrievalService.GetUsersInboundRequests(statuses, startDate, endDate, pageNumber, out numberOfPages, acn, patientFName, patientLName, accountNo);

            GridModel model = requests.AsQueryable().ToGridModel(page, 65000, orderBy, string.Empty, filter);



            var orders = model.Data.Cast<DocumentRequest>();



            //Create new Excel workbook

            var workbook = new HSSFWorkbook();



            //Create new Excel sheet

            var sheet = workbook.CreateSheet();





            //(Optional) set the width of the columns

            sheet.SetColumnWidth(0, 10 * 256);

            sheet.SetColumnWidth(1, 50 * 256);

            sheet.SetColumnWidth(2, 50 * 256);

            sheet.SetColumnWidth(3, 50 * 256);

            HSSFRow row1 = sheet.CreateRow(0);
            HSSFCell cell = row1.CreateCell(0);

            cell.SetCellValue("Outstanding requests");
            HSSFCellStyle style = workbook.CreateCellStyle();
            style.Alignment = HSSFCellStyle.ALIGN_LEFT;
            HSSFFont font = workbook.CreateFont();
            font.FontHeight = 20 * 20;
            style.SetFont(font);
            cell.CellStyle = style;
            //merged cells on single row
            sheet.AddMergedRegion(new Region(0, 0, 0, 5));



            HSSFRow row2 = sheet.CreateRow(1);

            HSSFCell cell1 = row2.CreateCell(0);
            HSSFCellStyle style1 = workbook.CreateCellStyle();


            style1.Alignment = HSSFCellStyle.ALIGN_LEFT;

            HSSFFont font1 = workbook.CreateFont();
            font1.FontHeight = 15 * 15;
            style1.SetFont(font);
            cell1.CellStyle = style1;
            cell1.SetCellValue("Run date: " + DateTime.Now);

            //Create a header row

            var headerRow = sheet.CreateRow(2);


            //Set the column names in the header row
            headerRow.CreateCell(0).SetCellValue("Request date");
            headerRow.CreateCell(1).SetCellValue("Response due by");
            headerRow.CreateCell(2).SetCellValue("Requested document type");
            headerRow.CreateCell(3).SetCellValue("Requested document description");
            headerRow.CreateCell(4).SetCellValue("First name");
            headerRow.CreateCell(5).SetCellValue("Last name");
            headerRow.CreateCell(6).SetCellValue("Status");
            //(Optional) freeze the header row so it is not scrolled


            //            Request Date
            //Response Due By
            //Request Document Type
            //Requested Document Descriptioin
            //Requested by
            //First Name
            //Last Name
            //Status


            sheet.CreateFreezePane(0, 1, 0, 1);

            int rowNumber = 3;


            //Populate the sheet with values from the grid data

            foreach (DocumentRequest order in orders)
            {

                //Create a new row

                var row = sheet.CreateRow(rowNumber++);
                //Set values for the cells
                row.CreateCell(0).SetCellValue(order.RequestDate);
                row.CreateCell(1).SetCellValue(order.RequestDueBy.ToString());
                row.CreateCell(2).SetCellValue(order.DocumentDescription);
                row.CreateCell(3).SetCellValue(order.CreatedByUserDescription.Email);
                row.CreateCell(4).SetCellValue(order.PatientFirstName);
                row.CreateCell(5).SetCellValue(order.PatientLastName);
                row.CreateCell(6).SetCellValue(order.DocumentStatus.ToString());

            }

            //Write the workbook to a memory stream

            MemoryStream output = new MemoryStream();

            workbook.Write(output);



            //Return the result to the end user



            return File(output.ToArray(),   //The binary data of the XLS file

                "application/vnd.ms-excel", //MIME type of Excel files

                "GridExcelExport.xls");     //Suggested file name in the "Save as" dialog which will be displayed to the end user

        }
        //6 Sent Requests
        //Commented By Abhi for ExportToExcel  (Method name was same as new method) 29-Oct-2014
        //public ActionResult ExportExcelSentRequests(int page, string orderBy, string filter)
        //{
        //    //Get the data representing the current grid state - page, sort and filter
        //    DateTime? startDate = null;
        //    DateTime? endDate = null;
        //    int pageNumber = 0;
        //    string acn = null;
        //    string patientFName = null;
        //    string patientLName = null;
        //    string accountNo = null;
        //    ICollection<DocumentStatus> statuses;
        //    statuses = new Collection<DocumentStatus>
        //    {
        //        DocumentStatus.RequestRespondedTo,
        //        DocumentStatus.Cancelled,
        //        DocumentStatus.ComplianceRejected,
        //        DocumentStatus.AwaitingComplianceApproval,
        //        DocumentStatus.RequestAwaitingDocument,
        //        //DocumentStatus.RequestRespondedTo,
        //        //DocumentStatus.RequestAwaitingDocument,
        //     };
        //    IEnumerable<DocumentRequest> requests;

        //    int numberOfPages;


        //    if (pageNumber == 0)
        //        pageNumber = 1; // hack - set to 1 by default


        //    if (pageNumber == 0)
        //        pageNumber = 1; // hack - set to 1 by default
        //    //documents = _RetrievalService.GetUsersInboundDocuments(statuses,startDate,endDate,pageNumber,out 2,acn,patientFName,patientLName,accountNo);
        //    requests = _RetrievalService.GetUsersInboundRequestsSent(statuses, startDate, endDate, pageNumber, out numberOfPages, acn, patientFName, patientLName, accountNo);

        //    GridModel model = requests.AsQueryable().ToGridModel(page, 65000, orderBy, string.Empty, filter);



        //    var orders = model.Data.Cast<DocumentRequest>();



        //    //Create new Excel workbook

        //    var workbook = new HSSFWorkbook();



        //    //Create new Excel sheet

        //    var sheet = workbook.CreateSheet();





        //    //(Optional) set the width of the columns

        //    sheet.SetColumnWidth(0, 10 * 256);

        //    sheet.SetColumnWidth(1, 50 * 256);

        //    sheet.SetColumnWidth(2, 50 * 256);

        //    sheet.SetColumnWidth(3, 50 * 256);

        //    HSSFRow row1 = sheet.CreateRow(0);
        //    HSSFCell cell = row1.CreateCell(0);

        //    cell.SetCellValue("Outstanding requests");
        //    HSSFCellStyle style = workbook.CreateCellStyle();
        //    style.Alignment = HSSFCellStyle.ALIGN_LEFT;
        //    HSSFFont font = workbook.CreateFont();
        //    font.FontHeight = 20 * 20;
        //    style.SetFont(font);
        //    cell.CellStyle = style;
        //    //merged cells on single row
        //    sheet.AddMergedRegion(new Region(0, 0, 0, 5));



        //    HSSFRow row2 = sheet.CreateRow(1);

        //    HSSFCell cell1 = row2.CreateCell(0);
        //    HSSFCellStyle style1 = workbook.CreateCellStyle();


        //    style1.Alignment = HSSFCellStyle.ALIGN_LEFT;

        //    HSSFFont font1 = workbook.CreateFont();
        //    font1.FontHeight = 15 * 15;
        //    style1.SetFont(font);
        //    cell1.CellStyle = style1;
        //    cell1.SetCellValue("Run date: " + DateTime.Now);

        //    //Create a header row

        //    var headerRow = sheet.CreateRow(2);


        //    //Set the column names in the header row
        //    headerRow.CreateCell(0).SetCellValue("Sent date");
        //    headerRow.CreateCell(1).SetCellValue("Response due by");
        //    headerRow.CreateCell(2).SetCellValue("Requested document type");
        //    headerRow.CreateCell(3).SetCellValue("Requested document description");
        //    headerRow.CreateCell(4).SetCellValue("First name");
        //    headerRow.CreateCell(5).SetCellValue("Last name");
        //    headerRow.CreateCell(6).SetCellValue("Status");
        //    //(Optional) freeze the header row so it is not scrolled


        //    //            Request Date
        //    //Response Due By
        //    //Request Document Type
        //    //Requested Document Descriptioin
        //    //Requested by
        //    //First Name
        //    //Last Name
        //    //Status


        //    sheet.CreateFreezePane(0, 1, 0, 1);

        //    int rowNumber = 3;


        //    //Populate the sheet with values from the grid data

        //    foreach (DocumentRequest order in orders)
        //    {

        //        //Create a new row

        //        var row = sheet.CreateRow(rowNumber++);
        //        //Set values for the cells
        //        row.CreateCell(0).SetCellValue(order.RequestDate);
        //        row.CreateCell(1).SetCellValue(order.RequestDueBy.ToString());
        //        row.CreateCell(2).SetCellValue(order.DocumentDescription);
        //        row.CreateCell(3).SetCellValue(order.CreatedByUserDescription.Email);
        //        row.CreateCell(4).SetCellValue(order.PatientFirstName);
        //        row.CreateCell(5).SetCellValue(order.PatientLastName);
        //        row.CreateCell(6).SetCellValue(order.DocumentStatus.ToString());

        //    }

        //    //Write the workbook to a memory stream

        //    MemoryStream output = new MemoryStream();

        //    workbook.Write(output);



        //    //Return the result to the end user



        //    return File(output.ToArray(),   //The binary data of the XLS file

        //        "application/vnd.ms-excel", //MIME type of Excel files

        //        "GridExcelExport.xls");     //Suggested file name in the "Save as" dialog which will be displayed to the end user

        //}
        //7
        //8
        //9
    }



}
