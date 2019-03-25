<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<%= Html.DevExpress().ComboBox((ComboBoxSettings)ViewData.GetValue(GlobalViewDataKey.DevExpressComboBoxSettings)).BindList(Model).GetHtml() %>