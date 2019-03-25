using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Ajax;

namespace RISARC.Web.EBubble.Controllers
{
    public class ErrorController : Controller
    {
        //
        // GET: /Error/

        public ActionResult SecurityError()
        {
            return View();
        }

        public ActionResult InvalidActionError()
        {
            return View();
        }

        public ActionResult UnexpectedError()
        {
            return View();
        }

        public ActionResult NotFound()
        {
            return View();
        }

    }
}
