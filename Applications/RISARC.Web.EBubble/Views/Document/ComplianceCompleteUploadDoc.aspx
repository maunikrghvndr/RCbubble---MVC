<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Please Complete, Scan and Upload the Release Form for this Document
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <% string encryptedDocumentId = Html.Encrypt(ViewData["DocumentId"]); %>
    <h2>
        Please Complete, Scan and Upload the Release Form for this Document</h2>
    <p class="Instructions">
        Complete, scan and upload release form for this document to submit for approval.</p>
    <%= Html.FormStepHeader("Download the Release Form")%>
    <ul>
        <li>
            <label>
                Download the Release Form</label>
            <% Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "ComplianceDocLink", "Document",
            new { documentId = Html.Encrypt(ViewData["DocumentId"]) }); %></li>
    </ul>
    <%= Html.FormStepHeader("Complete the Release Form and Upload It")%> 
    
    <%= Html.ValidationMessage("DocumentFileRequired", "File Required to Upload Before Sending")%>
    <%--render form where compliance document can be uploaded--%>
        <% Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "UploadCompletedComplianceDocForm", "File",
           new
           {
               providerIdToSubmitTo = Html.Encrypt(ViewData["ProviderId"]),
               documentFileId = Html.Encrypt(ViewData["SubmittedComplianceFileId"])
           });%>
    <%= Html.FormStepHeader("Submit the Release Form")%>
    <%using (Html.BeginForm("ComplianceCompleteUploadDoc", "Document", new { documentId = encryptedDocumentId }))
      { %>
    <%= Html.AntiForgeryToken()%>
    <%= Html.Hidden("submittedComplianceFileId", Html.Encrypt(ViewData["SubmittedComplianceFileId"]))%>
    <ul>
        <li>
            <input type="submit" value="Submit Release Form for This Document" />
        </li>
    </ul>
    <%} %>
    
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">

  <%--  <script type="text/javascript" src="<%: Url.Content("~/Scripts/FileUploader.js")%>"></script>--%>
          <script type="text/javascript" src="<%: Url.Content("~/Scripts/FileUploader.min.js")%>"></script>
    <script type="text/javascript">
        // performed after file is uploaded, will unhide div that shows status success
        function additionalPostUpload() {
            showSuccessMessage();
        }

        function showSuccessMessage() {
            // if uploaded file id has a value thats not 0, then can assume succeeded, and show success message
            var uploadedFiledId = $('#UploadedFileId').val();
            if (uploadedFiledId != null && uploadedFiledId != "" && uploadedFiledId != 0) {
                // find file id.
                $('#submittedComplianceFileId').val(uploadedFiledId);
            }
        }</script>

</asp:Content>
