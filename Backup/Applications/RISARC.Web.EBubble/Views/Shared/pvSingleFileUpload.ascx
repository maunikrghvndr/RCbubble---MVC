<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<div id="fileUploader" style="display: none;">
    <% Html.BeginForm("SingleFileUploadControlForm", "UploadControl", FormMethod.Post); %>
    <%
        Html.DevExpress().UploadControl(settings =>
        {
            settings.Name = "SingleFileUploadControl";
            settings.CallbackRouteValues = new { Controller = "File", Action = "SingleFileUploadControlUpload" };

            settings.ShowUploadButton = false;
            settings.ShowProgressPanel = true;
            settings.ShowClearFileSelectionButton = true;

            //setup validation
            RISARC.Web.EBubble.Models.DevxControlSettings.FileUploadControlSettings fileUploadControlSettings =
                new RISARC.Web.EBubble.Models.DevxControlSettings.FileUploadControlSettings();
            settings.ValidationSettings.Assign(fileUploadControlSettings.ValidationSettings);

            settings.NullText = "Click here to browse files...";
            settings.Width = Unit.Pixel(250);

            settings.ClientSideEvents.FileUploadStart = "function(s,e) { ClearFileContainer(); }";
            settings.ClientSideEvents.FileUploadComplete = "function(s,e) { if(e.callbackData != '') AddReleaseFileToContainer(e.callbackData);}";
            //settings.ClientSideEvents.FilesUploadComplete = "function(s,e) { Uploader_OnFilesUploadComplete(e); }";
            //settings.ClientSideEvents.UploadingProgressChanged = "function(s, e) { Uploader_ProgressChanged(e); }";
            settings.ClientSideEvents.TextChanged = "function(s, e) { UpdateSingleUploadButton(); }";

        }).Render();
    %>
    <% Html.EndForm(); %>
    <div class="buttons">
        <% Html.DevExpress().Button(
            settings =>
            {
                settings.Name = "btnUpload";
                settings.Text = "Upload";
                settings.ClientEnabled = false;
                settings.Style.Add("margin-top", "5px");
                settings.UseSubmitBehavior = false;
                settings.ClientSideEvents.Click = "function(s,e) { SingleFileUploadControl.Upload(); }";
            }).GetHtml();
        %>
    </div>
</div>
<%--<fieldset id="uploadedFiles" style="display: none;">
    <legend>Files successfully uploaded</legend>
    <div id="fileContainer" class="fileContainer">
    </div>
    <div id="removeError" style="display:none;color:red;">
       Error occurred while removing the file.     
    </div>
</fieldset>--%>

<br />
<br />
<div id="uploadedFiles" style="display: none;">
    <span class="floatLeft">Files successfully uploaded</span>
    <div id="fileContainer" class="fileContainer"></div>
    <div id="removeError" style="display: none; color: red;">Error occurred while removing the file.  </div>
</div>
