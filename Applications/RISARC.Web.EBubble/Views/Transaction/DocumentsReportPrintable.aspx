<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/PrintableReport.Master"
    Inherits="System.Web.Mvc.ViewPage<IEnumerable<RISARC.Documents.Model.Document>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	<%= Html.Encode(ViewData.GetValue(GlobalViewDataKey.PageTitle)) %>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ReportTitleHolder" runat="server">
  	<%= Html.Encode(ViewData.GetValue(GlobalViewDataKey.PageTitle)) %>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <% if (ViewData["StartDate"] != null)
       {%>
    <h2>
        From
        <%= String.Format("{0:d}", ViewData["StartDate"]) %></h2>
    <%} %>
    <% if (ViewData["EndDate"] != null)
       {%>
    <h2>
        To</h2>
    <%} %>
     <h2>
       Run Date  <% Response.Write(DateTime.Now.ToString("MM/dd/yyyy"));%>
    </h2>
     <h2>
       Run Time  <% Response.Write(DateTime.Now.ToString("hh:mm tt"));%>
    </h2>
    <table>
        <tr>
            <th>
                Type
            </th>
            <th>
                Status
            </th>
            <th>
                Sent On
            </th>
            <th>
                Sent By
            </th>
            <th>
                Sent for Request
            </th>
            <th>
                Cost
            </th>
            <th>
                Billing Method
            </th>
            <th>
                # of Pages
            </th>
        </tr>
        <% // below items need to all appear on same line to be exported properly
            Counter rowCounter = new Counter();
            foreach (var document in Model)
            { %>
        <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
            <td>
                <%= Html.Encode(document.DocumentTypeName) %>
            </td>
            <td>
                <label>
                    <% Html.RenderPartial("~/Views/ViewDocuments/DocumentStatusDescription.ascx", null, new ViewDataDictionary {
                                      {"DocumentStatus", document.DocumentStatus}
                                  }); %></label>
            </td>
            <td>
                <%= Html.SplitLineDate(document.CreateDate) %>
            </td>
            <td>
                <% Html.RenderPartial("UserDescription", document.CreatedByUserDescription); %>
            </td>
            <td>
                <%if (document.DocumentRequestId.HasValue)
                  { %>
                <div class="FieldInstructions">Yes</div>
                <%}
                  else
                  {%>
                <div class="FieldInstructions">
                    No</div>
                <%} %>
            </td>
            <td>
                $<%= String.Format("{0:f}", document.Cost) %>
            </td>
            <td>
                <% Html.RenderPartial("~/Views/ViewDocuments/DocumentBillingMethodDescription.ascx", document); %>
            </td>
            <td>
                <%= document.NumberOfPages %>
            </td>
        </tr>
        <%} %>
    </table>
</asp:Content>
