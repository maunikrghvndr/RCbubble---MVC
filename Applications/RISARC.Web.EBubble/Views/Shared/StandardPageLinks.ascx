<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<% DateTime? startDate = ViewData["StartDate"] as DateTime?;
   DateTime? endDate = ViewData["EndDate"]  as DateTime?; %>
<div class="paginate">
Page 
<%
    string formattedStartDate = String.Format("{0:d}", startDate);
    string formattedEndDate = String.Format("{0:d}", endDate);
     %>
<%= Html.PageLinks(
    (int)ViewData.GetValue(GlobalViewDataKey.PageNumber),
    (int)ViewData.GetValue(GlobalViewDataKey.NumberOfPages),
    pageNumber => Url.Action(ViewData.GetValue<string>(GlobalViewDataKey.ActionName), new 
    {
        pageNumber = pageNumber,
        startDate = formattedStartDate,
        EndDate = formattedEndDate,
    }))%>
</div>