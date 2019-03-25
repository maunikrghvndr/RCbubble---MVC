<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	My Documents
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>My Documents</h2>
    
 <% // will render sub menu of my documents
     Html.RenderAction<RISARC.Web.EBubble.Controllers.NavigationController>(x => x.ChildMenuOfNode(node => node.Root.ActionName == "MyDocuments")); %>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>
