<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<%
    Html.DevExpress().DocumentViewer(settings =>{
        // The following settings are required for a Document Viewer.
        settings.Name = "PredictiveAnalysisViewer";
        settings.Report = (RISARC.Web.EBubble.PredictiveAnalysisRpt)ViewData["Report"];
        settings.SettingsSplitter.DocumentMapCollapsed = true;
        string Temp = null;
        if (ViewData["ProviderId"] != null)
        {
            Temp = ViewData["ProviderId"].ToString();
        }
        
        // Callback and export route values specify corresponding controllers and their actions. 
        settings.CallbackRouteValues = new { Controller = "changefacility", Action = "_PredictiveAnalysisDocViewer", ProviderId = Temp };
        settings.ExportRouteValues = new { Controller = "changefacility", Action = "_PredictiveAnalysisExportDocViewer", ProviderId = Temp };
    }).Render();
%>