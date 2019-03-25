<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<RISARC.Files.Model.PerformanceReportDetail>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Performance Detailed Report
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Performance Detailed Report</h2>
    <%
        var NumeratorDenominator = "";
        if (Request["type"] == "1")
        {
            NumeratorDenominator = "Numerator";
        }
        else
        {
            NumeratorDenominator = "Denominator";
        }
    %>
    <div><a href="<%: Url.Content("~/ChangeFacility/Report") %>">Performance Report</a> > <%=NumeratorDenominator %> Detailed Report </div>
    <br />
    <div class="claimInfo ">
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
    </ul>
   <br /><br />
     <%= Html.Action("_gvPerformanceDetailReport", "ChangeFacility")%>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>

