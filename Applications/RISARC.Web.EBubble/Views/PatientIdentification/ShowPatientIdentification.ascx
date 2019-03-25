<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Documents.Model.PatientIdentification.PatientIdentificationMethods>" %>
<%@ Import Namespace="RISARC.Documents.Model.PatientIdentification" %>
<!-- <ul> -->
<% foreach(var identificationMethod in Model.ToCollection()){%>
    <!--<li> -->
<% if (identificationMethod.GetType() == typeof(AccountNumberIdentification))
       Html.RenderPartial("~/Views/PatientIdentification/ShowAccountNumberIdentification.ascx", identificationMethod);
   else if (identificationMethod.GetType() == typeof(SSNIdentification))
       Html.RenderPartial("~/Views/PatientIdentification/ShowSSNIdentification.ascx", identificationMethod);
   else if (identificationMethod.GetType() == typeof(MedicalRecordNoIdentification))
       Html.RenderPartial("~/Views/PatientIdentification/ShowMedicalRecordNoIdentification.ascx", identificationMethod); %>
     <!-- </li> -->
<%} %>
<!-- </ul>-->

