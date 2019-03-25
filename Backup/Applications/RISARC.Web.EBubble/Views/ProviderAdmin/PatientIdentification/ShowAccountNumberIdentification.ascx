<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Documents.Model.PatientIdentification.AccountNumberIdentification>" %>
<table class="data_table">
    <tr>
        <td class="headerCell">Account Number</td>
        <td><%= Html.Encode(Model.AccountNumber) %></td>
    </tr>
</table>

