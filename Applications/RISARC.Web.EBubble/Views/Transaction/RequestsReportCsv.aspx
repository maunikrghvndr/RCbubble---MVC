<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<RISARC.Documents.Model.DocumentRequest>>" %>
"Requested Document Type","Requested Document Description","Request Status","Date/Time Requested","Response Due By","Requested By","Responded to With Document"
<% // below items need to all appear on same line to be exported properly
    foreach(var request in Model){ %>"<%=  request.DocumentTypeName  %>","<%= request.DocumentDescription %>","<%=  
        request.DocumentStatus %>","<%= String.Format("{0:f}", request.RequestDate) %>","<%= String.Format("{0:f}", request.RequestDueBy) %>","<% 
        Html.RenderPartial("~/Views/User/UserDescriptionForReports.ascx", request.CreatedByUserDescription); %>","<%= 
        request.RespondedToByDocumentId.HasValue ? "Yes" : "No" %>"
<%} %>
