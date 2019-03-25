<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<%= Html.DevExpress().ComboBox(settings => {
    settings.Name = "recipientEmailAddress";
    settings.CallbackRouteValues = new { Controller = "CreateDocument", Action = "GetRecipientEmailsCallback" };
    
    settings.Properties.IncrementalFilteringMode = IncrementalFilteringMode.StartsWith;
    settings.Properties.DropDownStyle = DropDownStyle.DropDown;
    settings.Properties.ValueType = typeof(string);
    settings.Width = Unit.Pixel(300);
    settings.Properties.DropDownButton.Visible = false;
}).BindList(ViewData["RecipientEmailAddressList"]).Bind(ViewData["RecipientEmailAddress"]).GetHtml()%>