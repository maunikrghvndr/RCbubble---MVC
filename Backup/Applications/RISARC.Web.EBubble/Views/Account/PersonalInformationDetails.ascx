<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Membership.Model.PersonalInformation>" %>

<table class="data_table">
    <tr>
        <td class="headerCell">
            Title
        </td>
        <td>
            <%= Html.Encode(Model.Title) %>
        </td>
    </tr>
    <tr class="alt">
        <td class="headerCell">
            First Name
        </td>
        <td>
            <%= Html.Encode(Model.FirstName) %>
        </td>
    </tr>
    <tr>
        <td class="headerCell">
            Last Name
        </td>
        <td>
            <%= Html.Encode(Model.LastName) %>
        </td>
    </tr>
    <tr class="alt">
        <td class="headerCell">
            Primary Phone
        </td>
        <td>
            <%= Html.Encode(Model.PrimaryPhone.FullPhoneString) %>
        </td>
    </tr>
    <tr>
        <td class="headerCell">
            Secondary Phone
        </td>
        <td>
            <%= Html.Encode(Model.SecondaryPhone.FullPhoneString) %>
        </td>
    </tr>
    <tr class="alt">
        <td class="headerCell">
            Address
        </td>
        <td>
            <% Html.RenderPartial("AddressDetails", Model.Address); %>
        </td>
    </tr>
</table>
