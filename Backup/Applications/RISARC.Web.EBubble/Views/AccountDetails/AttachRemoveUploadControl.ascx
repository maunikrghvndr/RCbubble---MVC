<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<div class="error"></div>

<ul class="UploadHeader">
    <li><%  Html.DevExpress().TextBox(
                                 settings =>
                                 {
                                     settings.Name = "txtTCNNumber";
                                     settings.Width = 260;
                                     settings.Height = 32;
                                     settings.Properties.NullText = "Enter TCN #";
                                     settings.ControlStyle.CssClass = "dxc-textBoxPadding dxc-AttachRemoveTCN"; // For padding Purpose
                                 }).GetHtml();

    %></li>
    <li class="uploadbrowser">
        <%   Html.BeginForm("MultiSelectUploadControlForm", "UploadControl", FormMethod.Post); %>
        <input type="hidden" id="Hidden1" name="IsFileUploaded" value="false">

        <%  Html.DevExpress().UploadControl(settingsUpload =>
                   {
                       settingsUpload.Name = "TCNMultiSelectUploadControl";
                       settingsUpload.CallbackRouteValues = new { Controller = "File", Action = "MultiSelectTCNFileUploadControlUpload" };
                       //    //settingsUpload.ControlStyle.CssClass = "OrgNameSeachboxCls"; // For padding Purpose
                       settingsUpload.AdvancedModeSettings.EnableMultiSelect = true;
                       settingsUpload.Width = 350;
                       settingsUpload.Height = 32;
                       settingsUpload.ControlStyle.Paddings.Padding = 10;
                       settingsUpload.ShowUploadButton = false;
                       settingsUpload.ShowProgressPanel = true;
                       settingsUpload.ShowClearFileSelectionButton = true;
                       ////setup validation
                       RISARC.Web.EBubble.Models.DevxControlSettings.FileUploadControlSettings fileUploadControlSettings =
                       new RISARC.Web.EBubble.Models.DevxControlSettings.FileUploadControlSettings();

                       settingsUpload.ValidationSettings.Assign(fileUploadControlSettings.ValidationSettings);
                       settingsUpload.NullText = "Click here to browse files...";
                       settingsUpload.ClientSideEvents.FileUploadComplete = "function(s,e) { if(e.callbackData == 'true') AddTCNFileToContainer(e.callbackData); }";

                       settingsUpload.ClientSideEvents.TextChanged = "function(s, e) { UpdateTCNUploadButton(); }";

                   }).Render();
        %>

    </li>
    <li>
        <%   Html.DevExpress().Button(
                         settingsUpload =>
                         {
                             settingsUpload.Name = "btnUpload";
                             settingsUpload.Text = "Attach";
                             settingsUpload.ControlStyle.CssClass = "orangeBtn";
                             settingsUpload.Width = Unit.Pixel(100);
                             settingsUpload.Height = Unit.Pixel(32);
                             settingsUpload.UseSubmitBehavior = false;
                             settingsUpload.ClientSideEvents.Click = "function(s,e) { SetTCNNumberAndRecipientProviderId(); }";
                         }).GetHtml();

             Html.EndForm();
        %>


    </li>
</ul>
<div class="FixiedHT12 clear">&nbsp;</div>