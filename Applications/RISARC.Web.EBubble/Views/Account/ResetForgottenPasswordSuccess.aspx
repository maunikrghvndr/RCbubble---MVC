<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/PublicStatusMessage.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	You Have Successfully Reset Your Password
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="StatusContents" runat="server">

    <h2>You Have Successfully Reset Your Password</h2>
    
    <p>
        <strong>Your new password has been e-mailed to you at <%= ViewData.GetValue(GlobalViewDataKey.Email) %>.</strong>  Please open the email that was sent to you to get your new password.
    </p>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="StatusHeader" runat="server">
</asp:Content>
