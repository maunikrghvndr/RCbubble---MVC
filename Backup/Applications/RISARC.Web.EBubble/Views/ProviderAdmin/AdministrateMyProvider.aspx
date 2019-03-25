<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<RISARC.Setup.Model.Provider>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Administrate Provider Settings
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>
        Administrate Provider Settings</h2>
    <h3>
        Provider Info</h3>
    <%= Html.ImageAction("Edit", Url.Content("~/Images/icons/application_form_edit.png"), Url.Action("EditProviderInfo")) %>
    <% Html.RenderPartial("ProviderInfoDetails", Model.ProviderInfo); %>
    <h3>
        Provider Configuration
    </h3>
        <%= Html.ImageAction("Edit", Url.Content("~/Images/icons/application_form_edit.png"), Url.Action("EditProviderConfiguration"))%>
        <%  Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "ProviderConfigurationDetails"); %>

    <h3>
        Provider's Document Format Types
    </h3>
     <div class="OrignalOrgDocumentFormatTypes">
        <% Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "OrganizationDocumentFormat", "AccountAdministration", new { providerIdToAdministrate = Model.Id}); %>
    </div>
    <h3>
        Provider's Document Types
    </h3>
    <%= Html.ImageAction("Edit", Url.Content("~/Images/icons/application_form_edit.png"), Url.Action("EditProvidersDocumentTypes"))%>
    <%  Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "ProvidersDocumentTypesList", "ProviderAdmin", new { showDeleteButton = false }); %>
    <h3>
        Providers In Network
    </h3>
    <%= Html.ImageAction("Edit",Url.Content( "~/Images/icons/application_form_edit.png"), Url.Action("EditProvidersInNetwork"))%>
    <% Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "ProvidersInNetworkList", "ProviderAdmin", new { showFormActions = false }); %>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>
