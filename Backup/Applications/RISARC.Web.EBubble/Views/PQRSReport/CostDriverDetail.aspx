
<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<RISARC.Files.Model.PerformanceReportDetail>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Cost Driver Detail Report
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
   <h2>Cost Driver Detail Report</h2>
    <div><a href="<%: Url.Content("~/ChangeFacility/CostDriverReport") %>">Cost Driver </a> > Detailed Report </div>
    <br />
   <%-- <div class="claimInfo ">
        <table style="width: 85%;">
            <tr>
                <td>Provider : <b><%=Model.ProviderName %></b> </td>
                <td>From : <b>01/01/2014</b> &nbsp;&nbsp;&nbsp;&nbsp;To : <b>12/31/2014</b></td>
            </tr>
            <tr>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td>Measure : <b><%=Model.Measures %></b></td>
                <td>Results based on : <b>Numerator(<%=Model.Numerator %>)</b></td>
            </tr>
        </table>
    </div>

    <div class="selectPage"></div>
    <ul class="reportLI">
        <li>Denominator: <b><%=Model.Denominator %></b></li>
        <li>Quality Points: <b><%=Model.QualityPoints %></b></li>
        <li>Number of Patients: <b><%=Model.Patient.Count %></b></li>
    </ul>--%>

        <div class="claimInfo ">
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
    </div>

    <div class="selectPage"></div>
   

     <%= Html.Action("_gvCostDriverDetail", "ChangeFacility")%>

</asp:Content>


<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>




