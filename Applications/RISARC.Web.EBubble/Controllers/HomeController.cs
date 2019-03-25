using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using RISARC.Common;
using SpiegelDg.Security.Model;

namespace RISARC.Web.EBubble.Controllers
{
    [HandleError]
    public class HomeController : Controller
    {
        public ActionResult Index()
        {

            if (base.User.Identity.IsAuthenticated)
                return Members();
            else

            return View();
        }

        public ActionResult Lander()
        {

            if (base.User.Identity.IsAuthenticated)
                return Members();
            else

                return View();
        }

        //[AuditingAuthorizeAttribute("Members")]
        public ActionResult Members()
        {
            return View("Members");
        }

        public ActionResult About()
        {
            return View();
        }

        public ActionResult NavigationMenu()
        {
            if (User.IsInRole(ConstantManager.StoredProcedureConstants.DocumentAdmin))
                ViewData["RenderDocumentsAdmin"] = true;
            else
                ViewData["RenderDocumentsAdmin"] = false;

            return View();
        }

        public ActionResult Contact()
        {
            return View();
        }

        public ActionResult Support()
        {
            return View("Contact");
        }

        public ViewResult LogOnUserControlMember()
        {

            return View();
        }

        /// <summary>
        /// Set offset of browser timezone in Session variable.
        /// </summary>
        /// <param name="offSet">Offset of browser timezone.</param>
        /// <returns>null</returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 06/12/2014 | Gurudatta   | Created
        /// </RevisionHistory>
        public JsonResult SetTimeZone(int offSet){
            Session[ConstantManager.SessionConstants.LocalTimeZoneOffset] = (-1 * offSet).ToString();
            return Json(null);
        }
        //private string GetLoggedInUsersName()
        //{
        //    string loggedInUsersName;

        //    Request.Cookies
        //}

        //public string TestViewRender()
        //{
        //    IView
        //}

    }
}
