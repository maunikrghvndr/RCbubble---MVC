<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Documents.Model.MedicalRecordNoIdentification>" %>
<% Html.RenderPartial("MedicalRecordNoIdentification", Model); %>
<% if((bool)ViewData["IdentificationShouldBeKnown"] == true){ %>
<input type="submit" name="PatientIdentificationUnknown" value="I don't know the patient's Medical Record Number" />
<% } else{ %>
<input type="submit" name="PatientIdentificationUnknown" value="Patient doesn't have a Medical Record Number" />
<%} %>