<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Predictive Analysis Report
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="setBorderSpace">
        <h2>Predictive Analysis Report</h2>
        <div class="totalAccount">Select provider from the below list for which to view the Predictive Analysis Report.</div>
    </div>
    <%--<div>
        <br />--%>
      <%--  <%= Html.Action("ParentChildProviderDropdown")%></div>--%>
     <%--<%= Html.Action("ProviderDropdown")%></div>--%>
    <div class="orgDatils" style="display:none">
        <div class="floatLeft">Organization Name: <span class="orgName clsBold"><b> </b></span></div>
        <div class="floatRight"><span>From: <b>01/01/<%= DateTime.Now.Year.ToString() %></b> To: <b>12/31/<%= DateTime.Now.Year.ToString() %></b></span></div>
    </div>
       <%= Html.Partial("_PredictiveAnalysisCallbackPanel")%>
 
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
     <script type="text/javascript">

         $(document).ready(function () {
             PredictiveAnaysisCallbackPanel.PerformCallback({ ProviderId: 39 })
         });

         function UpdateReportByProviderId(s, e) {
             $(".orgDatils").show();
             $(".orgName").html(s.GetText());
             PredictiveAnaysisCallbackPanel.PerformCallback({ ProviderId: s.GetValue() })
         }
    </script>
    </asp:Content>
