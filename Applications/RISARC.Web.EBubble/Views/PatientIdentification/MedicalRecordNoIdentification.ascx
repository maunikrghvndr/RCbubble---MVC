<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Documents.Model.PatientIdentification.MedicalRecordNoIdentification>" %>
<% string bindingPrefix = ViewData.GetBindingPrefix(); %>
<li>
    <label for="MedicalRecordNumber">
        Medical Record Number 
    <span class="ValidationInstructor">*</span></label>
    <%= Html.StyledTextBox(bindingPrefix + "MedicalRecordNumber", Model.MedicalRecordNumber,null,"widthPercent")%>
    <%= Html.ValidationMessage("MedicalRecordNo.MedicalRecordNumberRequired", "Required")%>
</li>
 <li>
    <label for="DateOfServiceFrom">
        Date Of Service From
    <span class="ValidationInstructor">*</span></label>
   <%= Html.DevExpress().DateEdit( RISARC.Web.EBubble.Models.DevxControlSettings.DateEditSetting.DateEditSettingsMethodAdditional(settings => {
    settings.Name = bindingPrefix + "DateOfServiceFrom";
    settings.ShowModelErrors = false;
})).Bind(Model.DateOfServiceFrom).GetHtml() %>
    <%= Html.ValidationMessage("MedicalRecordNo.DateOfServiceFromRequired", "Required")%>
    <%= Html.ValidationMessage("MedicalRecordNo.DateOfServiceFromInvalid")%>
</li>
<li>
    <label for="DateOfServiceTo">
        Date Of Service To
    <span class="ValidationInstructor">*</span></label>
    <%= Html.DevExpress().DateEdit( RISARC.Web.EBubble.Models.DevxControlSettings.DateEditSetting.DateEditSettingsMethodAdditional(settings => {
    settings.Name = bindingPrefix + "DateOfServiceTo";
    settings.ShowModelErrors = false;
})).Bind(Model.DateOfServiceTo).GetHtml() %>
    <%= Html.ValidationMessage("MedicalRecordNo.DateOfServiceToRequired", "Required")%>
    <%= Html.ValidationMessage("MedicalRecordNo.DateOfServiceToInvalid")%>
    <div class="FieldInstructions">If service occured on just one day, and not multiple days, enter same value from <i>Date of Service From.</i></div>
</li>
<%--<script>
    function startChange() {
        var endPicker = $("#PatientInformation_PatientIdentificationMethods_SSNIdentification_DateOfServiceTo").data("kendoDateTimePicker"),
            startDate = this.value();

        if (startDate) {
            startDate = new Date(startDate);
            startDate.setDate(startDate.getDate() + 1);
            endPicker.min(startDate);
        }
    }

    function endChange() {
        var startPicker = $("#PatientInformation_PatientIdentificationMethods_SSNIdentification_DateOfServiceFrom").data("kendoDateTimePicker"),
            endDate = this.value();

        if (endDate) {
            endDate = new Date(endDate);
            endDate.setDate(endDate.getDate() - 1);
            startPicker.max(endDate);
        }
    }
</script>
--%>