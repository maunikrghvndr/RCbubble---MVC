<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Documents.Model.PatientIdentification.DateOfBirthIdentification>" %>
<% var rowCounter = new Counter(); %>
<table class="data_table">
 
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">Patient Date of Birth</td>
        <td><%= Html.Encode(String.Format("{0:d}", Model.DateOfBirth)) %></td>
    </tr>
     
</table>
