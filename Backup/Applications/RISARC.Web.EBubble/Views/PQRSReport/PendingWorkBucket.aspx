<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Pending Patient Data
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Pending Patient Data</h2>
    <div class="totalAccount">Please answer pending question if any & generate reports based on the uploaded claims</div>

    <div class="orgDatils">
        <div><b>Select Provider</b><%= Html.Action("ParentChildProviderDropdown", new {IsClosed=ViewData["IsCompleted"] })%></div>
      <%--  <div class="AdjustPosition"><b>Select Measure</b><%= Html.Action("MeasuresDropdown")%></div>--%>
    </div>
   
        <%= Html.Action("_gvPendingWorkBucket", "PQRSReport")%>
     
    <h2>Group Status</h2>
    <%= Html.Action("_gvGroupStatus", "PQRSReport",new { isViwer = 0})%>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
    <script type="text/javascript">
        var textSeparator = ";";
        var values;

        function OnListBoxSelectionChanged(listBox, args) {
            debugger;
            if (args.index == 0)
                args.isSelected ? listBox.SelectAll() : listBox.UnselectAll();
            //UpdateSelectAllItemState();
            UpdateText();

        }
        function UpdateSelectAllItemState() {
            IsAllSelected() ? checkListBox.SelectIndices([0]) : checkListBox.UnselectIndices([0]);
        }
        function IsAllSelected() {
            for (var i = 1; i < checkListBox.GetItemCount() ; i++)
                if (!checkListBox.GetItem(i).selected)
                    return false;
            return true;
        }
        function UpdateText() {
            debugger;
            var selectedItems = checkListBox.GetSelectedItems();
            if (selectedItems.length == 0)
                checkComboBox.SetText("ALL Providers");
            else
                checkComboBox.SetText(GetSelectedItemsText(selectedItems));
        }
        function SynchronizeListBoxValues(dropDown, args) {
            checkListBox.UnselectAll();
            var texts = dropDown.GetText().split(textSeparator);
            values = GetValuesByTexts(texts);
            checkListBox.SelectValues(values);
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
            debugger;
            var actualValues = [];
            var item;
            for (var i = 0; i < texts.length; i++) {
                item = checkListBox.FindItemByText(texts[i]);
                if (item != null)
                    actualValues.push(item.value);
            }
           
            return actualValues;
        }

        function DropDownClose(s, e) {
            debugger;
            //Show below grids 
            $("#ShowHide").addClass("show").removeClass("hide");
            //
            var Texts = $("#checkComboBox_I").val();
            var TextArr = Texts.split(textSeparator);
            var ValueArr = GetValuesByTexts(TextArr);
            var providerListIDs = ValueArr.toString();

            if (providerListIDs != "") {
                gvPendingBucketWorkBook.PerformCallback({ ProviderIdList: providerListIDs });

            }
        }

    </script>
</asp:Content>

