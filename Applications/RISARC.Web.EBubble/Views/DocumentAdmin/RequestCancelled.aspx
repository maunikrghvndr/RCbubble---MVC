<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/StatusMessage.master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	 The Member’s submitted request has been cancelled and they have been notified
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="StatusContents" runat="server">
<p>
 The member who submitted this request will receive an email notification indicating that the request was cancelled for the reason you indicated.

</p>
<p>

<%= Html.ActionLink("Return to Outstanding Requests", "MyOutstandingRequests", "ViewDocuments")%></p>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="StatusHeader" runat="server">

	 The member's submitted request has been cancelled and they have been notified
</asp:Content>
