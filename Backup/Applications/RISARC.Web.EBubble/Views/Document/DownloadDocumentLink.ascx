<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<%= Html.ActionLink(ViewData["DocumentName"].ToString(), "GetDocumentFile", 
           new { documentId = Html.Encrypt(ViewData["DocumentId"]) }) %>
