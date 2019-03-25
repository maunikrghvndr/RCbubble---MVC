<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IEnumerable<RISARC.Setup.Model.Provider>>" %>
<% Counter rowCounter = new Counter(); %>
<table class="data_table">
    <tr>
        <th>
            Provider Name (Id)
        </th>
        <th>
        </th>
        <th>
        </th>
    </tr>
<% foreach (var provider in Model)
   { %>
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td>
            <%= Html.Encode(provider.ProviderInfo.Name) %> (<%= Html.Encode(provider.Id) %>)
        </td>
        <td>
            <%= Html.ActionLink("Edit", "Edit", new { providerId = provider.Id })%>
        </td>
        <td>
            <%= Html.ActionLink("Manage Administrators", "ProvidersAdministrators", "AccountAdministration",
                new { providerId = provider.Id }, null)%>
        </td>
    </tr>
<%} %>
</table>
