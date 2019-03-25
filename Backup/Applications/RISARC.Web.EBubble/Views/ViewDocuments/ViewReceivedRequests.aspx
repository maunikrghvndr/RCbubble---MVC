<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<RISARC.Documents.Model.DocumentRequest>>" %>
<%@ Import Namespace="RISARC.Common.Enumaration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	<%=Html.Encode(ViewData.GetValue(GlobalViewDataKey.PageTitle)) %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<h2 ><%=Html.Encode(ViewData.GetValue(GlobalViewDataKey.PageTitle))%> </h2>
  <%=Html.Encode(ViewData.GetValue(GlobalViewDataKey.PageDesc))%>
    <%--Added by Guru: Set action menthod dynamically."--%>
    <% string actionMethod = "MyOutstandingRequests";
       if (ViewData.GetValue(GlobalViewDataKey.PageTitle).Equals("Requests Responded To"))
       {
           actionMethod = "MyRespondedToRequests";
       }
    %>
    <% using (Html.BeginForm(actionMethod, "ViewDocuments"))
       { %>

    <div class="worklist_search">
      
        <table class="TableLayoutFixed7">
            <tr>
                <td style="vertical-align:top" class="blockTblTd" >
                    <label class="searchLabel"  for="acn">ACN/DCN/ICN:</label>
                      <%  
                          Html.DevExpress().TextBox(
                          settings =>
                          {
                              settings.Name = "acn";
                              settings.Width = System.Web.UI.WebControls.Unit.Percentage(95);
                              settings.Height = 32;
                          }
                      ).Bind(ViewData["Acn"] == null ? null : ViewData["Acn"].ToString()).GetHtml();
                    %>

                </td>
                <td class="blockTblTd">
                     <label class="searchLabel"  for="startDate">Sent Date From:</label>
                       <%= Html.DevExpress().DateEdit( RISARC.Web.EBubble.Models.DevxControlSettings.DateEditSetting.DateEditSettingsMethodAdditional(settings =>
                        {
                            settings.Name =  "startDate";
                            settings.Width = System.Web.UI.WebControls.Unit.Percentage(95);
                            settings.Properties.MaxDate = DateTime.UtcNow;
                            settings.Properties.ValidationSettings.ErrorText="Please select valid date.";
                            settings.ShowModelErrors = false;
                            
                            
                        })).Bind( ViewData["StartDate"]).GetHtml()%>
                </td>
                <td class="blockTblTd">
                    
                      <label class="searchLabel"  for="endDate"> Sent Date To:</label>
  <%= Html.DevExpress().DateEdit( RISARC.Web.EBubble.Models.DevxControlSettings.DateEditSetting.DateEditSettingsMethodAdditional(settings =>
                        {
                            settings.Name =  "endDate";
                            settings.Width = System.Web.UI.WebControls.Unit.Percentage(100);
                            settings.Properties.MaxDate = DateTime.UtcNow;
                            settings.Properties.ValidationSettings.ErrorText = "Please select valid date.";
                            settings.ShowModelErrors = false;
                            //Changing button of date control
                            settings.Properties.DropDownButton.Image.Url = Url.Content("~/Images/icons/calenderIcon.png");
                            settings.Properties.ButtonStyle.Paddings.Padding = 0;
                            settings.Properties.ButtonStyle.CssClass = "calenderIcon";
                        })).Bind( ViewData["EndDate"]).GetHtml()%>
                

                </td>
            </tr>
          
            <tr>
                <td >
                  <label class="searchLabel"  for="accountNo"> Account#:</label>
                       <%  
                          Html.DevExpress().TextBox(
                          settings =>
                          {
                              settings.Name = "accountNo";
                              settings.Width = System.Web.UI.WebControls.Unit.Percentage(95);
                              settings.Height = 32;
                          }
                          ).Bind(ViewData["accountNo"]==null?null :ViewData["accountNo"].ToString()).GetHtml();
                    %>

                 
                </td>
                <td>
                   
                <label class="searchLabel"  for="patientFName">  Patient First Name:</label>
                      <%  
                          Html.DevExpress().TextBox(
                          settings =>
                          {
                              settings.Name = "patientFName";
                              settings.Width = System.Web.UI.WebControls.Unit.Percentage(95);
                              settings.Height = 32;
                          }
                      ).Bind(ViewData["PatientFName"] == null ? null : ViewData["PatientFName"].ToString()).GetHtml();
                    %>
                </td>
                <td>
              
                     <label class="searchLabel"  for="patientLName">Patient Last Name:</label>
                    <%  
                          Html.DevExpress().TextBox(
                          settings =>
                          {
                              settings.Name = "patientLName";
                              settings.Width = System.Web.UI.WebControls.Unit.Percentage(100);
                              settings.Height = 32;
                          }
                      ).Bind(ViewData["PatientLName"] == null ? null : ViewData["PatientLName"].ToString()).GetHtml();
                    %>


                </td>
            </tr>
            <tr><td class="FixiedHT20"> </td></tr>
            <tr>
                <td>

                    <% 
           Html.DevExpress().Button(
                         settings =>
                         {
                             settings.Name = "btnSearch";
                             settings.Width = System.Web.UI.WebControls.Unit.Pixel(100);
                             settings.Height = 32;
                             settings.EnableTheming = false;
                             settings.ControlStyle.CssClass = "orangeBtn";
                             settings.ControlStyle.HorizontalAlign = System.Web.UI.WebControls.HorizontalAlign.Center;
                             settings.Text = "Search";
                             settings.UseSubmitBehavior = true;

                         }).GetHtml();
                    %>

                </td>
            </tr>
        </table>
    </div>
        
    <% } %>
    <%
        if (actionMethod == "MyOutstandingRequests")
        { %>
    <div class="floatRight clsMarginBottom10">
       <div class="floatLeft"> <img src="<%= Url.Content("~/Images/icons/exportExcel.png")  %>"" /> &nbsp;&nbsp;</div>
      <%= Html.ActionLink("Export to Excel", "ExportExcelSentRequests", new { startDate = ViewData["StartDate"], endDate = ViewData["EndDate"], acn = ViewData["Acn"], patientFName = ViewData["PatientFName"], patientLName = ViewData["PatientLName"], accountNo = ViewData["AccountNo"] ,ReportType=(int)ExportGridSetting.OutstandingRequests })%>
   </div>
     <%=Html.Partial("_ViewReceivedRequests", Model)%>
    
        <%}
        else
        {%>
    <div class="floatRight clsMarginBottom10">
       <div class="floatLeft"> <img src="<%= Url.Content("~/Images/icons/exportExcel.png")  %>"" /> &nbsp;&nbsp;</div>
      <%= Html.ActionLink("Export to Excel", "ExportExcelSentRequests", new { startDate = ViewData["StartDate"], endDate = ViewData["EndDate"], acn = ViewData["Acn"], patientFName = ViewData["PatientFName"], patientLName = ViewData["PatientLName"], accountNo = ViewData["AccountNo"] ,ReportType=(int)ExportGridSetting.RequestsRespondedTo })%>
   </div>
     <%=Html.Partial("_MyRespondedToRequests", Model)%>
    
        <%}
         %>



</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">

</asp:Content>

