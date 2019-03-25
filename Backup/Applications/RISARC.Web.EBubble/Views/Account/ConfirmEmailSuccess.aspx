<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Public.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	<%= Html.Encode(ViewData.GetValue<string>(GlobalViewDataKey.StatusMessage))%>
</asp:Content>
<asp:Content ContentPlaceHolderID="AdditionalHeadContent" runat="server">
    <% string redirectUrl = Url.Action("LogOn", "Account", new { ReturnUrl = ViewData.GetValue(GlobalViewDataKey.ReturnUrl)}); %>
    <%= Html.MetaRefresh(redirectUrl, 10)%>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2><%= Html.Encode(ViewData.GetValue<string>(GlobalViewDataKey.StatusMessage))%></h2>
	<p>You will automatically be re-directed to the log-in page in 10 seconds, where you must log-in to the site to gain access. If for some reason you are not
	re-directed, <%= Html.ActionLink("Click here", "LogOn", "Account", new { ReturnUrl = ViewData.GetValue(GlobalViewDataKey.ReturnUrl)}, null)%> to go there now.</p>

</asp:Content>
