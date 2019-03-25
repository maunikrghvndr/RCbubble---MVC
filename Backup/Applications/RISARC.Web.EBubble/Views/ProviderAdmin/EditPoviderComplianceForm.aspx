<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Edit Povider's Release Form
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>
        Edit Povider's Release Form</h2>
        <% Html.RenderPartial("BackToProviderLink"); %>
    <p class="Instructions">
        This will be the release form that document recipients will download and fill for
        documents sent from your provider.
    </p>
        <%= Html.ValidationInstructionHeader() %>
    <%= Html.ActionLink("Back To Provider Configuration", "EditProviderConfiguration") %>
    <h3>
        Existing Release Form
    </h3>
    <ul>
        <li class="releaseFormLinkHolder">
            <% Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "PreviewComplianceFileLink", "ProviderAdmin"); %>
        </li>
    </ul>
    <h3>
        Upload New Release Form
    </h3>
    <%--below will be shown once release form is updated--%>
    <div class="newReleaseFormLinkHolder" style="display:none">
        <%= Html.ActionLink("Upload New Release Form", "EditPoviderComplianceForm")%>
    </div>
    <div class="UploadWrapper">
        <% Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "UploadProviderComplianceForm", "File", new { });  %>
    <p class="FieldInstructions">Warning: this cannot be undone.</p>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
  <%--  <script type="text/javascript" src="<%: Url.Content("~/Scripts/FileUploader.js")%>"></script>--%>
          <script type="text/javascript" src="<%: Url.Content("~/Scripts/FileUploader.min.js")%>"></script>
    <script type="text/javascript">
        // performed after file is uploaded, will copy uploaded file id to documents file id hidden field
        function additionalPostUpload() {
            parseResponeInForm();
        }

        function parseResponeInForm() {
            // find file id. If not null can assume succesffuly uploaded
            var fileId = $('#UploadedFileId').val();
            if (fileId != null && fileId != '') {
                // reload compliance file link in preview link
                $('.releaseFormLinkHolder').load('/ProviderAdmin/PreviewComplianceFileLink');
                $('.statusMessage').html('Release form successfully updated.');
                // add link after status message taking back to this page so can upload new form
                $('.newReleaseFormLinkHolder').show();
            }
            else {
                $('.statusMessage').empty();
            }
        }</script>
</asp:Content>
