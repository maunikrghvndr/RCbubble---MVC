<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<RISARC.Documents.Model.Document>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Documents Reviewed by DHS
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <%
        int reviewedDocumentsCount = 0;
        if (Model != null)
        {
            reviewedDocumentsCount = Model.Count();
        }
    %>
    <h2>Documents Reviewed by DHS</h2>

    <%if (reviewedDocumentsCount > 1)
      {%>

    <div class="totalAccount">Total <%= reviewedDocumentsCount%> Documents are reviewed by DHS </div>
    <%}
      else if (reviewedDocumentsCount == 1)
      { %>

    <div class="totalAccount">Only <%= reviewedDocumentsCount%> Documents are reviewed by DHS </div>
    <%} %>
  

    <% Html.RenderPartial("pvDocumentsReviewedByDHS", Model); %>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>


