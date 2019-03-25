<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Payment.Model.CreditCardPaymentInfo>" %>
<h3> Enter Billing Information <span>Step 2</span></h3>
<ul>
    <li>
        <label for="FirstName">
            First Name <span class="ValidationInstructor">*</span></label>
        <%= Html.StyledTextBox("FirstName", Model.FirstName) %>
        <%= Html.ValidationMessage("FirstNameRequired", "Required")%>
    </li>
    <li>
        <label for="FirstName">
            Last Name <span class="ValidationInstructor">*</span></label>
        <%= Html.StyledTextBox("LastName", Model.LastName) %>
        <%= Html.ValidationMessage("LastNameRequired", "Required")%>
    </li>
    <li>
        <label for="CompanyName">
            Company Name</label>
        <%= Html.StyledTextBox("CompanyName", Model.CompanyName) %>
    </li>
    <li><label for="BillingAddress.StreetAddress">Billing Address</label>
        <ul><% ViewDataDictionary addressInfoDictionary = new ViewDataDictionary();
               addressInfoDictionary.SetValue(GlobalViewDataKey.BindingPrefix, "BillingAddress.");
               addressInfoDictionary.ModelState.Merge(ViewData.ModelState);
               Html.RenderPartial("AddressInfo", Model.BillingAddress, addressInfoDictionary); %>
               
        </ul>
    </li>
    <li>
    <label for="PhoneAreaCode">
        Billing Phone <span class="ValidationInstructor">*</span></label>
    <% ViewDataDictionary primaryPhoneInfoDictionary = new ViewDataDictionary();
       primaryPhoneInfoDictionary.SetValue(GlobalViewDataKey.BindingPrefix, "BillingPhone.");
       primaryPhoneInfoDictionary.ModelState.Merge(ViewData.ModelState);

       Html.RenderPartial("PhoneInfo", Model.BillingPhone, primaryPhoneInfoDictionary); %>
    </li>
    </ul>
<h3>Enter Credit Card Information <span>Step 3</span></h3>   
<div style="float:right;margin:10px;">
                        	<img src="<%: Url.Content("~/images/cc.png")%>" alt=""/>
                        	<p style="font-weight:bold;color:#999;">We accept all major credit cards.<br/>
                        	Your transaction is 128-bit SSL Encrypted.<br/>
                        	For more information review our <a href="/Legal/Privacy">Privacy Policy</a>.</p>
                        </div> 
<ul>
    <li>
        <label for="CreditCardNumber">
            Credit Card Number <span class="ValidationInstructor">*</span></label>
        <%= Html.StyledTextBox("CreditCardNumber", Model.CreditCardNumber, 20, "numbersonly") %>
        <%= Html.ValidationMessage("CreditCardNumberRequired")%>
    </li>
    <li>
        <label for="SecurityCode">
            Security Code <span class="ValidationInstructor">*</span></label>
        <%= Html.StyledTextBox("SecurityCode", Model.SecurityCode) %>
        <%= Html.ValidationMessage("SecurityCodeRequired")%>
    </li>
    <li>
        <label for="ExpirationDate">
            Expiration Date <span class="ValidationInstructor">*</span></label>
        <% Html.RenderAction<RISARC.Web.EBubble.Controllers.CommonDropDownController>(x => x.MonthsDropDown("ExpirationMonth", 
               Model.ExpirationMonth, true)); %>
        <%= Html.ValidationMessage("ExpirationMonthRequired", "Required")%>
        <% Html.RenderAction<RISARC.Web.EBubble.Controllers.CommonDropDownController>(x => x.YearsDropDown("ExpirationYear", Model.ExpirationYear.ToString(),
               DateTime.Now.Year, DateTime.Now.AddYears(20).Year)); %>
        <%= Html.ValidationMessage("ExpirationYearRequired", "Required")%>
    </li>
    <li>
        <input type="submit" value="Submit Payment" />
        <%= Html.ValidationMessage("Payment") %><br />
        <%= Html.ValidationMessage("PaymentReason") %>
    </li>
</ul>
