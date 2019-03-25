<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<%      Html.DevExpress().CallbackPanel(settings =>
        {
            string Temp = null;
            if (ViewData["PhysicianId"] != null)
            {
                Temp = ViewData["PhysicianId"].ToString();
            }
            settings.Name = "PhyCostDriverCallbackPanel";
            settings.CallbackRouteValues = new { Controller = "ChangeFacility", Action = "_PhyCostDriverCallbackPanel", PhysicianId = Temp };

            settings.SetContent(() =>
            {
                if (ViewData["PhysicianId"] != null)
               {
                   ViewContext.Writer.Write(Html.Action("_PhyCostDriverDocViewer", new { PhysicianId = Temp }));
                }
            });
        }).GetHtml();
   
    
%>