<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Common.Model.ContactInfo>" %>
<% string bindingPrefix = ViewData.GetValue<string>(GlobalViewDataKey.BindingPrefix); %>
<li>
    <label>
        Contact Name <span class="ValidationInstructor">*</span></label>
    <%= Html.StyledTextBox(bindingPrefix + "Name", Model.Name) %>
    <%= Html.ValidationMessage(bindingPrefix + "NameRequired", "Required") %>
</li>
<li>
    <label>
        Contact Email <span class="ValidationInstructor">*</span></label>
    <%= Html.StyledTextBox(bindingPrefix + "Email", Model.Email)%>
    <%= Html.ValidationMessage(bindingPrefix + "EmailRequired", "Required")%>
    <%= Html.ValidationMessage(bindingPrefix + "EmailInvalid", "Invalid Email Address")%>
</li>
<li>
    <label>
        Contact Phone <span class="ValidationInstructor">*</span></label>
    <% ViewDataDictionary phoneInfoDictionary = new ViewDataDictionary();
       phoneInfoDictionary.SetValue(GlobalViewDataKey.BindingPrefix, bindingPrefix + "Phone.");
       phoneInfoDictionary.ModelState.Merge(ViewData.ModelState);
       Html.RenderPartial("PhoneInfo", Model.Phone, phoneInfoDictionary); %>
</li>
