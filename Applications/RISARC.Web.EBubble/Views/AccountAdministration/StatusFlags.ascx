<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Membership.Model.RMSeBubbleMembershipUser>" %>
<span style="color: Red" id="span1">
    <% bool UserStatus= true;
        if (Model.IsLockedOut)
        {
            UserStatus = false;%>
    Locked Out
    <br />
    <%} %>
    <% if (Model.IsOnline)
       {%>
    <span style="color: Green">Online</span><br />
    <%} %>
    <% if (!Model.IsApproved)
       {UserStatus = false;%>
    Disabled
    <br />
    <%} %>
    <% if (Model.MemberRegistrationStatus.PasswordIsExpired)
       {UserStatus = false;%>
    New Password Required
    <br />
    <%} %>
    <% if (Model.MemberRegistrationStatus.RequiresEmailConfirmation)
       {UserStatus = false;%>
    Email Confirmation Required
    <br />
    <%} %>
    <% if (Model.MemberRegistrationStatus.RequiresFullRegistration)
       {UserStatus = false;%>
    Awaiting Registration Completion
    <br />
    <%} %>
</span>
 <input type="hidden" name="UserStatus" id="UserStatus" value="<%=UserStatus%>" />