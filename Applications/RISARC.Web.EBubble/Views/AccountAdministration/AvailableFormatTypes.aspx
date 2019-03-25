<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<RISARC.Files.Model.DocumentFormatType>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Available Format Types
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<h2>Available Format Types</h2>
  <div class="totalAccount">Manage format type by adding, editing or deleting format types</div>

<%= Html.Partial("AvailableFormatTypesPartial", Model) %>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">

</asp:Content>
