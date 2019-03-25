<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Common.Model.UserDescription>" %>
<%= Html.Encode(Model.Title) %> <%= Html.Encode(Model.FirstName) %> <%= Html.Encode(Model.LastName) %> (<%= Html.Encode(Model.Email) %>)
