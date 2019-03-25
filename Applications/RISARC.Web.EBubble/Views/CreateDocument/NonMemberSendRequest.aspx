<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.Master" Inherits="System.Web.Mvc.ViewPage<RISARC.Documents.Model.DocumentRequestSend>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Request a Document
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>
        Request a Document</h2>
    <p class="Instructions">
        Complete the information below to send out a request to a provider. If you do 
        not have the provider’s release agreement, download agreement provided, fill out 
        completely, scan, save to secure location and attach to send out for approval.</p>
        <%= Html.ValidationInstructionHeader() %>
    
    
    <%= Html.FormStepHeader("Download the Release Form for This Request") %>
    <ul>
        <li>
            <label>
                Download the Release Form</label><br />
            <% Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "ProvidersComplianceDocLink", "Document",
            new { providerId = Model.ProviderId }); %> </li>
    </ul>
    <%= Html.FormStepHeader("Complete the Release Form and Upload It") %>
    <%= Html.ValidationMessage("SubmittedComplianceFileRequired", "Release Form Required to Upload Before Sending Request")%>
    <%--below will render form for non members to submit their release form--%>
    <% Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "UploadCompletedComplianceDocForm", "File",
           new
           {
               providerIdToSubmitTo = Html.Encrypt(Model.ProviderId),
               documentFileId = Html.Encrypt(Model.SubmittedComplianceFileId)
           });%>
           
    <% using (Html.BeginForm("NonMemberSendRequest", "CreateDocument"))
       {%>
       <%= Html.AntiForgeryToken() %>
       <%= Html.Hidden("SubmittedComplianceFileId", Html.Encrypt(Model.SubmittedComplianceFileId)) %>
    <% Html.RenderPartial("DocumentRequestSend", Model); %>
    <% } %>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
    <script type="text/javascript" src="<%: Url.Content("~/Scripts/OptionExpander.js")%>"></script>
    
  <%--  <link rel="Stylesheet" type="text/css" href="<%: Url.Content("~/Content/custom-theme/jquery-ui-1.7.2.custom.css")%>" />
    <script type="text/javascript" src="<%: Url.Content("~/Scripts/jquery-ui-1.9.2.custom.min.js")%>"></script>
    <script type="text/javascript" src="<%: Url.Content("~/Scripts/LoadDatePickers.js")%>"></script>--%>
    
  <%--  <script type="text/javascript" src="<%: Url.Content("~/Scripts/FileUploader.js")%>"></script>--%>
         <script type="text/javascript" src="<%: Url.Content("~/Scripts/FileUploader.min.js")%>"></script>

    
    <script type="text/javascript">
        // performed after file is uploaded, will copy uploaded file id to compliance file id hidden field
        function additionalPostUpload() {
            parseResponeInForm();
        }

        function parseResponeInForm() {
            // find file id.
            var fileId = $('#UploadedFileId').val();
            if (fileId != null && fileId != '') {
                var targetElement = $('#SubmittedComplianceFileId');
                targetElement.val(fileId);
            }

            // If not null or empty populate hidden field on page with file id
        }</script>
    
</asp:Content>
