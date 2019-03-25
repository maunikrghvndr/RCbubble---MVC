<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {

    }
</script>
<% DateTime? startDate = ViewData["StartDate"] as DateTime?;
   DateTime? endDate = ViewData["EndDate"] as DateTime?;
    string ACN = ViewData["ACN"] as string; %>
   
<label for="startDate"><strong>Sent Date From:</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label><%= Html.StyledTextBox("startDate", String.Format("{0:d}", startDate), null, "datepicker")%>
<%= Html.ValidationMessage("startDateRequired", "Required")%>
<label for="endDate"><strong>Sent Date To:</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
<%= Html.StyledTextBox("endDate", String.Format("{0:d}", startDate), null, "datepicker")%>
<%= Html.ValidationMessage("endDateRequired", "Required")%> 
<br />
<br />
<label for="FirstName"><strong>Patient First Name:</strong>&nbsp;&nbsp;</label><%= Html.StyledTextBox("PatientFName")%>
<%= Html.ValidationMessage("endDateRequired", "Required")%>
<label for="LastName" ><strong>Patient  Last Name:  </strong></label><%= Html.StyledTextBox("PatientLName")%>
<label for="ACN"><strong>
<br />
<br />
ACN# / ICN# / DCN#:</strong></label><%= Html.StyledTextBox("ACN") %>
<label for="AccountNo"><strong>Account No:</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label><%= Html.StyledTextBox("accountNo") %>
  <br />
  <br />
  <input type="submit" value="Search" />
   <br />
</ul>
