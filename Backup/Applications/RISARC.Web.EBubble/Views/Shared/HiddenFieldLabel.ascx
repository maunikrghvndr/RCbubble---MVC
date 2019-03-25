<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<label><i><%= Html.Encode(ViewData.GetValue(GlobalViewDataKey.LabelText)) %></i></label>
<%= Html.Hidden((string)ViewData.GetValue(GlobalViewDataKey.FieldName),
    ViewData.GetValue(GlobalViewDataKey.FieldValue)) %>
