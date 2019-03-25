<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/PublicStatusMessage.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	New Password Successfully Set
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="StatusContents" runat="server">

    <h2>You Have Successfully Set Your New Password</h2>

    <p>
        <%= Html.ActionLink("Click Here", "LogOn") %> to log in with your User Name and New Password.
    </p>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="StatusHeader" runat="server">
</asp:Content>
