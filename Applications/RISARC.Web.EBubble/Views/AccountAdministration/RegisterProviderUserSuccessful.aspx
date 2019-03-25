<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/StatusMessage.master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	User Successfully Registered for your Provider
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="StatusContents" runat="server">

    <h2>User Has Successfully Been Registered for Your Provider</h2>
    <p class="Instructions">
        Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor
        incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud
        exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute
        irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla
        pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia
        deserunt mollit anim id est laborum.</p>
    <h3>Login Info for New User</h3>
    <table class="data_table">
        <tr>
            <td class="headerCell">
                Email
            </td>
            <td>
                <%= Html.Encode(ViewData.GetValue(GlobalViewDataKey.Email)) %>
            </td>
        </tr>
        <tr class="alt">
            <td class="headerCell">
                Password
            </td>
            <td>
                <%= Html.Encode(ViewData["Password"]) %>
            </td>
        </tr>
    </table>
    
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="StatusHeader" runat="server">
</asp:Content>
