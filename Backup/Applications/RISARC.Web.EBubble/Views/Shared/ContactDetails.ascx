<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Common.Model.ContactInfo>" %>
<ul>
    <li>Name:
        <%= Html.Encode(Model.Name) %></li>
    <li>Email:
        <%= Html.Encode(Model.Email) %>
    </li>
    <li>Phone:
        <%= Html.Encode(Model.Phone.FullPhoneString) %>
    </li>
</ul>
