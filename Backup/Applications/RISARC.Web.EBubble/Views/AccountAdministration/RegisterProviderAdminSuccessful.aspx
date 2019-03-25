<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/StatusMessage.master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	You Have Successfully Created an Administrator for a Provider
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="StatusContents" runat="server">

    <h2>You Have Successfully Created an Administrator for a Provider</h2>
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
