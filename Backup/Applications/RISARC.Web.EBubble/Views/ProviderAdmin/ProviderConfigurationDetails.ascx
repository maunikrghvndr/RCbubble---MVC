<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Setup.Model.ProviderConfiguration>" %>
<table class="data_table">
    <% Counter rowCounter = new Counter(); %>
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">
            Release Form
        </td>
        <td>
            <%  Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "PreviewComplianceFileLink", "ProviderAdmin", new { providerId = ViewData["ProviderId"] }); %>
        </td>
    </tr>
    <%--<tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">
            Accept Release Forms By Fax
        </td>
        <td>
            <%= Html.Encode(Model.AcceptsComplianceFormsByFax) %>
        </td>
    </tr>--%>
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">
            Price Per Document Page
        </td>
        <td>
            $<%= Html.Encode(String.Format("{0:F}", Model.PricePerDocumentPage)) %>
        </td>
    </tr>
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">
            Price Per Document Megabyte
        </td>
        <td>
            $<%= Html.Encode(String.Format("{0:F}", Model.PricePerDocumentMegabyte)) %>
        </td>
    </tr>
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">
            Minimum Document Price
        </td>
        <td>
            $<%= Html.Encode(String.Format("{0:F}", Model.MinimumDocumentPrice)) %>
        </td>
    </tr>
</table>
