using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Ajax;
using RISARC.Encryption.Service;
using RISARC.Web.EBubble.Models.Binders;

namespace RISARC.Web.EBubble.Controllers
{
    public class TestController : Controller
    {
        //
        // GET: /Test/

        public string Encrypt(int value)
        {
            return Server.UrlEncode((new FrontEndEnrypter()).Encrypt((value).ToString()));
        }

        public string Decrypt([ModelBinder(typeof(EncryptedIntegerBinder))] int value)
        {
            return value.ToString();
        }


    }
}
