<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/PrintableReport.Master"
    Inherits="System.Web.Mvc.ViewPage<IEnumerable<RISARC.Documents.Model.DocumentRequest>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	<%= Html.Encode(ViewData.GetValue(GlobalViewDataKey.PageTitle)) %>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ReportTitleHolder" runat="server">
   <%= Html.Encode(ViewData.GetValue(GlobalViewDataKey.PageTitle)) %>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <% if(ViewData["StartDate"] != null) {%>
        <h2>Date From <%= String.Format("{0:d}", ViewData["StartDate"]) %></h2>
    <%} %>
    <% if(ViewData["EndDate"] != null) {%>
        <h2>Date To</h2>
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
        Requested Document Type
        </th>
        <th>
            Requested Document Description
        </th>
        <th>
            Status
        </th>
        <th>
            Date/Time Requested
        </th>
        <th>
            Response Due By
        </th>
        <th>
            Requested By
        </th>
        <th>
            Responded To With Document
        </th>
        </tr>
        <% // below items need to all appear on same line to be exported properly
            Counter rowCounter = new Counter();
            foreach (var request in Model)
            { %>
        <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
            <td>
            <%= Html.Encode(request.DocumentTypeName) %>
        </td>
        <td>
            <%= Html.Encode(request.DocumentDescription) %>
        </td>
        <td><label><% Html.RenderPartial("~/Views/ViewDocuments/RequestStatusDescription.ascx", null, new ViewDataDictionary {
                                  {"DocumentStatus", request.DocumentStatus}
                              }); %></label>
            
        </td>
        <td>
            <%= Html.SplitLineDate(request.RequestDate) %>
        </td>
        <td>
            <%= Html.SplitLineDate(request.RequestDueBy) %>
        </td>
        <td>
            <% Html.RenderPartial("UserDescription", request.CreatedByUserDescription); %>
        </td>
        <td>
            <% if (request.RespondedToByDocumentId.HasValue)
                   { %>
                    Yes 
                    <%} 
              else
              {%>
              <div class="FieldInstructions">No</div>
            <%} %>
        </td>
        </tr>
        <%} %>
    </table>
</asp:Content>
