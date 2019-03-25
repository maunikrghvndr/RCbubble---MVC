<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Documents.Model.DocumentSend>" %>
<% Html.RenderPartial("CommonDocumentSendFields", Model); %>
<h3>
    Information about Patient this Document Relates To<span>Step 4</span></h3>
<% Html.RenderPartial("PatientInformationFields", Model.PatientInformation, ViewData.CloneWithBindingPrefix("PatientInformation")); %>
<ul>
    <li>
        <input type="submit" value="Send Document" />
    </li>
</ul>
