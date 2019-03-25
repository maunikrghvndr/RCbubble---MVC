using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RISARC.Documents.Model;
using RISARC.Encryption.Service;
using System.Collections.Specialized;

namespace RISARC.Web.EBubble.Models.Binders
{
    public class DocumentSendBinder : DefaultModelBinder
    {
        public override object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext)
        {
            DocumentSend documentSend;
            FrontEndEnrypter encrypter;
            NameValueCollection form;
            string decryptedFileId;


            documentSend = base.BindModel(controllerContext, bindingContext) as DocumentSend;

            form = controllerContext.HttpContext.Request.Form;
            string encryptedValue = form["DocumentFileId"];
            encrypter = new FrontEndEnrypter();
            if (!String.IsNullOrEmpty(encryptedValue))
            {
                decryptedFileId = encrypter.Decrypt(encryptedValue);
                documentSend.DocumentFileId = Convert.ToInt32(decryptedFileId);
            }

            return documentSend;
        }
    }
}
