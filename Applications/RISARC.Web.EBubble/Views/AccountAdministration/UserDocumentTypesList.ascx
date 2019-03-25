<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IDictionary<short, string>>" %>
<% bool showFormActions = (bool)ViewData["ShowFormActions"]; %>
<table class="data_table">
<%
    if (Model.Count() > 0)
    {
        Counter rowCounter = new Counter();
        foreach (var documentType in Model)
        { %>
<tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
    <td>
    <%= Html.Encode(documentType.Value)%> 
    </td><td>
    <% if (showFormActions && Model.Count > 1) /* only allow to delete if more than one document type exist */
       { %>
        <% using (Html.BeginForm("RemoveDocumentTypeFromUser", "AccountAdministration"))
           { %>
            <%= Html.Hidden("UserName", Html.Encrypt(ViewData["UserName"]))%>
            <%= Html.Hidden("DocumentTypeId", documentType.Key)%>
            <%= Html.SubmitButton("Delete", "Remove Document Type from User", new { onclick = "return confirm('Remove document type from user?');", @class = "tinybuttons" })%>
        <%} %>
    <%} %>
    </td>
</tr>
<% }
    } else{%>
    <div class="FieldInstructions">No document types exists for user.</div>
    <%} %>
</table>