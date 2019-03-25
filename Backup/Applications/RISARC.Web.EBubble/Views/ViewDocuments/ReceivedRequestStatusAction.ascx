<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<%@ Import Namespace="RISARC.Documents.Model" %>
<% DocumentStatus status = (DocumentStatus)ViewData["DocumentStatus"];
    int requestId = (int)ViewData["RequestId"];
    string encryptedRequestId = Html.Encrypt(requestId); %>
 
 <%   
    //get the document action description.  
     string actionDescription;
     switch (status)
     {
         case DocumentStatus.RequestAwaitingDocument:
             actionDescription = "Respond to Request";
             break;
         case DocumentStatus.AwaitingComplianceApproval:
             actionDescription = "Respond to Request";
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
     <%= Html.ActionLink(actionDescription, "DocumentRequest", "DocumentAdmin",
                        new { requestId = encryptedRequestId }, null)%>
     <%} %>