<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/StatusMessage.master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Document Request Successfully Responded To
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="StatusContents" runat="server">

<p>
The recipient should now be able to purchase and download the document you sent.  
<%= Html.ActionLink("Click here", "MyOutstandingRequests", "ViewDocuments")%> to view your outstanding requests.
</p>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="StatusHeader" runat="server">

    Document Request Successfully Responded To
</asp:Content>
