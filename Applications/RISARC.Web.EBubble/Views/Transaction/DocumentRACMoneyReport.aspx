<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<RISARC.Documents.Model.Document>>" %>
<%@ Import Namespace="RISARC.Common.Enumaration" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Sent Documents Report
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>RAC $ Report</h2>
    <div class="floatRight clsMarginBottom10">
       <div class="floatLeft"> <img src="<%= Url.Content("~/Images/icons/exportExcel.png")  %>"" /> &nbsp;&nbsp;</div>
     <%= Html.ActionLink("Export to Excel", "ExportExcelSentRequests", new { ReportType=(int)ExportGridSetting.RACMoneyReport})%>
 </div> 
    <%=Html.Partial("DocumentRacMoneyTransactions",Model) %>
 
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">

</asp:Content>
