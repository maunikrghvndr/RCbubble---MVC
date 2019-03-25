<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Common.Model.UserDescription>" %>
<%= Html.Encode(Model.FirstName) %> <%= Html.Encode(Model.LastName) %> 
<% if(!String.IsNullOrEmpty(Model.Email)){ %>
    <%= Html.Mailto(Model.Email, Model.Email) %>
<%} %> 
<%= Html.Encode(Model.Title) %> 

