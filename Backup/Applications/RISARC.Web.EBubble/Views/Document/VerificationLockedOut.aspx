<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/StatusMessage.master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	We are sorry, but you have reached the maximum attempts to verify this document and have been locked out.
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="StatusContents" runat="server">
<p>
       This document is no longer available to you.  Please email us at asdfasfd@asdfas.com or 
       contact us at ###-###-#### if you feel you have reached this in error.
    </p>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="StatusHeader" runat="server">
We are sorry, but you have reached the maximum attempts to verify this document and have been locked out.
</asp:Content>
