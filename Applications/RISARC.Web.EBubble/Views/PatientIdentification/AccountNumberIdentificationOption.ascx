<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Documents.Model.AccountNumberIdentification>" %>
<% Html.RenderPartial("AccountNumberIdentification", Model); %>
<input type="submit" name="PatientIdentificationUnknown" value="I don't know the account number" />
