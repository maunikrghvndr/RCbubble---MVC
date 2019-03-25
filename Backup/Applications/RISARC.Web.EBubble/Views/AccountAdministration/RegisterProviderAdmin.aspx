<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.Master" Inherits="System.Web.Mvc.ViewPage<RISARC.Membership.Model.RMSeBubbleMembershipUser>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Add New Administrator to Provider
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
                                           
    <h2>Add New Administrator to Provider</h2>
     <p class="Instructions">
        Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor
        incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud
        exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute
        irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla
        pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia
        deserunt mollit anim id est laborum.</p>
        <%= Html.ValidationInstructionHeader() %>
 
    <h3>Enter Account Information Below for User to access RMSe-bubble</h3>
    <%using(Html.BeginForm()){ %>
    <%= Html.AntiForgeryToken() %>
    <ul>
        <li>
                <label for="ProviderMembership.ProviderId">Provider to Administrate</label>
                <%  Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "DisplayProviderName", "Setup", new { eProviderId = Html.Encrypt(ViewData["ProviderId"]) }); %>
                <%= Html.Hidden("ProviderMembership.ProviderId", Model.ProviderMembership.ProviderId) %>
            </li>
        <% Html.RenderPartial("AdministrativeRegistrationFields", Model,new ViewDataDictionary(ViewData) { { "rolesList",ViewData["RoleList"] }}); %>
            <li>
                <input type="submit" value="Create Administrator" />
            </li>
    </ul>
    <%} %>
    
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>
