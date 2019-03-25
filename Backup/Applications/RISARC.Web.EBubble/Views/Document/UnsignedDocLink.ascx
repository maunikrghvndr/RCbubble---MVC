<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<%= Html.ActionLink((string)ViewData["FileName"], "Unassigned", new { documentId = Html.Encrypt(ViewData["DocumentId"]) })%>