<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<%
    Html.DevExpress().DocumentViewer(settings =>{
        // The following settings are required for a Document Viewer.
        settings.Name = "PerformanceAnalysisDetailReport";
        settings.Report = (RISARC.Web.EBubble.PerformanceAnalysisDetailReport)ViewData["Report"];
        settings.SettingsSplitter.DocumentMapCollapsed = true;
        string Temp = null;
        string NPIId = null;
        if (ViewData["Month"] != null && ViewData["NPI"] != null)
        {
            Temp = ViewData["Month"].ToString();
            NPIId = ViewData["NPI"].ToString();
        }
       
        
        // Callback and export route values specify corresponding controllers and their actions. 
        settings.CallbackRouteValues = new { Controller = "changefacility", Action = "_PerformanceAnalysisDetailDocViewer", month = Temp, NPI = NPIId };
        settings.ExportRouteValues = new { Controller = "changefacility", Action = "_PerformanceAnalysisDetailExportDocViewer", month= Temp, NPI = NPIId };
    }).Render();
%>
