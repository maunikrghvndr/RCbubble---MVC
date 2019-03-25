using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Ajax;
using SpiegelDg.Security.Model;
using RISARC.Documents.Model;
using RISARC.Emr.Web.DataTypes;
using RISARC.Common.Utilities;
using System.Collections.ObjectModel;
using RISARC.Documents.Service;
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
using RISARC.Common;
using RISARC.Common.Enumaration;
// For Devexpress export  
using DevExpress.Web.Mvc;
//using System.Collections.ObjectModel;
using DevExpress.Web.ASPxGridView;
using DevExpress.Data;
using DevExpress.XtraReports.UI;

using DevExpress.Utils;
using System.Web.UI;
using DevExpress.Web.ASPxClasses;
using System.Web.UI.WebControls;
using System.Security.Policy;

namespace RISARC.Web.EBubble.Controllers
{
    public class TransactionController : Controller 
    {

        // used for changing header when downloading a file
        private const string _FileHeaderKey = "content-disposition";
        private const string _FileHeaderFormat = "attachment; filename={0}";

        private IDocumentsRetrievalService _DocumentsRetrievalService;
        private IRMSeBubbleMempershipService _MembershipService;
        //private IDocumentsRetrievalRepository _
        private IProviderRepository _ProviderRepository;
        private ILoggingService _LoggingService;

        public TransactionController(IDocumentsRetrievalService documentsRetrievalRepository,
            IProviderRepository providerRepository,
            IRMSeBubbleMempershipService membershipService,
            ILoggingService loggingService)
        {
            this._DocumentsRetrievalService = documentsRetrievalRepository;
            this._MembershipService = membershipService;
            this._ProviderRepository = providerRepository;
            this._LoggingService = loggingService;
        }
        //public ActionResult ProviderReports()
        //{
        //    ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.ProviderReports);

        //    return View();
        //}
        //
        // GET: /Transaction/
        public void SearchFieldHACK(ref DateTime startDate,ref DateTime endDate,ref string acn, ref string patientFName,ref string patientLName,ref string accountNo)//, string ClearSearchFlag)
        {
             
            if ((startDate != null) || (endDate != null) || (acn != null) || (accountNo != null) || (patientFName != null) || (patientLName != null)) 
            {
                if (startDate != null) Session["startDate"] = startDate;
                if (endDate != null) Session["endDate"] = endDate;
                if (acn != null) Session["acn"] = acn;
                if (patientFName != null) Session["patientFName"] = patientFName;
                if (patientLName != null) Session["patientLName"] = patientLName;
                if (accountNo != null) Session["accountNo"] = accountNo;
            }
            else
            {
                if (Session["startDate"] != null) startDate = Convert.ToDateTime(Session["startDate"]);
                if (Session["endDate"] != null) endDate = Convert.ToDateTime(Session["endDate"]);
                if (Session["acn"] != null) acn = "" + Session["acn"];
                if (Session["patientFName"] != null) patientFName = "" + Session["patientFName"];
                if (Session["patientLName"] != null) patientLName = "" + Session["patientLName"];
                if (Session["accountNo"] != null) accountNo = "" + Session["accountNo"]; 
                //if (acn != null) acn = "" + Session["acn"];
            }
        }

        private void CLEARSearchFieldHACK(DateTime startDate, DateTime endDate,string acn, string patientFName,string patientLName, string accountNo)//, string ClearSearchFlag)
        {
            if ((startDate == null) && (endDate == null) && (acn == "") && (accountNo == "") && (patientFName == "") && (patientLName == ""))
            {
                Session["startDate"] = null;
                Session["endDate"] = null;
                Session["acn"] = null;
                Session["patientFName"] = null;
                Session["patientLName"] = null;
                Session["accountNo"] = null;
            }
        }

        [AuditingAuthorizeAttribute("ProvidersDocumentTransactionLog", Roles = "ProviderReportsViewer")]
        public ActionResult DocumentTransactionLog(DateTime? startDate, DateTime? endDate, int pageNumber, string acn, string patientFName, string patientLName, string accountNo)//, string ClearSearchFlag)
        {
            ModelState.Clear();
            //SearchFieldHACK(startDate, endDate, acn, patientFName, patientLName, accountNo);

            //if (startDate != null)
            //{
                //UrlHelper u = new UrlHelper(this.ControllerContext.RequestContext);
                //string url = u.Action("DocumentTransactionLog", "Transaction", null);
                //string link = HtmlHelper.GenerateLink(this.ControllerContext.RequestContext, System.Web.Routing.RouteTable.Routes, "My link", "Root", "About", "Home", null, null);

            //}


            //if (Session["startDate"] == null)
            //  HttpContext.Current.Session.Add("__MySessionObject", new MySessionObject());
            //if(startDate
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.DocumentTransactionLog);
           // if (acn == ''){acn=null}

            _DocumentsRetrievalService.SetupSearchFilters(ConstantManager.ActionMethodNames.DocumentTransactionLog, ref startDate, ref endDate, ref acn, ref patientFName, ref patientLName, ref accountNo);

            IEnumerable<RISARC.Documents.Model.Document> documents;

            documents = SelectDocsAndSetViewData(startDate, endDate, pageNumber, acn, patientFName, patientLName, accountNo);


            
            if (documents.Count() > 0)
            {
                
                ViewData["acn"] = acn;
                ViewData["accountNo"] = accountNo;
                ViewData["patientFName"] = patientFName;
                ViewData["patientLName"] = patientLName;
                ViewData["StartDate"] = startDate;
                ViewData["EndDate"] = endDate;
            }
            else
            {
                    Session["startDate"] = null;
                    Session["endDate"] = null;
                    Session["acn"] = null;
                    Session["patientFName"] = null;
                    Session["patientLName"] = null;
                    Session["accountNo"] = null;
                    ViewData["acn"] = null;
                    ViewData["accountNo"] = null;
                    ViewData["patientFName"] = null;
                    ViewData["patientLName"] = null;
                    ViewData["StartDate"] = null;
                    ViewData["EndDate"] = null;
            }

