<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<%      Html.DevExpress().CallbackPanel(settings =>
        {
            string Temp = null; 
           
            if (ViewData["Count"] != null)
            {
                Temp = ViewData["Count"].ToString();
            }
            settings.Name = "PreformanceDetailCallbackPanel";
            settings.CallbackRouteValues = new { Controller = "ChangeFacility", Action = "_PredictiveAnalysisDetailCallbackPanel", Count = Temp };

            settings.SetContent(() =>
            {
                if (ViewData["Count"] != null)
                {
                    ViewContext.Writer.Write(Html.Action("_PredictiveAnalysisDetailDocViewer", new { Count = Temp }));
                }
            });
        }).GetHtml();
   
    
%>