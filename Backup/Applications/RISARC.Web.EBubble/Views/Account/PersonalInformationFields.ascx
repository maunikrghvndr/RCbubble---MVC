<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Membership.Model.PersonalInformation>" %>
<% string bindingPrefix = ViewData.GetValue<string>(GlobalViewDataKey.BindingPrefix); %>
<li>
    <label for="Title">
        Title</label>
    <%= Html.StyledTextBox(bindingPrefix + "Title", Model.Title, 50, null)%>
</li>
<li>
    <label for="FirstName">
        First Name <span class="ValidationInstructor">*</span></label>
    <%= Html.StyledTextBox(bindingPrefix + "FirstName", Model.FirstName, 50, null)%>
    <%= Html.ValidationMessage(bindingPrefix + "FirstNameRequired", "Required")%>
</li>
<li>
    <label for="LastName">
        Last Name <span class="ValidationInstructor">*</span></label>
    <%= Html.StyledTextBox(bindingPrefix + "LastName", Model.LastName, 50, null)%>
    <%= Html.ValidationMessage(bindingPrefix + "LastNameRequired", "Required")%>
</li>
<% ViewDataDictionary addressInfoDictionary = new ViewDataDictionary();
   addressInfoDictionary.SetValue(GlobalViewDataKey.BindingPrefix, bindingPrefix + "Address.");
   addressInfoDictionary.ModelState.Merge(ViewData.ModelState);

   Html.RenderPartial("AddressInfo", Model.Address, addressInfoDictionary); %>

<li>
    <label>
        Primary Phone <span class="ValidationInstructor">*</span></label>

     <% ViewDataDictionary primaryPhoneInfoDictionary = new ViewDataDictionary();
       primaryPhoneInfoDictionary.SetValue(GlobalViewDataKey.BindingPrefix, bindingPrefix + "PrimaryPhone.");
       primaryPhoneInfoDictionary.ModelState.Merge(ViewData.ModelState);
      %>
    
  
       <% Html.RenderPartial("PhoneInfo", Model.PrimaryPhone, primaryPhoneInfoDictionary); %>

</li>

<li>
    <label>
        Secondary Phone
    </label>
    <% ViewDataDictionary secondaryPhoneInfoDictionary = new ViewDataDictionary();
       secondaryPhoneInfoDictionary.SetValue(GlobalViewDataKey.BindingPrefix, bindingPrefix + "SecondaryPhone.");
       secondaryPhoneInfoDictionary.ModelState.Merge(ViewData.ModelState);

       Html.RenderPartial("PhoneInfo", Model.SecondaryPhone, secondaryPhoneInfoDictionary); %>
</li>
<li>
    <label>
        Fax Number
    </label>
    <% ViewDataDictionary faxPhoneInfoDictionary = new ViewDataDictionary();
       faxPhoneInfoDictionary.SetValue(GlobalViewDataKey.BindingPrefix, bindingPrefix + "Fax.");
       faxPhoneInfoDictionary.ModelState.Merge(ViewData.ModelState);

       Html.RenderPartial("PhoneInfo", Model.Fax, faxPhoneInfoDictionary); %>
</li>
