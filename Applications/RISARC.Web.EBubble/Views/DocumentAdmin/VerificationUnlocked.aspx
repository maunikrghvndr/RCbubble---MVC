<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/StatusMessage.master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	The Document Has Been Unlocked
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="StatusContents" runat="server">
<p>
You have successfully unlocked the document.
<p><%= Html.ActionLink("Return to Provider's Documents", "ProvidersDocuments", "ViewDocuments") %></p>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="StatusHeader" runat="server">

	 The Document Has Been Unlocked
</asp:Content>
