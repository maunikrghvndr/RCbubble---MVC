<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
RISARC Consulting, LLC &#169; 2009. All Rights Reserved.
<%= Html.ActionLink("Contact", "Contact", "Home") %>
|
<%= Html.ActionLink("Support", "Support", "Home")%>
|
<%= Html.ActionLink("Terms of Use", "Terms", "Legal", null, new { target = "_blank" })%>
|
<%= Html.ActionLink("Privacy Policy", "Privacy", "Legal", null, new { target = "_blank" })%>
| <a href="http://www.risarc.com/aboutus.htm" target="_blank">About Us</a> 