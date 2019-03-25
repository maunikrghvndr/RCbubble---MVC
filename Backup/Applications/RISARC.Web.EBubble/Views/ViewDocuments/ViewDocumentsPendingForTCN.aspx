<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<RISARC.Documents.Model.Document>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Documents Pending For TCN
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <%
        int pendingDocumentsCount = 0;
        if (Model != null) {
            pendingDocumentsCount = Model.Count();
        }%>
   
<h2>Documents Pending For TCN</h2>

    <%if(pendingDocumentsCount>1) {%>
        <div class="totalAccount">Total <%= pendingDocumentsCount%> accounts are available for review.</div>
    <%  }else if (pendingDocumentsCount == 1) { %>
        <div class="totalAccount">Only <%= pendingDocumentsCount%> account is available for review.</div>
    <% } %>

    <%= Html.Partial("ApproveRejectPopup") %>
    <% Html.RenderPartial("pvDocumentPendingForTCN", Model); %>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>


