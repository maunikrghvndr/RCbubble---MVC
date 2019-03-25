<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.eTAR.Model.AccountSubmissionDetails>" %>


<div class='dxc-padding12Left'>
    <% 
        Html.DevExpress().Memo(settings =>
        {
            settings.Name = "Comments";
            settings.Width = Unit.Percentage(98);
            //settings.Height = Unit.Percentage(100);
            settings.Properties.Rows = 10;
            //Max Length of TAR Language Comment is 500 characters
            settings.Properties.MaxLength = 500;
            
        }).Bind(Model.Comments).GetHtml();
    %>
</div>

    <div class="CommentSaveBtn">
    <% Html.DevExpress().Button(
         RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                           settings =>
                           {
                               settings.Name = "CommentsAddButton";
                               settings.Text = "Save";
                               settings.ControlStyle.CssClass = "greyBtn";
                               settings.Width = System.Web.UI.WebControls.Unit.Percentage(10);
                               settings.ClientSideEvents.Click = "AddComments";
                           })).GetHtml();
    %>
 </div>

