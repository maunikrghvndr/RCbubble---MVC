<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<ul class="tcnStatusList">
    <li><b>CONFIRM YOUR WORK STATUS BEFORE YOU EXIT </b></li>
    <li><b>Pending:</b> Saves the current record and returns to worklist</li>
    <li><b>Reviewed:</b> Saves and removes current record from worklist and places it in the Global Search worklist</li>
    <li><b>Cancel:</b> Takes you back to the previous screen without saving</li>
</ul>
<br />
<div class="statusButtons">
    <ul class="StatusTBUl">
        <li><% Html.DevExpress().Button(
                                   RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                           settings =>
                           {
                               settings.Name = "statusSaveBtn";
                               settings.Text = "Pending";
                               settings.Width = System.Web.UI.WebControls.Unit.Percentage(100);
                               settings.ClientSideEvents.Click = "function(s,e){ StatusSaveClick(s,e,\"saveBtn\"); }";
                           })).GetHtml(); %></li>
        <li>
            <% Html.DevExpress().Button(
                                   RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                           settings =>
                           {
                               settings.Name = "statusSubmitBtn";
                               settings.Text = "Reviewed";
                               settings.Width = System.Web.UI.WebControls.Unit.Percentage(100);
                               settings.ClientSideEvents.Click = "function(s,e){ StatusSaveClick(s,e,\"submitBtn\"); }";
                               settings.ClientEnabled = true;
                           })).GetHtml(); %>
        </li>
        <li>
            <% Html.DevExpress().Button(
                                   RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                           settings =>
                           {
                               settings.Name = "statusCancelBtn";
                               settings.Text = "Cancel";
                               settings.ControlStyle.CssClass = "greyBtn";
                               settings.Width = System.Web.UI.WebControls.Unit.Percentage(100);
                               settings.ClientSideEvents.Click = "function(s, e) { TCNStatusCancelBtnClick(s,e) }";
                           })).GetHtml();
            %>
        </li>
    </ul>
</div>
