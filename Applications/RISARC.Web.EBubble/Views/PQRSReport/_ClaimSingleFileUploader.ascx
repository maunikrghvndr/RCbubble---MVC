<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>


<div id="ClaimFileUploader">
    <div class="floatLeft">

        <input type="hidden" id="IsFileUploaded" name="IsFileUploaded" value="false">
        <%
            Html.DevExpress().UploadControl(settings =>
            {
                settings.Name = "ClaimFileUpload";
                settings.CallbackRouteValues = new { Controller = "File", Action = "ClaimFileUpload" };

                settings.Width = 300;
                settings.AdvancedModeSettings.EnableMultiSelect = true;
                //settings.ClientSideEvents.UploadingProgressChanged = "function(s,e){ alert('started');}";
                settings.ShowUploadButton = false;
                settings.ShowProgressPanel = true;
                settings.ShowClearFileSelectionButton = true;

                //+UI
                settings.BrowseButton.Text = "Browse";


                //UI ends 

                //setup validation
                //RISARC.Web.EBubble.Models.DevxControlSettings.FileUploadControlSettings fileUploadControlSettings =
                //    new RISARC.Web.EBubble.Models.DevxControlSettings.FileUploadControlSettings();
                //settings.ValidationSettings.Assign(fileUploadControlSettings.ValidationSettings);

                //settings.ValidationSettings.AllowedFileExtensions = new string[] { ".txt" };
                //settings.ValidationSettings.NotAllowedFileExtensionErrorText = "Upload only .txt extension files";
                
                
                
                settings.NullText = "Select File(s) to Upload";

                settings.ClientSideEvents.FileUploadStart = "function(s,e) {time = 60 ; getTokenExpirationTime(); ClearFileContainer(); }";
                settings.ClientSideEvents.FileUploadComplete = "function(s,e) { if(e.callbackData != '') AddClaimFileToContainer(e.callbackData); } ";

                settings.ClientSideEvents.TextChanged = "function(s, e) { UpdateSingleFileUploadButton(); }";

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
                settings.ClientSideEvents.Click = "function(s,e) { ClaimFileUpload.Upload(); }";

            }).GetHtml();
        %>
    </div>
</div>
<%= Html.Hidden("UploadedFileId", ViewData["DocumentFileId"])%>

