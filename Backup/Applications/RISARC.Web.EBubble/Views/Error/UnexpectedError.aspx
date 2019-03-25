<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Error.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Unexpected Error Has Occured
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ErrorMessage" runat="server">

    <h2>We're sorry, but an unexpected error has occured in this application.</h2>

    <p>
        The site's administrators have been notified.
    </p>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ErrorHeader" runat="server">
</asp:Content>
