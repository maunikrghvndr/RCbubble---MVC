<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Edit Your Provider's Document Types
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>
        Edit Your Provider's Document Types</h2>
        <% Html.RenderPartial("BackToProviderLink"); %>
    <p class="Instructions">
        These document types will determine which document types are available to members
        of your provider, as well as which document types are available to users when sending
        documents or requests to your provider.
    </p>
        <%= Html.ValidationInstructionHeader() %>
    <h3>
        Existing Document Types
    </h3>
    <% Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "ProvidersDocumentTypesList", "ProviderAdmin", new { showDeleteButton = false }); %>
    <h3>
        Add Document Type to Your Provider</h3>
    <% using (Html.BeginForm("AddProviderDocumentType", "ProviderAdmin"))
       { %>
       <%= Html.AntiForgeryToken() %>
    <ul>
        <li>
            <% Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html,"AddDocumentTypeToProviderDropDown", "ProviderAdmin", new { fieldName = "DocumentTypeId", emptyOptionText = "-Document Type-" }); %>
            <%= Html.ValidationMessage("DocumentTypeRequired", "Required") %>
        </li>
        <li>
            <input type="submit" value="Add Document Type to Your Provider" />
            <div class="FieldInstructions">Note: Once you add a document type to your provider it cannot be removed.</div>
        </li>
    </ul>
    <%} %>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>
