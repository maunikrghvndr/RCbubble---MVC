<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Public.Master" Inherits="System.Web.Mvc.ViewPage<RISARC.Membership.Model.RMSeBubbleMembershipUser>" %>

<asp:Content ID="registerTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Register
</asp:Content>
<asp:Content ContentPlaceHolderID="AdditionalHeadContent" ID="additionalHead" runat="server">
    <script type="text/javascript" src="<%: Url.Content("~/scripts/Address.js")%>"></script>
    <% if(Request.RequestType == "GET"){ %>
            <%-- if request is get, clear all items on page--%>
        <script type="text/javascript">
            $(document).ready(function() {
                clearAllEntriesOnPage();
            });
        </script>
    <%} %>
</asp:Content>
<asp:Content ID="registerContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2>
        Create a New Account</h2>
    <p class="Instructions">
        To create a new account, please enter your information in the fields below.
        If you already have an existing RMSe-bubble account, 
        click on the login link to access documents in a fast and secure manner. Register now!
       </p>
    <%= Html.ValidationInstructionHeader() %>
    
    <%--<%= Html.ValidationSummary("Account creation was unsuccessful. Please correct the errors and try again.") %>--%>
    <% using (Html.BeginForm())
       { %>
       <%= Html.AntiForgeryToken() %>
       <h3>Account Information <span>Step 1</span></h3>
    <ul>
        <%--<li>
            <label for="UserName">
                Username <span class="ValidationInstructor">*</span></label>
            <%= Html.StyledTextBox("UserName", ViewData["UserName"]) %>
            <%= Html.ValidationMessage("UserName")%>
        </li>--%>
        <li>
            <label for="Email">
                Email <span class="ValidationInstructor">*</span></label>
            <%= Html.StyledTextBox("Email", Model.Email) %>
            <%= Html.ValidationMessage("EmailRequired", "Required")%>
            <%= Html.ValidationMessage("EmailDuplicate", "A user with that e-mail address already exists. Please enter a different e-mail address.")%>
            <%= Html.ValidationMessage("EmailInvalid", "The e-mail address provided is invalid.") %>
        </li>
        <li>
            <label for="Password">
                Password<span class="ValidationInstructor">*</span></label>
            <%= Html.Password("Password", null, new { @class = "input_text" })%>
            <%= Html.ValidationMessage("Password")%>
            <div class="FieldInstructions">New passwords require a minimum of 8 characters in length and must contain a capital letter, a number and only alphanumeric characters.</div>
        </li>
        <li>
            <label for="ConfirmPassword">
                Confirm password <span class="ValidationInstructor">*</span></label>
            <%= Html.Password("ConfirmPassword", null, new { @class = "input_text" })%>
            <%= Html.ValidationMessage("ConfirmPassword")%>
        </li>
        <% Html.RenderPartial("PasswordQuestionAnswerFields"); %>
    </ul>
    <h3>Personal Information <span>Step 2</span></h3>
    <ul>
    <% 
        ViewDataDictionary personalInformationViewData = new ViewDataDictionary();
        personalInformationViewData.SetValue(GlobalViewDataKey.BindingPrefix, "PersonalInformation.");
        personalInformationViewData.ModelState.Merge(ViewData.ModelState);
        Html.RenderPartial("PersonalInformationFields", Model.PersonalInformation, personalInformationViewData); %>
    <li>
        <%= Html.CheckBox("AgreeTerms", (bool)ViewData["AgreeTerms"], new {@class="input_check" })%> <label for="AgreeTerms">I accept and understand the <%= Html.ActionLink("Terms and Conditions", "Terms", "Legal", null, new { target = "_blank" }) %></label>
        <%= Html.ValidationMessage("AgreeTermsRequired", "You must read and accept Terms and Conditions before registering.")  %>
    </li>
    <li>
        <input type="submit" value="Register" />
    </li>
    </ul>
    <% } %>
</asp:Content>
