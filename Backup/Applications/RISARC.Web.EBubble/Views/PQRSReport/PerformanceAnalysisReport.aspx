<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Population Analysis Report
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="setBorderSpace">
        <h2>Performance Analysis Report</h2>
        <div class="totalAccount">Select provider from the below list for which to view the Population Analysis report.</div>
    </div>
    <br />
   <input type="hidden" name="orgnizationName" id="orgnizationName" value="" />
    <input type="hidden" name="measureName" id="measureName" value="" />
     
     <div class="orgDatils">
        <div><%= Html.Action("ProviderDropdown")%></div>
        <div class="AdjustPosition"><%= Html.Action("MeasuresDropdown")%></div>
    </div>




    <div class="orgDatils" style="display: none">
        <div class="floatLeft">Organization Name: <span class="orgName clsBold"><b></b></span></div>
        <div class="floatRight"><span>From: <b>01/01/<%= DateTime.Now.Year.ToString() %></b> To: <b>12/31/<%= DateTime.Now.Year.ToString() %></b></span></div>
    </div>
    <%= Html.Partial("_PerformanceAnalysisCallbackPanel")%>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
    <script type="text/javascript">
        function UpdateReportByProviderId(s, e) {
            $(".orgDatils").show();
            $(".orgName").html(s.GetText());
            $("#orgnizationName").val(s.GetValue());
            $(".orgDatils").show();


            var orgnizationName = $("#orgnizationName").val();
            var measureName = $("#measureName").val();
            if (orgnizationName != "" && measureName != "") {
                PerformanceAnaysisCallbackPanel.PerformCallback({ ProviderId: orgnizationName, MeasureId: measureName })
            }
           
        }

        function MeasuresValue(s, e) {

            $("#measureName").val(s.GetValue());
           
            var orgnizationName = $("#orgnizationName").val();
            var  measureName =  $("#measureName").val();
             if (orgnizationName != "" && measureName != "") {
            PerformanceAnaysisCallbackPanel.PerformCallback({ ProviderId: orgnizationName, MeasureId: measureName })
          }
        }

    </script>
</asp:Content>
