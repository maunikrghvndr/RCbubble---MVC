using RISARC.Emr.Web.DataTypes;
using RISARC.eTAR.Model;
using RISARC.eTAR.Service;
using RISARC.Membership.Model;
using RISARC.Membership.Service;
using SpiegelDg.Security.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using RISARC.Web.EBubble.Models.Binders;

namespace RISARC.Web.EBubble.Controllers
{
    public class WorkListController : Controller
    {
        #region Private Variables

        private IFieldOfficerService _FieldOfficerService;
        
        #endregion Private Variables

        #region Constructor

        public WorkListController(IFieldOfficerService fieldOfficerService)
        {
            this._FieldOfficerService = fieldOfficerService;
        }

        #endregion Constructor

        #region Field Officer Work list

        /// <summary>
        /// Work list search view get method
        /// </summary>
        /// <returns>WorklistSearch view</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 03/12/2014 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        [HttpGet]
        [AuditingAuthorize("WorklistSearch", Roles = "User")]
        public ActionResult WorklistSearch()
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.WorkListSearch);
            SearchFieldWorklist searchFieldWorklist = new SearchFieldWorklist();
            _FieldOfficerService.SearchWorklist(searchFieldWorklist);
            return View(searchFieldWorklist);
        }

        /// <summary>
        /// Post method for searching provided search filter
        /// </summary>
        /// <param name="searchFieldWorklist">SearchFieldWorklist model / dat entity</param>
        /// <returns>WorklistSearch view</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 03/12/2014 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        [HttpPost]
        [AuditingAuthorize("WorklistSearch", Roles = "User")]
        public ActionResult WorklistSearch(SearchFieldWorklist searchFieldWorklist)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.WorkListSearch);
            return View(searchFieldWorklist);
        }

        /// <summary>
        /// Callback method for work list grid
        /// </summary>
        /// <param name="searchFieldWorklist">SearchFieldWorklist Model / Data entity</param>
        /// <returns>Partial view of work list grid</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 03/13/2014 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public ActionResult WorklistGridCallback(SearchFieldWorklist searchFieldWorklist)
        {
            _FieldOfficerService.SearchWorklist(searchFieldWorklist);
            return PartialView("WorklistGridCallback", searchFieldWorklist);
        }

        //Method to Lock TCN File
        //Added on 02-Feb-2015
        //Added by Abdul
        public object isTCNLockedOut([ModelBinder(typeof(EncryptedStringBinder))]string TCNIdentification)
        {
            string result;
            string username;
            //logged in Username from context
            username = HttpContext.User.Identity.Name;
            result = _FieldOfficerService.isTCNLockedOut(TCNIdentification, username);
            JsonResult jsonResult = new JsonResult
            {
                Data = result,
                JsonRequestBehavior = JsonRequestBehavior.AllowGet
            };
            return jsonResult.Data;
        }
        //End Added

        #endregion Field Officer Work list

        #region Global Search

        /// <summary>
        /// Global search for Worklist without PatientAlpha considration
        /// </summary>
        /// <returns>GlobalSearch View</returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 04/2/2014 | Abdul   | Created
        /// </RevisionHistory>
        [HttpGet]
        [AuditingAuthorize("GlobalSearch", Roles = "User")]
        public ActionResult GlobalSearch()
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.GlobalSearch);
            SearchFieldWorklist searchFieldGlobal = new SearchFieldWorklist();
            _FieldOfficerService.SearchGlobal(searchFieldGlobal);
            return View(searchFieldGlobal);
        }

        /// <summary>
        /// Global Search Post method based on search criteria
        /// </summary>
        /// <param name="searchFieldGlobal">Model for SearchFieldWorklist</param>
        /// <returns>View of Global Search</returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 04/2/2014 | Abdul   | Created
        /// </RevisionHistory>
        [HttpPost]
        [AuditingAuthorize("GlobalSearch", Roles = "User")]
        public ActionResult GlobalSearch(SearchFieldWorklist searchFieldGlobal)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.GlobalSearch);
            _FieldOfficerService.SearchGlobal(searchFieldGlobal);
            return View(searchFieldGlobal);
        }

        /// <summary>
        /// Call back for Global Search result Grid
        /// </summary>
        /// <param name="searchFieldGlobal">Partial view for Global search grid</param>
        /// <returns></returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 04/2/2014 | Abdul   | Created
        /// </RevisionHistory>
        public ActionResult GlobalSearchGridCallback(SearchFieldWorklist searchFieldGlobal)
        {
            _FieldOfficerService.SearchGlobal(searchFieldGlobal);
            return PartialView("GlobalSearchGridCallback", searchFieldGlobal);
        }

        #endregion Global Search

        #region eNote

        /// <summary>
        /// Enotes Search Action Method
        /// </summary>
        /// <returns>Enotes Search View</returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 04/23/2014 | Abdul   | Created
        /// </RevisionHistory>
        [HttpGet]
        [AuditingAuthorize("ENotesSearch", Roles = "User")]
        public ActionResult ENotesSearch()
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.ENotesSearch);
            SearchFieldENotes searchFieldGlobal = new SearchFieldENotes();
            //searchFieldGlobal.IsReceived = true;
            //_FieldOfficerService.SearchENotes(searchFieldGlobal);
            return View(searchFieldGlobal);
        }

        public ActionResult ENotesSearchTabCallback(SearchFieldENotes searchFieldENotes)
        {
            return PartialView("_eNoteSearchTab", searchFieldENotes);
        }

        /// <summary>
        /// Enotes Grid Recieved/Sent Call Back
        /// </summary>
        /// <param name="searchFieldENotes">Search field ENotes Model</param>
        /// <returns>Partial View of Grid</returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 04/23/2014 | Abdul   | Created
        /// </RevisionHistory>
        public ActionResult ENotesGridCallBack(SearchFieldENotes searchFieldENotes)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.ENotesSearch);
            if (searchFieldENotes.IsReceived == true)
            {
                _FieldOfficerService.SearchENotes(searchFieldENotes);
                return PartialView("ReceivedENotesGrid", searchFieldENotes);
            }
            else
            {
                _FieldOfficerService.SearchENotes(searchFieldENotes);
                return PartialView("SentEnotesGrid", searchFieldENotes);
            }
        }

        //public ActionResult ENotePopup() {
        //    return PartialView("ENotePopup");
        //}

        //public ActionResult EnotePopupContent() {
        //    return PartialView("EnotePopupContent");
        //}

        #endregion eNote
    }
}