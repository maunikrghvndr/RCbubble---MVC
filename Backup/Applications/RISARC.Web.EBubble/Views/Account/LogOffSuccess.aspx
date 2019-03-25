<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/PublicStatusMessage.master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	You Have Securely Logged Out Of RMSe-bubble
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="StatusContents" runat="server">

    <h2>You Have Securely Logged Out Of RMSe-bubble</h2>
    <p>TIP: For your security, we recommend you to close your browser to exit 
        application.</p>

    <p class="Instructions">
        <%= Html.ActionLink("Click here", "LogOn") %>
        to log back in.
    </p>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="StatusHeader" runat="server">
</asp:Content>
