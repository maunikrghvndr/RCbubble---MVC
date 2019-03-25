<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>


<div class="account">
    <ul>
        <li>Welcome, <% Html.RenderAction<RISARC.Web.EBubble.Controllers.AccountController>(x => x.GetLoggedInUsersFullName()); %></li>
        <li><%= Html.ActionLink("My Account", "Index", "Account",null, new { onclick = "generalizedShowLoader();" })%></li>
        <li><%= Html.ActionLink("Logout", "LogOff", "Account", null, new { id = "lnkLogOff" })%></li>
    </ul>
</div>
<% if (!(Request.Url.AbsolutePath.Contains("AccountDetailsMaster")))
   { %>

<% Html.RenderPartial("EnterDocumentID"); %>
<% }  %>