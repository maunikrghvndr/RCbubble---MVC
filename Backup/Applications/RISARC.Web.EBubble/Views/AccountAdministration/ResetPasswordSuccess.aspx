<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/StatusMessage.master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Password Successfully Reset
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="StatusContents" runat="server">

    <h2>Password Successfully Reset</h2>
    <p class="Instructions">
        Thank you. The member password has successfully been reset. Please notify the member to issue their temporary password. The member will be required to login and enter new password.</p>
    <h3>New Login Info for User</h3>
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
    <ul>
        <li>
            <%= Html.ActionLink("Back to User Administration",
                "AdministerUser",
                            new { emailAddress = Html.Encrypt(ViewData.GetValue(GlobalViewDataKey.Email)),
                                ReturnUrl = ViewData.GetValue(GlobalViewDataKey.ReturnUrl)}) 
                
                    %>
        </li>
        <%--<li>
            <a href="<%= ViewData.GetValue(GlobalViewDataKey.ReturnUrl) %>">
                Back to List Of Users
            </a>
        </li>--%>
    </ul>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="StatusHeader" runat="server">
</asp:Content>
