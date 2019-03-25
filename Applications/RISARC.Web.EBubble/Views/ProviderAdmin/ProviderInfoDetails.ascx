<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Setup.Model.ProviderInfo>" %>
<table class="data_table">
        <% Counter rowCounter = new Counter(); %>
        <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
            <td class="headerCell">
                Name
            </td>
            <td>
                <%= Html.Encode(Model.Name) %>
            </td>
        </tr>
        <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
            <td class="headerCell">
                Main Contact
            </td>
            <td>
                <% Html.RenderPartial("~/Views/Shared/ContactDetails.ascx", Model.MainContact); %>
            </td>
        </tr>
        <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
            <td class="headerCell">
                Main Address
            </td>
            <td>
                <% Html.RenderPartial("~/Views/Shared/AddressDetails.ascx", Model.Address); %>
            </td>
        </tr>
        <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
            <td class="headerCell">
                Main Fax
            </td>
            <td>
                <%= Html.Encode(Model.FaxNumber.FullPhoneString) %>
            </td>
        </tr>
        <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
            <td class="headerCell">
                Alternate Contact
            </td>
            <td>
                <% Html.RenderPartial("~/Views/Shared/ContactDetails.ascx", Model.AlternateContact); %>
            </td>
        </tr>
        <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
            <td class="headerCell">
                Billing Contact
            </td>
            <td>
                <% Html.RenderPartial("~/Views/Shared/ContactDetails.ascx", Model.BillingContact); %>
            </td>
        </tr>
        <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
            <td class="headerCell">
                Billing Address
            </td>
            <td>
                <% Html.RenderPartial("~/Views/Shared/AddressDetails.ascx", Model.BillingAddress); %>
            </td>
        </tr>
    </table>
