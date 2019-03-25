<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>TestFileUpload2</title>
    
    <script type="text/javascript" src="<%: Url.Content("~/Scripts/jquery-1.3.2.js")%>"></script>
    <%--<script type="text/javascript" src="<%: Url.Content("~/Scripts/jquery-1.3.2.min.js"></script>--%>
    <script type="text/javascript" src="<%: Url.Content("~/Scripts/MicrosoftAjax.js")%>"></script>
    <script type="text/javascript" src="<%: Url.Content("~/Scripts/MicrosoftMvcAjax.js")%>"></script>
<script type="text/javascript" src="<%: Url.Content("~/Scripts/FileUploader.js")%>"></script>
</head>
<body>
    <div>
    <%--<% Html.RenderAction<RISARC.Web.EBubble.Controllers.FileController>(x => x.UploadFilePanel("UploadDocumentFile", "DocumentAdmin", null, (int?)ViewData["DocumentFileId"])); %>--%>
    <%= Html.Hidden("DocumentFileId") %>
    </div>
</body>
</html>
