<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Documents.Model.Document>" %>
<%@ Import Namespace="RISARC.Documents.Model" %>
<% DocumentStatus status = Model.DocumentStatus;
    string encryptedDocumentId = Html.Encrypt(Model.Id); %>
    
    
<% if(status == DocumentStatus.AwaitingVerification) { %>
    <label>Awaiting Confirmation from Recipient</label>           
<% } 
   else if(status == DocumentStatus.LockedOutFromAttemptedVerifications) { %>
    <label>Locked Out From Too Many Failed Attempted Verifications</label> <br />          
    <%= Html.DocumentAdminLink("Unlock Document", encryptedDocumentId)%>
<% }else if(status == DocumentStatus.ReadyForCompliance) { %>
    <label>Waiting for Recipient to Submit Release Forms</label>    
<% }
    else if(status == DocumentStatus.AwaitingComplianceApproval) { %>
    <label>Awaiting Release Form Approval</label>        <br />   
    <%= Html.DocumentAdminLink("Review Submitted Release Form", encryptedDocumentId) %>
<% }
    else if(status == DocumentStatus.ReadyForPurchase) { %>
    <label>Waiting for Recipient to Purchase Document</label>    
<% }else if(status == DocumentStatus.ReadyForDownload) { %>
    <label>Available for Recipient to Download</label>    
<% } 
   else if(status == DocumentStatus.Expired) { %>
    <label>Expired</label>    
<% }%>
