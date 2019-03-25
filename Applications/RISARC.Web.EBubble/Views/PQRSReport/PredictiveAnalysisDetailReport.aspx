<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Predictive Analysis Detail Report
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<h2>Predictive Analysis Detail Report</h2>
    <div><a href="<%: Url.Content("~/ChangeFacility/PredictiveAnalysisReport") %>">Predictive Analysis</a> > Detailed Report </div>
    <br />

        <div class="claimInfo ">
        <table style="width: 85%;">
            <tr>
                <td>Condition : <b><%= Request["Cond"] %></b> </td>
                <td>Total Cases: <b><%= Request["Count"] %></b></td>
            </tr>
        </table>
    </div>

    <div class="selectPage"></div>
   

     <%= Html.Action("_PredictiveAnalysisDetailCallbackPanel", "ChangeFacility")%>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>


