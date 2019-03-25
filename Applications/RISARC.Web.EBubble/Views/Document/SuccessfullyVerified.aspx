<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/StatusMessage.master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	You have successfully verified this document
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="StatusContents" runat="server">
<% int documentId = (int)ViewData["DocumentId"]; %>
<p>
You can now <%= Html.DocumentLink("download", documentId) %> this document.
    </p>
    <p>
        <%= Html.ActionLink("Return to your received documents", "MyReceivedDocuments", "ViewDocuments") %>
    </p>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="StatusHeader" runat="server">
You have successfully verified this document
</asp:Content>
