<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Perfromance Report
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<h2>Performance Report</h2>
    <div class="totalAccount">Select provider from the below list for which to view the ACO GPRO report.</div>
    





   <div><%= Html.Action("ProviderDropdown")%></div> 
     <%= Html.Partial("_ReportCallbackPanelPartial")%>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
    <script type="text/javascript">
        function UpdateReportByProviderId(s, e) {
           // alert(s.GetValue());
            ReportCallbackPanel.PerformCallback({ ProviderId: s.GetValue() })
        }
    </script>

</asp:Content>
