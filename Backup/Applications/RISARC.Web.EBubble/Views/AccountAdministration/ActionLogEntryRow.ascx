<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Logging.Model.ActionLogEntry>" %>
<% int rowIndex = (int)ViewData["rowIndex"];
   bool isEven = rowIndex % 2 == 0;
   string rowClassString;
   if (isEven)
       rowClassString = "class='alt'";
   else
       rowClassString = "";
   
    bool ShowDocumentColumns = (bool?)ViewData["HideDocumentColumns"] == false;  %>  
<tr <%= rowClassString %>>
    <% if(ShowDocumentColumns){ %>
    <td>
        <%= Html.Encode(Model.DocumentType) %>
        <% if(Model.DocumentId.HasValue){ %>
        <%= Html.ActionLink("Document Details",
                "DocumentTransaction", "Transaction", new { documentId = Html.Encrypt(Model.DocumentId)}, null) %>
                <%} %>
    </td>
    <td>
    
        <%= Html.Encode(Model.DocumentType) %>
        <%if (Model.RequestId.HasValue)
      { %>
        <%= Html.ActionLink("Request Details", "DocumentRequestTransaction", "Transaction", 
                new { requestID = Html.Encrypt(Model.RequestId.Value) }, null)%>
        <%}%>
    </td>
        <%} %>
    <td>
            <%= Html.Encode(Model.ActionByUserName) %>
    </td>
    <%-- <td>
            <%= Html.Encode(Model.PreviousStatusName) %>
        </td>--%>
    <td>
        <%= Html.Encode(Model.ActionDescription.Replace("\n", "<br/>")).Replace("&lt;br/&gt;", "<br/>") %>
    </td>
    <td>
   
        <%//= Html.Encode(Model.ActionTime) %>

        <table><tr><td>
        <b>Server time zone:<br />
        
        <%= Model.ActionUTCTime.ToString("MM/dd/yyyy hh':'mm tt")%>  <%= TimeZoneInfo.Utc.StandardName %> </b>
        </td><td>
        Your browser's current time zone:<br />
       <div id="ClientTime_LOG<%= rowIndex%>"></div> 

       <script type="text/javascript">
           //Michael Bert time calculations and ASHX/AJAX based on browser timezone on Jan 21, 2012
           var myDate = new Date();
           var timezone = jstz.determine();
           $.ajax({ url: "../TimeZoneCalculator.ashx?Date=<%= Model.ActionUTCTime%>&ClientTimeZone=" + (myDate.getTimezoneOffset() / 60), cache: false }).done(function (html) { $("#ClientTime_LOG<%= rowIndex%>").append(html + " (" + timezone.name() + ")"); });

        </script>
        </td></tr></table>


    </td>
</tr>
