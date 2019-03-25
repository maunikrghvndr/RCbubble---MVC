<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/StatusMessage.master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Your release forms are being reviewed.
</asp:Content>


<asp:Content ID="Content3" ContentPlaceHolderID="StatusHeader" runat="server">
Your release form are being reviewed.
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="StatusContents" runat="server">
    <p>
        The release forms you submitted are currently being reviewed by a member of our staff.  
        You will receive an email notification when they have been reviewed.
    </p>
    <p>
        <%= Html.ActionLink("Return to your received documents", "MyReceivedDocuments", "ViewDocuments") %>
    </p>
</asp:Content>

    
