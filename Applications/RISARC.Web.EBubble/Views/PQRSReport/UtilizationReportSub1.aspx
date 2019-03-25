<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Utilization Details Report
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2> Utilization Details Report</h2>
  <div><a href="<%: Url.Content("~/ChangeFacility/UtilizationReport") %>"> Utilization Report </a>  >  Detailed Report</div>
    <br />
     <%= Html.Partial("_Utilizationsub1CallbackPanel")%>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>

