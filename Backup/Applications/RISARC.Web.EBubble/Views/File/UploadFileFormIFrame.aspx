<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>UploadFileFormIFrame</title>
    
<script type="text/javascript">
    function init() {
        if (top.populateResponseToForm) top.populateResponseToForm(); //top means parent frame.
        if (top.additionalPostUpload) top.additionalPostUpload();
    }
    window.onload = init;
</script>
</head>
<body>
    <div>
    <% Html.RenderPartial("~/Views/File/UploadFileFormContents.ascx"); %>  
    </div>
</body>
</html>
