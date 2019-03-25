<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<RISARC.Documents.Model.Document>>" %>
"Document Type","Document Status","Sent On","Sent By","Sent for Request","Cost","Billing Method","# of Pages"
<% // below items need to all appear on same line to be exported properly
    foreach(var document in Model){ %>"<%= document.DocumentTypeName  %>","<%= 
        document.DocumentStatus %>","<%= String.Format("{0:f}", document.CreateDate) %>","<% 
        Html.RenderPartial("~/Views/User/UserDescriptionForReports.ascx", document.CreatedByUserDescription); %>","<%= 
        document.DocumentRequestId.HasValue ? "Yes" : "No" %>","$<%= String.Format("{0:f}", document.Cost) %>","<% 
        Html.RenderPartial("~/Views/ViewDocuments/DocumentBillingMethodDescription.ascx", document); %>",<%=
        document.NumberOfPages  %>
<%} %>
