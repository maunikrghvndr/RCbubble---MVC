<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Edit Provider's Administrators
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Edit Provider's Administrators</h2>
    <p class="Instructions">
        Update Configuration below</p>
    <%= Html.ValidationInstructionHeader() %>
    
    <%using(Html.BeginForm()){ %>
    <%= Html.AntiForgeryToken() %>
     <ul>
        <li>
            <label>
                Select Which Provider to Edit the Administrators of<span class="ValidationInstructor">*</span></label>
            <%= Html.ValidationMessage("ProviderIdRequired", "You Must Select a Provider") %>
            <ul>
                <%  Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "CascadingProviderFilters", "Setup", new
               {
                   providerIdFieldName = "ProviderIdToAdministrate",
                   selectedProviderState = ViewData["SelectedProviderState"],
                   selectedProviderCity = ViewData["SelectedProviderCity"],
                   selectedProviderId = ViewData["ProviderId"]
               }); %>
            </ul>
        </li>
        <li>
            <input type="submit" value="Continue" />
        </li>
    </ul>
    <%} %>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
    
<script type="text/javascript" src="<%: Url.Content("~/Scripts/CascadingProviderFilter.js")%>"></script>
</asp:Content>
