<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Dashboard
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Dashboard</h2>
    <div class="totalAccount">View reports and click on the right side arrow to view detailed reports by Provider and physician level</div>
  
    <% if (Session["IsACO"] == "True")
       { %>
       
       <table style="width: 100%">
        <tr>
            <td>
                <a href="<%: Url.Content("~/ChangeFacility/CostDriverReport") %>">
                    <img src="<%: Url.Content("~/Images/ACO_GPRO/CostDriver.jpg") %> "   width="473" height="372" /></a>
            </td>
            <td>&nbsp;&nbsp;</td>
            <td>
                <a href="<%: Url.Content("~/ChangeFacility/PredictiveAnalysisReport") %>">
                     <img src="<%: Url.Content("~/Images/ACO_GPRO/Predictive.jpg") %> " width="473" height="372"/>
                   </a>
            </td>
        </tr>
           <tr>
               <td>&nbsp;</td>
           </tr>
           
            <tr>
            <td>
                <a href="<%: Url.Content("~/ChangeFacility/HL7") %>">
                    <img src="<%: Url.Content("~/Images/ACO_GPRO/Hl7logo.jpg") %> "   width="473" height="372" /></a>
            </td>
            <td>&nbsp;&nbsp;</td>
            <td>
                &nbsp;
            </td>
        </tr>

    </table>
       <%}else{%>
     <table style="width: 100%">
        <tr>
            <td>
                <a href="<%: Url.Content("~/ChangeFacility/PCostDriverReport") %>">
                    <img src="<%: Url.Content("~/Images/ACO_GPRO/CostDriver.jpg") %> " width="473" height="372" /></a>
            </td>
            <td>&nbsp;&nbsp;</td>
            <%--<td>
                <a href="<%: Url.Content("~/ChangeFacility/PerformanceAnalysisReport") %>">
                     <img src="<%: Url.Content("~/Images/ACO_GPRO/Performance.jpg") %> " width="473" height="372" />
                   </a>
            </td>--%>
        </tr>

    </table>

      <% }  %>
    

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>
