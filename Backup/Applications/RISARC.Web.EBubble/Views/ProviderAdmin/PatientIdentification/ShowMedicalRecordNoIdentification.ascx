<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Documents.Model.PatientIdentification.MedicalRecordNoIdentification>" %>
<% var rowCounter = new Counter(); %>
<table class="data_table">
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">Medical Record Number</td>
        <td><%= Html.Encode(Model.MedicalRecordNumber) %></td>
    </tr>
    <%--<tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">Patient Date of Birth</td>
        <td><%= Html.Encode(String.Format("{0:d}", Model.DateOfBirth)) %></td>
    </tr>--%>
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
