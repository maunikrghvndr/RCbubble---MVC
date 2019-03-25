<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<RISARC.Membership.Model.RMSeBubbleMembershipUser>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    User Roles
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">


    <h2>User Roles</h2>
    <div class="totalAccount">
        Click edit to configure roles accordings to users 
            <div class="floatRight ReviewersList">

                     <%  Html.DevExpress().Button(
                   settings =>
                   {
                       settings.Name = "AddUser";
                       settings.ControlStyle.CssClass = "orangeBtn clsLoader";
                       settings.Width = Unit.Pixel(90);
                      
                       settings.Text = "Add User";
                       settings.RouteValues = new { Controller = "AccountAdministration", Action = "RegisterProviderUser", ur = "1" };
                   }).GetHtml();  %>

            </div>

    </div>





    <%  if (!String.IsNullOrEmpty(Convert.ToString(ViewData["Status"])))
        { %>
    <div class="statusMessage">
        <% Response.Write(ViewData["Status"]);  %>
    </div>
    <% } %>

    <% Html.RenderPartial("UserRolesPatial", Model); %>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>
