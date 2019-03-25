using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Html;
using RISARC.Emr.Web.Extensions;

namespace RISARC.Web.EBubble.Models.Extensions
{
    public static class DataExtensions
    {
        private const string _DocumentIdKey = "documentId";
        /// <summary>
        /// Renders the document id as the hidden field containing encrypted documentId 
        /// </summary>
        /// <param name="helper"></param>
        /// <returns></returns>
        public static MvcHtmlString HiddenDocumentIdField(this HtmlHelper helper)
        {
            object documentIdValue;
            string encryptedDocumentId;
            
            documentIdValue = helper.ViewData["DocumentId"];
            encryptedDocumentId = helper.Encrypt(documentIdValue);

            return helper.Hidden(_DocumentIdKey, encryptedDocumentId);
        }
    }
}
