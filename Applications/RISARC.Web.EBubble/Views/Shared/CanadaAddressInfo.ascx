<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Common.Model.AddressInfo>" %>
<% string bindingPrefix = ViewData.GetValue<string>(GlobalViewDataKey.BindingPrefix); %>

<li>
    <label for="<%= bindingPrefix + "State" %>">
        Province <span class="ValidationInstructor">*</span></label>
    <% Html.RenderAction<RISARC.Web.EBubble.Controllers.CommonDropDownController>(
                   x => x.ProvincesDropDown(bindingPrefix + "State", Model.State)); %>
    <%= Html.ValidationMessage(bindingPrefix + "StateRequired", "Required")%>
</li>
<li>
    <label for="<%= bindingPrefix + "ZipCode" %>">
        Postal Code <span class="ValidationInstructor">*</span></label>
    <%= Html.StyledTextBox(bindingPrefix + "ZipCode", Model.ZipCode, 6, "zipCode")%>
    <%= Html.ValidationMessage(bindingPrefix + "ZipCodeRequired", "Required")%>
    <%= Html.ValidationMessage(bindingPrefix + "ZipCodeFormat")%>
</li>
