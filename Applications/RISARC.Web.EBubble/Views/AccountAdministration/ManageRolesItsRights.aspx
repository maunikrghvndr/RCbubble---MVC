<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<RISARC.Membership.Model.DisplayRoleRights>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    ManageRolesItsRights
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<h2>Roles & Rights</h2>

<%= Html.Partial("UserDocumentPopup") %>
     <div class="error" style="display: none; background: red; width: 60%; height: 20px;">Please tick altlest one check box</div>

    <div style="width: 70%;">
                <div style="float: left;">
                    
                    
                      <input type="hidden" name="all_checkbox_value" id="all_checkbox_value" value="" />
                      <input type="hidden" name="current_selected_row" id="current_selected_row" value="" />
                      <input type="hidden" value="<%= Url.Content("~/AccountAdministration/ManageRoles/") %>" id="EditPath" />
                      <%= Html.Action("RoleRights","AccountAdministration") %>
                    

                </div>

                <div style="float:right; display:none;" id="RightList" >
                    <%= Html.Action("ListRolesRights","AccountAdministration") %>
                </div>

            </div>
    

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
    <script type="text/javascript">
        var selectedRoleId = "";
        function SelectionChanged(s, e) {
            s.GetSelectedFieldValues("RoleId", OnGetSelectedFieldValues);

        }

        function OnGetSelectedFieldValues(selectedValues) {
            $("#all_checkbox_value").val(selectedValues);
        }

        function RowClick(s, e) {

            $("#current_selected_row").val(selectedRoleId);
            //show rights block.
            $("#RightList").show();

            selectedRoleId = s.GetRowKey(e.visibleIndex);
           
            
            UserRights.PerformCallback({ selectedID: selectedRoleId });

        }

        //This function for user rights sections  
        function OnButtonClick(s, e) {
            s.GetRowValues(e.visibleIndex, 'ImageUrl', OnGetRowValues);
        }

        function OnGetRowValues(url) {
            $('#docImages').attr('src', url);
            popupControl.Show();
        }

        function OnBeginCallback(s, e) {     // ASPxCallbackPanel BeginCallback
            e.customArgs["roleid"] = selectedRoleId;
        }

        //this function for checkbox section validation 
        var timeout = null;
        function OnSaveClick(s, e) {

            var checkedVal = $("#all_checkbox_value").val();
            if ((checkedVal.length == 0)) {
                if (timeout !== null) clearTimeout(timeout);
                $('.error').show(600);
                $('.error').fadeIn(600);
                timeout = setTimeout(function () {
                    $('.error').fadeOut(500);
                }, 3000);
            }

        }
       
        ////for edit button clicked validation
        function editClick() {
            //alert("in edit");
           
            var currentVal = $("#current_selected_row").val();

             if ((currentVal.length == 0)) {

                if (timeout !== null) clearTimeout(timeout);
                $('.error').show(600);
                $('.error').fadeIn(600);
                timeout = setTimeout(function () {
                    $('.error').fadeOut(500);
                }, 3000);
             } else {
                 alert("redirect");
                 var editPath = $("#EditPath").val();
                 window.location = editPath +"?roleId="+ currentVal;

            }


        }


    </script>
</asp:Content>