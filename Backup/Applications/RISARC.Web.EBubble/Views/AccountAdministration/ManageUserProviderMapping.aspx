<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<RISARC.Membership.Model.UserProviderMapping>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Map Members to Organization
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <% using (Html.BeginForm("ManageUserProviderMapping", "AccountAdministration", FormMethod.Post, new { id = "FormMapUserToProvider" }))
       {%>

    <h2>Map Members to Organization</h2>
    <h1><% Convert.ToString(ViewData["Message"]); %></h1>
    <div class="error"><% Convert.ToString(ViewData["ErrorMsg"]); %></div>
    <div class="totalAccount"><b class="darkGrey">Step 1 -</b>Select Organization to which you want to map user(s) to </div>
   <div class="greyTopBottom"></div>
    <div class="editorContainer">
        <input type="hidden" name="OrganizationNameHidden" id="OrganizationNameHidden" value="<%= Model.ProviderId %>" />
        <% Html.DevExpress().ComboBoxFor(model => model.ProviderId, settings =>
               {
                   settings.Name = "ProviderId";
                   settings.Width = Unit.Percentage(40);
                   settings.SelectedIndex = -1;
                   settings.Properties.IncrementalFilteringMode = IncrementalFilteringMode.StartsWith;
                   //settings.Properties.DropDownStyle = DropDownStyle.DropDown;
                   settings.Properties.TextField = "Text";
                   settings.Properties.ValueField = "Value";
                   settings.Properties.ValueType = typeof(short);
                   settings.Properties.EnableClientSideAPI = true;
                   settings.Properties.ClientSideEvents.SelectedIndexChanged = "OnSelectionGetOrgnizationMember";
                   settings.ShowModelErrors = true;
                   settings.ControlStyle.CssClass = "OrgNameSeachboxCls";

                 
                   
                   settings.ControlStyle.BackColor = System.Drawing.ColorTranslator.FromHtml("#f7f7f7");

                   settings.Properties.DropDownButton.Image.Url = @Url.Content("~/Images/icons/dropdown_button.png");
                   settings.Properties.ButtonStyle.Border.BorderWidth = 0;
                   settings.Properties.ButtonStyle.Paddings.Padding = 0;
                   settings.Properties.ButtonStyle.CssClass = "dropdownButton";
                   
                   
               }).BindList(ViewData["ProviderList"]).GetHtml(); %>
    </div>
    <div class="clsMaringBottom"></div>
    <div class="totalAccount"><b class="darkGrey">Step 2 -</b>Select Members, Click Left/Right arrow to move them into selected organization</div>
<div class="greyTopBottom"></div>
    <table class="orgnizationGrp">
        <tr>
            <td>
                <div class="h3shadow">Non-Organization Members</div>
                <input type="hidden" id="NonOrganizationSelectedRowValues" name="NonOrganizationSelectedRowValues" value="" />
                <%= Html.Action("UserGridParialCallback","AccountAdministration", new { SearchText = "" }) %>
                   
            </td>
            <td class="alignBtn" >

             <%--    <div class="button_holder">
            <div class="floatLeft">
                <%  Html.DevExpress().Button(
                   settings =>
                   {
                       settings.Name = "DownManageUserProviderMapping";
                       settings.ControlStyle.CssClass = "DownButton";
                       settings.RouteValues = new { Controller = "AccountAdministration", Action = "ManageUserProviderMapping" };
                       settings.Width = Unit.Pixel(32);
                       settings.Height = 80;
                       settings.Text = "";
                  //     settings.ControlStyle.Cursor = "pointer";
                      // settings.Styles.EnableDefaultAppearance = false; //made defult apperance false for applying own styles
                     //  settings.ControlStyle.BackColor = System.Drawing.ColorTranslator.FromHtml("#707070");
                          settings.Images.Image.Url = Url.Content("~/Images/icons/RightMoveBtn.png");
                     //  settings.ImagePosition = ImagePosition.Right;
                       settings.UseSubmitBehavior = true;
                      settings.ControlStyle.CssClass = "orangeBtn11";
                       settings.ClientSideEvents.Click = "OnDownClick";
                   }).GetHtml();  %>
            </div>

            <div  class="floatRight">
                <%  Html.DevExpress().Button(
                   settings =>
                   {
                       settings.Name = "UpManageUserProviderMapping";
                       settings.ControlStyle.CssClass = "UpButton";
                       settings.RouteValues = new { Controller = "AccountAdministration", Action = "ManageUserProviderUnMapping" };
                       settings.Width = Unit.Pixel(60);
                       settings.Height = 25;
                       settings.Text = "";
                      // settings.Styles.EnableDefaultAppearance = false; //made defult apperance false for applying own styles
                       settings.ControlStyle.Cursor = "pointer";
                       settings.ControlStyle.BackColor = System.Drawing.ColorTranslator.FromHtml("#DCDCDC");
                       settings.Images.Image.Url = Url.Content("~/Images/icons/LeftMoveBtn.png");
                       settings.UseSubmitBehavior = true;
                       settings.ControlStyle.CssClass = "orangeBtn";
                       settings.ClientSideEvents.Click = "OnUpClick";
                   }).GetHtml();  %>
            </div>
        </div>--%>

                <div class="button_holder">
                    <div class="clsmarginBottom25">
                        <%  Html.DevExpress().Button(
                   settings =>
                   {
                       settings.Name = "DownManageUserProviderMapping";
                       settings.ControlStyle.CssClass = "DownButton";
                       settings.RouteValues = new { Controller = "AccountAdministration", Action = "ManageUserProviderMapping" };
                       settings.Width = Unit.Pixel(34);
                       settings.Height = 64;
                       settings.Text = "";
                       settings.UseSubmitBehavior = true;
                       settings.ClientSideEvents.Click = "OnDownClick";
                       settings.Images.Image.Url = Url.Content("~/Images/icons/RightMoveBtn.png");
                       settings.ControlStyle.CssClass = "mapUserDisableBtn";
                       settings.ClientEnabled = false;
                    
                   }).GetHtml();  %>
                    </div>

                    <div>
                        <%  Html.DevExpress().Button(
                   settings =>
                   {
                       settings.Name = "UpManageUserProviderMapping";
                       settings.ControlStyle.CssClass = "UpButton";
                       settings.RouteValues = new { Controller = "AccountAdministration", Action = "ManageUserProviderUnMapping"};
                       settings.ClientSideEvents.Click = "OnUpClick";
                       settings.Width = Unit.Pixel(34);
                       settings.Height = 64;
                       settings.Text = "";
                       settings.ClientEnabled = false;
                       settings.UseSubmitBehavior = true;
                       settings.Images.Image.Url = Url.Content("~/Images/icons/LeftMoveBtn.png");
                       settings.ControlStyle.CssClass = "mapUserDisableBtn";
                       
                   }).GetHtml();  %>
                    </div>
                </div>

            </td>
            <td>

                <div class="h3shadow">Organization Members</div>
                <input type="hidden" id="OrganizationSelectedRowValues" name="OrganizationSelectedRowValues" value="" />
                <%= Html.Action("GetUsersForSelectedProvider", "AccountAdministration", new { ProviderId = Model.ProviderId})%>
                  

            </td>
        </tr>
    </table>


    <!-- .holder -->

    <% } %>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
    <script type="text/javascript" id="dxss_anyid">
      //  var providerID = "";
    
     
        function OnDownClick(s, e) {
          
            var checkedVal = $("#NonOrganizationSelectedRowValues").val();
           // var providerID_Select = $("#OrganizationNameHidden").val();
           
            if (checkedVal.length == 0) {
                $(".error").html("Please select at least one non organization member to map with organization.");
                e.processOnServer = false;
                return false;
            } // else if (providerID_Select == null || providerID_Select == "") {
            //    $(".error").html("Please select organization.");
            //    e.processOnServer = false;
            //    return false;
            //}

            return true;
        }

        function OnUpClick(s, e) {
          //  var providerID_Select = $("#OrganizationNameHidden").val();
        
            var orgcheckedVal = $("#OrganizationSelectedRowValues").val();
            if ((orgcheckedVal.length == 0)) {
                $(".error").html("Please select at least one organization member to Un-map from organization.");
                e.processOnServer = false;
                return false;
            } //else if (providerID_Select == null || providerID_Select == "") {
            //    $(".error").html("Please select organization.");
            //    e.processOnServer = false;
            //    return false;
            //}

            return true;
        }

        //up & down validation ends 
        function NonOrganizationSelectionChanged(s, e) {
          
            DownManageUserProviderMapping.SetEnabled(true);
            $("#DownManageUserProviderMapping").removeClass("mapUserDisableBtn").addClass("mapUserActiveBtn");

            s.GetSelectedFieldValues("Email", GetSelectedFieldValuesCallback);
        }

        function GetSelectedFieldValuesCallback(values) {
            $('#NonOrganizationSelectedRowValues').val(values);
        }
        //non-organization ends

        //Organization select values
        function OrganizationSelectionChanged(s, e) {

            UpManageUserProviderMapping.SetEnabled(true);
            $("#UpManageUserProviderMapping").removeClass("mapUserDisableBtn").addClass("mapUserActiveBtn");

            s.GetSelectedFieldValues("Email", GetSelectedFieldValuesOrg);
        }

        function GetSelectedFieldValuesOrg(values) {
            $('#OrganizationSelectedRowValues').val(values);
        }

        //On selection of combo box value change function ends 
        function OnSelectionGetOrgnizationMember(s, e) {
       
            $("[id$=OrganizationNameHidden]").val(s.GetValue());
            //   providerID = s.GetValue();

            OrgMemberMaping.PerformCallback({ ProviderID: s.GetValue() });


        }


        function disableCommandColResizing(s, e) {
        
            if (e.column.fieldName == null) {
                e.cancel = true;
            }
        }

        function sendSelectedProviderId(s,e) {
            e.customArgs['ProviderID'] = $("#OrganizationNameHidden").val();
        }




    </script>
</asp:Content>
