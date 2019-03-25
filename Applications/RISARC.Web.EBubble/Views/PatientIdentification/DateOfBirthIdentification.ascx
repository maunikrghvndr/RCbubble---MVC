<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Documents.Model.PatientIdentification.DateOfBirthIdentification>" %>
<% string bindingPrefix = ViewData.GetBindingPrefix(); %>




<li>
    

                 <label for="DateOfBirth"> Patient's Date of Birth <span class="ValidationInstructor">*</span></label>
                <%= Html.DevExpress().DateEdit( RISARC.Web.EBubble.Models.DevxControlSettings.DateEditSetting.DateEditSettingsMethodAdditional(settings => {
    settings.Name = bindingPrefix + "DateOfBirthCalender";
})).Bind(Model.DateOfBirth.DateTime).GetHtml() %>
           
                <%= Html.ValidationMessage("DateOfBirthIdentification.DateOfBirthCalender")%>
           
</li>