<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Expenditure Analysis Report
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="setBorderSpace">
        <h2>Expenditure Analysis Report</h2>
        <div class="totalAccount">Select provider from the below list for which to view the Expenditure Analysis Report.</div>
    </div>
    <br />
   <input type="hidden" name="orgnizationName" id="orgnizationName" value="" />
     
   <%--  <div class="orgDatils">
        <div><%= Html.Action("ProviderDropdown")%></div>
        <div class="AdjustPosition"><%= Html.Action("MeasuresDropdown")%></div>
    </div>--%>




    <div class="orgDatils" style="display: none">
        <div class="floatLeft">Organization Name: <span class="orgName clsBold"><b></b></span></div>
        <div class="floatRight"><span>From: <b>01/01/2014</b> To: <b>12/31/2014</b></span></div>
    </div>
    <%= Html.Partial("_ExpenditureCallbackPanel")%>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
    <script type="text/javascript">

        $(document).ready(function () {
            ExpenditureCallbackPanel.PerformCallback({ ProviderId: 39, measureId: 1 })
   });
        

        function UpdateReportByProviderId(s, e) {
            $(".orgDatils").show();
            $(".orgName").html(s.GetText());
            $("#orgnizationName").val(s.GetValue());
            $(".orgDatils").show();
           
        }

        function MeasuresValue(s,e) {
           // alert(MeasuresName.GetValue());
            var orgnizationName = $("#orgnizationName").val();
            ExpenditureCallbackPanel.PerformCallback({ ProviderId: orgnizationName, measureId: MeasuresName.GetValue() })

        }

    </script>
</asp:Content>
