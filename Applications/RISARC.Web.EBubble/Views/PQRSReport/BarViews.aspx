<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<IList<RISARC.Membership.Model.ReportList>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    BarViews
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
ReportList
<h2>BarViews</h2>
     <%=Html.Partial("BarViewsPartial",Model) %>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>

