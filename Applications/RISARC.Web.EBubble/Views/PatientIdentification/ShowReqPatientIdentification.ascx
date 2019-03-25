<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Documents.Model.PatientIdentification.PatientIdentificationMethods>" %>
<%@ Import Namespace="RISARC.Documents.Model.PatientIdentification" %>
<ul>
<% foreach(var identificationMethod in Model.ToCollection()){%>
    <li>
<%  
    Html.RenderPartial("~/Views/PatientIdentification/ShowDateOfBirthIdentification.ascx", identificationMethod);%>
     </li>
<%} %>
</ul>

