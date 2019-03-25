<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IDictionary<short, RISARC.Setup.Model.ProviderInNetwork>>" %>
<% bool showFormActions = (bool)ViewData["ShowFormActions"]; %>
<table class="data_table">
    <tr>
        <th>
            Provider
        </th>
        <th>
            BAA Agreement Exists
        </th>
        <% if (showFormActions)
           { %>
        <th>
        </th>
        <th>
        </th>
        <%} %>
    </tr>
    <% Counter rowCounter = new Counter();
       foreach (var providerInNetwork in Model.Values)
       { %>
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td>
            <%= Html.Encode(providerInNetwork.ProviderName)%>
        </td>
        <td>
            <i>
                <%= Html.Encode(providerInNetwork.BAAExists) %></i>
        </td>
        <% if (showFormActions)
           { %>
        <td>
            <% using (Html.BeginForm("UpdateBAASetting", "ProviderAdmin"))
               { %>                
                <%= Html.Hidden("ProviderInNetworkId", providerInNetwork.ProviderId) %>
                <%if (providerInNetwork.BAAExists)
                  { %>
                <%= Html.Hidden("BAAExists", false)%>
                <input type="submit" value="Disable BAA Agreement" class="tinybuttons" />
                <%}
                  else
                  {%>
                <%= Html.Hidden("BAAExists", true)%>
                <input type="submit" value="Enable BAA Agreement" class="tinybuttons" />                  
                <%} %>
            <%} %>
        </td>
        <td>
            <% using(Html.BeginForm("RemoveProviderFromNetwork", "ProviderAdmin")){ %>
                <%= Html.Hidden("ProviderInNetworkId", providerInNetwork.ProviderId) %>
                <input type="submit" value="Remove Provider From Network" class="tinybuttons" onclick="return confirm('Are you sure you want to remove this provider from the network?');" />
            <%} %>
        </td>
        <%} %>
    </tr>
    <%} %>
</table>
