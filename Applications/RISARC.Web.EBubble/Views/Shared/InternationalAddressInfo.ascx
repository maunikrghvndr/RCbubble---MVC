<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Common.Model.AddressInfo>" %>
<% string bindingPrefix = ViewData.GetValue<string>(GlobalViewDataKey.BindingPrefix); %>

<li>
    <label for="<%= bindingPrefix + "State" %>">
        County/Province <span class="ValidationInstructor">*</span></label>
    <%= Html.StyledTextBox(bindingPrefix + "State", Model.State, 100, null) %>
    <%= Html.ValidationMessage(bindingPrefix + "StateRequired", "Required")%>
</li>
<li>
    <label for="<%= bindingPrefix + "ZipCode" %>">
        Postal Code <span class="ValidationInstructor">*</span></label>
    <%= Html.StyledTextBox(bindingPrefix + "ZipCode", Model.ZipCode, 20, "intPostalCode")%>
    <%= Html.ValidationMessage(bindingPrefix + "ZipCodeRequired", "Required")%>
    <%= Html.ValidationMessage(bindingPrefix + "ZipCodeFormat")%>
</li>
