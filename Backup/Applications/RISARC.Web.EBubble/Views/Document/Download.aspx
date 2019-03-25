<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Download Document
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Download Document</h2>
        
    <p class="Instructions">
        Download, view and save your document to a secure location. 
        Your document will be available for download for a limited time only.Please verify with your document Provider.</p>
    <h3>Click Link Below to Download Your Document</h3>
    
    <p>
           <% 
               Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html,"DownloadDocumentLink", "Document", new { documentId = Html.Encrypt(ViewData["DocumentId"]) }); %> 
            <%-- <% Html.RenderAction("DownloadDocumentLink", "Document", new { documentId = Html.Encrypt(ViewData["DocumentId"]) }); %> --%>
     </p>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>
