<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<RISARC.Documents.Model.Document>>" %>
<%@ Import Namespace="RISARC.Common.Enumaration" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	<%= Html.Encode(ViewData.GetValue(GlobalViewDataKey.PageTitle)) %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
   <h2><%= Html.Encode(ViewData.GetValue(GlobalViewDataKey.PageTitle)) %></h2>
     <div class="totalAccount">  <%= Html.Encode(ViewData.GetValue(GlobalViewDataKey.PageDesc)) %> </div>
    
    <div class="floatRight clsMarginBottom10">
       <div class="floatLeft"> <img src="<%= Url.Content("~/Images/icons/exportExcel.png")  %>"" /> &nbsp;&nbsp;</div>
      <%= Html.ActionLink("Export to Excel", "ExportExcelSentRequests", new { startDate = ViewData["StartDate"], endDate = ViewData["EndDate"], acn = ViewData["Acn"], patientFName = ViewData["PatientFName"], patientLName = ViewData["PatientLName"], accountNo = ViewData["AccountNo"] ,ReportType=(int)ExportGridSetting.TransactionRequring })%>
   </div>
    
    <%= Html.Partial("_ViewReceivedDocuments",Model) %>
                 
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">

</asp:Content>
