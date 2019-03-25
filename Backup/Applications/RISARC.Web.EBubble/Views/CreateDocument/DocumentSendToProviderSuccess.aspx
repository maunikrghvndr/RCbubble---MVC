<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/StatusMessage.master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Document Successfully Sent to Provider
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="StatusContents" runat="server">

    <p>
    You have successfully sent a document to a provider.
</p>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="StatusHeader" runat="server">
    Document Successfully Sent to Provider
</asp:Content>
