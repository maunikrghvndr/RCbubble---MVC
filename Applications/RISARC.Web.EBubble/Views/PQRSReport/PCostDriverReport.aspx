<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
  Cost Driver - Provider Report
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
 
        <h2>Cost Driver - Provider Report</h2>
    <%if(Request["provider"] !=null){ %>
         <div><a href="<%: Url.Content("~/ChangeFacility/CostDriverReport") %>">Cost Driver </a> > 
             Provider Detailed Report </div>
         <br />
    
        <div class="claimInfo ">

             <table style="width: 85%;">
            <tr>
                <td>Provider : <b><%=Request["provider"] %></b> </td>
                <td>No of Physician: <b><%=Request["physician"] %></b></td>
            </tr>
            <tr>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td>Individuals Pre Physician: <b><%=Request["individual"] %></b></td>
                <td>Risk Score : <b><%=Request["risk"] %></b></td>
            </tr>
        </table>
    </div>

    <div class="selectPage"></div>

    <%} %>
  
       <%= Html.Partial("_PCostDriverCallbackPanel")%>
 
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
 
</asp:Content>


