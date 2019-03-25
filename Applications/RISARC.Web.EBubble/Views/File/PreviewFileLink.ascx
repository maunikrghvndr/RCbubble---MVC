<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Files.Model.DocumentFile>" %>

<table>
    <tr>
        <td>

<%= Html.ImageAction(Model.FileName, Url.Content("~/images/icons/icon_attachment.gif"), Url.Action("GetPreviewedFile", new { documentFileId = Html.Encrypt(ViewData["DocumentFileId"])})) %>
        </td>
        <td>&nbsp;</td>
        <td>
<a href="<%= Url.Action("RemoveFile", new { documentFileId = Html.Encrypt(ViewData["DocumentFileId"]), IsSignedComplainceDocumentUpload = true }) %>"> 
    <img alt="searchPage" style="vertical-align: middle;" height="17px" src="<%: Url.Content("~/images/remove.jpg")%>" title="Remove File" /> 
</a>
            </td>


    </tr>
</table>
 
 

<%--<%= Html.ActionLink("Remove File","RemoveFile", new { documentFileId = Html.Encrypt(ViewData["DocumentFileId"]) })%>--%>

<%--
<%= Html.ImageAction("Model.FileName", "Remove.jpg", Url.Action("RemoveFile", new { documentFileId = Html.Encrypt(ViewData["DocumentFileId"]) }))%>--%>
<%--<%= Html.ActionLink(Model.FileName,"GetPreviewedFile", new { documentFileId = Html.Encrypt(ViewData["DocumentFileId"])})%>--%>
