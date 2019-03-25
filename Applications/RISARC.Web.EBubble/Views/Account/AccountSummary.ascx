<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Membership.Model.RMSeBubbleMembershipUser>" %>
<%  Counter rowCounter = new Counter(); %>
<table class="data_table">
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">
            Email
        </td>
        <td>
            <%= Html.Encode(Model.Email) %>
        </td>
    </tr>
    <% if(Model.ProviderMembership != null){ %>
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">
            Organization
        </td>
        <td>
            <% Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "DisplayProviderName", "Setup", new { eProviderId = Html.Encrypt(Model.ProviderMembership.ProviderId) });  %>
        </td>
    </tr>
    <%} %>
</table>

