<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<RISARC.Logging.Model.ActionLogEntry>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	History for User <%= Html.Encode(ViewData.GetValue(GlobalViewDataKey.Email)) %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>History for User <%= Html.Encode(ViewData.GetValue(GlobalViewDataKey.Email)) %></h2>

    <% Html.RenderPartial("ActionLogEntryTable", Model); %>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>
