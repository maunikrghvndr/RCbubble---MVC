<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.Master" Inherits="System.Web.Mvc.ViewPage<RISARC.Membership.Model.RMSeBubbleMembershipUser>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	My Account
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>My Account</h2>
    <p class="Instructions">
        To edit your account,locate the information you want to edit and then click link(s) to update information
        .</p>

    
    <% Html.RenderPartial("MembershipUserDetails", Model); %>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>

