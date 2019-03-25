<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Common.Model.PhoneInfo>" %>

<div class="FixiedWT170">
<div class="floatLeft">
    <% string bindingPrefix = ViewData.GetValue<string>(GlobalViewDataKey.BindingPrefix); %>
(<%= Html.StyledTextBox(bindingPrefix + "PhoneAreaCode", Model.PhoneAreaCode, 3, "numbersonly phoneArea")%>)
    <%= Html.ValidationMessage(bindingPrefix + "PhoneAreaCodeRequired", "Required")%>
    <%= Html.ValidationMessage(bindingPrefix + "PhoneAreaCodeFormat")%>
</div>
<div class="floatRight">
    <%= Html.StyledTextBox(bindingPrefix + "PhoneBody", Model.PhoneBody, 15, "numbersonly phoneBody")%>
    <%= Html.ValidationMessage(bindingPrefix + "PhoneBodyRequired", "Required")%>
    <%= Html.ValidationMessage(bindingPrefix + "PhoneBodyFormat")%>
</div><br /><br />
<span>Digits only</span>
</div>
<div class="clear"></div>