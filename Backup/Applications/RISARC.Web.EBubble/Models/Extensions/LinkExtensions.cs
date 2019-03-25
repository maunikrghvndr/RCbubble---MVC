using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Html;
using RISARC.Encryption.Service;

namespace RISARC.Web.EBubble.Models.Extensions
{
    public static class LinkExtensions
    {
        private static IEncryptionService _Encrypter = new FrontEndEnrypter();

        public static MvcHtmlString DocumentLink(this HtmlHelper helper, string linkText, int documentId)
        {
            string encryptedId = _Encrypter.Encrypt(documentId.ToString());

            return helper.DocumentLink(linkText, encryptedId);
        }



        public static MvcHtmlString DocumentLink(this HtmlHelper helper, string linkText, string encryptedDocumentId)
        {
            return helper.ActionLink(linkText, "Index", "Document", new { documentId = encryptedDocumentId }, null);
        }

        public static MvcHtmlString DocumentAdminLink(this HtmlHelper helper, string linkText, string encryptedDocumentId)
        {
            return helper.ActionLink(linkText, "Index", "DocumentAdmin", new { documentId = encryptedDocumentId }, null);
        }

        public static MvcHtmlString DocumentRequestAdminLink(this HtmlHelper helper, string linkText, string encryptedRequestId)
        {
            return helper.ActionLink(linkText, "DocumentRequest", "DocumentAdmin", new { requestId = encryptedRequestId }, null);
        }



    }
}
