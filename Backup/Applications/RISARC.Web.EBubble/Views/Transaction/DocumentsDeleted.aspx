<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<RISARC.Documents.Model.DocumentRequest>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	<%= Html.Encode(ViewData.GetValue(GlobalViewDataKey.PageTitle)) %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<% DateTime? startDate = ViewData["StartDate"] as DateTime?;
   DateTime? endDate = ViewData["EndDate"]  as DateTime?; 
	bool showFilterDateRange;
	if(Model.Count() > 0)
		showFilterDateRange = true;
	else if (startDate.HasValue || endDate.HasValue)
	{
		showFilterDateRange = true;
	}
	else
		showFilterDateRange = false;
	// display acn column if any requests have acn number
	bool displayACNcolumn = Model.Any(x => x.ACN != null);
	%>
	<h2>RMSe-bubble Transaction Log
</h2>
		<% if (showFilterDateRange)
		   {
			   using (Html.BeginForm(new { pageNumber = 1 }))
			   {
				  %>   
	  <% Html.RenderPartial("FilterByDateRangeFields"); %>
	<%} %> 
	<%} %>
	<% if (Model.Count() == 0)
	   { %>
	<div class="FieldInstructions">
		No Records To Display</div>
	<%}
	   else
	   { %>
	  
	<strong>** Sorted by current Date Sent on.</strong>
	<strong> All times PST</strong>
	<table class="data_table">
		<tr>
			<th>
				Create Time</th>
			<th>
				File Name</th>
			<th>
				Full Path</th>
			<th>
				File Size</th>
			<th>&nbsp;</th>
			<th>
				&nbsp;</th>
			<% if (displayACNcolumn)
			   { %>
			<%} %>
			<th>
				&nbsp;</th>
		</tr>
		<% 
			Counter rowCounter = new Counter();
			foreach (var request in Model)
			{%>
		<tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
			<td class="style1">
				<%--<%= Html.Encode(String.Format("{0:g}", request.RequestDate)) %>--%>
				<%= Html.SplitLineDate(request.RequestDate) %>
			</td>
			<td class="style1">
				<%= Html.SplitLineDate(request.RequestDueBy) %>
			</td>
			<td class="style1">
				<%= request.DocumentTypeName%>
			</td>
			<td class="style1">
				<%= request.DocumentDescription%>
			</td>
			<td class="style1">
			<%--<td>
					<% Html.RenderPartial("ReceivedRequestStatusAction", null, new ViewDataDictionary {
						  {"DocumentStatus", request.DocumentStatus},
						  {"RequestId", request.Id}
					  });  %>
			</td>--%>
		</tr>
		<%} %>
	</table>
	
	<% Html.RenderPartial("StandardPageLinks"); %>

	<%} %>
	<%= Html.ActionLink("Print report", "ExportProviderSentDocumentsReporttest", new
	{
		startDate = ViewData["StartDate"] as DateTime?,
		endDate = ViewData["EndDate"] as DateTime?,
		exportType = RISARC.Web.EBubble.Controllers.ExportType.Printable,
	}, new { target = "_blank" })
	%>
	
	<%= Html.ActionLink("Export report", "ExportProviderSentDocumentsReporttest", new
	{
		startDate = ViewData["StartDate"] as DateTime?,
		endDate = ViewData["EndDate"] as DateTime?,
		exportType = RISARC.Web.EBubble.Controllers.ExportType.CSV
	})%>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
	<link rel="Stylesheet" type="text/css" href="<%: Url.Content("~/Content/custom-theme/jquery-ui-1.7.2.custom.css")%>" />
	<script type="text/javascript" src="<%: Url.Content("~/Scripts/jquery-ui-1.9.2.custom.min.js")%>"></script>
	<script type="text/javascript" src="<%: Url.Content("~/Scripts/LoadDatePickers.js")%>"></script>
    <style type="text/css">
        .style1
        {
            height: 24px;
        }
    </style>
</asp:Content>
