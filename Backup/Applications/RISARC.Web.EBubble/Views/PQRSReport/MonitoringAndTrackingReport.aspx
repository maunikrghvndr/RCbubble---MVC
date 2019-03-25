<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
   Monitoring & Tracking Report
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="setBorderSpace">
        <h2>Monitoring & Tracking Report</h2>
        <div class="totalAccount">Select provider from the below list for which to view the Monitoring & Tracking report.</div>
    </div>
    <div>
        <br />
        <%= Html.Action("ProviderDropdown")%></div>
    
    <div class="orgDatils" style="display:none">
        <div class="floatLeft">Organization Name: <span class="orgName clsBold"><b> </b></span></div>
        <div class="floatRight"><span>From: <b>01/01/<%= DateTime.Now.Year.ToString() %></b> To: <b>12/31/<%= DateTime.Now.Year.ToString() %></b></span></div>
    </div>
       <%= Html.Partial("_MonitoringTrackingCallbackPanel")%>
 
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
     <script type="text/javascript">
         function UpdateReportByProviderId(s, e) {
             $(".orgDatils").show();
             $(".orgName").html(s.GetText());
             MonitoringTrackingCallbackPanel.PerformCallback({ ProviderId: s.GetValue() })
         }
    </script>
</asp:Content>
