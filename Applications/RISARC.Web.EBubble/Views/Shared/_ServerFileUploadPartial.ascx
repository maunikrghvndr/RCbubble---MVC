<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<script type="text/javascript">
    //$(document).ready(function () {
    //    if (!document.getElementById('_FileManagePartial') == null) {
    //        btnAttach.SetVisible(false);
    //        btnAttachFolder.SetVisible(false);
    //    }
    //});

    function Button_Click_FilesUpload(s, e) {
        if ((document.getElementById('_FileManagePartial') == null))
            return false;

        var items = _FileManagePartial.GetSelectedItems();
        var names = [];

        for (var i = 0; i < items.length; i++) {
            names[i] = items[i].GetFullName();
        }

        $.ajax({
            url: '../File/UploadServerFiles',
            dataType: "json",
            traditional: true,
            data: { files: names },
            type: "POST",
            success: function (data) {
                //$("#fileContainerServer").html(data).parent().show();
                $("#IsFileUploaded").val("true");
                FileManagerPopUp.Hide();
                if (!(document.getElementById('fileUploadGrid') == null))
                    fileUploadGrid.PerformCallback();
            },
            error: function (request, status, error) {
                $("#removeError").html(error).show();
            }
        });
    }
    function Button_Click_FolderUpload(s, e) {
        if ((document.getElementById('_FileManagePartial') == null))
            return false;

        var folderPath = _FileManagePartial.GetCurrentFolderPath();
        $.ajax({
            url: '../File/UploadServerFiles',
            dataType: "json",
            traditional: true,
            data: { UploadFolderPath: folderPath },
            type: "POST",
            success: function (data) {
                //$("#fileContainerServer").html(data).parent().show();
                $("#IsFileUploaded").val("true");
                FileManagerPopUp.Hide();
                if (!(document.getElementById('fileUploadGrid') == null))
                    fileUploadGrid.PerformCallback();
            },
            error: function (request, status, error) {
                $("#removeError").html(error).show();
            }
        });
    }
</script>

  <!-- from tamara request we are setting this link disable 20.08.2014 -->
<%--<div class="MutipleFileUploadBtn">
      <%= Html.ActionLink("Select File(s) to Upload", "", null, new { href = "javascript:FileManagerPopUp.Show();" }) %>
  </div>--%>
 <!-- from tamara request we are setting this link disable 20.08.2014 -->
 <div class="MutipleFileUploadBtn DisableMutipleFileUploadBtn">
      <%= Html.ActionLink("Select File(s) to Upload","",null,new {href="#" , @class=""}) %>
   </div>



<%--<% ViewContext.Writer.Write("<div id = 'fileContainerServer'></div>"); %>--%>
<%= Html.DevExpress().PopupControl(settings => {
    settings.Name = "FileManagerPopUp";
    settings.Width = 800;
    settings.AllowDragging = true;
    settings.CloseAction = CloseAction.CloseButton;
    settings.PopupAnimationType = AnimationType.Slide;
    settings.HeaderText = "Select Files From SFTP";
    settings.PopupHorizontalAlign = PopupHorizontalAlign.WindowCenter;
    settings.PopupVerticalAlign = PopupVerticalAlign.WindowCenter;
    settings.Modal = true;
    settings.SetContent(() => {
            ViewContext.Writer.Write(Html.Action("FileManager", "File").ToHtmlString());
            ViewContext.Writer.Write("<table class=\"tblWidth50Per\"><tr><td>&nbsp;</td></tr><tr><td>");
            Html.DevExpress().Button(
               buttonsettings =>
               {
                   buttonsettings.Name = "btnAttach";
                   buttonsettings.Text = "Attach Files";
                   buttonsettings.ClientSideEvents.Click = "Button_Click_FilesUpload";
               }).Render();
            ViewContext.Writer.Write("</td><td>&nbsp;</td><td>");
            Html.DevExpress().Button(
               buttonsettings =>
               {
                   buttonsettings.Name = "btnAttachFolder";
                   buttonsettings.Text = "Attach Selected Folder";
                   buttonsettings.ClientSideEvents.Click = "Button_Click_FolderUpload";
               }).Render();
            ViewContext.Writer.Write("</td></tr></table>");
    });
}).GetHtml() %>

