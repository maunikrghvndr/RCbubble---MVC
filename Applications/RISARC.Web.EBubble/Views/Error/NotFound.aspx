<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Error.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Page Not Found
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ErrorHeader" runat="server">
We're sorry but the page you are looking for cannot be found
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ErrorMessage" runat="server">
<p>Please check the url and try again
</p>
    
</asp:Content>

