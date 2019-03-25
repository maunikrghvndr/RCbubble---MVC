<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IDictionary<short, string>>" %>
<% bool showDeleteButton = (bool)ViewData["ShowDeleteButton"]; %>
<table class="data_table">
<% Counter rowCounter = new Counter();
    foreach(var documentType in Model){ %>
<tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
    <td>
    <%= Html.Encode(documentType.Value) %> 
    </td><td>
    <% if(showDeleteButton && Model.Count > 1) /* only allow to delete if more than one provider document type exist */{ %>
        <% using(Html.BeginForm("RemoveDocumentTypeFromProvider", "ProviderAdmin")){ %>
            <%= Html.Hidden("DocumentTypeId", documentType.Key) %>
            <%= Html.SubmitImage("Delete", "../../images/Delete.png", new { onclick="return confirm('Remove document type from your provider?');"} ) %>
        <%} %>
    <%} %>
    </td>
</tr>
<% }%>
</table>