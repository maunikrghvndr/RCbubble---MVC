<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<RISARC.eTAR.Model.AccountDetailsMain>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    ViewDocumentInViewer
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<h2>ViewDocumentInViewer</h2>
<% Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "DocumentViewer", "AccountDetails", new { DocumentFileIDValue = (ViewData["DocumentFileId"]) }); %>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
    <script src="<%: Url.Content("~/Scripts/AccountDetailsCommon.js") %>" type="text/javascript"></script>
    <script type ="text/javascript">

        $(document).ready(function () {
       
          var path =   $('#documentViewer_DocumentPath').val();
          var filename = $('#DocumentFileName').val();
          var pages = $('#documentViewer_NumberOfPages').val();
          LoadDocument(true);

        });
    </script>
</asp:Content>


