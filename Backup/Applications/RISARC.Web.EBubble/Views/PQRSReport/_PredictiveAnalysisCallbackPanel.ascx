<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<%      Html.DevExpress().CallbackPanel(settings =>
        {
            string Temp = null;
            if (ViewData["ProviderId"] != null)
            {
                Temp = ViewData["ProviderId"].ToString();
            }
            settings.Name = "PredictiveAnaysisCallbackPanel";
            settings.CallbackRouteValues = new { Controller = "ChangeFacility", Action = "_PredictiveAnalysisCallbackPanel", ProviderId = Temp };

            settings.SetContent(() =>
            {
                if (ViewData["ProviderId"] != null)
                {
                    ViewContext.Writer.Write(Html.Action("_PredictiveAnalysisDocViewer", new { ProviderId = Temp }));
                }
            });
        }).GetHtml();
   
    
%>