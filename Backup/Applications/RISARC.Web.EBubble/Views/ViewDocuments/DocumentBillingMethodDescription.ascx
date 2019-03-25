<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Documents.Model.Document>" %>
<%@Import Namespace="RISARC.Common.Model" %>
<% BillingMethod billingMethod = Model.BillingMethod;
    if(billingMethod == BillingMethod.CreditCard){ %>Bill to receiver by credit/debit card<%} 
    else if (billingMethod == BillingMethod.Free){ %>Document is free<%} 
    else if (billingMethod == BillingMethod.InvoiceProvider){ %>Bill to sender<%} 
    else if (billingMethod == BillingMethod.PaymentReceived){  %>Payment received<% }%>

