<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<%
    Html.DevExpress().DocumentViewer(settings =>{
        // The following settings are required for a Document Viewer.
        settings.Name = "ExpenditureDetailReport";
        settings.Report = (RISARC.Web.EBubble.ExpenditureDetailReport)ViewData["Report"];
        settings.SettingsSplitter.DocumentMapCollapsed = true;
        string Temp = null;
        if (ViewData["Month"] != null )
        {
            Temp = ViewData["Month"].ToString();
           // NPIId = ViewData["NPI"].ToString();
        }
       
        
        // Callback and export route values specify corresponding controllers and their actions. 
        settings.CallbackRouteValues = new { Controller = "changefacility", Action = "_ExpenditureDetailDocViewer", month = Temp };
        settings.ExportRouteValues = new { Controller = "changefacility", Action = "_ExpenditureDetailExportDocViewer", month = Temp };
    }).Render();
%>
