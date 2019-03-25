using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace RISARC.Web.EBubble.Controllers
{
    public class LegalController : Controller
    {
        //
        // GET: /Legal/

        public ActionResult Terms()
        {
            return View("Legal");
        }


        public ActionResult Privacy()
        {
            return View("Privacy");
        }
    }
}
