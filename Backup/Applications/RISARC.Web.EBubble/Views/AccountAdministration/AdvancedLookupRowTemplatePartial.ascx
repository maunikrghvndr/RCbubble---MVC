<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<div class="templateContainer">
    <%bool Checked = false;%>
    <% if (Model.UserIndex == Convert.ToInt32(ViewData["userindex"]) || Model.UserIndex == null)
       {
    %>

    <table class="templateTable" >
        <tr >
            <%--<td class="caption alphaDisplay">RowNum:</td>
            <td class="alphaDisplay"><span><%:Model.RowNum%></span></td>

            <td class="caption alphaDisplay">PatientAlpha:</td>--%>
            <td style="width:50px;"><span><%:Model.PatientAlpha%></span></td>
            <td><span><%:Model.FullName%></span></td>
        </tr>
        <tr style="display: none">
            <td class="caption">Checked:</td>
            <td><span><%:Checked%></span></td>
        </tr>
    </table>

    <% }
       else
       {
           Checked = true;
    %>
    <table class="templateTable disableRow" >
        <tr>
           <%-- <td class="caption alphaDisplay">RowNum:</td>
            <td class="alphaDisplay"><span><%:Model.RowNum%></span></td>
            <td class="caption alphaDisplay">PatientAlpha:</td> --%>
            <td style="width:50px;"><span><%:Model.PatientAlpha%></span></td>
            <td><span><%:Model.FullName%></span></td>
        </tr>
        <tr style="display: none">
            <td class="caption">Checked:</td>
            <td><span><%:Checked%></span></td>
        </tr>
    </table>
    <% }%>
</div>
