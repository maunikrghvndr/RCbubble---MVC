<%@Language="C#" MasterPageFile="~/Views/Shared/Members.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="changePasswordTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Change Password
</asp:Content>

<asp:Content ID="changePasswordSuccessContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Change Password</h2>
    <p>
        Your password has been changed successfully.  <%= Html.ActionLink("Click here", "Members", "Home") %> to go to the home page.
    </p>
</asp:Content>
