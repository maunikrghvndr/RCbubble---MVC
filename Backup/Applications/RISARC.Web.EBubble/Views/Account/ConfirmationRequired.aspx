<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Public.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	You must confirm your email address to activate your account.
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>You must confirm your email address to be able to login your account.</h2>
    
    <p>A Confirmation Has Been Sent to your Email at <%= Html.Encode(ViewData.GetValue(GlobalViewDataKey.Email)) %>.   <b>In order to activate
    your account, you must enter the <strong>Confirmation ID</strong> sent to your email address:</b></p>
    <% Html.RenderPartial("ConfirmEmailForm"); %>
    <p>If you for some reason have not received the email, <%= Html.ActionLink("click here to send another confirmation email.",
                                                               "SendConfirmation", new
                                                               {
                                                                   emailAddress = ViewData.GetValue(GlobalViewDataKey.Email),
                                                                   ReturnUrl = ViewData.GetValue(GlobalViewDataKey.ReturnUrl)
                                                               }) %></p>

</asp:Content>
