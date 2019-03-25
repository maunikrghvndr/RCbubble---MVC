<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Membership.Model.RMSeBubbleMembershipUser>" %>
<%= Html.ActionLink(String.Format("{0} {1} {2} ({3})", Model.PersonalInformation.Title,
    Model.PersonalInformation.FirstName,
    Model.PersonalInformation.LastName,
    Model.UserName), "AdministerUser",
    new {
        emailAddress = Html.Encrypt(Model.UserName),
        returnUrl = ViewData.GetValue(GlobalViewDataKey.ReturnUrl)
    })%>
