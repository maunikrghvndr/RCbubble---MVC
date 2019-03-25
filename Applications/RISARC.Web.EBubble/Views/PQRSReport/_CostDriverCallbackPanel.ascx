<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<%      Html.DevExpress().CallbackPanel(settings =>
        {
            string Temp = null;
            if (ViewData["ProviderId"] != null)
            {
                Temp = ViewData["ProviderId"].ToString();
            }
            settings.Name = "CostDriverCallbackPanel";
            settings.CallbackRouteValues = new { Controller = "ChangeFacility", Action = "_CostDriverCallbackPanel", ProviderIdList = Temp };

            settings.SetContent(() =>
            {
                if (ViewData["ProviderId"] != null)
                {
                    ViewContext.Writer.Write(Html.Action("_CostDriverDocViewer", new { ProviderIdList = Temp }));
                }
            });
        }).GetHtml();
   
    
%>