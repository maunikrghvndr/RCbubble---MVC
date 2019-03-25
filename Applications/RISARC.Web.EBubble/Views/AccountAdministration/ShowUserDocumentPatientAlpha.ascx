<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<form>
<ul>
    <li>
<label>User only receives requests of the above document types for patients with last name beginnning: <%= ViewData["PatientFirstAlpha"]  %></label>
    </li>
    <li>
<label>User only receives requests of the above document types for patients with last name ending: <%= ViewData["PatientLastAlpha"]  %></label>
    </li>
</ul>
</form>