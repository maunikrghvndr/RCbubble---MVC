<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<%
    Html.DevExpress().DocumentViewer(settings =>{
        // The following settings are required for a Document Viewer.
        settings.Name = "PerformanceAnalysisViewer";
        settings.Report = (RISARC.Web.EBubble.PerformanceAnalysisRpt)ViewData["Report"];
        settings.SettingsSplitter.DocumentMapCollapsed = true;
        string Temp = null;
        int MeasureIdTemp = 0;
        if (ViewData["ProviderId"] != null && Convert.ToInt32(ViewData["MeasureId"]) != 0)
        {
            Temp = ViewData["ProviderId"].ToString();
            MeasureIdTemp = Convert.ToInt32(ViewData["MeasureId"]);
        }
        
        // Callback and export route values specify corresponding controllers and their actions. 
        settings.CallbackRouteValues = new { Controller = "changefacility", Action = "_PerformanceAnalysisDocViewer", ProviderId = Temp, MeasureId = MeasureIdTemp };
        settings.ExportRouteValues = new { Controller = "changefacility", Action = "_PerformanceAnalysisExportDocViewer", ProviderId = Temp, MeasureId = MeasureIdTemp };
    }).Render();
%>