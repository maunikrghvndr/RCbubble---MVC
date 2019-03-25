<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Completed Patient Data
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Completed Patient Data</h2>
    <div class="totalAccount">View and edit the answers provided based on the measures</div>

    <div class="orgDatils">
        <table>
            <tr>
                <td>
                    <b>Select Provider</b>
                </td>
                <td style="width:70%">&nbsp;</td>
            </tr>
            <tr>
                <td style="width: 40%">
                    <%= Html.Action("ParentChildProviderDropdown", new { IsClosed = ViewData["IsCompleted"] })%>
                </td>
                <td>
                    <% Html.DevExpress().Button(
                                   RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                           settings =>
                           {
                               settings.Name = "ExportBtn";
                               settings.UseSubmitBehavior = true;
                               settings.Text = "Export XML";
                               settings.Width = Unit.Percentage(20);
                               settings.ClientSideEvents.Click = "Export";
                               settings.Width = 100;
                           })).GetHtml(); %>
                </td>
            </tr>
        </table>

    <%= Html.Action("_gvClosedWorkBucket", "PQRSReport")%>
    <br />
    <a href="javascript:launch()" id="test"></a>
    <a href="javascript:launch2()" id="test2"></a>
    <a href="javascript:launch3()" id="test3"></a>
    <a href="javascript:launch4()" id="test4"></a>
    <h2>Group Status</h2>
    <%= Html.Action("_gvGroupStatus", "PQRSReport")%>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">

    <script type="text/javascript">
        var textSeparator = ";";
        var values;

        function Export() {
            setTimeout(window.open('/PQRSReport/ExportXML?type=Provider'), 3000);
            document.getElementById("test").click();

        }
        function launch() {
            setTimeout(window.open('/PQRSReport/ExportXML?type=Discharge'), 3000);
            document.getElementById("test2").click();
        }
        function launch2() {
            setTimeout(window.open('/PQRSReport/ExportXML?type=Ranking'), 3000);
            document.getElementById("test3").click();
        }
        function launch3() {
            setTimeout(window.open('/PQRSReport/ExportXML?type=Patient'), 3000);
            document.getElementById("test4").click();
        }
        function launch4() {
            setTimeout(window.open('/PQRSReport/ExportXML?type=Clinic'), 3000);
        }

        function OnListBoxSelectionChanged(listBox, args) {

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
            //Show below grids 
            $("#ShowHide").addClass("show").removeClass("hide");
            //
            var Texts = $("#checkComboBox_I").val();
            var TextArr = Texts.split(textSeparator);
            var ValueArr = GetValuesByTexts(TextArr);
            var providerListIDs = ValueArr.toString();

            if (providerListIDs != "") {
                gvCloseBucketWorkBook.PerformCallback({ ProviderIdList: providerListIDs });

            }
        }

    </script>

</asp:Content>

