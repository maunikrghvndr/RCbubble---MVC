<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IEnumerable<RISARC.Logging.Model.ActionLogEntry>>" %>
<% bool ShowDocumentColumns = (bool?)ViewData["HideDocumentColumns"] == false;  %>
<table class="data_table">
    <tr>
        <% if (ShowDocumentColumns)
           { %>
        <th>
            Action Performed on
            Document Type 
        </th>
        <th>
            Action Performed on
            Requested Document Type 
        </th>
        <%} %>
        <th>
            Action By
        </th>
        <th>
            Action Description
        </th>
        <th>
            Date/Time Occurred
        </th>
    </tr>
   <% Counter counter = new Counter();         
       foreach(var logEntry in Model){ 
        ViewDataDictionary newViewData = new ViewDataDictionary{ {"rowIndex", counter.Increment()}};
        Html.RenderPartial("~/Views/AccountAdministration/ActionLogEntryRow.ascx", logEntry, newViewData); 
    } %> 
</table>
