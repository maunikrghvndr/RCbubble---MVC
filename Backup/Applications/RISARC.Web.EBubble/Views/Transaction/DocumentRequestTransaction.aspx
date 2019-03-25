<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<RISARC.Documents.Model.DocumentRequest>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Document Request Information
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Document Request Information</h2>
    
    <h3>Request Summary</h3>
        <% Html.RenderPartial("~/Views/DocumentAdmin/RequestDetails.ascx", Model); %>

    <h3>History of Request</h3>
    <%  Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "RequestActionLogHistory", "Transaction", new { requestId = Html.Encrypt(Model.Id) }); %>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>
