<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Documents.Model.FaxInstructions>" %>
<ul>
    <li>
        <label><%= Html.Encode(Model.ProviderName) %></label>
    </li>
    <li>
        <label>Attn: <%= Html.Encode(Model.ContactName) %></label>
    </li>
    <li>
        <label>Fax Number: <%= Html.Encode(Model.FaxNumber) %></label>
    </li>
</ul>