            //ViewData["startDate"] = startDate;// HttpContext.Session["startDate"];// startDate;
            return View(documents);
        }
        //Added By Abhi for  gvDocumentTransactionLog Callback
        public ActionResult _DocumentTransactionLog(DateTime? startDate, DateTime? endDate, int pageNumber, string acn, string patientFName, string patientLName, string accountNo)//, string ClearSearchFlag)
        {

            //_DocumentsRetrievalService.SetupSearchFilters(ConstantManager.ActionMethodNames.DocumentTransactionLog, ref startDate, ref endDate, ref acn, ref patientFName, ref patientLName, ref accountNo);
            IEnumerable<RISARC.Documents.Model.Document> documents;
            documents = SelectDocsAndSetViewData(startDate, endDate, pageNumber, acn, patientFName, patientLName, accountNo);

            if (documents.Count() > 0)
            {

                ViewData["acn"] = acn;
                ViewData["accountNo"] = accountNo;
                ViewData["patientFName"] = patientFName;
                ViewData["patientLName"] = patientLName;
                ViewData["StartDate"] = startDate;
                ViewData["EndDate"] = endDate;
            }
            else
            {
                Session["startDate"] = null;
                Session["endDate"] = null;
                Session["acn"] = null;
                Session["patientFName"] = null;
                Session["patientLName"] = null;
                Session["accountNo"] = null;
                ViewData["acn"] = null;
                ViewData["accountNo"] = null;
                ViewData["patientFName"] = null;
                ViewData["patientLName"] = null;
                ViewData["StartDate"] = null;
                ViewData["EndDate"] = null;
            }
            return PartialView("DocumentTransactionsTable", documents);
        }
        //End Added

        [AuditingAuthorizeAttribute("DocumentRACDecision", Roles = "ProviderReportsViewer")]
        public ActionResult DocumentRACDecision(DateTime? startDate, DateTime? endDate, int pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.DocumentRACDecision);

            IEnumerable<RISARC.Documents.Model.Document> documents;

            documents = SelectDocsAndSetViewData(startDate, endDate, pageNumber, acn, patientFName, patientLName, accountNo);

