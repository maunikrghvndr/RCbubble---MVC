<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
   Cost Driver Report
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="setBorderSpace">
        <h2>Cost Driver Report</h2>
        <div class="totalAccount">Select provider from the below list for which to view the Cost Driver report.</div>
    </div>
    <div>
        <br />
      <%--  <%= Html.Action("ProviderDropdown")%></div>--%>
       <%= Html.Action("ParentChildProviderDropdown")%></div>
      <br />
    <div class="orgDatils" style="display:none">
        <div class="floatLeft">Organization Name: <span class="orgName clsBold"><b> </b></span></div>
       <div class="floatRight"><span>From: <b>01/01/<%= DateTime.Now.Year.ToString() %></b> To: <b>12/31/<%= DateTime.Now.Year.ToString() %></b></span></div>
    </div>
  
       <%= Html.Partial("_CostDriverCallbackPanel")%>
 
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
   
      <script type="text/javascript">
        var textSeparator = ";";
        var values;
       
        function OnListBoxSelectionChanged(listBox, args) {
            if (args.index == 107)
                args.isSelected ? listBox.SelectAll() : listBox.UnselectAll();
            //UpdateSelectAllItemState();
            UpdateText();
            //Show Selected Value in comma seprator 
            $(".orgDatils").show();
            $(".orgName").html($("#checkComboBox_I").val());

            
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
                if (items[i].index != 107)
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

        function DropDownClose(s,e) {
          
            var Texts = $("#checkComboBox_I").val();
            var TextArr = Texts.split(textSeparator);
            var ValueArr = GetValuesByTexts(TextArr);
            var providerListIDs = ValueArr.toString();
          
            if (providerListIDs!="") {
            CostDriverCallbackPanel.PerformCallback({ ProviderIdList: providerListIDs });
            }
        }

</script>
</asp:Content>


