<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<%using (Html.BeginForm("ConfirmEmail", "Account"))
  { %>
  <%= Html.AntiForgeryToken() %>
  <%= Html.Hidden("emailAddress", ViewData.GetValue(GlobalViewDataKey.Email))%>
  <%= Html.Hidden("ReturnUrl", ViewData.GetValue(GlobalViewDataKey.ReturnUrl)) %>
<ul>
    <li>
        <label for="EmailConfirmationId">
            Confirmation ID</label>
        <%= Html.StyledTextBox("EmailConfirmationId") %>
        <%= Html.ValidationMessage("EmailConfirmation") %>
        <div class="FieldInstructions"><%--<strong>Confirmation Id</strong> is case-sensitive.--%>  Enter the Confirmation ID exactly as it was sent to you in the email.</div>
    </li>
    <li>
        <input type="submit" value="Confirm Email Address" />
    </li>
</ul>
<%} %>