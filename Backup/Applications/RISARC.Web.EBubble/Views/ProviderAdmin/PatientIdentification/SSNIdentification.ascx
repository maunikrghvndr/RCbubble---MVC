<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Documents.Model.PatientIdentification.SSNIdentification>" %>
<% string bindingPrefix = ViewData.GetBindingPrefix(); %>
<li>
    <label for="SSN">Social Security Number 
    <span class="ValidationInstructor">*</span></label>
    <%= Html.StyledTextBox(bindingPrefix + "SSN", Model.SSN, 9, "numbersonly") %>
    <%= Html.ValidationMessage("SSN.SSNRequired", "Required") %>
    <%= Html.ValidationMessage("SSN.SSNInvalid") %>
</li>
<li>
    <label for="DateOfServiceFrom">Date of Service From
    <span class="ValidationInstructor">*</span></label>
    <%= Html.StyledTextBox(bindingPrefix + "DateOfServiceFrom", String.Format("{0:MM/dd/yyyy}", Model.DateOfServiceFrom.NullIfDefault()), null, "datepicker")%>
    <%= Html.ValidationMessage("SSN.DateOfServiceFromRequired", "Required")%>
    <%= Html.ValidationMessage("SSN.DateOfServiceFromInvalid")%>
</li>
<li>
    <label for="DateOfServiceTo">Date of Service To
    <span class="ValidationInstructor">*</span></label>
    <%= Html.StyledTextBox(bindingPrefix + "DateOfServiceTo", String.Format("{0:MM/dd/yyyy}", Model.DateOfServiceTo.NullIfDefault()), null, "datepicker")%>
    <%= Html.ValidationMessage("SSN.DateOfServiceToRequired", "Required")%>
    <%= Html.ValidationMessage("SSN.DateOfServiceToInvalid")%>
    <div class="FieldInstructions">If service occured on just one day, and not multiple days, enter same value from <i>Date of Service From.</i></div>
</li>
<input type="hidden" id="UploadedFileId" name="UploadedFileId" />


