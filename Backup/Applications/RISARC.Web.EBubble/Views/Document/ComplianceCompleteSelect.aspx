<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Choose How to Complete Release Form
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <% string encryptedDocumentId = Html.Encrypt(ViewData["DocumentId"]); %>
    <h2>
        Please Choose How to Complete the Release Form</h2>
    <p class="Instructions">
        Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor
        incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud
        exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute
        irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla
        pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia
        deserunt mollit anim id est laborum.</p>
        <%= Html.ValidationInstructionHeader() %>
    <h3>
        Download the release form <span>Step 1</span></h3>
    <ul>
        <li>
            <label>
                Download the Release Form</label>
            <% Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "ComplianceDocLink", "Document",
            new { documentId = Html.Encrypt(ViewData["DocumentId"]) }); %>
            <%--<%= Html.ActionLink("Download the release form", "GetComplianceDoc", 
        new {documentId = encryptedDocumentId}) %>--%>. </li>
    </ul>
    <h3>
        Choose how you will submit it <span>Step 2</span></h3>
        <%= Html.ValidationMessage("complianceSubmittalModeRequired", "You must select how you would like to submit the release form.") %>
        <%using (Html.BeginForm("ComplianceCompleteSelect", "Document"))
          {%>
        <%= Html.AntiForgeryToken() %>
            <%= Html.Hidden("DocumentId", Html.Encrypt(ViewData["DocumentId"])) %>
            <ul>
                <li>
                    <input type="radio" class="input_radio" name="complianceSubmittalMode" id="complianceSubmittalModeFax" value="Fax" />
                    <label for="complianceSubmittalModeFax">Send by Fax</label><br />
                    <input type="radio" class="input_radio" name="complianceSubmittalMode" id="complianceSubmittalModeUpload" value="Upload" />
                    <label for="complianceSubmittalModeUpload">Scan and Upload</label>
                    <%--<%= Html.RadioButtonList("complianceSubmittalMode", new System.Collections.ObjectModel.Collection<SelectListItem>{
                            new SelectListItem { Text = "Send By Fax", Value=RISARC.Documents.Model.ComplianceSubmittalMode.Fax.ToString(), Selected = false},
                            new SelectListItem { Text = "Scan and Upload", Value=RISARC.Documents.Model.ComplianceSubmittalMode.Upload.ToString(), Selected = false}
                        } as IEnumerable<SelectListItem>) %>--%>
                </li>
                <li>
                    <input type="submit" value="Continue" />
                </li>
            </ul>
        <%} %>
        
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">

   <%-- <script type="text/javascript" src="<%: Url.Content("~/Scripts/FileUploader.js")%>"></script>--%>
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
                $('#uploadFileSuccessMessage').show();
            }
        }</script>

</asp:Content>
