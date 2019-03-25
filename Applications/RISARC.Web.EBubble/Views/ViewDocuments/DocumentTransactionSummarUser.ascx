<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Documents.Model.Document>" %>
<%@ Import Namespace="RISARC.Documents.Model.DocumentReception" %>
<style type="text/css">
    .style1 {
        height: 23px;
    }
</style>

<% Counter rowCounter = new Counter(); %>
<table class="data_table">

    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">
           Document Id
        </td>
        <td>
            <%= Html.Encode(Model.Id) %>
        </td>
    </tr>
<tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">
           Type of Document
        </td>
        <td>
            <%= Html.Encode(Model.DocumentTypeName) %>
        </td>
    </tr>
<tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">
           Description of Document
        </td>
        <td>
            <%= Html.Encode(Model.DocumentDescription) %>
        </td>
    </tr>
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">
            Status 
        </td>
        <td>
            <% Html.RenderPartial("~/Views/DocumentAdmin/AdminDocumentStatusAction.ascx", Model); %>
        </td>
    </tr>
    <tr id="MemNumLBL" class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">
            Member Number</td>
         <td>
           <%= Html.Encode(Model.MemberNumber) %>
         </td>
    </tr>
     <tr id="captionRow" class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">
            <div id="ProviderLBL">Claim Number</div>
       </td>
         <td>
           <%--   <%= Html.Encode(Model.ACN.ACNNumber)%>--%>
              <%= Model.ACN != null ? Model.ACN.ACNNumber.ToString() : (string)null%>          
         </td>
    </tr>
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">
            Provider Name (Id)
        </td>
        <td nowrap="nowrap"><%= Html.Encode(ViewData["ProviderName"]) %>(<%= Html.Encode(Model.SentFromProviderId) %>)</td>
    </tr>
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="style1">
            <b>Created On</b>
        </td>
        <td class="style1">
           
        <table><tr><td>
        <b>Server time zone:<br />
        <%= Model.CreateUTCDate.ToString("MM/dd/yyyy hh':'mm tt") %>  <%= TimeZoneInfo.Utc.StandardName %> <!--<% //= Html.SplitLineDate(Model.CreateUTCDate) %>--></b>
        </td><td>
        Your browser's current time zone:<br />
       <div id="ClientTime"></div> 

       <script type="text/javascript">
           //Michael Bert time calculations and ASHX/AJAX based on browser timezone on Jan 21, 2012
           var myDate = new Date();
           var timezone = jstz.determine(); 
           $.ajax({ url: "../TimeZoneCalculator.ashx?Date=<%= Model.CreateUTCDate%>&ClientTimeZone=" + (myDate.getTimezoneOffset() / 60), cache: false }).done(function (html) { $("#ClientTime").append(html + " (" + timezone.name() + ")"); });

        </script>
        </td></tr></table>

        </td>
    </tr>
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">
            <b>Created By (User Name)</b>
        </td>
        <td>
            <% Html.RenderPartial("UserDescription", Model.CreatedByUserDescription); %>
        </td>
    </tr>
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
    <td class="style1">
        <b>Sent To</b>
    </td>
    <td nowrap="nowrap" >
        <% if (Model.MultipleRecipients.Trim().Length > 0)
           {%>
                <div id='Div1'>
                    <!--<% // Html.RenderPartial("~/Views/ViewDocuments/DocsProviderValue.ascx", Model.DocumentRecipient); %>-->
                    <%= Model.MultipleRecipients.Replace(",", "<br />") %>
                </div>
        <% }
            else if (Model.DocumentRecipient is ProviderDocumentRecipient)
            {
                ProviderDocumentRecipient providerRecipient = (ProviderDocumentRecipient)Model.DocumentRecipient;
                %>
                    <%= Html.Encode(providerRecipient.ProviderName) %>
                <%
            }
            else if(Model.DocumentRecipient is UserDocumentRecipient)
            {
                UserDocumentRecipient userRecipient = (UserDocumentRecipient)Model.DocumentRecipient;

                if (!String.IsNullOrEmpty(userRecipient.EmailAddress))
                {%>
                    <%= Html.Encode(userRecipient.EmailAddress) %>
                <%}
                else
                {%>
                    <% Html.RenderPartial("UserDescription", userRecipient.UserDescription); %>
                <%} 
            }
            else
	        {%>
                <b>SENT TO EVERYONE</b>        
	        <%}%>
    </td>
</tr>
<tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
    <td class="headerCell">
        Document To Download
    </td>
    <td>
 <%--    <%  Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "DownloadDocumentLink", "Document", new { documentId = Html.Encrypt(Model.Id) }); %>--%>
    </td>
</tr>
<%--<tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
    <td class="headerCell">
        Number Of Pages
    </td>
    <td>
        <%= Html.Encode(Model.NumberOfPages) %>
    </td>
</tr>--%>
<tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
    <td class="headerCell">
        Cost
    </td>
    <td>
        $<%= Html.Encode(String.Format("{0:F}", Model.Cost)) %>
    </td>
</tr>
<tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
    <td class="headerCell">
        Request Document is For
    </td>
    <td>
    <% if(Model.DocumentRequestId.HasValue) {%>
         <%= Html.ActionLink(String.Format("Request ({0})", Model.DocumentRequestId.Value), "DocumentRequestTransaction",
                new { requestID = Html.Encrypt(Model.DocumentRequestId.Value) })
    %>
    <%}
      else
      {%>
            <div class="FieldInstructions">Document not sent for request</div> 
        <%--<%= Html.Mailto(Model.DocumentSentToEmail, Model.DocumentSentToEmail) %>--%>
    <%} %>
    </td>
</tr>
<tr  class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>"><td class="headerCell">
        Comments
    </td>
    <td>
    <%= Html.Encode(Model.Comments.Replace("\n", "<br/>")).Replace("&lt;br/&gt;", "<br/>") %>
    </td>
</tr>

<tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">

    <td class="headerCell">
        Release Form Submitted By User
    </td>

    <td>
        <% if(Model.SentComplianceFileId.HasValue){ %>
        <%= Html.ActionLink("Download Submitted Release Form", "DownloadSubmittedCompliance","DocumentAdmin",
                new { documentId = Html.Encrypt(Model.Id)}, null)%>
        <%} else{ %>
            <div class="FieldInstructions">None submitted</div>
        <%} %>
    </td>
</tr></table>

<script language="javascript" type="text/javascript">
    function trim(stringToTrim) {
        //return stringToTrim.replace(/^\s+|\s+$/g, "");
        return stringToTrim.replace(/^s*|s(?=s)|s*$/g, "");
    }
</script>