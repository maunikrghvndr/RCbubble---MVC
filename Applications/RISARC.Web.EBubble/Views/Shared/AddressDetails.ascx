<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Common.Model.AddressInfo>" %>
<%= Html.Encode(Model.StreetAddress) %><br />
<%= Html.Encode(Model.City) %>,
<%= Html.Encode(Model.State) %>
<%= Html.Encode(Model.ZipCode) %><br />
<%= Html.Encode(Model.CountryName) %>
