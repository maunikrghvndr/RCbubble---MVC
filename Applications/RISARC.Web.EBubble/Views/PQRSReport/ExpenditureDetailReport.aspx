
<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<RISARC.Files.Model.PerformanceReportDetail>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Expenditure Analysis Report
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
   <h2>Expenditure Analysis Report</h2>
    <div><a href="<%: Url.Content("~/ChangeFacility/ExpenditureReport") %>">Expenditure Analysis</a> > Detailed Report </div>
    <br />

   
    <div class="selectPage"></div>
   

     <%= Html.Action("_ExpenditureDetailCallbackPanel", "ChangeFacility")%>

</asp:Content>


<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>




