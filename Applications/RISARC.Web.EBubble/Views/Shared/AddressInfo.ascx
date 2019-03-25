<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Common.Model.AddressInfo>" %>
<% string bindingPrefix = ViewData.GetValue<string>(GlobalViewDataKey.BindingPrefix); %>
<li>
    <label for="<%= bindingPrefix + "StreetAddress" %>">
        Street Address <span class="ValidationInstructor">*</span></label>
    <%= Html.StyledTextBox(bindingPrefix + "StreetAddress", Model.StreetAddress, 100, null)%>
    <%= Html.ValidationMessage(bindingPrefix + "StreetAddressRequired", "Required")%>
</li>
<li>
    <label for="<%= bindingPrefix + "City" %>">
        City <span class="ValidationInstructor">*</span></label>
    <%= Html.StyledTextBox(bindingPrefix + "City", Model.City, 150, null)%>
    <%= Html.ValidationMessage(bindingPrefix + "CityRequired", "Required")%>
</li>
<li>
    <label for="<%= bindingPrefix + "Country" %>">
        Country <span class="ValidationInstructor">*</span></label>
    <div class="linkWrapper">
    <% Html.RenderAction<RISARC.Web.EBubble.Controllers.CommonDropDownController>(
                   x => x.CountriesDropDown(bindingPrefix + "CountryCode", Model.CountryCode
        )); %>
        <%= Html.LoadingImage(false,Url.Content("~/Images/ajax-loader.gif")) %>
        <label class="bindingPrefix" style="display: none"><%= Html.Encode(bindingPrefix) %></label>
    </div>
    <%= Html.ValidationMessage(bindingPrefix + "CountryRequired", "Required")%>
</li>
<div class="addressContentsWrapper">
<div class="addressContents">
<% if (Model.CountryCode == "US")
       Html.RenderPartial("USAddressInfo", Model);
   else if (Model.CountryCode == "CA")
       Html.RenderPartial("CanadaAddressInfo", Model);
   else if (!String.IsNullOrEmpty(Model.CountryCode))
       Html.RenderPartial("InternationalAddressInfo", Model);
     %>
     </div>
</div>
