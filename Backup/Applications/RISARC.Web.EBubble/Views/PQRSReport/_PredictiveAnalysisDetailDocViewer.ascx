<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<%
    Html.DevExpress().DocumentViewer(settings =>{
        // The following settings are required for a Document Viewer.
        settings.Name = "PredictiveAnalysisDetailRpt";
        settings.Report = (RISARC.Web.EBubble.PredictiveAnalysisDetailRpt)ViewData["Report"];
        settings.SettingsSplitter.DocumentMapCollapsed = true;
        string Temp = null;
        string cond = null;
        
        if (ViewData["Count"] != null)
        {
            Temp = ViewData["Count"].ToString();
            cond = ViewData["cond"].ToString();
            
        }
        
        // Callback and export route values specify corresponding controllers and their actions. 
        settings.CallbackRouteValues = new { Controller = "changefacility", Action = "_PredictiveAnalysisDetailDocViewer", Count = Temp, cond = cond };
        settings.ExportRouteValues = new { Controller = "changefacility", Action = "_PredictiveAnalysisDetailDocViewer", Count = Temp, cond = cond };
    }).Render();
%>