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
         case DocumentStatus.AwaitingVerification:
             actionDescription = "Verify Patient Identification";
             break;
         case DocumentStatus.ReadyForCompliance:
             actionDescription = "Submit Release Forms";
             break;
         case DocumentStatus.ReadyForPurchase:
             actionDescription = "Purchase Document";
             break;
         case DocumentStatus.ReadyForDownload:
             actionDescription = "Download Document";
             break;
         default:
             actionDescription = null;
             break;
     }  
     
    //If no description for action, no action can be performed.  Otherwise, render link which
    //allows user to perform action on document
     if(!string.IsNullOrEmpty(actionDescription)){
     %>
     <%--this is essentially what gets rendered on the page, if action can be performed by recipient--%>
     <%= Html.ActionLink(actionDescription, "Index", "Document",
            new { documentId = encryptedDocumentId }, null)%>
     <%} %>