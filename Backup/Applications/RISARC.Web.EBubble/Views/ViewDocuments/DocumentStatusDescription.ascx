<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<%@ Import Namespace="RISARC.Documents.Model" %>
<%--based on the document status, this will render text describing the status--%>
<% DocumentStatus status = (DocumentStatus)ViewData["DocumentStatus"];%>
<% if (status == DocumentStatus.AwaitingVerification) { %>
    Identity verification needed
<% } else if (status == DocumentStatus.LockedOutFromAttemptedVerifications) { %>
    Locked
<% } else if (status == DocumentStatus.ReadyForCompliance) { %>
    Release form needed
<% } else if (status == DocumentStatus.AwaitingComplianceApproval) { %>
    Pending release form approval
<% } else if (status == DocumentStatus.ReadyForPurchase) { %>
    Available for purchase
<% } else if (status == DocumentStatus.ReadyForDownload) { %>
    Available to download
<% } else if (status == DocumentStatus.Expired) { %>
    Download has expired   
<% }%>