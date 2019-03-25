<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Documents.Model.PatientIdentification.SSNIdentification>" %>
<% var rowCounter = new Counter(); %>
<table class="data_table">
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">Social Security Number</td>
        <td>*****<%= Html.Encode(Model.SSNLast4) %></td>
    </tr>
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">Date of Service From</td>
        <td><%= Html.Encode(String.Format("{0:d}", Model.DateOfServiceFrom)) %></td>
    </tr>
    <tr  class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">
        Date of Service To
        </td>
        <td><%= Html.Encode(String.Format("{0:d}", Model.DateOfServiceTo)) %>
        </td>
    </tr>
</table>
