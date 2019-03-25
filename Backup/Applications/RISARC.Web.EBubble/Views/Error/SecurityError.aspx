<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Error.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Security Error
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ErrorHeader" runat="server">
You do not have the valid security clearance to perform this action or access this document.
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ErrorMessage" runat="server">
<p>Please <%= Html.ActionLink("log-in", "LogOn", "Account", new {ReturnUrl = Request.QueryString["ReturnUrl"]}, null ) %>  with the valid security credentials and try again.
</p>
    
</asp:Content>

