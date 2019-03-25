<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Files.Model.DocumentFile>" %>
<%= Html.ImageAction(Model.FileName, Url.Content("~/images/icons/icon_attachment.gif"), Url.Action("GetPreviewComplianceFile"))%>
