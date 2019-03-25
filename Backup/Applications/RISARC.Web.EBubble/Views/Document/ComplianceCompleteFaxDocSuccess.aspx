<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/StatusMessage.master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Thank you for faxing the release form
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="StatusContents" runat="server">
 A member of our staff will review
       your faxed form. If it is approved, you will be notified and be able to continue to retrieve 
        the document.
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="StatusHeader" runat="server">
Thank you for faxing the release form
</asp:Content>
