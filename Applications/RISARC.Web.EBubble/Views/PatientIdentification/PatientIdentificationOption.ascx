<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Documents.Model.APatientIdentification>" %>
<% if ((bool?)ViewData["LastOptionReached"] == true)
   {
       Html.RenderPartial("LastOptionReached");
   }
   else
   {
       Type modelType = Model.GetType();
       if (modelType == typeof(RISARC.Documents.Model.AccountNumberIdentification))
           Html.RenderPartial("AccountNumberIdentificationOption");
       else if (modelType == typeof(RISARC.Documents.Model.SSNIdentification))
           Html.RenderPartial("SSNIdentificationOption");
       else if (modelType == typeof(RISARC.Documents.Model.MedicalRecordNoIdentification))
           Html.RenderPartial("MedicalRecordNoIdentificationOption");
%>
<%= // encrypt type name so not exposed to public
    Html.Hidden("PatientIdentificationTypeName", 
    (new RISARC.Encryption.Service.FrontEndEnrypter()).Encrypt(Model.GetType().FullName))  %>
<%}   %>
