<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Membership.Model.UserProviderMapping>" %>

<%= @Html.DevExpress().ListBox(
    settings => {
        settings.Name = "OldUser";
        settings.Width = Unit.Percentage(100);
        settings.Height = Unit.Pixel(100);
        settings.Properties.EnableClientSideAPI = true;
        settings.Properties.TextField = "FullName";
        settings.Properties.ValueField = "UserIndex";
        settings.Properties.ValueType = typeof(int);
    }).BindList(Model.MappedUserToProvider).GetHtml() %>