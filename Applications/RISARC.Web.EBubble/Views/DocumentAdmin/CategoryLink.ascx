<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<SpiegelDg.Common.Web.Model.NavSettings>" %>
<%= Html.ActionLink(Model.Text, Model.ActionName, Model.RouteValues) %>
</li> 