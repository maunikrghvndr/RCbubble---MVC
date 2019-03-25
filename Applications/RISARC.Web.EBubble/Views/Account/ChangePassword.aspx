<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Members.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="changePasswordTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Change Password
</asp:Content>
<asp:Content ID="changePasswordContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2>
        Change Password</h2>
    <p class="Instructions">
    New passwords require a minimum of 8 characters in length and must contain a capital letter, a number and only alphanumeric characters.
        </p>
    <%= Html.ValidationInstructionHeader() %>
   <%-- <%= Html.ValidationSummary("Password change was unsuccessful. Please correct the errors and try again.")%>--%>
    <% using (Html.BeginForm())
       { %>
    <%= Html.AntiForgeryToken() %>
    <ul>
        <% Html.RenderPartial("ChangePasswordFields"); %>
        <li>
            <input type="submit" value="Change Password" />
        </li>
    </ul>
    <% } %>
</asp:Content>
