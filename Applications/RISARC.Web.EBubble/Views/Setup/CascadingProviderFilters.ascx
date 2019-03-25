<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<li>
<label for="ProviderState">Provider's State <span class="ValidationInstructor">*</span> </label>
<%  Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "StatesDropDown", "CommonDropDown", new { fieldName = "ProviderState", selectedValue = ViewData["SelectedProviderState"] }); %>
<%= Html.ValidationMessage("ProviderStateRequired", "Required")  %>
</li>
<li>
    
<label for="ProviderState">Provider's City <span class="ValidationInstructor">*</span> </label>
<div class="ProviderCitiesHolder">
<%  Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "ProviderCitiesDropDown", "Setup", new 
   { fieldName = "ProviderCity", 
       providerState = ViewData["SelectedProviderState"],
       selectedValue = ViewData["SelectedProviderCity"] }); %>
</div>
<%= Html.ValidationMessage("ProviderCityRequired", "Required")  %>
</li>
<li>
    <label for="ProviderId">Provider <span class="ValidationInstructor">*</span> </label>
    <div class="ProviderHolder">
    <%  Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "ProvidersDropDown", "Setup", new
    {
        fieldName = ViewData["ProviderIdFieldName"],
        providerState = ViewData["SelectedProviderState"],
        providerCity = ViewData["SelectedProviderCity"],
        selectedValue = ViewData["SelectedProviderId"],
    }); %>
    </div>
    <%= Html.ValidationMessage("ProviderIdRequired", "Required") %>
</li>