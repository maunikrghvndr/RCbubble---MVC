<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Documents.Model.PatientIdentification.MedicalRecordNoIdentification>" %>
<% string bindingPrefix = ViewData.GetBindingPrefix(); %>
<li>
    <label for="MedicalRecordNumber">
        Medical Record Number 
    <span class="ValidationInstructor">*</span></label>
    <%= Html.StyledTextBox(bindingPrefix + "MedicalRecordNumber", Model.MedicalRecordNumber)%>
    <%= Html.ValidationMessage("MedicalRecordNo.MedicalRecordNumberRequired", "Required")%>
</li>
 <li>
    <label for="DateOfServiceFrom">
        Date Of Service From
    <span class="ValidationInstructor">*</span></label>
   
    <%= Html.StyledTextBox(bindingPrefix + "DateOfServiceFrom", String.Format("{0:MM/dd/yyyy}", Model.DateOfServiceFrom.NullIfDefault()), null, "datepicker")%>
    <%= Html.ValidationMessage("MedicalRecordNo.DateOfServiceFromRequired", "Required")%>
    <%= Html.ValidationMessage("MedicalRecordNo.DateOfServiceFromInvalid")%>
</li>
<li>


<script type="text/jscript" language="javascript">
    $(document).ready(function () {
        $('#DateOfServiceFrom').datepicker();
        $('#EndDate').datepicker();
    });
</script>



    <label for="DateOfServiceTo">
        Date Of Service To
    <span class="ValidationInstructor">*</span></label>
    <%= Html.StyledTextBox(bindingPrefix + "DateOfServiceTo", String.Format("{0:MM/dd/yyyy}", Model.DateOfServiceTo.NullIfDefault()), null, "datepicker")%>
    <%= Html.ValidationMessage("MedicalRecordNo.DateOfServiceToRequired", "Required")%>
    <%= Html.ValidationMessage("MedicalRecordNo.DateOfServiceToInvalid")%>
    <div class="FieldInstructions">If service occured on just one day, and not multiple days, enter same value from <i>Date of Service From.</i></div>
</li>
