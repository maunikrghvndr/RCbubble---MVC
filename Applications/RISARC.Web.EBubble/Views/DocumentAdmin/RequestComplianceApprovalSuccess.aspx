<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/StatusMessage.master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	 <% if ((bool)ViewData["Approved"])
     { %>
        User's Submitted Release Form Accepted
	 <%}
     else
     {    %>
        User's Submitted Release Form Rejected
     
     <%} %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="StatusContents" runat="server">

<% if ((bool)ViewData["Approved"])
     { %>
        <p>The user's release form has been approved.</p>
        <p><%= Html.ActionLink("Continue To Respond to Request", "RequestAdmin", "DocumentAdmin", new { requestId = Html.Encrypt(ViewData["RequestId"]) }, null)%></p>        
	 <%}
     else
     {    %>
        <p>USER’S RELEASE FORM HAS BEEN DENIED AND THEY HAVE BEEN NOTIFIED</p>
     
     <%} %>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="StatusHeader" runat="server">

	 <% if ((bool)ViewData["Approved"])
     { %>
        User's Submitted Release Form Accepted
	 <%}
     else
     {    %>
        User's Submitted Release Form Rejected
     
     <%} %>
</asp:Content>
