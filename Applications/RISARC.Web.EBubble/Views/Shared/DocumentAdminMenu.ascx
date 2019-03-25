<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<li><%= Html.ActionLink("Provider Docs", "ProvidersDocuments", "DocumentAdmin", null, null)%>
    <ul>
        <li>
            <%= Html.ActionLink("Provider Requests", "ProvidersRequests", "DocumentAdmin", null, null)%>
            
        </li>
        <li>
            <%= Html.ActionLink("Send Document", "Send", "DocumentAdmin") %>
        </li>
    </ul>
</li>
