<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
  Cost Driver - Provider Report
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
 
        <h2>Cost Driver - Physician Report</h2>
        

     <div><a href="<%: Url.Content("~/ChangeFacility/CostDriverReport") %>">Cost Driver </a> > 
         <a href="#" onclick="window.history.go(-1); return false;" >Provider Detailed  Report </a> >
          <a>Physician Detailed  Report </a>
     </div>
         <br />






        <div class="claimInfo ">
        <table style="width: 85%;">
            <tr>
                <td>Physician : <b><%=Request["Physician"] %></b> </td>
                <td>No of Individuals: <b><%=Request["individual"] %></b></td>
            </tr>
            <tr>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td>Average Individual Age: <b><%=Request["age"] %></b></td>
                <td>Risk Score : <b><%=Request["risk"] %></b></td>
            </tr>
        </table>
    </div>

    <div class="selectPage"></div>

    
    <%= Html.Partial("_PhyCostDriverCallbackPanel")%>
  
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
 
</asp:Content>


