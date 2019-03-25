<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<div class="UploadWrapper">
 

            <% Html.RenderPartial("UploadFileFormContents"); %>

        <%--</div>
        <%
      }%>--%>

</div>
<iframe id="upload_target" name="upload_target" onkeypress="javascript: CancelEnterKey();" src="" style="display:none">
</iframe>
