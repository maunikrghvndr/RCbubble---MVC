<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<%= Html.Hidden("FileId", (string)ViewData["FileId"])%>
<label class="successMessage">File <%= Html.Encode((string)ViewData["FileName"])%> succcessfully uploaded</label>
