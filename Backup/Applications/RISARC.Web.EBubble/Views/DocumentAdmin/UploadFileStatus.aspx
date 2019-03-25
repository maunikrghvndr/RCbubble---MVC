<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
<script type="text/javascript">
    function init() {
        if (top.uploadComplete) top.uploadComplete(); //top means parent frame.
    }
    window.onload = init;
</script>
</head>
<body>
<%if (ViewData["FileId"] != null)
  { %>
  <% Html.RenderPartial("UploadFileSuccess"); %>
<% }
  else
  {%>
  <label class="errorMessage">We're sorry, and error occured when uploading the file.  The site administrators have been notified</label>
<%} %>
</div>
</body>
</html>
