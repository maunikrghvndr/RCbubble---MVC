<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Edit User Roles
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="error">
        <%=ViewData["selectedRoles"] %>
    </div>
    <% using (Html.BeginForm("EditUserRoles", "AccountAdministration"))
       {%>
    <h2>Edit User Roles</h2>
    <div class="totalAccount">User : &nbsp;&nbsp;   <%=ViewData["UserName"] %></div>


    <%= Html.Partial("RightSnapshotPopup") %>
    <!--here user rights document popup view loaded befor: Required -->

    <div class="error"></div>
    <!-- Error message holder-->
    <% string UserId = ViewData["id"].ToString(); %>
    <table class="EditRoleRightContainer">
        <tr>
            <td id="RoleList">
                <input type="hidden" name="all_checkbox_value" id="all_checkbox_value" value="" />
                <input type="hidden" name="current_selected_row" id="current_selected_row" value="" />
                <input type="hidden" name="editUserIndex" id="editUserIndex" value="<%= UserId %>" />

                <%= Html.Action("Roles","AccountAdministration",new { id = Convert.ToInt32(ViewData["id"]) }) %>
               
            </td>
            <td id="RightList" style="display: none">
                <%= Html.Action("Rights","AccountAdministration") %>
            </td>
        </tr>
    </table>

     <div class="space">&nbsp;&nbsp;</div>
     <div class="viewerActionBtnADetails">
                                <div class="floatLeft">
                                    <% Html.DevExpress().Button(
                                   RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                                   settings =>
                                   {
                                       settings.Name = "SaveButton";
                                       settings.Height = 32;
                                       settings.Width = 83;
                                       settings.ControlStyle.CssClass = "orangeBtn";
                                    
                                       settings.Text = "Save";

                                   })).GetHtml(); %>
                                </div>

                                <div class="floatRight">
                                    <% Html.DevExpress().Button(
                                   RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                                   settings =>
                                   {
                                       settings.Name = "CancelBtn";
                                       settings.Height = 32;
                                       settings.Width = 83;
                                       settings.ControlStyle.CssClass = "greyBtn";
                                       settings.Text = "Cancel";
                                       settings.RouteValues = new { Controller = "AccountAdministration", Action = "DisplayUserRoles" };
                                   })).GetHtml(); %>

                                 
                                </div>
                            </div>
     <div class="space">&nbsp;&nbsp;</div>


    <% } %>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
    <script src="<%: Url.Content("~/Scripts/RoleRightsCommon.js") %>" type="text/javascript"></script>
  
</asp:Content>
