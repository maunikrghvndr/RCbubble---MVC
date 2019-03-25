<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<%
    Html.DevExpress().DocumentViewer(settings =>{
        // The following settings are required for a Document Viewer.
        settings.Name = "Utilizationsub1Viewer";
        settings.Report = (RISARC.Web.EBubble.UtilizationSub1)ViewData["Report"];
      
        string Temp = null;
        if (ViewData["Level"] != null)
        {
            Temp = ViewData["Level"].ToString();
        }
        
        // Callback and export route values specify corresponding controllers and their actions. 
        settings.CallbackRouteValues = new { Controller = "changefacility", Action = "_Utilizationsub1DocViewer", Level = Temp };
    }).Render();
%>