            return View(documents);
        }

        //Added By Abhi for  gvRacDecisionReport Callback
        public ActionResult _DocumentRACDecision(DateTime? startDate, DateTime? endDate, int pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        {
            IEnumerable<RISARC.Documents.Model.Document> documents;

            documents = SelectDocsAndSetViewData(startDate, endDate, pageNumber, acn, patientFName, patientLName, accountNo);

            return PartialView("DocumentRacDescTransactions", documents);
        }

        [AuditingAuthorizeAttribute("DocumentRACMoneyReport", Roles = "ProviderReportsViewer")]
        public ActionResult DocumentRACMoneyReport(DateTime? startDate, DateTime? endDate, int pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.DocumentRACMoneyReport);

            IEnumerable<RISARC.Documents.Model.Document> documents;

            documents = SelectDocsAndSetViewData(startDate, endDate, pageNumber, acn, patientFName, patientLName, accountNo);

            return View(documents);
        }
         /// <summary>
        /// Render $ RAC report view
        /// </summary>
        /// <param name="accountNumberId"></param>
        /// <param name="id"></param>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 10/06/2014 | surekha   | Created
        /// </RevisionHistory>
        public ActionResult _DocumentRACMoneyTransactions(DateTime? startDate, DateTime? endDate, int pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        {
            IEnumerable<RISARC.Documents.Model.Document> documents;
            documents = SelectDocsAndSetViewData(startDate, endDate, pageNumber, acn, patientFName, patientLName, accountNo);
            return PartialView("DocumentRacMoneyTransactions", documents);
        }


        /// <summary>
        /// Render $ RAC report view
        /// </summary>
        /// <param name="accountNumberId"></param>
        /// <param name="id"></param>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 10/06/2014 | surekha   | Created
        /// </RevisionHistory>
        //public ActionResult _DocumentRACMoneyTransactions(DateTime? startDate, DateTime? endDate, int pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        //{
        //    IEnumerable<RISARC.Documents.Model.Document> documents;
        //    documents = SelectDocsAndSetViewData(startDate, endDate, pageNumber, acn, patientFName, patientLName, accountNo);
        //    return PartialView("DocumentRacMoneyTransactions", documents);
        //}

        public RedirectResult ClearAllSearchCatch()//, string ClearSearchFlag)
        {

            _DocumentsRetrievalService.ClearSearchFilters();
            ViewData["acn"] = null;
            ViewData["accountNo"] = null;
            ViewData["patientFName"] = null;
            ViewData["patientLName"] = null;
            ViewData["StartDate"] = null;
            ViewData["EndDate"] = null;
            return Redirect("../" + Request.QueryString["CurrentPage"]);
            //return null;// RedirectToAction("SelectClasses", "Registration");
        }


        public ActionResult ExportProviderSentDocumentsReportForUser(DateTime? startDate, DateTime? endDate, ExportType exportType, string acn, string patientFName, string patientLName, string accountNo)
        {
            IEnumerable<RISARC.Documents.Model.Document> documents;
            string viewName;

            documents = SelectDocsAndSetViewDataForUser(startDate, endDate, null, acn, patientFName, patientLName, accountNo);

            if (exportType == ExportType.Printable)
            {
                ViewData.SetValue(GlobalViewDataKey.PageTitle, "Sent Documents Report");
                viewName = "DocumentsReportPrintable";
            }
            else
            {
                // if csv export, then change return method so that can save doc, and export it
                HttpContext.Response.AddHeader(_FileHeaderKey,
                String.Format(_FileHeaderFormat, _DocumentReportsFileName));

                viewName = "DocumentsReportCsv";
            }

            return View(viewName, documents);
        }


        private const string _DocumentReportsFileName = "ProviderSentDocs.csv";

        private IEnumerable<RISARC.Documents.Model.Document> SelectDocsAndSetViewDataForUser(DateTime? startDate, DateTime? endDate, int? pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        {
            IEnumerable<RISARC.Documents.Model.Document> documents;
            int? actualPageNumber;
            int numberOfPages;
            
            actualPageNumber = GetActualPageNumber(pageNumber);
            startDate = GetActualStartDate(startDate);
            documents = _DocumentsRetrievalService.GetUsersOutboundDocuments
                (DocumentStatusUtilities.AllStatuses,
                startDate, endDate, actualPageNumber, out numberOfPages, acn, patientFName, patientLName, accountNo);

            ViewData.SetValue(GlobalViewDataKey.NumberOfPages, numberOfPages);
            ViewData.SetValue(GlobalViewDataKey.PageNumber, actualPageNumber);
          
            return documents;
        }

        private IEnumerable<RISARC.Documents.Model.Document> SelectDocsAndSetViewData(DateTime? startDate, DateTime? endDate, int? pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        {
            IEnumerable<RISARC.Documents.Model.Document> documents;
            int? actualPageNumber;
            int numberOfPages;
            //if startsWith
            //acn = startsWith
            //ViewData["startsWith"] = startsWith ?? "";
            actualPageNumber = GetActualPageNumber(pageNumber);

            //startDate = GetActualStartDate(startDate);
            // Mikes Hack...Telerik is by passing the post
            //Request.QueryString[]
            //    Session["startDate"] = startDate;
            //    Session["endDate"] = endDate;
            //    Session["acn"] = acn;
            //    Session["patientFName"] = patientFName;
            //    Session["patientLName"] = patientLName;
            //    Session["accountNo"] = accountNo;
            //if (ClearSearch == false)
            //{
            //    Session["startDate"] = startDate;
            //    Session["endDate"] = endDate;
            //    Session["acn"] = acn;
            //    Session["patientFName"] = patientFName;
            //    Session["patientLName"] = patientLName;
            //    Session["accountNo"] = accountNo;
            //}
            //else
            //{
            //    startDate = Convert.ToDateTime(Session["startDate"]);
            //    endDate = Convert.ToDateTime(Session["endDate"]);
            //    acn = Session["acn"].ToString();
            //    patientFName = Session["patientFName"].ToString();
            //    patientLName = Session["patientLName"].ToString();
            //    accountNo = Session["accountNo"].ToString();
            //}


            // MIKE: Replaced to fix reporting, User with no ProviderAdmin Role can only see there own sent document reports

            if (User.IsInRole(ConstantManager.StoredProcedureConstants.ProviderAdminRoleAccess) == true)
            { // SEE EVERYONES SENT DOCS WITH HIS METHOD
                documents = _DocumentsRetrievalService.
                    GetProvidersOutboundDocuments(DocumentStatusUtilities.AllStatuses,
                    startDate, endDate, actualPageNumber, out numberOfPages, acn, patientFName, patientLName, accountNo);
            }
            else
            { // ONLY SEE YOUR DOCS THAT WHERE SENT WITH THIS METHOD
                documents = _DocumentsRetrievalService.
                    GetUsersOutboundDocuments(DocumentStatusUtilities.AllStatuses, 
                    startDate, endDate, actualPageNumber, out numberOfPages, acn, patientFName, patientLName, accountNo);
            }

            
            ViewData.SetValue(GlobalViewDataKey.NumberOfPages, numberOfPages);
            ViewData.SetValue(GlobalViewDataKey.PageNumber, actualPageNumber);
            //View(acn,acn.ToString()); remove
           // ViewData["StartDate"] = startDate;
           // ViewData["EndDate"] = endDate;

            return documents;
        }

        [AuditingAuthorizeAttribute("ProvidersDocumentRequestTransactionLog", Roles = "ProviderReportsViewer")]
        public ActionResult DocumentRequestTransactionLog(DateTime? startDate, DateTime? endDate, int pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.DocumentRequestTransactionLog);

            IEnumerable<DocumentRequest> documentRequests;
            int numberOfPages;
            int? actualPageNumber;

            actualPageNumber = GetActualPageNumber(pageNumber);

            documentRequests = _DocumentsRetrievalService.
                GetProvidersInboundRequests(DocumentStatusUtilities.AllStatuses,
                startDate, endDate, actualPageNumber, out numberOfPages, acn, patientFName, patientLName, accountNo);
            ViewData.SetValue(GlobalViewDataKey.NumberOfPages, numberOfPages);
            ViewData.SetValue(GlobalViewDataKey.PageNumber, actualPageNumber);
            // Add aditional fields

            ViewData["acn"] = acn;
            ViewData["accountNo"] = accountNo;
            ViewData["patientFName"] = patientFName;
            ViewData["patientLName"] = patientLName;
            ViewData["StartDate"] = startDate;
            ViewData["EndDate"] = endDate;

            ViewData["StartDate"] = startDate;
            ViewData["EndDate"] = endDate;
            return View("DocumentRequestTransactionLog", documentRequests);
        }

        //Added By Abhi for  gvDocumentRequestTransactionsTable Callback
        public ActionResult _DocumentRequestTransactionLog(DateTime? startDate, DateTime? endDate, int pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        {
            IEnumerable<DocumentRequest> documentRequests;
            int numberOfPages;
            int? actualPageNumber;

            actualPageNumber = GetActualPageNumber(pageNumber);

            documentRequests = _DocumentsRetrievalService.
                GetProvidersInboundRequests(DocumentStatusUtilities.AllStatuses,
                startDate, endDate, actualPageNumber, out numberOfPages, acn, patientFName, patientLName, accountNo);
            //ViewData.SetValue(GlobalViewDataKey.NumberOfPages, numberOfPages);
            //ViewData.SetValue(GlobalViewDataKey.PageNumber, actualPageNumber);
            //// Add aditional fields

            //ViewData["acn"] = acn;
            //ViewData["accountNo"] = accountNo;
            //ViewData["patientFName"] = patientFName;
            //ViewData["patientLName"] = patientLName;
            //ViewData["StartDate"] = startDate;
            //ViewData["EndDate"] = endDate;

            //ViewData["StartDate"] = startDate;
            //ViewData["EndDate"] = endDate;
            return PartialView("DocumentRequestTransactionsTable", documentRequests);
            
        }

        ////Added By Abhi for  gvDocumentRequestTransactionsTable Callback
        //public ActionResult _DocumentRequestTransactionLog(DateTime? startDate, DateTime? endDate, int pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        //{
        //    IEnumerable<DocumentRequest> documentRequests;
        //    int numberOfPages;
        //    int? actualPageNumber;

        //    actualPageNumber = GetActualPageNumber(pageNumber);

        //    documentRequests = _DocumentsRetrievalService.
        //        GetProvidersInboundRequests(DocumentStatusUtilities.AllStatuses,
        //        startDate, endDate, actualPageNumber, out numberOfPages, acn, patientFName, patientLName, accountNo);
        //    //ViewData.SetValue(GlobalViewDataKey.NumberOfPages, numberOfPages);
        //    //ViewData.SetValue(GlobalViewDataKey.PageNumber, actualPageNumber);
        //    //// Add aditional fields

        //    //ViewData["acn"] = acn;
        //    //ViewData["accountNo"] = accountNo;
        //    //ViewData["patientFName"] = patientFName;
        //    //ViewData["patientLName"] = patientLName;
        //    //ViewData["StartDate"] = startDate;
        //    //ViewData["EndDate"] = endDate;

        //    //ViewData["StartDate"] = startDate;
        //    //ViewData["EndDate"] = endDate;
        //    return PartialView("DocumentRequestTransactionsTable", documentRequests);
            
        //}





        [AuditingAuthorizeAttribute("ProvidersDocumentRequestTransactionLog", Roles = "ProviderReportsViewer")]
        public ActionResult SentRequests(DateTime? startDate, DateTime? endDate, int pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.SentRequests);

            IEnumerable<DocumentRequest> documentRequests;
            int numberOfPages;
            int? actualPageNumber;


            actualPageNumber = GetActualPageNumber(pageNumber);
            pageNumber = Convert.ToInt32(actualPageNumber);

            _DocumentsRetrievalService.SetupSearchFilters(ConstantManager.ActionMethodNames.SentRequests, ref startDate, ref endDate, ref acn, ref patientFName, ref patientLName, ref accountNo);

            documentRequests = _DocumentsRetrievalService.
                GetUsersInboundRequestsSentTest(DocumentStatusUtilities.AllStatuses,
                startDate, endDate, pageNumber, out numberOfPages, acn, patientFName, patientLName, accountNo);

            ViewData.SetValue(GlobalViewDataKey.NumberOfPages, numberOfPages);
            ViewData.SetValue(GlobalViewDataKey.PageNumber, actualPageNumber);
            ViewData.SetValue(GlobalViewDataKey.PageDesc, "Sent Requests Report");
            // Additional fields

            ViewData["acn"] = acn;
            ViewData["accountNo"] = accountNo;
            ViewData["patientFName"] = patientFName;
            ViewData["patientLName"] = patientLName;
            ViewData["StartDate"] = startDate;
            ViewData["EndDate"] = endDate;

            ViewData["StartDate"] = startDate;
            ViewData["EndDate"] = endDate;

            return View("ViewSentRequests", documentRequests);
        }
        //Added By Abhi for gvViewSentRequestsTransaction Callback
        public ActionResult _SentRequests(DateTime? startDate, DateTime? endDate, int pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.SentRequests);

            IEnumerable<DocumentRequest> documentRequests;
            int numberOfPages;
            int? actualPageNumber;


            actualPageNumber = GetActualPageNumber(pageNumber);
            pageNumber = Convert.ToInt32(actualPageNumber);

            _DocumentsRetrievalService.SetupSearchFilters(ConstantManager.ActionMethodNames.SentRequests, ref startDate, ref endDate, ref acn, ref patientFName, ref patientLName, ref accountNo);

            documentRequests = _DocumentsRetrievalService.
                GetUsersInboundRequestsSentTest(DocumentStatusUtilities.AllStatuses,
                startDate, endDate, pageNumber, out numberOfPages, acn, patientFName, patientLName, accountNo);

            ViewData.SetValue(GlobalViewDataKey.NumberOfPages, numberOfPages);
            ViewData.SetValue(GlobalViewDataKey.PageNumber, actualPageNumber);
            ViewData.SetValue(GlobalViewDataKey.PageDesc, "Sent Requests Report");
            // Additional fields

            ViewData["acn"] = acn;
            ViewData["accountNo"] = accountNo;
            ViewData["patientFName"] = patientFName;
            ViewData["patientLName"] = patientLName;
            ViewData["StartDate"] = startDate;
            ViewData["EndDate"] = endDate;

            ViewData["StartDate"] = startDate;
            ViewData["EndDate"] = endDate;

            return PartialView("_ViewSentRequests", documentRequests);
        }
        //End Added

        private IEnumerable<DocumentRequest> SelectReqsAndSetViewDataTest(DateTime? startDate, DateTime? endDate, int? pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        {
            IEnumerable<DocumentRequest> requests;
            int numberOfPages;

            int? actualPageNumber;

            actualPageNumber = GetActualPageNumber(pageNumber);


            requests = _DocumentsRetrievalService.
            GetUsersInboundRequestsSentTest(DocumentStatusUtilities.AllStatuses,
            startDate, endDate, Convert.ToInt32(GetActualPageNumber(pageNumber)), out numberOfPages, acn, patientFName, patientLName, accountNo);

            //GetProvidersInboundRequests(DocumentStatusUtilities.AllStatuses,
            //startDate, endDate, GetActualPageNumber(pageNumber), out numberOfPages);

            ViewData.SetValue(GlobalViewDataKey.NumberOfPages, numberOfPages);
            ViewData.SetValue(GlobalViewDataKey.PageNumber, pageNumber);
            // Add addition fields
            ViewData["StartDate"] = startDate;
            ViewData["EndDate"] = endDate;

            return requests;
        }






        private const string _ReceivedRequestsReportsFileName = "ProviderReceivedRequests.csv";
        [AuditingAuthorizeAttribute("ExportProviderSentDocumentsReport", Roles = "ProviderReportsViewer")]
        public ActionResult ExportProviderReceivedRequestsReport(DateTime? startDate, DateTime? endDate, ExportType exportType, string acn, string patientFName, string patientLName, string accountNo)
        {
            IEnumerable<DocumentRequest> requests;
            string viewName;

            requests = SelectReqsAndSetViewData(startDate, endDate, null, acn, patientFName, patientLName, accountNo);

            if (exportType == ExportType.Printable)
            {
                ViewData.SetValue(GlobalViewDataKey.PageTitle, "Received Requests Report");
                viewName = "RequestsReportPrintable";
            }
            else
            {
                // if csv export, then change return method so that can save doc, and export it
                HttpContext.Response.AddHeader(_FileHeaderKey,
                String.Format(_FileHeaderFormat, _ReceivedRequestsReportsFileName));

                viewName = "RequestsReportCsv";
            }

            return View(viewName, requests);
        }

        private const string _ReceivedRequestsReportsFileNametest = "ProviderReceivedRequeststest.csv";
        [AuditingAuthorizeAttribute("ExportProviderSentDocumentsReport", Roles = "ProviderReportsViewer")]
        public ActionResult ExportProviderSentDocumentsReporttest(DateTime? startDate, DateTime? endDate, ExportType exportType, string acn, string patientFName, string patientLName, string accountNo)
        {
            IEnumerable<DocumentRequest> requests;
            string viewName;

            requests = SelectReqsAndSetViewDataTest(startDate, endDate, 0, acn, patientFName, patientLName, accountNo);

            if (exportType == ExportType.Printable)
            {
                ViewData.SetValue(GlobalViewDataKey.PageTitle, "Sent Documents Report");
                viewName = "SentRequestsReportPrintable";
            }
            else
            {
                // if csv export, then change return method so that can save doc, and export it
                HttpContext.Response.AddHeader(_FileHeaderKey,
                String.Format(_FileHeaderFormat, _ReceivedRequestsReportsFileName));

                viewName = "SendRequestsReportCsv";
            }

            return View(viewName, requests);
        }





        private IEnumerable<DocumentRequest> SelectReqsAndSetViewData(DateTime? startDate, DateTime? endDate, int? pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        {
            IEnumerable<DocumentRequest> requests;
            int numberOfPages;

            requests = _DocumentsRetrievalService.
                GetProvidersInboundRequests(DocumentStatusUtilities.AllStatuses,
                startDate, endDate, GetActualPageNumber(pageNumber), out numberOfPages, acn, patientFName, patientLName, accountNo);

            ViewData.SetValue(GlobalViewDataKey.NumberOfPages, numberOfPages);
            ViewData.SetValue(GlobalViewDataKey.PageNumber, pageNumber);
            // Add additional fields
            ViewData["StartDate"] = startDate;
            ViewData["EndDate"] = endDate;

            return requests;
        }

         
        public ActionResult RacAppeals([ModelBinder(typeof(EncryptedIntegerBinder))] int documentId)
        {
            RISARC.Documents.Model.Document document;

            document = _DocumentsRetrievalService.GetDocument(documentId);
            if (document == null)
                throw new ArgumentException("No document exists with id " + documentId + ".", "documentId");

            ViewData["ProviderName"] = _ProviderRepository.GetProviderName(document.SentFromProviderId);

            return View(document);
        }


     



        [AuditingAuthorizeAttribute("DocumentTransaction", Roles = "User")]
        public ActionResult DocumentTransaction([ModelBinder(typeof(EncryptedIntegerBinder))] int documentId)
        {
            RISARC.Documents.Model.Document document;

            document = _DocumentsRetrievalService.GetDocument(documentId);
            if (document == null)
                throw new ArgumentException("No document exists with id " + documentId + ".", "documentId");

            ViewData["ProviderName"] = _ProviderRepository.GetProviderName(document.SentFromProviderId);

            return View(document);
        }

        [AuditingAuthorizeAttribute("DocumentRequestTransaction", Roles = "ProviderReportsViewer")]
        public ActionResult DocumentRequestTransaction([ModelBinder(typeof(EncryptedIntegerBinder))] int requestId)
        {
            DocumentRequest request;

            request = _DocumentsRetrievalService.GetDocumentRequest(requestId);
            if (request == null)
                throw new ArgumentException("No request exists with id " + requestId + ".", "request");

            ViewData["ProviderName"] = _ProviderRepository.GetProviderName(request.SentToProviderId);

            return View(request);
        }

        #region Partial Views

        [AcceptVerbs(HttpVerbs.Post)]
        [AuditingAuthorizeAttribute("DocumentTransaction", Roles = "DocumentAdmin")]
        [AuditingAuthorizeAttribute("DocumentTransactionPost", Roles = "User")]
        public ActionResult DocumentTransaction([ModelBinder(typeof(EncryptedIntegerBinder))] int documentId, string Dollar)
        {
            RISARC.Documents.Model.Document document;

            document = _DocumentsRetrievalService.GetDocument(documentId);

            ViewData["ProviderName"] = _ProviderRepository.GetProviderName(document.SentFromProviderId);
          

            return View(document);

        }




        [AuditingAuthorizeAttribute("DocumentTransaction", Roles = "DocumentAdmin")]
        public ActionResult DocumentActionLogHistory([ModelBinder(typeof(EncryptedIntegerBinder))] int documentId)
        {
            ICollection<ActionLogEntry> actionLogHistory;

            actionLogHistory = _LoggingService.GetActionHistoryForDocument(documentId);

            // will hide columns that show which document or request was performed on
            ViewData["HideDocumentColumns"] = true;
            return View("~/Views/AccountAdministration/ActionLogEntryTable.ascx", actionLogHistory);
        }

        [AuditingAuthorizeAttribute("DocumentTransaction", Roles = "DocumentAdmin")]
        public ActionResult RequestActionLogHistory([ModelBinder(typeof(EncryptedIntegerBinder))] int requestId)
        {
            ICollection<ActionLogEntry> actionLogHistory;

            actionLogHistory = _LoggingService.GetActionHistoryForRequest(requestId);

            // will hide columns that show which document or request was performed on
            ViewData["HideDocumentColumns"] = true;
            return View("~/Views/AccountAdministration/ActionLogEntryTable.ascx", actionLogHistory);
        }

        #endregion

        //private void GetActualDates(DateTime? startDate, DateTime? endDate, out DateTime actualStartDate, out DateTime actualEndDate)
        //{
        //    if (!startDate.HasValue)
        //        actualStartDate = DateService.CurrentSystemTime.AddYears(-100);
        //    else
        //        actualStartDate = startDate.Value;

        //    if (!endDate.HasValue)
        //        actualEndDate = DateService.CurrentSystemTime.AddDays(20);
        //    else
        //        actualEndDate = endDate.Value;
        //}

        //7
        //public ActionResult ExportExcelSentRequests(DateTime? startDate, DateTime? endDate, int pageNumber, string acn, string patientFName, string patientLName, string accountNo)
        //{
        //    IEnumerable<RISARC.Documents.Model.Document> documents;

        //    documents = SelectDocsAndSetViewData(startDate, endDate, pageNumber, acn, patientFName, patientLName, accountNo);

            //if (Request.Params["xls"] != null)
                //return GridViewExtension.ExportToXlsx(ExportGridViewSettings, documents);


            //return View("DocumentRacMoneyTransactions",documents);
       // }

 

//        public ActionResult ExportExcelSentRequests(int page, string orderBy, string filter)
//        {
//            //Get the data representing the current grid state - page, sort and filter
//            DateTime? startDate = null;
//            DateTime? endDate = null;
//            int pageNumber = 0;
//            string acn = null;
//            string patientFName = null;
//            string patientLName = null;
//            string accountNo = null;
//            ICollection<DocumentStatus> statuses;
//            statuses = new Collection<DocumentStatus>
//            {
//                DocumentStatus.RequestRespondedTo,
//                DocumentStatus.Cancelled,
//                DocumentStatus.ComplianceRejected,
//                DocumentStatus.AwaitingComplianceApproval,
//                DocumentStatus.RequestAwaitingDocument,
//                //DocumentStatus.RequestRespondedTo,
//                //DocumentStatus.RequestAwaitingDocument,
//             };
//            IEnumerable<RISARC.Documents.Model.Document> documents;

//            int numberOfPages;


//            if (pageNumber == 0)
//                pageNumber = 1; // hack - set to 1 by default


//            if (pageNumber == 0)
//                pageNumber = 1; // hack - set to 1 by default
//            //documents = _RetrievalService.GetUsersInboundDocuments(statuses,startDate,endDate,pageNumber,out 2,acn,patientFName,patientLName,accountNo);
//            documents = _DocumentsRetrievalService.GetProvidersOutboundDocuments(DocumentStatusUtilities.AllStatuses, startDate, endDate, pageNumber, out numberOfPages, acn, patientFName, patientLName, accountNo);

//            GridModel model = documents.AsQueryable().ToGridModel(page, 65000, orderBy, string.Empty, filter);



//            var orders = model.Data.Cast<RISARC.Documents.Model.Document>();



//            //Create new Excel workbook

//            var workbook = new HSSFWorkbook();



//            //Create new Excel sheet

//            var sheet = workbook.CreateSheet();





//            //(Optional) set the width of the columns

//            sheet.SetColumnWidth(0, 10 * 256);

//            sheet.SetColumnWidth(1, 50 * 256);

//            sheet.SetColumnWidth(2, 50 * 256);

//            sheet.SetColumnWidth(3, 50 * 256);

//            HSSFRow row1 = sheet.CreateRow(0);
//            HSSFCell cell = row1.CreateCell(0);

//            cell.SetCellValue("Outstanding requests");
//            HSSFCellStyle style = workbook.CreateCellStyle();
//            style.Alignment = HSSFCellStyle.ALIGN_LEFT;
//            HSSFFont font = workbook.CreateFont();
//            font.FontHeight = 20 * 20;
//            style.SetFont(font);
//            cell.CellStyle = style;
//            //merged cells on single row
//            sheet.AddMergedRegion(new Region(0, 0, 0, 5));



//            HSSFRow row2 = sheet.CreateRow(1);

//            HSSFCell cell1 = row2.CreateCell(0);
//            HSSFCellStyle style1 = workbook.CreateCellStyle();


//            style1.Alignment = HSSFCellStyle.ALIGN_LEFT;

//            HSSFFont font1 = workbook.CreateFont();
//            font1.FontHeight = 15 * 15;
//            style1.SetFont(font);
//            cell1.CellStyle = style1;
//            cell1.SetCellValue("Run date: " + DateTime.Now);

//            //Create a header row

//            var headerRow = sheet.CreateRow(2);


//            //Set the column names in the header row
//            headerRow.CreateCell(0).SetCellValue("Document type");
//            headerRow.CreateCell(1).SetCellValue("Document Description");
//            headerRow.CreateCell(2).SetCellValue("ACN Number");
//            headerRow.CreateCell(3).SetCellValue("Sent by");
//            headerRow.CreateCell(4).SetCellValue("First name");
//            headerRow.CreateCell(5).SetCellValue("Last name");
//            headerRow.CreateCell(6).SetCellValue("Status");
//            headerRow.CreateCell(7).SetCellValue("Sent on");
//            headerRow.CreateCell(8).SetCellValue("Sent to");
//            headerRow.CreateCell(9).SetCellValue("Downloaded");
//            headerRow.CreateCell(10).SetCellValue("Cost");
//            headerRow.CreateCell(11).SetCellValue("Billing method");
//            headerRow.CreateCell(12).SetCellValue("# of pages");
//            //(Optional) freeze the header row so it is not scrolled

////DocumentTYpe
////Document Description
////CAN Number
////Sent by
////First Name
////Last Name
////Sent on
////Sent To
////Downloaded
////Cost
////Billing Method
////# page 

//            sheet.CreateFreezePane(0, 1, 0, 1);

//            int rowNumber = 3;


//            //Populate the sheet with values from the grid data

//            foreach (RISARC.Documents.Model.Document order in orders)
//            {

//                //Create a new row

//                var row = sheet.CreateRow(rowNumber++);
//                //Set values for the cells
//                row.CreateCell(0).SetCellValue(order.DocumentTypeName);
//                row.CreateCell(1).SetCellValue(order.DocumentDescription);
//                row.CreateCell(2).SetCellValue(order.ACNGrid);
//                row.CreateCell(3).SetCellValue(order.SentFromProviderName);
//                row.CreateCell(4).SetCellValue(order.PatientFirstname);
//                row.CreateCell(5).SetCellValue(order.PatientLastname);
//                row.CreateCell(6).SetCellValue(order.DocumentStatus.ToString());
//                row.CreateCell(7).SetCellValue(order.CreateDate);
//                row.CreateCell(8).SetCellValue(order.DocumentRecipient.ToString());
//                row.CreateCell(9).SetCellValue(order.ActionTime.ToString());
//                row.CreateCell(10).SetCellValue(order.Cost);
//                row.CreateCell(11).SetCellValue(order.BillingMethod.ToString());
//                row.CreateCell(12).SetCellValue(order.NumberOfPages.ToString());
//            }

//            //Write the workbook to a memory stream

//            MemoryStream output = new MemoryStream();

//            workbook.Write(output);



//            //Return the result to the end user



//            return File(output.ToArray(),   //The binary data of the XLS file

//                "application/vnd.ms-excel", //MIME type of Excel files

//                "GridExcelExport.xls");     //Suggested file name in the "Save as" dialog which will be displayed to the end user

//        }
        //8
        public ActionResult ExportExcelSentRequests2(int page, string orderBy, string filter)
        {
            //Get the data representing the current grid state - page, sort and filter
            DateTime? startDate = null;
            DateTime? endDate = null;
            int pageNumber = 0;
            string acn = null;
            string patientFName = null;
            string patientLName = null;
            string accountNo = null;
      
            IEnumerable<DocumentRequest> documentRequests;
            int numberOfPages;
            int? actualPageNumber;

            actualPageNumber = GetActualPageNumber(pageNumber);
 

            if (pageNumber == 0)
                pageNumber = 1; // hack - set to 1 by default


            if (pageNumber == 0)
                pageNumber = 1; // hack - set to 1 by default
            //documents = _RetrievalService.GetUsersInboundDocuments(statuses,startDate,endDate,pageNumber,out 2,acn,patientFName,patientLName,accountNo);
            documentRequests = _DocumentsRetrievalService.GetProvidersInboundRequests(DocumentStatusUtilities.AllStatuses, startDate, endDate, pageNumber, out numberOfPages, acn, patientFName, patientLName, accountNo);

            GridModel model = documentRequests.AsQueryable().ToGridModel(page, 65000, orderBy, string.Empty, filter);



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
            headerRow.CreateCell(0).SetCellValue("Requested document type");
            headerRow.CreateCell(1).SetCellValue("Requested document description");
            headerRow.CreateCell(2).SetCellValue("Status");
            headerRow.CreateCell(3).SetCellValue("Document downloaded");
            headerRow.CreateCell(4).SetCellValue("Response due by");
            headerRow.CreateCell(5).SetCellValue("Requested by");
 
            //(Optional) freeze the header row so it is not scrolled
                        //    
            sheet.CreateFreezePane(0, 1, 0, 1);

            int rowNumber = 3;


            //Populate the sheet with values from the grid data

            foreach (DocumentRequest order in orders)
            {

                //Create a new row

                var row = sheet.CreateRow(rowNumber++);
                //Set values for the cells
                row.CreateCell(0).SetCellValue(order.DocumentTypeName);

                row.CreateCell(1).SetCellValue(order.DocumentDescription);
                row.CreateCell(2).SetCellValue(order.DocumentStatus.ToString());
                row.CreateCell(3).SetCellValue(order.ActionTime.ToString());
                row.CreateCell(4).SetCellValue(order.RequestDueBy.ToString());
                row.CreateCell(5).SetCellValue(order.CreatedByUserDescription.Email);
 

            }

            //Write the workbook to a memory stream

            MemoryStream output = new MemoryStream();

            workbook.Write(output);



            //Return the result to the end user



            return File(output.ToArray(),   //The binary data of the XLS file

                "application/vnd.ms-excel", //MIME type of Excel files

                "GridExcelExport.xls");     //Suggested file name in the "Save as" dialog which will be displayed to the end user

        }
        //9

        public ActionResult ExportExcelSentRequests3(int page, string orderBy, string filter)
        {
            //Get the data representing the current grid state - page, sort and filter
            DateTime? startDate = null;
            DateTime? endDate = null;
            int pageNumber = 0;
            string acn = null;
            string patientFName = null;
            string patientLName = null;
            string accountNo = null;

            IEnumerable<DocumentRequest> documentRequests;
            int numberOfPages;
            int? actualPageNumber;

            actualPageNumber = GetActualPageNumber(pageNumber);


            if (pageNumber == 0)
                pageNumber = 1; // hack - set to 1 by default


            if (pageNumber == 0)
                pageNumber = 1; // hack - set to 1 by default
            //documents = _RetrievalService.GetUsersInboundDocuments(statuses,startDate,endDate,pageNumber,out 2,acn,patientFName,patientLName,accountNo);
            documentRequests = _DocumentsRetrievalService.GetUsersInboundRequestsSentTest(DocumentStatusUtilities.AllStatuses, startDate, endDate, pageNumber, out numberOfPages, acn, patientFName, patientLName, accountNo);

            GridModel model = documentRequests.AsQueryable().ToGridModel(page, 65000, orderBy, string.Empty, filter);



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
            headerRow.CreateCell(0).SetCellValue("Sent date");
            headerRow.CreateCell(1).SetCellValue("Response due by");
            headerRow.CreateCell(2).SetCellValue("Requested document type");
            headerRow.CreateCell(3).SetCellValue("Requested document description");
            headerRow.CreateCell(4).SetCellValue("requested by");
            headerRow.CreateCell(5).SetCellValue("requested from");
            headerRow.CreateCell(6).SetCellValue("First name");
            headerRow.CreateCell(7).SetCellValue("Last name");
            headerRow.CreateCell(8).SetCellValue("Status");
            //(Optional) freeze the header row so it is not scrolled

            sheet.CreateFreezePane(0, 1, 0, 1);

            int rowNumber = 3;

            //Populate the sheet with values from the grid data

            foreach (DocumentRequest order in orders)
            {

                //Create a new row

                var row = sheet.CreateRow(rowNumber++);
                //Set values for the cells
                row.CreateCell(0).SetCellValue(order.RequestDate.ToString());
                row.CreateCell(1).SetCellValue(order.RequestDueBy.ToString());
                row.CreateCell(2).SetCellValue(order.DocumentTypeName);
                row.CreateCell(3).SetCellValue(order.DocumentDescription);
                row.CreateCell(4).SetCellValue(order.CreatedByUserDescription.Email);
                row.CreateCell(5).SetCellValue(order.SentToProviderName);
                row.CreateCell(6).SetCellValue(order.PatientFirstName);
                row.CreateCell(7).SetCellValue(order.PatientLastName);
                row.CreateCell(8).SetCellValue(order.DocumentStatus.ToString());
            }

            //Write the workbook to a memory stream

            MemoryStream output = new MemoryStream();

            workbook.Write(output);



            //Return the result to the end user



            return File(output.ToArray(),   //The binary data of the XLS file

                "application/vnd.ms-excel", //MIME type of Excel files

                "GridExcelExport.xls");     //Suggested file name in the "Save as" dialog which will be displayed to the end user

        }



        private int? GetActualPageNumber(int? pageNumber)
        {
            if (pageNumber.HasValue)
            {
                if (pageNumber.Value == 0)
                    return 1;
                else
                    return pageNumber.Value;
            }
            else
                return pageNumber;
        }

// REmove this function, Mike
    private DateTime GetActualStartDate(DateTime? startDate)
    {
       
            //UrlHelper u = new UrlHelper(this.ControllerContext.RequestContext);
            //string url = u.Action("About", "Home", null);
            if (startDate.HasValue)
            {
                if (startDate.Value == null)
                    return Convert.ToDateTime("01/01/1900");
                else
                    return startDate.Value;
            }
            else
                return Convert.ToDateTime("01/01/1900");
     }

    
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
        
        exportGridViewSettings = null;

        if (ReportType == (int)ExportGridSetting.RACMoneyReport || ReportType == (int)ExportGridSetting.RACDecisionReport || ReportType == (int)ExportGridSetting.SentDocumentsReport)
        {
            IEnumerable<RISARC.Documents.Model.Document> documents;

            if (ReportType == (int)ExportGridSetting.SentDocumentsReport)
            {
                _DocumentsRetrievalService.SetupSearchFilters(ConstantManager.ActionMethodNames.DocumentTransactionLog, ref startDate, ref endDate, ref acn, ref patientFName, ref patientLName, ref accountNo);
                documents = SelectDocsAndSetViewData(startDate, endDate, pageNumber, acn, patientFName, patientLName, accountNo);
            }
            else if (ReportType == (int)ExportGridSetting.RACMoneyReport || ReportType == (int)ExportGridSetting.RACDecisionReport)
            {
                documents = SelectDocsAndSetViewData(startDate, endDate, pageNumber, acn, patientFName, patientLName, accountNo);
            }
            else
                documents = null;

            return GridViewExtension.ExportToXlsx(ExportGridViewSettings(ReportType), documents);
        }
        else if (ReportType == (int)ExportGridSetting.DocumentRequestTransactionTable || ReportType == (int)ExportGridSetting.SentRequests)
        {
            IEnumerable<DocumentRequest> documentRequests;
            int numberOfPages;
            int? actualPageNumber;

            DateTime? sDate = Convert.ToDateTime(Request.Form.Get("StartDate"));

            actualPageNumber = GetActualPageNumber(pageNumber);
            if (ReportType == (int)ExportGridSetting.DocumentRequestTransactionTable)
                documentRequests = _DocumentsRetrievalService.
                GetProvidersInboundRequests(DocumentStatusUtilities.AllStatuses,
                startDate, endDate, actualPageNumber, out numberOfPages, acn, patientFName, patientLName, accountNo);
            else if (ReportType == (int)ExportGridSetting.SentRequests)
            {
                pageNumber = Convert.ToInt32(actualPageNumber);

                _DocumentsRetrievalService.SetupSearchFilters(ConstantManager.ActionMethodNames.SentRequests, ref startDate, ref endDate, ref acn, ref patientFName, ref patientLName, ref accountNo);

                documentRequests = _DocumentsRetrievalService.
                GetUsersInboundRequestsSentTest(DocumentStatusUtilities.AllStatuses,
                startDate, endDate, pageNumber, out numberOfPages, acn, patientFName, patientLName, accountNo);
            }
            else
                documentRequests = null;

            return GridViewExtension.ExportToXlsx(ExportGridViewSettings(ReportType), documentRequests);
        }
        else
        {
            return null;
        }
            //if (Request.Params["xls"] != null)
        


        //return View("DocumentRacMoneyTransactions",documents);
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
        settings.Width = System.Web.UI.WebControls.Unit.Percentage(100);

        if ((int)ExportGridSetting.RACMoneyReport == ReportType || (int)ExportGridSetting.RACDecisionReport == ReportType)
        {
            

            settings.Columns.Add(column =>
            {
                column.Caption = "Account No";
                column.FieldName = "AccountNoRac";
            });


            settings.Columns.Add(column =>
            {
                column.Caption = "First Name";
                column.FieldName = "PatientFirstname";
            });


            settings.Columns.Add(column =>
            {
                column.Caption = "Last Name";
                column.FieldName = "PatientLastname";
            });


            settings.Columns.Add(column =>
            {
                column.Caption = "Request Date";
                column.FieldName = "RequestUTCDate";

            });


            if ((int)ExportGridSetting.RACMoneyReport == ReportType)
            {
                settings.Name = "RACMoneyReport";

                settings.Columns.Add(column =>
                {
                    column.Caption = "Original Pay";
                    column.FieldName = "OriginalPay";

                });



                settings.Columns.Add(column =>
                {
                    column.Caption = "Over Payment";
                    column.FieldName = "Overpayment";

                });



                settings.Columns.Add(column =>
                {
                    column.Caption = "INS / Copay";
                    column.FieldName = "InsCopay";

                });


                settings.Columns.Add(column =>
                {
                    column.Caption = "Recoup";
                    column.FieldName = "Recouped";

                });


                settings.Columns.Add(column =>
                {
                    column.Caption = "Return";
                    column.FieldName = "Returned";
                });


                settings.Columns.Add(column =>
                {
                    column.Caption = "Total Loss";
                    column.FieldName = "TotalLoss";

                });
            }
            else
            {
                settings.Name = "RACDecisionReport";

                settings.Columns.Add(column =>
                {
                    column.Caption = "Denial Date";
                    column.HeaderStyle.Wrap = DefaultBoolean.True;
                    column.FieldName = "DenialUTCDate";
                });

                settings.Columns.Add(column =>
                {
                    column.Caption = "Appeal Level";
                    column.FieldName = "AppealLevel";

                });


                settings.Columns.Add(column =>
                {
                    column.Caption = "Denial Reason";
                    column.FieldName = "DenialReason";

                });

                settings.Columns.Add(column =>
                {
                    column.Caption = "Response Due Date";
                    column.FieldName = "ResponseUTCDueDate";
                });

                settings.Columns.Add(column =>
                {
                    column.Caption = "Appeal Status";
                    column.FieldName = "AppealStatus";
                });


                settings.Columns.Add(column =>
                {
                    column.Caption = "Recoup Deadline";
                    column.FieldName = "RecoupedDeadline";
                });


                settings.Columns.Add(column =>
                {
                    column.Caption = "Date Denial Letter Received";
                    column.FieldName = "UTCDateDenialLetterRecieved";
                });
            }
            

            settings.Columns.Add(column =>
            {
                column.Caption = "Notes";
                column.FieldName = "Notes";

            });


            settings.Columns.Add(column =>
            {
                column.Caption = "Sent By (Provider)";
                column.FieldName = "SentByProvider";

            });

            settings.Columns.Add(column =>
            {
                column.Caption = "Sent To";
                column.FieldName = "SentTo";

            });


            settings.Columns.Add(column =>
            {
                column.Caption = "# of Pages";
                column.FieldName = "NumberOfPages";

            });
        }
        else if ((int)ExportGridSetting.DocumentTransactionLog == ReportType)
        {
            settings.Name = "DocumentTransactionLog";
            settings.Columns.Add(column =>
            {
                column.Caption = "Document Type";
                column.FieldName = "DocumentTypeName";
            });


            settings.Columns.Add(column =>
            {
                column.Caption = "Status";
                column.FieldName = "DocumentStatusMessage";

            });

            settings.Columns.Add(column =>
            {
                column.Caption = "Sent On";
                column.HeaderStyle.Wrap = DefaultBoolean.True;
                column.FieldName = "CreateUTCDate";
            });

        }
        else if ((int)ExportGridSetting.DocumentRequestTransactionTable == ReportType)
        {
            settings.Name = "ReceivedRequestsReport";

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
                column.Caption = "Status";
                column.FieldName = "DocumentStatusMessage";
            });

            settings.Columns.Add(column =>
            {
                column.Caption = "Document Downloaded";
                column.FieldName = "ActionUTCTime";
            });

            settings.Columns.Add(column =>
            {
                column.Caption = "Response Due By";
                column.FieldName = "RequestUTCDueBy";
            });

            settings.Columns.Add(column =>
            {
                column.Caption = "Requested By";
                column.FieldName = "RequestedBy";
            });

            settings.Columns.Add(column =>
            {
                column.Caption = "Responded To With Document";
                column.FieldName = "RespondedDate";
            });
        }
        else if ((int)ExportGridSetting.SentRequests == ReportType)
        {
            settings.Name = "SentRequestsReport";

            settings.Columns.Add(column =>
            {
                column.Caption = "Sent Date";
                column.FieldName = "RequestUTCDate";
            });

            settings.Columns.Add(column =>
            {
                column.Caption = "Response Due By";
                column.FieldName = "RequestDueBy";

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
        else if ((int)ExportGridSetting.SentDocumentsReport == ReportType)
        {
            settings.Name = "SentDocumentsReport";
            settings.Columns.Add(column =>
            {
                column.Caption = "Document Type";
                column.FieldName = "DocumentTypeName";
            });


            settings.Columns.Add(column =>
            {
                column.Caption = "Status";
                column.FieldName = "DocumentStatusMessage";
            });


            settings.Columns.Add(column =>
            {
                column.Caption = "Sent On";
                column.FieldName = "CreateUTCDate";
            });

            settings.Columns.Add(column =>
            {
                column.Caption = "Downloaded";
                column.FieldName = "ActionTime";
            });

            settings.Columns.Add(column =>
            {
                column.Caption = "ACN/DCN/ICN #";
                column.FieldName = "ACN.ACNNumber";
            });

            settings.Columns.Add(column =>
            {
                column.Caption = "Account #";
                column.FieldName = "AccountNoRac";
            });

            settings.Columns.Add(column =>
            {
                column.Caption = "Sent By (Provider)";
                column.FieldName = "SentByProvider";
            });

            settings.Columns.Add(column =>
            {
                column.Caption = "Sent for Request";
                column.FieldName = "SentForRequest";
            });

            settings.Columns.Add(column =>
            {
                column.Caption = "First Name";
                column.FieldName = "PatientFirstname";
            });

            settings.Columns.Add(column =>
            {
                column.Caption = "Last Name";
                column.FieldName = "PatientLastname";
            });

            settings.Columns.Add(column =>
            {
                column.Caption = "Sent To";
                column.FieldName = "SentToList";
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
                column.Caption = "# of Pages";
                column.FieldName = "NumberOfPages";
            });

            
        }
        
        return settings;
    }

   

    } // class ends 



    public enum ExportType
    {
        CSV,
        Printable
    }

  

}
