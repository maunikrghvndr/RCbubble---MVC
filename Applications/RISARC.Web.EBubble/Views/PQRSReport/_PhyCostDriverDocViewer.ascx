<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<%
    Html.DevExpress().DocumentViewer(settings =>{
        // The following settings are required for a Document Viewer.
        settings.Name = "PCostDriverViewer";
        settings.Report = (RISARC.Web.EBubble.PhysicianCostDriverReport)ViewData["Report"];
        settings.SettingsSplitter.DocumentMapCollapsed = true;
        string Temp = null;
        string filter = null;
        if (ViewData["PhysicianId"] != null)
        {
            Temp = ViewData["PhysicianId"].ToString();
            filter = ViewData["filter"].ToString();
        }
        
        // Callback and export route values specify corresponding controllers and their actions. 
        settings.CallbackRouteValues = new { Controller = "changefacility", Action = "_PhyCostDriverDocViewer", PhysicianId = Temp,filter=filter };
        settings.ExportRouteValues = new { Controller = "changefacility", Action = "_PhyCostDriverExportDocViewer", PhysicianId = Temp,filter=filter };
    }).Render();
%>
