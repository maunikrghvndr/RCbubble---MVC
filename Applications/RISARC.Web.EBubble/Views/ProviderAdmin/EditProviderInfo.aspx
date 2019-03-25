<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<RISARC.Setup.Model.ProviderInfo>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Edit Provider Information
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>
        Edit Provider Information</h2>
        <% Html.RenderPartial("BackToProviderLink"); %>
    <p class="Instructions">
        Update your information below.</p>
        <%= Html.ValidationInstructionHeader() %>
    <h3>
        Provider Information</h3>
    <%using (Html.BeginForm())
      { %>
    <ul>
        <li>
            <label>
                Provider Name <span class="ValidationInstructor">*</span></label>
            <%= Html.StyledTextBox("Name", Model.Name)%>
            <%= Html.ValidationMessage("NameRequired", "Required") %>
        </li>
        <li>
            <label>
                Main Contact </label>
                <ul>
            <% ViewDataDictionary mainContactDictionary = new ViewDataDictionary();
               mainContactDictionary.SetValue(GlobalViewDataKey.BindingPrefix, "MainContact.");
               mainContactDictionary.ModelState.Merge(ViewData.ModelState);
               Html.RenderPartial("~/Views/Shared/ContactInfo.ascx", Model.MainContact, mainContactDictionary); %></ul>
        </li>
        <li>
            <label>
                Main Address</label>
             <ul>   
            <% ViewDataDictionary addressInfoDictionary = new ViewDataDictionary();
               addressInfoDictionary.SetValue(GlobalViewDataKey.BindingPrefix, "Address.");
               addressInfoDictionary.ModelState.Merge(ViewData.ModelState);
                Html.RenderPartial("~/Views/Shared/AddressInfo.ascx", Model.Address, addressInfoDictionary); %>
                </ul>
        </li>
        <li>
            <label>
                Main Fax <span class="ValidationInstructor">*</span></label>
             <% ViewDataDictionary mainFaxDictionary = new ViewDataDictionary();
                mainFaxDictionary.SetValue(GlobalViewDataKey.BindingPrefix, "FaxNumber.");
                mainFaxDictionary.ModelState.Merge(ViewData.ModelState);
                Html.RenderPartial("PhoneInfo", (Model.FaxNumber), mainFaxDictionary); %>
        </li>
        <li>
            <label>
                Alternate Contact </label>
                <ul>
            <% ViewDataDictionary alternateContactDictionary = new ViewDataDictionary();
               alternateContactDictionary.SetValue(GlobalViewDataKey.BindingPrefix, "AlternateContact.");
               alternateContactDictionary.ModelState.Merge(ViewData.ModelState);
                Html.RenderPartial("~/Views/Shared/ContactInfo.ascx", Model.AlternateContact, alternateContactDictionary); %></ul>
        </li>
        <li>
            <label>
                Billing Contact </label>
                <ul>
            <% ViewDataDictionary billingContactDictionary = new ViewDataDictionary();
               billingContactDictionary.SetValue(GlobalViewDataKey.BindingPrefix, "BillingContact.");
               billingContactDictionary.ModelState.Merge(ViewData.ModelState);
               Html.RenderPartial("~/Views/Shared/ContactInfo.ascx", Model.BillingContact, billingContactDictionary); %></ul>
        </li>
        <li>
            <label>
                Billing Address</label>
            <ul>
            <% ViewDataDictionary billingAddressDictionary = new ViewDataDictionary();
               billingAddressDictionary.SetValue(GlobalViewDataKey.BindingPrefix, "BillingAddress.");
               billingAddressDictionary.ModelState.Merge(ViewData.ModelState);
                Html.RenderPartial("~/Views/Shared/AddressInfo.ascx", Model.BillingAddress, billingAddressDictionary); %>
            </ul>
        </li>
        <li>
            <input type="submit" value="Update Provider Information" />
        </li>
    </ul>
    <%} %>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
    <script type="text/javascript" src="<%: Url.Content("~/Scripts/Address.js")%>"></script>
</asp:Content>
