<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Public.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Please Enter your Confirmation ID
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>A <strong>Confirmation ID</strong> has been sent to your Email Address</h2>
    <p>You must confirm your email address to activate your account.  In order to activate
    your account, you must enter the <strong>Confirmation ID</strong> sent to your email in the box below:.</p>
    <% Html.RenderPartial("ConfirmEmailForm"); %>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>
