<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<%@ Import Namespace="RISARC.Common.Model" %>
<%
    // get all billing methods, and 
    ICollection<BillingMethod> availableBillingMethods = ViewData["AvailableBillingMethods"] as ICollection<BillingMethod>;
    BillingMethod? selectedBillingMethod = ViewData["SelectedBillingMethod"] as BillingMethod?;

    // this will determine how options will be displayed
    IDictionary<BillingMethod, string> billingMethodDescriptions = new Dictionary<BillingMethod, string>
    {
        { BillingMethod.CreditCard, "Bill to receiver by credit/debit card"},
        { BillingMethod.Free, "Document is free"},
        { BillingMethod.InvoiceProvider, "Bill to sender"},
        { BillingMethod.PaymentReceived, "Payment received"}
    };
    
    // render drop down partial view, buildling select list items from available billing methods and corresponding descriptions
    var billingMethodDropDownItems = from billingMethod in availableBillingMethods
                                     select new SelectListItem
                                     {
                                         Text = billingMethodDescriptions[billingMethod],
                                         Value = billingMethod.ToString(),
                                         Selected = billingMethod == selectedBillingMethod
                                     };

    Html.RenderPartial("DropDown", billingMethodDropDownItems);
 %>
