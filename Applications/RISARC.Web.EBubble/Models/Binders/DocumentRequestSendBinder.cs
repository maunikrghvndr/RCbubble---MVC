using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RISARC.Documents.Model;
using System.Collections.Specialized;
using RISARC.Documents.Model.PatientIdentification;
using RISARC.Encryption.Service;

namespace RISARC.Web.EBubble.Models.Binders
{
    public class DocumentRequestSendBinder : DefaultModelBinder
    {
        public override object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext)
        {
            DocumentRequestSend documentRequest;
            FrontEndEnrypter encrypter;
            NameValueCollection form;
            string decryptedFileId;
            //DocumentInfo documentInfo;

            documentRequest = (DocumentRequestSend)base.BindModel(controllerContext, bindingContext);

            form = controllerContext.HttpContext.Request.Form;
            string encryptedValue = form["SubmittedComplianceFileId"];
            encrypter = new FrontEndEnrypter();
            if (!String.IsNullOrEmpty(encryptedValue))
            {
                decryptedFileId = encrypter.Decrypt(encryptedValue);
                documentRequest.SubmittedComplianceFileId = Convert.ToInt32(decryptedFileId);
            }

            return documentRequest;
        }
    }
}
