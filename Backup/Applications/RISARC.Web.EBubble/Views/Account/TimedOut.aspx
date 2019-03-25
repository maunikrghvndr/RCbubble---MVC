<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/PublicStatusMessage.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	You Have Been Logged Off Due to Inactivity
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="StatusContents" runat="server">

    <h2>You Have Been Logged Off Due to Inactivity</h2>

    <p class="Instructions">
        <%= Html.ActionLink("Click here", "LogOn") %>
        to log back in.
    </p>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="StatusHeader" runat="server">
</asp:Content>
