<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.eTAR.Model.AccountSubmissionDetails>" %>


<div class='dxc-padding12Left'>
    <% 
        Html.DevExpress().Memo(settings =>
        {
            settings.Name = "AdditionalTARLanguage";
            settings.Width = Unit.Percentage(98);
            settings.Properties.Rows = 15;
        }).Bind(Model.AdditionalTARLanguage).GetHtml();
    %>

    <div class="CommentSaveBtn">
    <% Html.DevExpress().Button(
         RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                           settings =>
                           {
                               settings.Name = "AdditionalTARLanguageAddButton";
                               settings.Text = "Save";
                               settings.ControlStyle.CssClass = "greyBtn";
                               settings.Width = System.Web.UI.WebControls.Unit.Percentage(10);
                               settings.ClientSideEvents.Click = "AddAdditionalTARLanguage";
                           })).GetHtml();
    %>
</div>


</div>

