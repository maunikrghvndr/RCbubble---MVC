<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<div class="UploadWrapper">
  
            <% Html.RenderPartial("~/Views/File/UploadFileFormContents.ascx", ViewData["ProviderId"]); %>

     
</div>
<iframe id="upload_target" name="upload_target"  style="display:none">
</iframe>

