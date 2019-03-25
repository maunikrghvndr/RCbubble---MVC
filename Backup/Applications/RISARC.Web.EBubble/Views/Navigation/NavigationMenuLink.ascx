<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<SpiegelDg.Common.Web.Model.NavLink>" %>
<%
    // determine if class should render active if nav link is active
    string linkClass;

    if (Model.Selected && Model.IsLastLink)
        linkClass = "active lastnav";
    else if (Model.Selected)
        linkClass = "active";
    else if (Model.IsLastLink)
        linkClass = "lastnav";
    else
        linkClass = null;
    
    object htmlAttributes;
    if (!String.IsNullOrEmpty(linkClass))
        htmlAttributes = new { @class = linkClass };
    else
        htmlAttributes = null;
%>
<% if(!String.IsNullOrEmpty(Model.Settings.ControllerName)){ %>
<%= Html.ActionLink(Model.Settings.Text, Model.Settings.ActionName, Model.Settings.ControllerName, Model.Settings.RouteValues, htmlAttributes) %>
<%} %>
<%if (Model.ChildLinks.Count > 0){ %>
<% Html.RenderPartial("NavigationMenu", Model.ChildLinks); %>
<%} %>
