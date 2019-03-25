<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.Master" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="RISARC.Documents.Model" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Review Submitted Release Form
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <% string encryptedDocumentId = Html.Encrypt(ViewData["DocumentId"]); %>
    <% ComplianceSubmittalMode comlianceSubmittalMode = (ComplianceSubmittalMode)ViewData["ComplianceSubmittalMode"]; %>
    <h2>
        Approve or Deny User's Submitted Release Form</h2>
    
        <h3>Review Submitted Release Form <span>Step 1</span></h3>
       <% if (comlianceSubmittalMode == ComplianceSubmittalMode.Upload)
          { %> 
        <p class="Instructions">
            A user has uploaded their completed release form. 
            Please review to approve or deny.</p>
        <%= Html.ValidationInstructionHeader() %>
       
    <ul>
        <li>
            <%= Html.ActionLink("Download Submitted Release Form", "DownloadSubmittedCompliance",
                new { documentId = encryptedDocumentId })%>
        </li>
    </ul>
    <%}
          else if(comlianceSubmittalMode == ComplianceSubmittalMode.Fax)
          {%>
          <p class="Instructions">
        The user has indicated that they have faxed their completed release forms to:</p>
        <%  Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "FaxInstructions", "Document", new { documentId = encryptedDocumentId }); %>
        
          <p class="Instructions">
        Please review them  and either approve or deny them below.</p>
       
    
          <%} %>
    <h3>
        Approve or Deny It <span>Step 2</span>
    </h3>
    <h4>Approve It</h4>
    <%--Approval form--%>
    <%using (Html.BeginForm("ReviewCompliance", "DocumentAdmin", new {documentId = encryptedDocumentId}))
      { %>
      <%= Html.AntiForgeryToken() %>
    <ul>
        <li>
            <input type="submit" value="Approve Submitted Release Form" />
            <%= Html.Hidden("approve", true) %>
            <%--<%= Html.ActionLink("Click Here to Approve the Submitted Release Form", "SetComplianceDocApproval",
                new { documentId = encryptedDocumentId, approve = true }) %>--%>
        </li>
    </ul>
    <%} %>
    <h4>Or Deny It</h4>
    <%--Rejection Form--%>
    <% using (Html.BeginForm("ReviewCompliance", "DocumentAdmin", new {documentId = encryptedDocumentId}))
       { %>
       <%= Html.AntiForgeryToken() %>
    <ul>
        <li>
            <%= Html.Hidden("approve", false) %>
            
            <label for="reason">Indicate reason for denial (user will see this in email notification) <span class="ValidationInstructor">*</span></label>
            <%= Html.StyledTextArea("reason") %>
            <%= Html.ValidationMessage("RejectionReason", "Required")%>
        </li>
        <li>
            <input type="submit" value="Deny Submitted Release Form" />
        </li>
    </ul>
    <%} %>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>
