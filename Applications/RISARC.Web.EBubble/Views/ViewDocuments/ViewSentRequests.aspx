<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<RISARC.Documents.Model.DocumentRequest>>" %>
<%@ Import Namespace="RISARC.Common.Enumaration" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Sent Requests
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<h2>Sent Requests</h2>
 <div class="floatRight clsMarginBottom10">
       <div class="floatLeft"> <img src="<%= Url.Content("~/Images/icons/exportExcel.png")  %>"" /> &nbsp;&nbsp;</div>
     <%= Html.ActionLink("Export to Excel", "ExportExcelSentRequests", new { page = 1, orderBy = "~", filter = "~",ReportType=(int)ExportGridSetting.SentRequests }, new { id = "exportLink" })%>
 </div>
    <%=Html.Action("_MySentRequests","ViewDocuments") %>
    
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">

</asp:Content>

