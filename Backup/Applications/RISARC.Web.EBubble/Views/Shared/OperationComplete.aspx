<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	<%= Html.Encode(ViewData.GetValue<string>(GlobalViewDataKey.StatusTitle))%>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2><%= Html.Encode(ViewData.GetValue<string>(GlobalViewDataKey.StatusTitle))%></h2>

    <p>
        <%= Html.Encode(ViewData.GetValue<string>(GlobalViewDataKey.StatusMessage)) %>
    </p>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>
