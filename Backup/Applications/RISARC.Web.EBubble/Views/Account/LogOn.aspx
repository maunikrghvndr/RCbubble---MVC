<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Public.Master" Inherits="System.Web.Mvc.ViewPage" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {

    }
</script>

<asp:Content ID="loginTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Log On
</asp:Content>
<asp:Content ID="loginContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2>
        Login</h2>
    <p class="Instructions">
        Please enter your email and password.
        <%= Html.ActionLink("Register", "RegisterUser", new { ReturnUrl = ViewData.GetValue(GlobalViewDataKey.ReturnUrl) })%>
        if you don't have an account.
    </p>
    <%= Html.ValidationSummary("Login was unsuccessful.") %>
    <%= Html.ValidationMessage("InvalidEmailPassword", "The email and/or password are incorrect. Please try again.")%>
    <%= Html.ValidationMessage("LockedOut", "You have exceeded the number of attempts to login. Please contact your facility/provider to enable account.")%>
     <!----for not allowing the Disabled User to log in (by abdul)---->
    <%= Html.ValidationMessage("Approved", "Your account is Currently Disabled") %>
   
   
    
     <% using (Html.BeginForm())
       { %>
       <%= Html.AntiForgeryToken() %>
       <%= Html.Hidden("ReturnUrlIsGet", ViewData["ReturnUrlIsGet"]) %>
    <ul>
        <li>
            <label for="emailAddress">
                Email</label>
            <%--<%= Html.StyledTextBox("emailAddress") %>--%>
            <%= Html.StyledTextBox("emailAddress", "risarc-ehr_ehrdev@cybage.com") %>
            <%= Html.ValidationMessage("EmailRequired", "Required")%>
        </li>
        <li>
            <label for="password">
                Password</label>
            <%--<%= Html.Password("password", null, new { @class = "input_text" })%>--%>
            <%= Html.Password("password", "Cybage123", new { @class = "input_text" })%>
            <%= Html.ValidationMessage("PasswordRequired", "Required") %>
        </li>
        <li>
            <%= Html.ActionLink("Forgot Your Password?", "ForgotPassword") %>
        </li>
        <li>
            <input type="submit" value="Log On"  />
        </li>
    </ul>
    <% } %>
</asp:Content>
