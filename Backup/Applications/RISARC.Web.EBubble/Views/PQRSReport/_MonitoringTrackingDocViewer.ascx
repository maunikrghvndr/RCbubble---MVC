<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<%
    Html.DevExpress().DocumentViewer(settings =>{
        // The following settings are required for a Document Viewer.
        settings.Name = "MonitoringTrackingViewer";
        settings.Report = (RISARC.Web.EBubble.MonitoringTrackingReport)ViewData["Report"];
      
        string Temp = null;
        if (ViewData["ProviderId"] != null)
        {
            Temp = ViewData["ProviderId"].ToString();
        }
        
        // Callback and export route values specify corresponding controllers and their actions. 
        settings.CallbackRouteValues = new { Controller = "changefacility", Action = "_MonitoringTrackingDocViewer", ProviderId = Temp };
        settings.ExportRouteValues = new { Controller = "changefacility", Action = "_MonitoringTrackingExportDocViewer", ProviderId = Temp };
    }).Render();
%>
