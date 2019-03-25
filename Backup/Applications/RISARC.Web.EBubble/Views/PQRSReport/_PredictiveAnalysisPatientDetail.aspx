<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    PredictiveAnalysisPatientDetail
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<h2>Predictive Analysis Patient Detail</h2>
<a href="<%: Url.Content("~/ChangeFacility/PredictiveAnalysisReport") %>">Predictive Report </a> > 
         <a href="#" onclick="window.history.go(-1); return false;" >Patient Report </a> >
          <a>Detailed  Report </a>
    <br />
    <img src="<%: Url.Content("~/Images/ACO_GPRO/Predictivethirdstep.jpg") %>" />
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>

