using System.Web;
using System.Web.Mvc;
using System.Web.UI;
using System;

namespace RISARC.Web.EBubble
{
    public partial class _Default : Page
    {
        public void Page_Load(object sender, System.EventArgs e)
        {
            // Add by Michael Bert to KILL Cache
            HttpContext.Current.Response.Cache.SetExpires(DateTime.UtcNow.AddDays(-1));
            HttpContext.Current.Response.Cache.SetValidUntilExpires(false);
            HttpContext.Current.Response.Cache.SetRevalidation(HttpCacheRevalidation.AllCaches);
            HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);
            HttpContext.Current.Response.Cache.SetNoStore();
            // Add by Mike at Jan 16, 2013



            // Orginal Code
            // Change the current path so that the Routing handler can correctly interpret
            // the request, then restore the original path so that the OutputCache module
            // can correctly process the response (if caching is enabled).
            string originalPath = Request.Path;
            HttpContext.Current.RewritePath(Request.ApplicationPath, false);
            IHttpHandler httpHandler = new MvcHttpHandler();
            httpHandler.ProcessRequest(HttpContext.Current);
            HttpContext.Current.RewritePath(originalPath, false);
        }
    }
}
