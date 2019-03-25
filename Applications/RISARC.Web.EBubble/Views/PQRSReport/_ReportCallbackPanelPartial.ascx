<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<%      Html.DevExpress().CallbackPanel(settings =>
        {
            settings.Name = "ReportCallbackPanel";
            settings.CallbackRouteValues = new
            {
                Controller = "ChangeFacility",
                Action = "ReportCallbackPanelPartial",
                
            };
            settings.Width = System.Web.UI.WebControls.Unit.Percentage(100);
            settings.Height = 800;

            settings.SetContent(() =>
            {
                string Temp = null;
                if (ViewData["ProviderId"] != null)
	                    {
                                    Temp = ViewData["ProviderId"].ToString();
                                    ViewContext.Writer.Write(Html.Action("DocumentViewerPartial", new { ProviderId = Temp }));
                }
                
                
            });
        }).GetHtml();
   
    
 %>