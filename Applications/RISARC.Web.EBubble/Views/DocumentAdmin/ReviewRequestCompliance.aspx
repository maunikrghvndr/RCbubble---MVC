<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.Master" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="RISARC.Documents.Model" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Review Submitted Release Form
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <% string encryptedRequestId = Html.Encrypt(ViewData["RequestId"]); %>
    <h2>
        Approve or Deny User's Submitted Release Form</h2>
        <%= Html.ValidationInstructionHeader() %>
    
    <%= Html.FormStepHeader("Review the Request") %>
    <div class="SubDetails">
    <% Html.RenderAction("RequestDetails", "DocumentAdmin", new { requestId = encryptedRequestId }); %>
    </div>
    
        <%= Html.FormStepHeader("Review Submitted Release Form") %>
        <p class="Instructions">
        The user has uploaded their completed release forms.  Please download the release forms by 
        clicking the link below, then either approve or deny them.</p>       
    <ul>
        <li>
            <%= Html.ActionLink("Download Submitted Release Form", "DownloadSubmittedRequestCompliance",
                new { requestId = encryptedRequestId })%>
        </li>
    </ul>
    <%= Html.FormStepHeader("Approve or Deny It") %>
    <h4>Approve It</h4>
    <%--Approval form--%>
    <%using (Html.BeginForm("ReviewRequestCompliance", "DocumentAdmin", new {requestID = encryptedRequestId}))
      { %>
      <%= Html.AntiForgeryToken() %>
    <ul>
        <li>
            <input type="submit" value="Approve Submitted Release Form" />
            <%= Html.Hidden("approve", true) %>
        </li>
    </ul>
    <%} %>
    <h4>Or Deny It</h4>
    <%--Rejection Form--%>
    <% using (Html.BeginForm("ReviewRequestCompliance", "DocumentAdmin", new { requestID = encryptedRequestId }))
       { %>
       <%= Html.AntiForgeryToken() %>
    <ul>
        <li>
            <%= Html.Hidden("approve", false) %>
            
            <label for="reason">Indicate reason for rejection (user will see this in email notification)</label>
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
