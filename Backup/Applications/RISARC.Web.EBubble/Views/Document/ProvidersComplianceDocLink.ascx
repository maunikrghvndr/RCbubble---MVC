<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Files.Model.DocumentFile>" %>
<%= Html.ActionLink(Model.FileName, "GetProvidersComplianceDocLink", "Document", 
        new {providerId = Html.Encrypt(ViewData["ProviderId"])}, null) %>