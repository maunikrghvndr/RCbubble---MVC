<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Documents.Model.DocumentRequestSend>" %>
<%@ Import Namespace="RISARC.Documents.Model.PatientIdentification" %>
<% bool allowRelatesToPatientOption = (bool)ViewData["AllowRelatesToPatientOption"];
   bool? isEDSRequestSender = ViewData["IsEDSRequestSender"] as bool?;

%>

<%--<% var requestDueOptions = new Dictionary<string, string>{
     {"168", "1 week"},
     {"72", "3 days"},
     {"24", "1 day"}
   }; 
    var requestDueItems = from kvp in requestDueOptions
                          select new SelectListItem { Text = kvp.Value, Value = kvp.Key, Selected = kvp.Value == Model.RequestDueByInHours.ToString()}; %>--%>
<%= Html.FormStepHeader("Enter Information About Document to Request") %>
<ul>
    <li>
        <label>
            Provider to Request Document From <span class="ValidationInstructor">*</span></label>
        <b><% Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "DisplayProviderName", "Setup", new { eProviderId = Html.Encrypt(Model.ProviderId) }); %></b>
        <%= Html.Hidden("ProviderId", Model.ProviderId) %>
    </li>
</ul>

<h3>Document Type <span></span></h3>

<ul>
    <li>
        <label for="DocumentType">
            Type of Document <span class="ValidationInstructor">*</span></label>
        <div class="DocumentTypeHolder">
            <% Html.RenderAction<RISARC.Web.EBubble.Controllers.CreateDocumentController>(
               x => x.ProviderDocumentTypesDropDown("DocumentTypeId", "-Select-", Model.ProviderId, Model.DocumentTypeId)
               ); %>
            <%= Html.ValidationMessage("DocumentTypeRequired", "Required")%>
        </div>
    </li>
</ul>

<h3>Provider Member To Send Request <span>Step 2</span></h3>
<ul>
    <li>
        <%= Html.CheckBox("chkSendToEveryOne",  new { onchange = "SendProviderWide()" }) %> : Check here if you would like your request to go to all members under the selected organization, otherwise select individual member(s) below.
    </li>
    <li>
        <div id="SelectedRecipientsPanel">
            <table border="0"  style="float: none; width:80%" >
                <tr>
                    <td nowrap="nowrap">
                        <label for="recipientEmailAddress">
                            Provider Member to Send To <span class="ValidationInstructor">*</span>
                        </label>
                    </td>
                    <td width="5px"></td>
                    <td>
                        <b>Recipient(s): <font color="red">*</font></b>
                    </td>
                </tr>
                <tr>
                    <td valign="top">
                        <div class="RecipientEmailHolder">
                            <% Html.RenderAction<RISARC.Web.EBubble.Controllers.CreateDocumentController>(drc =>
                   drc.ProvidersMembersListBox("recipientEmailAddress", "-Select-", Model.ProviderId, (string)ViewData["RecipientEmailAddress"])); %>
                        </div>
                        <%= Html.ValidationMessage("RecipientEmailRequired", "Required") %>
                    </td>
                    <td></td>
                    <td valign="top" nowrap="nowrap">
                        <div>
                            <span id="MyRecipientList"></span>
                            <ul id="SelectedItemsListUL"></ul>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </li>
</ul>

<h3>Information about Document <span>Step 3</span></h3>


