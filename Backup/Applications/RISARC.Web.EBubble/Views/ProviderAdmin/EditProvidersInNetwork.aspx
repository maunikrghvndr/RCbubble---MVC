<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Edit the Providers In Your Provider's Network
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>
        Edit the Providers In Your Provider's Network</h2>
        <% Html.RenderPartial("BackToProviderLink"); %>
    <p class="Instructions">
        This list of providers will determine which providers that the members of your provider
        can send and request documents from.
    </p>
        <%= Html.ValidationInstructionHeader() %>
    <h3>
        Existing Providers In Network
    </h3>
    <% Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "ProvidersInNetworkList", "ProviderAdmin", new { showFormActions = true }); %>
    <h3>
        Add Provider to Network</h3>
    <% using (Html.BeginForm("AddProviderToNetwork", "ProviderAdmin"))
       { %>
    <% bool? BAAExists = ViewData["BAAExists"] as bool?; %>
    <%= Html.AntiForgeryToken() %>
    <ul>
        <li>
            <label>
                Select Provider to Add to Network <span class="ValidationInstructor">*</span></label>
            <%= Html.ValidationMessage("ProviderIdRequired", "You Must Select a Provider") %>
            <%= Html.ValidationMessage("ProviderAlreadyExists", "Provider already exists in network.  Please select another one.") %>
            <ul>
                <% Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "CascadingProviderFilters", "Setup", new
               {
                   providerIdFieldName = "ProviderId",
                   selectedProviderState = ViewData["SelectedProviderState"],
                   selectedProviderCity = ViewData["SelectedProviderCity"],
                   selectedProviderId = ViewData["ProviderId"]
               }); %>
            </ul>
        </li>
        <li>
            <label>Does BAA Agreement Exist with this Provider? <span class="ValidationInstructor">*</span></label>
            <input type="radio" class="input_radio" name="BAAExists" id="BAAExistsTrue" value="True" <%= BAAExists == true ? "checked='checked'" : (string)null %> /> 
            <label for="BAAExistsTrue">Yes</label>
            <input type="radio" class="input_radio" name="BAAExists" id="BAAExistsFalse" value="False" <%= BAAExists == false ? "checked='checked'" : (string)null %> /> 
            <label for="BAAExistsFalse">No</label>
            <%= Html.ValidationMessage("BAAExistsRequired", "Required") %>
            <div class="FieldInstructions">Select <i>Yes</i> if a BAA agreement exists with your provider and this provider.  If <i>Yes</i> is selected, you can
            send documents to this provider and its members without requiring release forms.  If <i>No</i> is selected, all document sent to this provider will automatically require a release form. </div>
        </li>
        <li>
            <input type="submit" value="Add Provider to Network" />
        </li>
    </ul>
    <%} %>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">

    <script type="text/javascript" src="<%: Url.Content("~/Scripts/CascadingProviderFilter.js")%>"></script>

</asp:Content>
