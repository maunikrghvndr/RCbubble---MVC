<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<li>
    <label for="CurrentPassword">
        Current password <span class="ValidationInstructor">*</span></label>
    <%= Html.Password("CurrentPassword") %>
    <%= Html.ValidationMessage("CurrentPasswordRequired", "Required")%>
    <%= Html.ValidationMessage("CurrentPasswordInvalid", "Password did not match the password in our system")%>
    <%= Html.ValidationMessage("AccountLockedOut", "You have exceeded the number of attempts to change your password. Please contact your facility/provider to enable account.")%>
</li>
<li>
    <label for="NewPassword">
        New password <span class="ValidationInstructor">*</span></label>
    <%= Html.Password("NewPassword") %>
    <%= Html.ValidationMessage("NewPasswordRequired", "Required")%>
    <%= Html.ValidationMessage("NewPasswordFormat", "New password must be at least 8 characters, and contain at least one capital letter and digit") %>
</li>
<li>
    <label for="ConfirmPassword">
        Confirm new password <span class="ValidationInstructor">*</span></label>
    <%= Html.Password("ConfirmPassword") %>
    <%= Html.ValidationMessage("ConfirmPasswordInvalid", "The new password and confirmation password do not match") %>
</li>