<ul>
    <li>
        <label for="Description">
            Description of Document <span class="ValidationInstructor DescriptionValidationInstructor"
                style="display: none">*</span>
        </label>
        <%= Html.StyledTextBox("DocumentDescription", Model.DocumentDescription)%>
        <%= Html.ValidationMessage("DescriptionRequired", "Required")%>
    </li>
    <li>
        <label for="Comments">
            Purpose for Request <span class="ValidationInstructor">Minimum 25 characters</span>
        </label>
        <!--%= Html.StyledTextArea("Comments") %-->
        <%= Html.TextArea("Comments", null, 10, 100, new {onkeydown="CharCount()"}) %><br />
        <span id="CharCountDisplay"></span>

        <%= Html.ValidationMessage("CommentsRequired", "Required") %>
        <%= Html.ValidationMessage("CommentsMinimumLength", "Must contain at least 25 characters") %>
    </li>
    <li>
        <label for="RequestDueByInHours">
            Response Due By</label>

        <%= Html.DevExpress().DateEditFor(o=>o.RequestDueBy, RISARC.Web.EBubble.Models.DevxControlSettings.DateEditSetting.DateEditSettingsMethodAdditional(settings =>
                        {
                            settings.Name = "RequestDueBy";
                            settings.Width = Unit.Pixel(280);
                            settings.Properties.MinDate = DateTime.Now.Date;
                            settings.Properties.ValidationSettings.ErrorText="Please select validate date.";
                            settings.ShowModelErrors = false;
                        })).GetHtml()%>

        <%= Html.ValidationMessage("RequestDueByInvalid", "Cannot be in the past")%>
        <div class="FieldInstructions">
            Select date to have requested document by (optional)
        </div>
    </li>
    <%// if requester is eds requester, display option to manually enter acn number
        if (isEDSRequestSender == true)
        { %>
    <li>
        <%--link that, when clicked, will show manual acn input--%>
        <a href="#" onclick="$('.manualACNHolder').show(); return false" title="Enter Payor Identifier. This is to identify">Enter Payor Identifier</a> </li>
    <li <%= String.IsNullOrEmpty(Model.ManualACNNumber) ? "style='display:none'" : "" %>
        class="manualACNHolder">
        <label for="ManualACNNumber">
            (Optional) Enter Payor Identifier to manually assign to requested document</label>
        <%= Html.StyledTextBox("ManualACNNumber", Model.ManualACNNumber, 20, null) %>
        <%= Html.ValidationMessage("ACNTaken", "The Payor Identifier you entered is already taken by another document or request.")%>
        <%= Html.ValidationMessage("ACNInvalidForProvider", "The Payor Identifier you entered is invalid for your provider.")%>
    </li>
    <li>
        <%= Html.ValidationMessage("ACNNotConfiguredForProvider", "Payor Identifier configuration is not set up correctly for your provider.  Please contact your provider's administrator.")%>
        <%= Html.ValidationMessage("NoACNLeft", "No Payor Identifier numbers left for your provider.  Please contact your provider's administrator.")%>
    </li>
    <%} %>
</ul>
<%= Html.FormStepHeader("Enter Patient Information")%>
<% if (allowRelatesToPatientOption)
   { %>
<ul>
    <li>
        <label> Does this document relate to a patient? If more than one patient, select no.  <span class="ValidationInstructor">*</span></label>
          <div class="clsWidth100px">
            <div class="floatLeft">
                <input type="radio" class="input_radio" name="DocumentRelatesToPatient" id="DocumentRelatesToPatientTrue"
                    value="True" <%= Model.DocumentRelatesToPatient ? "checked='checked'" : (string)null %> />
                <label class="floatRight" for="DocumentRelatesToPatientTrue">Yes</label>
            </div>
            <div class="floatRight">
                <input type="radio" class="input_radio" name="DocumentRelatesToPatient" id="DocumentRelatesToPatientFalse"
                    value="False" <%= !Model.DocumentRelatesToPatient ? "checked='checked'" : (string)null %> />
                <label class="floatRight" for="DocumentRelatesToPatientFalse">No</label>
            </div>
        </div>

    </li>
</ul>
<%} %>
<div class="clear"></div>
<div class="PatientInformationHolder">
    <%-- <!-- < <%= !Model.DocumentRelatesToPatient ? "style='display: none'" : (string)null  %>> --> <% Html.RenderPartial("DateOfBirthIdentification", Model.DateOfBirthIdentification, ViewData.CloneWithBindingPrefix("DateOfBirthIdentification")); %>
    --%>
    <% Html.RenderPartial("PatientInformationFields", Model.PatientInformation, ViewData.CloneWithBindingPrefix("PatientInformation")); %>
</div>

<ul>
    <li>
        <input type="submit" value="Request Document" />
    </li>
</ul>
<script type="text/javascript">
    $(document).ready(
    function () {
        $('input:radio[name=DocumentRelatesToPatient]').change(function () {
            // alert("patient info" +  $(this).val());
            if ($(this).val() == 'True') {
                $('.PatientInformationHolder').slideDown('slow'); //.hide();
            }
            else {
                $('.PatientInformationHolder').slideUp('slow'); //.show();

            }
        });
    });
</script>
