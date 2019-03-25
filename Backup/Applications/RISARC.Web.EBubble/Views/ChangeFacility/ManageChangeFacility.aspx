<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
   Manage Change Facility Settings
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<h2>Manage Change Facility Settings</h2>
<div class="totalAccount">Select User, add organizations and map accessible roles for them</div>
   
    <input type="hidden" id="Roles" name="Roles" value="" />
    <input type="hidden" id="UserIndex" name="UserIndex" value="" />
    <span class="totalAccount">Select Users</span>
     
   <%= Html.Action("UsersOrgnizationsList", "ChangeFacility") %>
    <br />
    <div class="ShowHide hide">
      <%= Html.Action("_gvChangeFacility", "ChangeFacility")%>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
    <script type="text/javascript">
        var action;
        function UserListClick(s, e) {
            s.GetRowValues(e.visibleIndex, 'UserIndex', GetSelectedUserIndex);
        }

        function gvChangeFacility_BeginCallback(s, e) {
            action = e.command;
            e.customArgs["actioncommand"] = e.command;
            e.customArgs["UserIndex"] = $('#UserIndex').val();
            
        }

        //function gvChangeFacility_EndCallback(s, e) {
           
        //    if (action == "UPDATEEDIT") {
        //        gvUserOrgnizationsList.Refresh();
        //    }
           
        //}

        function GetSelectedUserIndex(UserIndex) {
       
            gvChangeFacility.PerformCallback({ UserIndex: UserIndex });
            $("#UserIndex").val(UserIndex);
            $("div.ShowHide").removeClass("hide").addClass("show");
        }

       
    </script>

    <script type="text/javascript">
        //<![CDATA[
        var textSeparator = ";";
        function OnListBoxSelectionChanged(listBox, args) {
       
            if (args.index == 0)
                args.isSelected ? listBox.SelectAll() : listBox.UnselectAll();
            UpdateSelectAllItemState();
            UpdateText();
            //Set all selected valuees to hidden filed 
            $("#Roles").val($("#RolesComboBox_I").val());
        }
        function UpdateSelectAllItemState() {
            IsAllSelected() ? RoleNamesListBox.SelectIndices([0]) : RoleNamesListBox.UnselectIndices([0]);
        }
        function IsAllSelected() {
            for (var i = 1; i < RoleNamesListBox.GetItemCount() ; i++)
                if (!RoleNamesListBox.GetItem(i).selected)
                    return false;
            return true;
        }
        function UpdateText() {
            var selectedItems = RoleNamesListBox.GetSelectedItems();
            RolesComboBox.SetText(GetSelectedItemsText(selectedItems));
        }
        function SynchronizeListBoxValues(dropDown, args) {
           // debugger;
            RoleNamesListBox.UnselectAll();
            var texts = dropDown.GetText().split(textSeparator);
            var values = GetValuesByTexts(texts);
            RoleNamesListBox.SelectValues(values);
            UpdateSelectAllItemState();
            UpdateText(); // for remove non-existing texts
        }
        function GetSelectedItemsText(items) {
            var texts = [];
            for (var i = 0; i < items.length; i++)
                if (items[i].index != 0)
                    texts.push(items[i].text);
            return texts.join(textSeparator);
        }
        function GetValuesByTexts(texts) {

            var actualValues = [];
            var item;
            for (var i = 0; i < texts.length; i++) {
                item = RoleNamesListBox.FindItemByText(texts[i]);
                if (item != null)
                    actualValues.push(item.value);
            }
            return actualValues;
        }
        // ]]>
</script>


</asp:Content>


