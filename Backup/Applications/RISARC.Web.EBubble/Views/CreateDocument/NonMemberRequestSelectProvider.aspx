<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Request a Document
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>
        Request a Document</h2>
    <p class="Instructions">
        <%= Html.Encode(ViewData.GetValue(GlobalViewDataKey.PageDesc)) %> </p>
        <%= Html.ValidationInstructionHeader() %>
    <%using (Html.BeginForm("NonMemberRequestSelectProvider", "CreateDocument"))
      { %>
    <ul>
        <li>
            <label>
                Select a Provider to Request a Document From <span class="ValidationInstructor">*</span></label>
            <%= Html.ValidationMessage("ProviderIdRequired", "You Must Select a Provider") %>
            <ul>
              <% Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "CascadingProviderFilters", "Setup", new
               {
                   providerIdFieldName = "ProviderToRequestFromId",
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
