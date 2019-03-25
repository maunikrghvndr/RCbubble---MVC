<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<RISARC.Documents.Model.Document>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Document Information
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Document Information</h2>
    
    <h3>Document Summary</h3>
        <% Html.RenderPartial("DocumentTransactionSummary", Model); %>

    <h3>History of Document</h3>
    <% Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "DocumentActionLogHistory", "ViewDocuments", new { documentId = Html.Encrypt(Model.Id) }); %>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>
