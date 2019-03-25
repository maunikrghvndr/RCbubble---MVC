<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.Master" Inherits="System.Web.Mvc.ViewPage<RISARC.Membership.Model.RMSeBubbleMembershipUser>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Add User
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Add User</h2>
    <p class="Instructions">
        Registering user to your organization will allow them to review, respond, request and/or send documents.
    </p>

    <%= Html.Partial("RightSnapshotPopup") %>
    <!--here user rights document popup view loaded befor: Required -->
    <%= Html.ValidationInstructionHeader() %>
    <div class="error"></div>
  
    <h3>Enter Account Information Of User</h3>
    <%using (Html.BeginForm())
      {   %>
    <%= Html.AntiForgeryToken() %>
    <ul>

        <% Html.RenderPartial("AdministrativeRegistrationFields", Model); %>
        <li>
            <label for="Department">User's Department</label>
            <% Html.RenderAction<RISARC.Web.EBubble.Controllers.ProviderAdminController>(x =>
                       x.ProvidersDepartmentsDropDown("ProviderMembership.DepartmentId",
                       Model.ProviderMembership.ProviderId, Model.ProviderMembership.DepartmentId)); %>
          
        </li>

        <li>
            <h2>Assign Roles</h2>

            <table>
                <tr>
                    <td id="RoleList">
                        <input type="hidden" name="all_checkbox_value" id="all_checkbox_value" value="" />
                        <input type="hidden" name="UserRoleNames" id="UserRoleNames" value="" />
                        <input type="hidden" name="current_selected_row" id="current_selected_row" value="" />
                        <%= Html.Action("Roles","AccountAdministration") %>
                       
                    </td>
                    <td id="RightList">
                        <%= Html.Action("Rights","AccountAdministration") %>
                    </td>
                </tr>
            </table>
        </li>
       
        <li>

            <div class=" buttonHolder">
                <div class="floatLeft" >

                     <% Html.DevExpress().Button(
                                   RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                           settings =>
                           {
                               settings.Name = "SaveButton";
                               settings.Text = "Save";
                               settings.ControlStyle.CssClass = "orangeBtn";
                               
                           })).GetHtml(); %>
                </div>

                <div class="floatRight" >
                      <% Html.DevExpress().Button(
                                   RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                           settings =>
                           {
                               settings.Name = "btnCancel";
                               settings.Text = "Cancel";
                               settings.ControlStyle.CssClass = "greyBtn";
                               
                               string UserRole = Request.Params["ur"];
                               
                               if (UserRole != null)
                               {
                                   settings.RouteValues = new { Controller = "AccountAdministration", Action = "DisplayUserRoles" };
                               }
                               else
                               {
                                   settings.RouteValues = new { Controller = "AccountAdministration", Action = "ProvidersUsers" };
                               }
                           })).GetHtml(); %>

                </div>
            </div>
        </li>
       <li><div class="clear"></div></li>
    </ul>
    <%} %>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">

    <script src="<%: Url.Content("~/Scripts/RoleRightsCommon.js") %>" type="text/javascript"></script>
   
</asp:Content>


