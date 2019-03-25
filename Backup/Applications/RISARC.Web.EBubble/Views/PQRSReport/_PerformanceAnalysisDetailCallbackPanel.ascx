<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<%      Html.DevExpress().CallbackPanel(settings =>
        {
            string Temp = null; 
            string NPIId = null;

            if (ViewData["Month"] != null && ViewData["NPI"] != null)
            {
                Temp = ViewData["Month"].ToString();
                NPIId = ViewData["NPI"].ToString();
            }
            settings.Name = "PreformanceDetailCallbackPanel";
            settings.CallbackRouteValues = new { Controller = "ChangeFacility", Action = "_PerformanceAnalysisDetailCallbackPanel", Month = Temp, NPI = NPIId };

            settings.SetContent(() =>
            {
                if (ViewData["NPI"] != null)
                {
                    ViewContext.Writer.Write(Html.Action("_PerformanceAnalysisDetailDocViewer", new { Month = Temp, NPI = NPIId }));
                }
            });
        }).GetHtml();
   
    
%>