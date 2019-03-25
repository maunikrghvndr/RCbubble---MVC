<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<p class="account">
 
        [ <%= Html.ActionLink("Login", "LogOn", "Account") %> ]
        [ <%= Html.ActionLink("Register", "RegisterUser", "Account") %>  ]
</p>