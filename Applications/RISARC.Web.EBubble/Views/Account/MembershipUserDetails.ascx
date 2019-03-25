<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Membership.Model.RMSeBubbleMembershipUser>" %>
<h3>
    Summary</h3>

<% Html.RenderPartial("AccountSummary", Model); %>

<%= Html.ActionLink("Change Password", "ChangePassword") %>

<% // if user belongs to provider member, then render user's document types
    if(Model.ProviderMembership != null){ %>
    <h3>Available Document Types</h3>
    <div class="Instructions">These determine which document types you can receive, and which types of requests you can respond to.  
    To add or remove document types from this list, please contact your provider's administrator.</div>
    <%  Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "UserDocumentTypesList", "AccountAdministration", new { userName = Html.Encrypt(ViewData["UserName"]), showFormActions = false }); %>
    
<%using(Html.BeginForm("EditUserDocumentPatientAlphapost", "Account")){ %>
<%= Html.AntiForgeryToken() %>

    <%  Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "ShowUserDocumentPatientAlpha", "AccountAdministration", new { userName = Html.Encrypt(ViewData["UserName"]), showFormActions = false });  %>
<%--<ul>
    <li>
        <label for="PatientFirstAlpha">Only receive requests of the above document types for patients with last name beginning</label>
        <% Html.RenderAction<RISARC.Web.EBubble.Controllers.SetupController>(x => x.AlphaDropDown("patientFirstAlpha",
               null, (char)ViewData["PatientFirstAlpha"]));  %>
    </li><li>
        <label for="PatientLastAlpha">Only receive requests of the above document types for patients with last name ending</label>
        <% Html.RenderAction<RISARC.Web.EBubble.Controllers.SetupController>(x => x.AlphaDropDown("patientLastAlpha",
               null, (char)ViewData["PatientLastAlpha"]));  %></li>
    <li>
        <input type="submit" value="update" />
    </li>
</ul>--%>
<%} %>
<%} %>

<h3>Personal Information</h3>
<% Html.RenderPartial("PersonalInformationDetails", Model.PersonalInformation); %>
<%= Html.ActionLink("Edit Personal Information", "UpdatePersonalInformation") %>