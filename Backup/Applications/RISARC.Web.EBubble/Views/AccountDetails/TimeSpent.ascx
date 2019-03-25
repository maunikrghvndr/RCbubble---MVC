<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>


<%      
    if (Convert.ToBoolean(Session["IsFieldOffierLogin"]) && Convert.ToBoolean(ViewData["popupFlag"])) { %>
                <span  style="font-weight:bold" >Time Spent:</span>
<% } %>

    
 <% 
        Html.DevExpress().Label(
            settings =>
            {

                if (Convert.ToBoolean(ViewData["popupFlag"]))
                {
                    settings.Name = "timeSpentPopup";
                }
                else
                {
                    settings.Name = "timeSpent";
                   
                }
                settings.Properties.EnableClientSideAPI = true;
                if (Session["IsFieldOffierLogin"] != null && (bool)Session["IsFieldOffierLogin"] && !Convert.ToBoolean(ViewData["popupFlag"]))
                {
                    settings.Properties.ClientSideEvents.Init = "function(s,e){ OnTickerInit(); }";
                }
                
            }).GetHtml();   
    %>


