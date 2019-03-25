<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<RISARC.Membership.Model.ManageRoleRights>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    <% string roleId = Request.Params["roleId"]; %>
    <% if (roleId != null)
       { %>
     Edit Role
    <% }
       else
       { %>
    Add Role
       
      <% } %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <%= Html.ValidationSummary() %>
  
    <% using (Html.BeginForm("AddEditRole", "AccountAdministration", FormMethod.Post, new {id = "AddEditForm" }))
       {%>
    <%= Html.Partial("RightSnapshotPopup")%>
    <!--here user rights document popup view loaded befor: Required -->


    <% string roleId = Request.Params["roleId"]; %>
    <% if (roleId != null)
       { %>
    <h2>Edit Role</h2>
    <% }
       else
       { %>
    <h2>Add Role</h2>

    <% } %>

    <div class="error">
        <%= Html.ValidationMessage("roleName")%>
        <%= Html.ValidationMessage("selectedRights", "No Rights Selected Atleast one Right")%>
    </div>
    <table id="RoleRight" >
        <tr>
            <td>
                <div class="label_text">

               <%  
       if (Convert.ToBoolean(ViewData["ComboBoxDisplay"]))
       {
           ViewContext.Writer.Write("<div>");
           Html.DevExpress().Label(
                         labelSettings =>
                         {
                             labelSettings.ControlStyle.CssClass = "label";
                             labelSettings.Text = "Role:";
                             labelSettings.AssociatedControlName = "RoleName";
                         }
                     ).Render();

           Html.DevExpress().TextBoxFor(model => model.RoleName, settings =>
           {
               settings.Name = "RoleName";
               settings.ControlStyle.CssClass = "RoleName";
               settings.Width = Unit.Percentage(50);
               if (roleId != null)
               {
                   settings.ClientEnabled = false;
                   settings.Properties.NullText = Model.RoleName;
               }
           }).Render();

           Html.DevExpress().Label(
                  labelSettings =>
                  {
                      labelSettings.ControlStyle.CssClass = "label";
                      labelSettings.Text = "Access Type:";
                      labelSettings.AssociatedControlName = "RoleAcessTypes";
                  }
              ).Render();


           RISARC.Common.Enumerators.RoleAcessTypes? val = Model.AccessType == 0 ? (RISARC.Common.Enumerators.RoleAcessTypes?)null : Model.AccessType;
           Html.DevExpress().ComboBoxFor(model=>model.AccessType,
               settings =>
               {
                   settings.Name = "AccessType";
                   settings.Width = Unit.Percentage(28);
                   settings.ControlStyle.CssClass = "RoleAcessTypes OrgNameSeachboxCls";
                   settings.Properties.NullText = "Select Access Type";
                   //for chombo box selection disable.
                   settings.Properties.EnableClientSideAPI = true;
                    if (roleId != null) settings.Enabled = false;
                   settings.Properties.NullText = "Select access type";

               }

     
       ).BindList(ViewData["ComboBoxList"]).Bind(val).GetHtml();


       }
       else
       {
           Html.DevExpress().Label(
                    labelSettings =>
                    {
                        labelSettings.ControlStyle.CssClass = "label";
                        labelSettings.Text = "Role:";
                        labelSettings.AssociatedControlName = "RoleName";
                    }
                ).Render();

           Html.DevExpress().TextBoxFor(model => model.RoleName, settings =>
           {
               settings.Name = "RoleName";
               settings.ControlStyle.CssClass = "RoleName";
               settings.Width = Unit.Percentage(93);
               if (roleId != null)
               {
                   settings.ClientEnabled = false;
                   settings.Properties.NullText = Model.RoleName;
               }
           }).Render();

       }%>
                   
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <input type="hidden" name="all_checkbox_value" id="all_checkbox_value" value="" />
                <input type="hidden" name="current_selected_row" id="current_selected_row" value="" />
                <input type="hidden" name="selected_roleId" id="selected_role_id" value="<%= roleId%>" />
                <%= Html.Partial("AddEditRolesGrid", Model)%>
            </td>
        </tr>

    </table>


  
     <div class="viewerActionBtnADetails">
                                <div class="floatLeft">
                                    <% Html.DevExpress().Button(
                                   RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                                   settings =>
                                   {
                                       settings.Name = "SaveButton";
                                       
                                       settings.Height = 32;
                                       settings.Width = 83;
                                       settings.ControlStyle.CssClass = "orangeBtn AddEditRoleSaveButton";
                                       settings.UseSubmitBehavior = false;
                                      
                                       settings.Text = "Save";

                                   })).GetHtml(); %>
                                </div>

                                <div class="floatRight">
                                    <% Html.DevExpress().Button(
                                   RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                                   settings =>
                                   {
                                       settings.Name = "CancelButton";
                                       settings.Height = 32;
                                       settings.Width = 83;
                                       settings.ControlStyle.CssClass = "greyBtn";
                                       settings.Text = "Cancel";
                                       settings.RouteValues = new { Controller = "AccountAdministration", Action = "ManageRoles" };
                                   })).GetHtml(); %>

                                 
                                </div>
                            </div>





    <% } %>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">

    <script src="<%: Url.Content("~/Scripts/RoleRightsCommon.js") %>" type="text/javascript"></script>
  
</asp:Content>
