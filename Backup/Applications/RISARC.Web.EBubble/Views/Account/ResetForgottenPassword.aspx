<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Public.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Reset Your Forgotten Password
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Reset Your Password</h2>
    <p class="Instructions">
        Enter the answer to your secret question to reset your forgotton password.  Your new password will be emailed to you.
    </p>
    <%= Html.ValidationInstructionHeader() %>
    <%using(Html.BeginForm("ResetForgottenPassword", "Account")){ %>
    <ul>
        <li>
            <label>Email</label> <%= Html.Encode(ViewData.GetValue(GlobalViewDataKey.Email))%>
            <%= Html.Hidden("emailAddress", ViewData.GetValue(GlobalViewDataKey.Email)) %>
        </li>
        <li>
            <label>Secret Question</label> <%= Html.Encode(ViewData["PasswordQuestion"]) %>
        </li>
        <li>
            <label for="questionAnswer">Security Answer</label>
            <%= Html.StyledTextBox("questionAnswer", null, 256, null) %>
            <%= Html.ValidationMessage("QuestionAnswerRequired", "Required")%>
            <%= Html.ValidationMessage("InvalidQuestionAnswer", "The answer provided does not match our records, please try again.")%>
            <%= Html.ValidationMessage("LockedOut", "You have exceeded the number of attempts to reset your password. Please contact your facility/provider to enable account.")%>
        </li>
        <li>
            <input type="submit" value="Reset Your Password" />
        </li>
    </ul>
    <%} %>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>