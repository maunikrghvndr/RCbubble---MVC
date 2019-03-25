<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<div id="fileUploader">
    <div class="floatLeft">
        <%--<Form /> <%--Required for Dev express Upload Control. Don't Remove it [TTPRo bug No 212; 213]--%>
        <%--<Form action="">--%>
        <input type="hidden" id="IsFileUploaded" name="IsFileUploaded" value="false">
        <%
            Html.DevExpress().UploadControl(settings =>
            {
                settings.Name = "MultiSelectUploadControl";
                settings.CallbackRouteValues = new { Controller = "File", Action = "MultiSelectUploadControlUpload" };
                settings.Width = 325;
                settings.AdvancedModeSettings.EnableMultiSelect = true;

                settings.ShowUploadButton = false;
                settings.ShowProgressPanel = true;
                settings.ShowClearFileSelectionButton = true;

                //+UI
                settings.BrowseButton.Text = "Browse";
                //  settings.ControlStyle.BackColor = System.Drawing.ColorTranslator.FromHtml("#595959");

                //UI ends 

                //setup validation
                RISARC.Web.EBubble.Models.DevxControlSettings.FileUploadControlSettings fileUploadControlSettings =
                    new RISARC.Web.EBubble.Models.DevxControlSettings.FileUploadControlSettings();
                settings.ValidationSettings.Assign(fileUploadControlSettings.ValidationSettings);

                settings.NullText = "Click here to browse files...";

                settings.ClientSideEvents.FileUploadStart = "function(s,e) { ClearFileContainer(); }";
                settings.ClientSideEvents.FileUploadComplete = "function(s,e) { if(e.callbackData != '') AddFileToContainer(e.callbackData); }";
         
                settings.ClientSideEvents.TextChanged = "function(s, e) { UpdateUploadButton(); }";

            }).Render();
        %>
    </div>
    <div class="buttons floatRight">
        <% Html.DevExpress().Button(
            settings =>
            {
                settings.Name = "btnUpload";
                settings.Text = "Upload";
                settings.ClientEnabled = false;

                settings.Height = 32;
                settings.Width = 83;
                settings.ControlStyle.CssClass = "orangeBtn";

                settings.UseSubmitBehavior = false;
                settings.ClientSideEvents.Click = "function(s,e) { MultiSelectUploadControl.Upload(); }";

            }).GetHtml();
        %>
    </div>

</div>




<%--<fieldset id="uploadedFiles" style="display: none;">
    <legend>Files successfully uploaded</legend>
    <div id="fileContainer" class="fileContainer">
    </div>
    <div id="removeError" style="display: none; color: red;">
        Error occurred while removing the file.     
    </div>
</fieldset>
</div>--%>

<br />
<br />
<div id="uploadedFiles" style="display: none;">
    <span class="floatLeft">Files successfully uploaded</span>
    <div id="fileContainer" class="fileContainer"></div>
    <div id="removeError" style="display: none; color: red;">Error occurred while removing the file.  </div>
</div>