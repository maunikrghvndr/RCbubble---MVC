<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Documents.Model.PatientIdentification.AccountNumberIdentification>" %>
<% string bindingPrefix = ViewData.GetBindingPrefix(); %>
<li>
    <label for="AccountNumber" id="AccountNum">
        Account Number <span class="ValidationInstructor">*</span></label>    
    <%= Html.StyledTextBox(bindingPrefix + "AccountNumber", Model.AccountNumber,null,"widthPercent")%>
    <%= Html.ValidationMessage("AccountNumber.AccountNumberRequired", "Required")%>
    <%= Html.ValidationMessage("AccountNumber.AccountNumberDuplicate")%>
    <div class="FieldInstructions">
          </div>
</li>
<li>
    <label for="DateOfServiceFrom">Date of Service from
    <span class="ValidationInstructor">*</span></label>
    <%= Html.DevExpress().DateEdit( RISARC.Web.EBubble.Models.DevxControlSettings.DateEditSetting.DateEditSettingsMethodAdditional(settings => {
    settings.Name = bindingPrefix + "AccountDateOfServiceFrom";
    settings.ShowModelErrors = false;
    //settings.Width = Unit.Percentage();
  //  settings.Width = 269;

  //  settings.Width = Unit.Percentage(95);
    

})).Bind(Model.AccountDateOfServiceFrom).GetHtml() %>
    <%= Html.ValidationMessage("AccountDateOfServiceFrom.AccountDateOfServiceFromError")%>
</li>
<li>
    <label for="DateOfServiceFrom">Date of Service To
    <span class="ValidationInstructor">*</span></label>
    <%= Html.DevExpress().DateEdit( RISARC.Web.EBubble.Models.DevxControlSettings.DateEditSetting.DateEditSettingsMethodAdditional(settings => {
    settings.Name = bindingPrefix + "AccountDateOfServiceTo";
    settings.ShowModelErrors = false;
  //  settings.Width = Unit.Percentage(95);
})).Bind(Model.AccountDateOfServiceTo).GetHtml() %>
    <%= Html.ValidationMessage("AccountDateOfServiceTo.AccountDateOfServiceToError")%>
</li>
