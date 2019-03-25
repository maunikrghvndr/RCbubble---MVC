<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Documents.Model.PatientIdentification.AccountNumberIdentification>" %>
<% string bindingPrefix = ViewData.GetBindingPrefix(); %>
<li>
<%--    <label for="AccountNumber">--%>
    <label for="AccountNumber" id="AccountNum">
        Account Number <span class="ValidationInstructor">*</span></label>    
    <%= Html.StyledTextBox(bindingPrefix + "AccountNumber", Model.AccountNumber)%>
    <%= Html.ValidationMessage("AccountNumber.AccountNumberRequired", "Required")%>
    <div class="FieldInstructions">
          </div>
</li>
