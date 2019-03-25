<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Public.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	An Confirmation Has Been Sent to your Email at <%= Html.Encode(ViewData.GetValue(GlobalViewDataKey.Email)) %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>A Confirmation  Email Has Been Sent to your Email at <%= Html.Encode(ViewData.GetValue(GlobalViewDataKey.Email)) %></h2>
    
    <h3>You must confirm your email address to activate your account.</h3>
   
    <p>A confirmation email has been sent to <%= Html.Encode(ViewData.GetValue(GlobalViewDataKey.Email)) %>.  <b>In order to activate
    your account, you must enter the <i>Confirmation ID</i> sent to your email address:</b></p>
    <% Html.RenderPartial("ConfirmEmailForm"); %>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>
