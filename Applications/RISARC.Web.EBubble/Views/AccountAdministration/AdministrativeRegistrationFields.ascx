<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Membership.Model.RMSeBubbleMembershipUser>" %>

<li>
            <label for="Email">
                Email <span class="ValidationInstructor">*</span></label>
            <%= Html.StyledTextBox("Email", Model.Email) %>
            <%= Html.ValidationMessage("EmailRequired", "Required")%>
            <%= Html.ValidationMessage("EmailDuplicate", "A user with that e-mail address already exists. Please enter a different e-mail address.")%>
            <%= Html.ValidationMessage("EmailInvalid", "The e-mail address provided is invalid.")%>
</li>
<li>
    <label for="Title">
        Title</label>
    <%= Html.StyledTextBox("PersonalInformation.Title", Model.PersonalInformation.Title, 75, null)%>
</li>
<li>
    <label for="FirstName">
        First Name <span class="ValidationInstructor">*</span></label>
    <%= Html.StyledTextBox("PersonalInformation.FirstName", Model.PersonalInformation.FirstName, 50, null)%>
    <%= Html.ValidationMessage("PersonalInformation.FirstNameRequired", "Required")%>
</li>
<li>
    <label for="LastName">
        Last Name <span class="ValidationInstructor">*</span></label>
    <%= Html.StyledTextBox("PersonalInformation.LastName", Model.PersonalInformation.LastName, 50, null)%>
    <%= Html.ValidationMessage("PersonalInformation.LastNameRequired", "Required")%>
 </li>

<%  if((ViewData["rolesList"])!=null){ %>
<li>
     <label for="Role">
                Select Role<span class="ValidationInstructor">*</span> </label>
    <%  Html.DevExpress().ComboBoxFor(model => model.UserRolesList, settings =>
                       {
                           settings.Width = Unit.Percentage(25);
                           settings.SelectedIndex = 0;
                           settings.ControlStyle.CssClass = "RoleAcessTypes";
                           settings.Properties.TextField = "Text";
                           settings.Properties.ValueField = "Value";
                           settings.Properties.ValueType = typeof(string);
                           settings.ControlStyle.CssClass = "OrgNameSeachboxCls";
                       }).BindList(ViewData["rolesList"]).GetHtml();
         %>
                
</li>
<% } %>