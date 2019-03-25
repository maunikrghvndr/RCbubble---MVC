<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/StatusMessage.master"
    Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Thanks for Paying for Your Medical Document
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StatusContents" runat="server">
<% string encryptedDocumentId = Html.Encrypt(ViewData["DocumentId"]);  %>
    <p>
        Thank you for paying for Your Medical Document.
    </p>
    <p>
        <%= Html.DocumentLink("Go to the document download page", encryptedDocumentId) %>
    </p>
    <p>
        <%= Html.ActionLink("Return to your received documents", "MyReceivedDocuments", "ViewDocuments") %>
    </p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="StatusHeader" runat="server">
    Thanks for Paying for Your Medical Document
</asp:Content>
