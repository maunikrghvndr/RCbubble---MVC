<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>

<input type="hidden" id="UploadedFileId" name="UploadedFileId" />
<iframe id="ifjqFileUploadForm" src=<%: Url.Content("~/File/Upload") %> frameborder="0" scrolling="auto" height="280px" width="100%"></iframe>