<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<%      Html.DevExpress().CallbackPanel(settings =>
        {
            string Temp = null;
            int MeasureIdTemp = 0;
            if (ViewData["ProviderId"] != null && Convert.ToInt32(ViewData["MeasureId"])!=0)
            {
                Temp = ViewData["ProviderId"].ToString();
                MeasureIdTemp = Convert.ToInt32(ViewData["MeasureId"]);
            }
            settings.Name = "PerformanceAnaysisCallbackPanel";
            settings.CallbackRouteValues = new { Controller = "ChangeFacility", Action = "_PerformanceAnalysisCallbackPanel", ProviderId = Temp, MeasureId = MeasureIdTemp };

            settings.SetContent(() =>
            {
                if (ViewData["ProviderId"] != null)
                {
                    ViewContext.Writer.Write(Html.Action("_PerformanceAnalysisDocViewer", new { ProviderId = Temp, MeasureId = MeasureIdTemp }));
                }
            });
        }).GetHtml();
   
    
%>