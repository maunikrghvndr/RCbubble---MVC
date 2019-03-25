<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<%      Html.DevExpress().CallbackPanel(settings =>
        {
            string Temp = null;
            if (ViewData["Level"] != null)
            {
                Temp = ViewData["Level"].ToString();
            }
            settings.Name = "Utilizationsub1CallbackPanel";
            settings.CallbackRouteValues = new { Controller = "ChangeFacility", Action = "_Utilizationsub1CallbackPanel", Level = Temp };

            settings.SetContent(() =>
            {
                if (ViewData["Level"] != null)
                {
                    ViewContext.Writer.Write(Html.Action("_Utilizationsub1DocViewer", new { Level = Temp }));
                }
            });
        }).GetHtml();
   
    
%>