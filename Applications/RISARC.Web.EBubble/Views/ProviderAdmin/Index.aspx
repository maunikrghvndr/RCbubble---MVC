<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<RISARC.Setup.Model.Provider>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Provider Administration
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Provider Administration</h2>
    
    <%= Html.ActionLink("Add New Provider", "Create") %>

    <h3>Existing Providers</h3>
    
    <% Html.RenderPartial("ProvidersTable", Model); %>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>
