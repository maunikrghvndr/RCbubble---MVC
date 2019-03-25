<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Documents.Model.Document>" %>
<style type="text/css">
    .style1
    {
        width: 230px;
    }
    .style2
    {
        width: 230px;
        height: 23px;
    }
    .style3
    {
        height: 23px;
    }
    .style4
    {
        width: 22px;
    }
    .style5
    {
        height: 23px;
        width: 22px;
    }
    .style6
    {
        width: 230px;
        height: 21px;
    }
    .style7
    {
        width: 22px;
        height: 21px;
    }
    .style8
    {
        height: 21px;
    }
</style>
<% Counter rowCounter = new Counter(); %>
 <% using (Html.BeginForm("RacAppealsUpdate", "ViewDocuments", 
           new { documentId = Html.Encrypt(Model.Id) }))
     
   { %>
<table class="data_table">
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="style2">
            Request Date:</td>
        <td class="style5"> <%= Html.Telerik().DatePicker()
                            .Name("RequestDate")
                            .Format(RISARC.Web.EBubble.Models.Constants.TelerikControlConstants.DateFormat)
                            .Value(Model.RequestDate)%>        </td>
        <td class="style3">
            Original Pay ($):</td>
        <td class="style3"><%= Html.StyledTextBox("OriginalPay",Model.OriginalPay) %></td>
    </tr>
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="style1">
            Denial Date: 
        </td>
        <td class="style4">
               <%= Html.Telerik().DatePicker()
               .Name("DenialDate")
               .Format(RISARC.Web.EBubble.Models.Constants.TelerikControlConstants.DateFormat)
               .Value(Model.DenialDate)
               .ClientEvents(events => events.OnChange("onchangeDenialDate"))%>
        </td>
        <td>
            Overpayment:
        </td>
        <td>     <%= Html.StyledTextBox("Overpayment",Model.Overpayment) %> </td>
    </tr>
        <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="style1">
            Appeal Date: 
        </td>
        <td class="style4">
              <%= Html.Telerik().DatePicker()
              .Name("AppealDate")
              .Format(RISARC.Web.EBubble.Models.Constants.TelerikControlConstants.DateFormat)
              .Value(Model.AppealDate)%>
        </td>
        <td>
            INS/copay:</td>
              <td>           <%= Html.StyledTextBox("InsCopyay", Model.InsCopay)%></td>
    </tr>
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="style6">
             Appeal Levels: 
        </td>
        <td class="style7">  <%= Html.Encode(Model.AppealLevel)%> <br />
              <%= Html.Telerik().DropDownList().Name("ComboBox")
        .Items(item => 
        {
            item.Add().Text("").Value("0");
            item.Add().Text("RAC").Value("1");
            item.Add().Text("1st Appeal (F1/Mac)").Value("2");
            item.Add().Text("2nd Appeal (QIC)").Value("3");
            item.Add().Text("3rd Appeal (ALJ)").Value("4");
            item.Add().Text("4th Appeal (Department Board)").Value("5");
            item.Add().Text("5th Appeal (District Court)").Value("6");
        }).ClientEvents(events => events.OnLoad("onload")).ClientEvents(events => events.OnChange("onDropDownListChange")).DropDownHtmlAttributes(new { style = "width:250px; font-size: 10px; height: 70px;" })%>  </td>
        <td class="style8">
         Recoup:
        </td>
        <td class="style8"> <%= Html.StyledTextBox("Recouped", Model.Recouped) %></td>
    </tr>
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="style2">
           Denial Reason: 
        </td>
        <td class="style5">
            <%= Html.StyledTextBox("DenialReason", Model.DenialReason) %>
        </td>
        <td class="style3">
           Return:</td>
        <td class="style3">  <%= Html.StyledTextBox("Return", Model.Returned)%></td>
    </tr>

     <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="style1">Response Due Date:</td>
        <td class="style4">
           <%= Html.Telerik().DatePicker()
           .Name("ResponseDueDate")
           .Format(RISARC.Web.EBubble.Models.Constants.TelerikControlConstants.DateFormat)
           .Value(Model.ResponseDueDate)
           .ClientEvents(events => events.OnLoad("onLoadResponseDueDate"))
           .ClientEvents(events => events.OnChange("onchangeResponseDueDate"))%> </td>
        <td>
            Total Loss:</td>
        <td> <%= Html.StyledTextBox("TotalLoss",Model.TotalLoss) %></td>
    </tr>

    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="style1">
            # of Days Left to Respond:</td>
        <td class="style4">
           <div id="dateVal"></div>
        </td>
      </tr>
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="style2">Appeal Status:</td>
        <td class="style7">  <%= Html.Encode(Model.AppealStatus)%> <br />
               <%= Html.Telerik().DropDownList().Name("AppealStatus")
        .Items(item => 
        {
            item.Add().Text("").Value("0");
            item.Add().Text("Approved").Value("1");
            item.Add().Text("Decision Pending").Value("2");
            item.Add().Text("Denied").Value("3");
         }) %>   
        </td>
        <td class="style3">
            </td>
        <td class="style3">
            </td>
    </tr>
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="style1">Recoup Deadline:</td>
        <td class="style4">
            <%= Html.Telerik().DatePicker()
            .Name("ReccoupedDeadline")
            .Format(RISARC.Web.EBubble.Models.Constants.TelerikControlConstants.DateFormat)
            .Value(Model.RecoupedDeadline)%>
        </td>
        <td>
            &nbsp;</td>
        <td>
            &nbsp;</td>
    </tr>
     <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="style1">
            Date Denial Letter Received:</td>
        <td class="style4"> <%= Html.Telerik().DatePicker()
                            .Name("DateDenialLetterRecived")
                            .Format(RISARC.Web.EBubble.Models.Constants.TelerikControlConstants.DateFormat)
                            .Value(Model.DateDenialLetterRecived)%>
         </td>
        <td>
            &nbsp;</td>
        <td>
            &nbsp;</td>
    </tr>
       <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="style1">
            Approved Date:</td>
      <td class="style4"> 
          <%= Html.Telerik().DatePicker()
          .Name("ApprovedDate")
          .Format(RISARC.Web.EBubble.Models.Constants.TelerikControlConstants.DateFormat)
          .Value(Model.ApproveDate)%>
      </td>
      <td> 
          &nbsp;</td>
      <td> 
          &nbsp;</td>
    </tr>
 
   <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="style1"> Notes: </td>
      <td class="style4">    <%= Html.TextArea("Notes", Model.Notes, 10, 50, new { style = "width:600; height=400px" })%>   </td>
      <td>    &nbsp;</td>
      <td>    &nbsp;</td>
    </tr>     
 
 </table>

 
         <input type="submit" class="t-button" value="Appeal update" />   
 

 <% } %>
 <script type="text/javascript">

     function onDropDownListChange(e) {
         var now = new Date();
         var datepicker = null;
         datepicker = $('#DenialDate').data('tDatePicker');
         var date1 = new Date(datepicker.value());
         if (e.value == 0) {
             document.getElementById('dateVal').innerHTML = ''
         }
         if (e.value == 1) {
             date1.setDate(date1.getDate() + 120);
         }
         if (e.value == 2) {
             date1.setDate(date1.getDate() + 120);
         }
         if (e.value == 3) {
             date1.setDate(date1.getDate() + 180);
         }
         if (e.value == 4) {
             date1.setDate(date1.getDate() + 60);
         }
         if (e.value == 5) {
             date1.setDate(date1.getDate() + 60);
         }
         if (e.value == 6) {
             date1.setDate(date1.getDate() + 60);
         }
         var otherDatePicker = $('#ResponseDueDate').data('tDatePicker');
         otherDatePicker.value(date1);
         document.getElementById('dateVal').innerHTML = '# of Days Left to Respond: ' + days_between(date1, now);
       
       }

     function onchangeDenialDate(e) {
         var datepicker = $('#DenialDate').data('tDatePicker');
         var date1 = datepicker.value();
         if (date1 == null)
             $("#ComboBox").data("tDropDownList").disable();
         else 
             $("#ComboBox").data("tDropDownList").enable();
         
     }

     function onload(e) {

         var datepicker = $('#DenialDate').data('tDatePicker');
         var date1 = datepicker.value();
         if (date1 == null)
             $("#ComboBox").data("tDropDownList").disable();

     }
     function onLoadResponseDueDate() {
         var datepicker = $('#ResponseDueDate').data('tDatePicker');
         var date1 = datepicker.value();
         var now = new Date();
         if (date1 != null) {
             document.getElementById('dateVal').innerHTML = days_between(date1, now);
             document.getElementById('dateVal').innerHTML = date1;
              
         }
     }
              
     function onchangeResponseDueDate(e) {
          var datepicker = $('#ResponseDueDate').data('tDatePicker');
          var date1 = datepicker.value();
          var now = new Date();
         if (date1 != null) {
             document.getElementById('dateVal').innerHTML =  days_between(date1, now);
         
         };

     }
     function ExecuteOnLoad() {
         var datepicker = $('#ResponseDueDate').data('tDatePicker');
         var date1 = datepicker.value();
         var now = new Date();
         if (date1 != null) {
            document.getElementById('dateVal').innerHTML =  days_between(date1, now);
        }
     }

     function days_between(date1, date2) {

         // The number of milliseconds in one day
         var ONE_DAY = 1000 * 60 * 60 * 24

         // Convert both dates to milliseconds
         var date1_ms = date1.getTime()
         var date2_ms = date2.getTime()

         // Calculate the difference in milliseconds
         var difference_ms = Math.abs(date1_ms - date2_ms)

         // Convert back to days and return
         return Math.round(difference_ms / ONE_DAY)

     }
 
  </script>   

 