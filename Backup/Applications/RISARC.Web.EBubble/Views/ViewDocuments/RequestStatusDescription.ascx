<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<%@ Import Namespace="RISARC.Documents.Model" %>
<%--based on the document status, this will render text describing the status--%>
<% DocumentStatus status = (DocumentStatus)ViewData["DocumentStatus"];%>
<% if (status == DocumentStatus.RequestAwaitingDocument) { %>
    Document Requested Not Yet Received.
<% } else if (status == DocumentStatus.AwaitingComplianceApproval) { %>
    Document Requested Not Yet Received.
<% } else if (status == DocumentStatus.RequestRespondedTo) { %>
    Document Received.
<% } else if (status == DocumentStatus.Cancelled) { %>
    Request Cancelled.
<% } else if (status == DocumentStatus.ComplianceRejected) { %>
    Release Form Rejected.
<% } %>