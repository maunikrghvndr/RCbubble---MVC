<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Documents.Model.PatientInformation>" %>
<% string bindingPrefix = ViewData.GetBindingPrefix(); %>
<p class="FieldInstructions gery_bottomLine">Enter information to uniquely identify the patient that this document is for.</p>
<ul class="patientInfo">
    <li>
        <label for="PatientFirstName">
            Patient's First Name <span class="ValidationInstructor">*</span></label>
        <%= Html.StyledTextBox(bindingPrefix + "PatientFirstName") %>
        <%= Html.ValidationMessage("PatientFirstNameRequired", "Required")%>
    </li>
    <li>
        <label for="PatientLastName">
            Patient's Last Name 
        <span class="ValidationInstructor">*</span></label>
        <%= Html.StyledTextBox(bindingPrefix + "PatientLastName")%>
        <%= Html.ValidationMessage("PatientLastNameRequired", "Required")%>
    </li>
   
</ul>
<div class="clear"></div>
<ul>
    <li>

         <label for="AccountNumberIdentification" class="setSpace"> Please select one or more of the following to uniquely identify the patient<span class="ValidationInstructor">*</span></label>
        <%= Html.ValidationMessage("PatientIdentificationMethodsRequired", "One or more method to identify the patient must be selected.") %>
        <%= Html.ValidationMessage("PatientIdentification", "You must choose at least one way to identify the patient") %>
        <% Html.RenderPartial("~/Views/PatientIdentification/PatientIdentificationMethods.ascx", Model.PatientIdentificationMethods,
               ViewData.CloneWithBindingPrefix("PatientIdentificationMethods")); %>


    </li>
</ul>
