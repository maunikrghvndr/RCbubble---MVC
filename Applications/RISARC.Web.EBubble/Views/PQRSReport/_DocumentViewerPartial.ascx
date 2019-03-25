<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
    <% Html.DevExpress().DocumentViewer(settings =>
       {
           settings.Name = "DocumentViewer";
           settings.SettingsSplitter.DocumentMapCollapsed = true;
           string Temp = null;
           if (ViewData["ProviderId"] != null)
           {
               Temp = ViewData["ProviderId"].ToString();
           }
           settings.CallbackRouteValues = new
           {
               Controller = "changefacility",
               Action = "DocumentViewerPartial",

               ProviderId = Temp
           };
           settings.ExportRouteValues = new
           {
               Controller = "changefacility",
               Action = "DocumentViewerExport",
              ProviderId = Temp
           };
           settings.Report = (XtraReport)Model;

           settings.Height = 800;
           
           
       }).GetHtml();%>