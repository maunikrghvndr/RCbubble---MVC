<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<RISARC.Membership.Model.DisplayRoleRights>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Roles & Rights
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Roles & Rights</h2>
    <div class="totalAccount">Select Roles From The Left Section To View Its Corresponding Rights On The Right Section</div>
   <%   if (! String.IsNullOrEmpty( Convert.ToString( ViewData["Status"]) ))
       { %>
      <div class="statusMessage">
        <% Response.Write(ViewData["Status"]);  %>
    </div>
     <% } %>
    
    <%= Html.Partial("RightSnapshotPopup") %>
    <!--here user rights document popup view loaded befor: Required -->
    <div class="error">
        <%--<%=ViewData["DeleteRole"] %>--%>
        <%=Html.ValidationMessage("DeleteRole") %>
    </div>
    <div class="validation-summary-errors"></div>

    <table style="width:100%">
        <tr>
            <td id="RoleList" >
                <input type="hidden" name="all_checkbox_value" id="all_checkbox_value" value="" />
                <input type="hidden" name="current_selected_row" id="current_selected_row" value="" />
                <input type="hidden" name="current_selected_rolename" id="current_selected_rolename" value="" />
                <input type="hidden" name="selected_access_type" id="selected_access_type" value="" />
                <%  if (Convert.ToBoolean(ViewData["IsSuperAdmin"]))
                    { %>
                <input type="hidden" name="LogUser_Superadmin" id="LogUser_Superadmin" value="1" />
                <% } %>
                <input type="hidden" value="<%= Url.Content("~/AccountAdministration/AddEditRole") %>" id="EditPath" />
                <input type="hidden" value="<%= Url.Content("~/AccountAdministration/DeleteRole") %>" id="DeleteRolePath" />
                <%= Html.Action("Roles","AccountAdministration") %>
                       
            </td>
            <td  id="RightList" style="display: none">
               <%-- <%= Html.Action("Rights","AccountAdministration") %>--%>
                <%=Html.Partial("Rights") %>
            </td>
        </tr>
    </table>



</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
    <script src="<%: Url.Content("~/Scripts/RoleRightsCommon.js") %>" type="text/javascript"></script>
  
  
</asp:Content>
