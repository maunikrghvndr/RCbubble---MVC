<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<string>" %>
<% if (!String.IsNullOrEmpty(Model))
   {%>
    <%= Html.DevExpress().FileManager(
        settings =>
        {
            settings.Name = "_FileManagePartial";
            settings.CallbackRouteValues = new { Controller = "File", Action = "FileManager" };
        
            settings.Settings.ThumbnailFolder = Url.Content("~/Content/FileManager/Thumbnails");
            settings.SettingsFileList.View = DevExpress.Web.ASPxFileManager.FileListView.Thumbnails;
            settings.Settings.AllowedFileExtensions = RISARC.Documents.Implementation.Service.DocumentsAdminService.GetAllowedFileExtensions();
            settings.Settings.EnableMultiSelect = true;
            settings.SettingsUpload.Enabled = false;
            settings.Styles.FolderContainer.Width = Unit.Percentage(30);
            settings.Width = Unit.Percentage(100);
            settings.Height = 500;
        }
    ).BindToFolder(Model).GetHtml()
    %>
<%} else {%>
    <div><b>SFTP path either not Accessible or Configured. Please contact System Administrator.</b></div>
<%} %>