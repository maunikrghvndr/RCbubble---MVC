using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using System.Security.Principal;
using SpiegelDg.Common.Web.ModelBinders;
using RISARC.Documents.Model;
using RISARC.Web.EBubble.Models.Binders;
using RISARC.Documents.Model.PatientIdentification;
using Microsoft.Practices.EnterpriseLibrary.ExceptionHandling;
using System.Security;
using SpiegelDg.Common.Validation;
using Microsoft.Practices.EnterpriseLibrary.Logging;
using System.Web.Optimization;

namespace RISARC.Web.EBubble
{
    // Note: For instructions on enabling IIS6 or IIS7 classic mode, 
    // visit http://go.microsoft.com/?LinkId=9394801

   
    public class MvcApplication : System.Web.HttpApplication
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            // need to set this to true so that outside can't access internal files
            routes.RouteExistingFiles = true;

            routes.IgnoreRoute("Content/{*restOfUrl}");
            routes.IgnoreRoute("Images/{*restOfUrl}");
            routes.IgnoreRoute("Scripts/{*restOfUrl}");


            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            
            routes.MapRoute("Document",
                "Document/",
                new { controller = "Document", action = "Index" });

            routes.MapRoute("DocumentPost",
                "DocumentPost/{action}/",
                new { controller = "Document", action = "Index" });


            routes.MapRoute("DocumentAdmin",
                "DocumentAdmin/",
                new { controller = "DocumentAdmin", action = "Index" });

            routes.MapRoute("DocumentRequestAdmin",
                "RequestAdmin/",
                new { controller = "DocumentAdmin", action = "DocumentRequest" });

            routes.MapRoute("DocumentAdminPost",
                "DocumentAdminPost/{action}/",
                new { controller = "DocumentAdmin"});

            routes.MapRoute("IdLessActions",
                "{controller}/{action}/",
                new { controller="Home" }
            );


            routes.MapRoute("Default",
                "",
                 new { controller = "Home", action = "Lander" });


            ModelBinders.Binders[typeof(IPrincipal)] = new IPrincipalModelBinder();
            ModelBinders.Binders[typeof(DateTime)] = new DateTimeModelBinder();
            ModelBinders.Binders[typeof(Int32)] = new IntegerBinder();
            ModelBinders.Binders[typeof(DocumentRequestSend)] = new DocumentRequestSendBinder();
            ModelBinders.Binders[typeof(DocumentRequestResponse)] = new DocumentRequestResponseBinder();
            ModelBinders.Binders[typeof(DocumentSend)] = new DocumentSendBinder();
            ModelBinders.Binders[typeof(PatientIdentificationMethods)] = new PatientIdentificationMethodsBinder();
           // ModelBinders.Binders[typeof(DocumentSend)] = new DocumentSendBinder();
           // ModelBinders.Binders[typeof(PatientIdentificationMethods)] = new PatientIdentificationMethodsBinder();
        }

        public static void RegisterBundles(BundleCollection bundles)
        {
            //Creating bundle for your css files
            bundles.Add(new StyleBundle("~/Content/css").Include("~/Content/risarc.css",
            "~/Content/IE7-only.css"));
           
            //Creating bundle for your js files
            bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
            "~/Scripts/jquery-1.11.1.min.js",
            "~/Scripts/jquery-1.9.0.js",
            "~/Scripts/jquery-ui.js",
            "~/Scripts/jquery-migrate-1.1.0.min.js",
            "~/Scripts/jstz-1.0.4.min.js",
             "~/Scripts/MicrosoftAjax.js",
             "~/Scripts/MicrosoftMvcValidation.js",
             "~/Scripts/Common.js"
            ));


            // Document viewer js files bundle
              bundles.Add(new ScriptBundle("~/bundles/documentViewer").Include(
            "~/Scripts/ImGearPlugins21.1.js",
            "~/Scripts/ImGearCore21.1.js",
            "~/Scripts/ImGearClientViewer21.1.js",
             "~/Scripts/ImGearThumbnailList21.1.js",
             "~/Scripts/NotesCommon.js"
            ));

        }


        protected void Application_Start()
        {
            //// Added By Dnyaneshwar
            //DataAnnotationsModelValidatorProvider.AddImplicitRequiredAttributeForValueTypes = false;
            //// End Added
            RegisterRoutes(RouteTable.Routes);
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            ControllerBuilder.Current.SetControllerFactory(new WindsorControllerFactory());

            ModelBinders.Binders.DefaultBinder = new DevExpress.Web.Mvc.DevExpressEditorsBinder();
            RegisterBundles(BundleTable.Bundles);
            BundleTable.EnableOptimizations = true; 
        }

        protected void Application_Error(object sender, EventArgs e)
        {
            Exception error = Server.GetLastError().GetBaseException();        
            //// TODO: FIGURE OUT WHY NOT LOGGING!
            bool shouldReThrow = false;
            if (error != null)
                shouldReThrow = ExceptionPolicy.HandleException(error, "Global Policy");

            //Microsoft.Practices.EnterpriseLibrary.Logging.Logger.Write("An Error Has Occured", "General2");
            // if exception is security exception, then return 401
            if (error is SecurityException)
            {
                Response.Redirect("../Error/SecurityError/?ReturnUrl=" + Server.UrlEncode(Request.Url.AbsoluteUri));
            }
            else if (shouldReThrow)
                throw error;
            /*
            if (error.GetType() == typeof(SecurityException))
                Response.Redirect("~/Error/SecurityError");
            else if (error.GetType() == typeof(InvalidActionException))
                Response.Redirect("~/Error/InvalidActionError");
            else
                Response.Redirect("~/Error/UnexpectedError");
            */
        }
    }
}