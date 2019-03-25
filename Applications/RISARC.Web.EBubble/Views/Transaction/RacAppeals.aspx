<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<RISARC.Documents.Model.Document>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	RAC Management
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>RAC Management</h2>
    
    <h3>RAC Appeal Update</h3>
        <% Html.RenderPartial("RacAppealFields", Model); %>
 
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>
