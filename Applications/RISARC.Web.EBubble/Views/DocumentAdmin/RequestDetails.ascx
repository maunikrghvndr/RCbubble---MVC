<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Documents.Model.DocumentRequest>" %>
<% Counter rowCounter = new Counter(); %>
<table class="data_table">
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">
            Requested On
        </td>
        <td>
            
       <table><tr><td width="300px">
        Server time zone:<br />
        <%= (Model.RequestUTCDate).ToString()%>  <%= TimeZoneInfo.Utc.StandardName %>  <!--  <% // Html.SplitLineDate(Model.RequestDate) %> -->
        </td><td>
        <b>
        Your browser's current time zone:<br />
       <div id="RequestedDateClientTime"></div> 
       </b>
       <script type="text/javascript">
           //Michael Bert time calculations and ASHX/AJAX based on browser timezone on Jan 21, 2012
           var DateClientTime = new Date();
           var timezone = jstz.determine();
           $.ajax({ url: "../TimeZoneCalculator.ashx?Date=<%= Model.RequestUTCDate%>&ClientTimeZone=" + (DateClientTime.getTimezoneOffset() / 60), cache: false }).done(function (html) { $("#RequestedDateClientTime").append(html + " (" + timezone.name() + ")"); });

        </script>
        </td></tr></table>


        </td>
    </tr>
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">
            Response Due By
        </td>
        <td>
          

          <%
              if (Model.RequestDueBy.HasValue == true)
             { %>
       <table><tr><td width="300px">
        Server time zone:<br />
        <%= (Model.RequestUTCDueBy).ToString()%>  <%= TimeZoneInfo.Utc.StandardName%>  <!--  <% //Html.SplitLineDate(Model.RequestDueBy) %> -->
        </td><td><b>
        Your browser's current time zone:<br />
       <div id="ClientTime"></div> </b>

       <script type="text/javascript">
           //Michael Bert time calculations and ASHX/AJAX based on browser timezone on Jan 21, 2012
           var myDate = new Date();
           var timezone = jstz.determine();
           $.ajax({ url: "../TimeZoneCalculator.ashx?Date=<%= Model.RequestUTCDueBy%>&ClientTimeZone=" + (myDate.getTimezoneOffset() / 60), cache: false }).done(function (html) { $("#ClientTime").append(html + " (" + timezone.name() + ")"); });

        </script>
        </td></tr></table>
        <% } %>








        </td>
    </tr>
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">
            Requested By
        </td>
        <td>
            Provider/Facility: <%= Html.Encode(Model.SentToProviderName) %><br />
            <% Html.RenderPartial("UserDescription", Model.CreatedByUserDescription); %>
        </td>
    </tr>
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">
            Type of Requested Document
        </td>
        <td>
            <%= Html.Encode(Model.DocumentTypeName) %>
        </td>
    </tr>
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">
            Description of Requested Document
        </td>
        <td>
            <%= Html.Encode(Model.DocumentDescription) %>
        </td>
    </tr>
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">
            Purpose of Request
        </td>
        <td>
            <%= Html.Encode(Model.Comments) %>
        </td>
    </tr>
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">
            Information about Patient</td>
        <td>
            <%= Html.Encode(Model.PatientFirstName) %> 
                        <%= Html.Encode(Model.PatientLastName) %></td>
    </tr>
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">
                        Patient Identification</td>
        <td align="left">
                      <%System.Web.Mvc.Html.ChildActionExtensions.RenderAction(this.Html, "PatientIdentificationForRequest", "DocumentAdmin",
                                    new { patientIdDocumentRequestId = Html.Encrypt(Model.Id) }); %>
                        <!-- % Html.RenderAction("PatientIdentificationForRequest", "DocumentAdmin",
                                    new { patientIdDocumentRequestId = Html.Encrypt(Model.Id) }); % -->
           </td>
    </tr>
 
    <% if (Model.RespondedToByDocumentId.HasValue)
       { %>
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">
            Responded to with Document
        </td>
        <td>
            <%= Html.ActionLink(String.Format("{0} ({1})", Model.RespondedToByDocumentName, Model.RespondedToByDocumentId),
                "DocumentTransaction", new { documentId = Html.Encrypt(Model.RespondedToByDocumentId)}) %>
        </td>
    </tr>
    <%} %>
</table>
