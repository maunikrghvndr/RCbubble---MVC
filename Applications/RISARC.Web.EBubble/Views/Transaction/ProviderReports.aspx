<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Provider Reports
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Provider Reports</h2>

 <% // will render sub menu of providers reports
     Html.RenderAction<RISARC.Web.EBubble.Controllers.NavigationController>(x => x.ChildMenuOfNode(node => node.Root.ActionName == "ProviderReports")); %>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>
