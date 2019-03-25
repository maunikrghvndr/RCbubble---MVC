<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Documents.Model.DocumentReception.ADocumentRecipient>" 

%><%@ Import Namespace="RISARC.Documents.Model.DocumentReception"

 %><% if (Model is ProviderDocumentRecipient)
   {
       ProviderDocumentRecipient providerRecipient = (ProviderDocumentRecipient)Model;%>Provider:<%= Html.Encode(providerRecipient.ProviderName)
   %><%}
   else if (Model is UserDocumentRecipient)
   {
       UserDocumentRecipient userDocumentRecipient = (UserDocumentRecipient)Model;
    // if recipient has email address, then it's known this was sent to an email address.
    // just render the email addrress.  Otherwise, can assume was sent to actual user with description.   Show the user description
    if (!String.IsNullOrEmpty(userDocumentRecipient.EmailAddress))
    {%><%= Html.Encode(userDocumentRecipient.EmailAddress) %><%}
       else
       {%><% Html.RenderPartial("UserDescription", userDocumentRecipient.UserDescription); %><%} %><%} %>