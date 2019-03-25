<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<%      Html.DevExpress().CallbackPanel(settings =>
        {
            string Temp = null; 
            string NPIId = null;

            if (ViewData["Month"] != null )
            {
                Temp = ViewData["Month"].ToString();
            }
            settings.Name = "ExpenditureCallbackPanel";
            settings.CallbackRouteValues = new { Controller = "ChangeFacility", Action = "_ExpenditureDetailCallbackPanel", Month = Temp };

            settings.SetContent(() =>
            {
                if (ViewData["Month"] != null)
                {
                    ViewContext.Writer.Write(Html.Action("_ExpenditureDetailDocViewer", new { Month = Temp }));
                }
            });
        }).GetHtml();
   
    
%>