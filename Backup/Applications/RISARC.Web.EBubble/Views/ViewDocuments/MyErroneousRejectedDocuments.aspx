<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<RISARC.Documents.Model.Document>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Documents Rejected By Reviewer
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <%
        int RejectedDocumentsCount = 0;
        if (Model != null)
        {
            RejectedDocumentsCount = Model.Count();
        }
    %>
    <h2>Erroneous / Rejected Documents </h2>

    <%if (RejectedDocumentsCount > 1)
      {%>
        <div class="totalAccount">Total <%= RejectedDocumentsCount%> accounts are rejected by reviewer.</div>
    <%}
      else if (RejectedDocumentsCount == 1)
      { %>
        <div class="totalAccount">Only <%= RejectedDocumentsCount%> account are rejected by reviewer.</div>
    <%} %>

    <% Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "GridViewForErroneousRejectedDocuments","ViewDocuments"); %>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>
