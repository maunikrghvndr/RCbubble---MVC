<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Documents.Model.SSNIdentification>" %>
<% Html.RenderPartial("SSNIdentification", Model); %>

<% if((bool)ViewData["IdentificationShouldBeKnown"] == true){ %>
<input type="submit" name="PatientIdentificationUnknown" value="I don't know the patient's Social Security Number" />
<% } else{ %>
<input type="submit" name="PatientIdentificationUnknown" value="Patient doesn't have a Social Security Number" />
<%} %>
