<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage" %>

<%@ Import Namespace="RISARC.Membership.Model" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Administrate Users
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Select User to Administrate</h2>
    <div class="totalAccount">Search by username/email address</div>

    <div class="mvUp">
    <% using (Html.BeginForm("FindUserByUserName", "AccountAdministration"))
       { %>
    <div class="error"></div>
    <div class="clswidth350 ">

        <div class="floatLeft">
            <% Html.DevExpress().TextBox(
                settings =>
                {
                    settings.Name = "userName";

                    settings.Width = 238;
                    settings.Height = 32;

                   

                    if (ViewData["UserName"] != null)
                    {

                        settings.Text = ViewData["UserName"].ToString();
                    }
                    else
                    {
                        settings.Properties.NullText = "Search";
                    }

                    settings.ControlStyle.CssClass = "dxcTextBoxSearchIcon dxcTextBoxStyle";

                    //settings.ControlStyle.BackColor = System.Drawing.ColorTranslator.FromHtml("#f7f7f7");
                    //settings.Properties.FocusedStyle.BackColor = System.Drawing.ColorTranslator.FromHtml("#ffffff");
                  //  settings.Properties.c
                    
                    
                }
            ).GetHtml(); %>
        </div>

        <div class="floatRight">

            <% Html.DevExpress().Button(
                                   RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                                   settings =>
                                   {
                                       settings.Name = "FindUser";
                                       settings.Width = 100;
                                       settings.ControlStyle.CssClass = "orangeBtn";
                                       settings.Text = "Find User";
                                       settings.ClientSideEvents.Click = "findUser";
                                       settings.UseSubmitBehavior = false;

                                   })).GetHtml(); %>
        </div>

    </div>

    <% } %>
   </div>
    <div>
        <br />
        <br />
        <br />
    </div>

    <% // hack: only display results if form post
        if (Request.HttpMethod.ToLower() == "post")
        {
            var user = ViewData["User"] as System.Collections.ObjectModel.Collection<RMSeBubbleMembershipUser>;
            if (user == null)
            {%>
    <div class="errorMessage">No user exists with that username/email address.</div>
    <%}
            else
            {%>
    <h2>Administrate User</h2>
    <div class="totalAccount">Manage user settings by clicking on the Administrate link </div>
    <% 
                   // view expects collection of user, so convert to collection
                   Html.RenderPartial("_gvUsersAccounts", user as System.Collections.ObjectModel.Collection<RMSeBubbleMembershipUser>); %>

    <%}
        } %>


</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
    <%--    <script type="text/javascript" src="<%: Url.Content("~/scripts/UserAdminTableScript.js")%>"></script>--%>
    <script>
        function OnSelectionChanged(s, e) { }

        function findUser(s,e) {
            var userName = $("#userName_I").val();
    
            if (userName == null || userName=="Search") {
                $(".error").html("Please enter either username or email address");
                return false;
            }

            $(".error").html("");
            $("form").submit();
            return true;


        }
    </script>
</asp:Content>
