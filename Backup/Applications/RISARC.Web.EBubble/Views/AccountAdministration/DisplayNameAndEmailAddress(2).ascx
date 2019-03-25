<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Membership.Model.RMSeBubbleMembershipUser>" %>
<%= Html.Encode(Model.PersonalInformation.Title)  %>
<%= Html.Encode(Model.PersonalInformation.FirstName)  %>
<%= Html.Encode(Model.PersonalInformation.LastName)  %>
<%= Html.Encode(Model.UserName) %>
