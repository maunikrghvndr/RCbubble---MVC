
<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<RISARC.Files.Model.PerformanceReportDetail>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Performance Analysis Report
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
   <h2>Performance Analysis Report</h2>
    <div><a href="<%: Url.Content("~/ChangeFacility/PerformanceAnalysisReport") %>">Performance Analysis</a> > Detailed Report </div>
    <br />

      <%--  <div class="claimInfo ">
        <table style="width: 85%;">
            <tr>
                <td>Provider : <b>Risarc</b> </td>
                <td>Month: <b>July</b></td>
            </tr>
            <tr>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td>Cost Driver Category : <b>Home Health Agency</b></td>
                <td>Results based on : <b>$ 1500</b></td>
            </tr>
        </table>
    </div>--%>

    <div class="selectPage"></div>
   

     <%= Html.Action("_PerformanceAnalysisDetailCallbackPanel", "ChangeFacility")%>

</asp:Content>


<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>




