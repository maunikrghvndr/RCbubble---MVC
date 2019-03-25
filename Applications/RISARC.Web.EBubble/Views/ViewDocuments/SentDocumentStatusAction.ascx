<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<%@ Import Namespace="RISARC.Documents.Model" %>
<% DocumentStatus status = (DocumentStatus)ViewData["DocumentStatus"];
    int documentId = (int)ViewData["DocumentId"];
    string encryptedDocumentId = Html.Encrypt(documentId); %>
    
 <%   
    //get the document action description.  
     string actionDescription;
     switch (status)
     {
         case DocumentStatus.LockedOutFromAttemptedVerifications:
             actionDescription = "Unlock Document";
             break;
         case DocumentStatus.AwaitingComplianceApproval:
             actionDescription = "Review Submitted Release Form";
             break;
         default:
             actionDescription = null;
             break;
     }  
     
    //If no description for action, no action can be performed.  Otherwise, render link which
    //allows user to perform action on document
     
     if(!string.IsNullOrEmpty(actionDescription)){
     %>
     <%--this is essentially what gets rendered on the page, if action can be performed by admin--%>
    <%= Html.DocumentAdminLink(actionDescription, encryptedDocumentId)%>
     <%} %>
