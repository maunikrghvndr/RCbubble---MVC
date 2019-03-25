<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Documents.Model.DocumentRequest>" %>
<% Counter rowCounter = new Counter(); %>
<table class="data_table">
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">
           Id
        </td>
        <td>
            <%= Html.Encode(Model.Id) %>
        </td>
    </tr>
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">
            Status 
        </td>
        <td>
            
    <% Html.RenderPartial("~/Views/ViewDocuments/ReceiveRequestStatusAction.ascx", Model); %>
        </td>
    </tr>
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">
           Description of Document Requested
        </td>
        <td>
            <%= Html.Encode(Model.DocumentDescription) %>
        </td>
    </tr>
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">
           Type of Requested Document
        </td>
        <td>
            <%= Html.Encode(Model.DocumentTypeName) %>
        </td>
    </tr>
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">
            Provider Name (Id)
        </td>
        <td>
            <%= Html.Encode(Model.SentToProviderId) %>
            (<%= Html.Encode(Model.SentToProviderName) %>)
        </td>
    </tr>
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">
            Requested On
        </td>
        <td>
            <%= Html.SplitLineDate(Model.RequestDate) %>
        </td>
    </tr>
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">
            Requested By (Email Address)
        </td>
        <td>
            <% Html.RenderAction<RISARC.Web.EBubble.Controllers.AccountAdministrationController>(
               x => x.DisplayNameAndEmailAddress(Model.CreatedByUserIndex)); %>
        </td>
    </tr>
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">
            Requested For (Patient Identification)
        </td>
        <td>
            <%= Html.Encode(Model.PatientFirstName) %>  <%= Html.Encode(Model.PatientLastName) %><br />
             <% Html.RenderAction<RISARC.Web.EBubble.Controllers.DocumentAdminController>(
               x => x.PatientIdentificationForRequest(Model.Id)); %>
        </td>
    </tr>
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">
            Request Comments
        </td>
        <td>
        <%= Html.Encode(Model.Comments) %>
        </td>
    </tr>
    <tr class="<%= Html.TableRowAlternatingClass(ref rowCounter) %>">
        <td class="headerCell">
            Responded To With Document
        </td>
        <td>
        <% if (Model.RespondedToByDocumentId.HasValue)
           { %>
           <%= Html.ActionLink(String.Format("{0} ({1})", Model.RespondedToByDocumentName, Model.RespondedToByDocumentId),
                "DocumentTransaction", new { documentId = Html.Encrypt(Model.RespondedToByDocumentId)}) %>
            <%} %>
        </td>
    </tr>
 </table>




