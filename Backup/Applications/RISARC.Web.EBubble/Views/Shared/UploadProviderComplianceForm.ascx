<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<div class="UploadWrapper">
    <%--<%using (Html.BeginForm("UploadProviderCompliance", "File", FormMethod.Post,
        new { enctype = "multipart/form-data",
           @class="fileUploaderForm"}
        )){%>
        <%= Html.AntiForgeryToken() %>
        <div class="formContents">--%>
            <% Html.RenderPartial("UploadFileFormContents"); %>
        <%--</div>
        <%
      }%>--%>
</div>
<iframe id="upload_target" name="upload_target" src="" style="display:none">
</iframe>
