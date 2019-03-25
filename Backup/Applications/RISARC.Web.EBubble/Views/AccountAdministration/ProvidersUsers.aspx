<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<RISARC.Membership.Model.RMSeBubbleMembershipUser>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    User's Accounts
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <input type="hidden" name="ResponsibleMemValues" id="ResponsibleMemValues" value="" />
    <input type="hidden" name="ExtAcessMemCheck" id="ExtAcessMemCheck" value="" />
    <input type="hidden" name="ExtAcessMemUnCheck" id="ExtAcessMemUnCheck" value="" />
    <div class="statusMessage" style="display: none;">
    User Accounts  Updated SuccessFully
    </div>
    <h2>User's Accounts      <span class="floatRight">
        <% Html.DevExpress().Button(
                                   RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                                   settings =>
                                   {
                                       settings.Name = "btnAddUser";
                                       settings.ControlStyle.CssClass = "orangeBtn adminHeadMargin";
                                       settings.UseSubmitBehavior = false;
                                       settings.Text = "Add User";
                                       settings.RouteValues = new { Controller = "AccountAdministration", Action = "RegisterProviderUser" };

                                   })).GetHtml(); %>
    </span>

    </h2>

    <div class="totalAccount">Add, edit and assign account information for users</div>
    <% Html.RenderPartial("_gvUsersAccounts", Model); %>

    <div class="adminAction">
        <div class="floatLeft">
            <% Html.DevExpress().Button(
                                   RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                           settings =>
                           {
                               settings.Name = "btnSave";
                               settings.UseSubmitBehavior = true;
                               settings.ControlStyle.CssClass = "orangeBtn";
                               settings.Text = "Save";
                               settings.ClientSideEvents.Click = "Save";

                               settings.ClientEnabled = false;
                               

                           })).GetHtml(); %>
        </div>

        <div class="floatRight">
            <% Html.DevExpress().Button(
                                   RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                                   settings =>
                                   {
                                       settings.Name = "btnCancel";
                                       settings.ControlStyle.CssClass = "greyBtn";
                                       settings.UseSubmitBehavior = false;
                                       settings.Text = "Cancel";
                                       settings.ClientSideEvents.Click = "function(s, e) {Cancel(s,e);}";

                                   })).GetHtml(); %>
        </div>



    </div>

    <%= Html.Partial("confirmPopup") %>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">

    <script type="text/javascript" src="<%: Url.Content("~/scripts/UserAdminTableScript.js")%>"></script>

</asp:Content>
