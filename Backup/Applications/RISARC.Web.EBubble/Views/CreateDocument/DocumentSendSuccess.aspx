<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/StatusMessage.master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Document Successfully Sent 
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="StatusContents" runat="server">

    <p>
The recipient at the email <%= Html.Encode(ViewData["RecipientEmailAddress"]) %>  will receive an email allowing them to retrieve the document.  
</p>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="StatusHeader" runat="server">
    Document Successfully Sent
</asp:Content>
