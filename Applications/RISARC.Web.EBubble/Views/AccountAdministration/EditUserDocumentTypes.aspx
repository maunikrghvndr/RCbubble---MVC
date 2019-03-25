<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Edit User <%= Html.Encode(ViewData["UserName"]) %>'s Document Types
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <% string encryptedUserName = Html.Encrypt(ViewData["UserName"]); %>
    <h2>Edit User <%= Html.Encode(ViewData["UserName"]) %>'s Document Types</h2>
    <p class="Instructions">
        These document types will determine which document types can be sent to this user, and which requests they can respond to.
    </p>
    <h3>Existing Document Types
    </h3>
    <% Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "UserDocumentTypesList", "AccountAdministration", new { showFormActions = true }); %>

    <% Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "ShowUserDocumentPatientAlpha", "AccountAdministration", new { userName = encryptedUserName });  %>
    <h3>Add Document Type to User</h3>
    <% using (Html.BeginForm("AddUserDocumentType", "AccountAdministration", new { UserName = encryptedUserName }))
       { %>
    <%= Html.AntiForgeryToken()%>
    <ul>
        <li>
            <% Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "ProviderDocumentTypesDropDown", "Setup", new { fieldName = "DocumentTypeId", emptyOptionText = "-Document Type-", providerId = ViewData["ProviderId"], Username = encryptedUserName, IsRemoveUsersAvailableDocType = true }); %>
            <%= Html.ValidationMessage("DocumentTypeRequired", "Required")%>
            <%= Html.ValidationMessage("DocumentTypeExists", "Document type already exists for this user.  Please select another document type.")%>
        </li>
        <li>
            <input type="submit" value="Add Document Type to User" />
        </li>
    </ul>
    <%} %>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>
