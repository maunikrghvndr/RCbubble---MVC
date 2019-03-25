<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<table class="templateTable" style="width:100%; table-layout:fixed" >
        <tr>
            <%--<% string[] count = ViewData["Providers"].ToString().Split(','); %>--%>
            <td style="width:50%;word-wrap:break-word"><span><%=ViewData["UserName"]%></span></td>
             <td><%--<b><%=count.Length %> &nbsp;&nbsp;</b>--%>
           <%--     <b> Organizations:</b>&nbsp;<span><%=ViewData["Providers"].ToString()%></span></td>--%>
             <b> Organizations:</b>&nbsp;<span><%= Convert.ToString(ViewData["Providers"]) %></span></td>
        </tr>
</table>
 

