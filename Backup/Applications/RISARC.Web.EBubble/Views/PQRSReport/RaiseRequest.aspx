<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Request Document
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Request Document</h2>
    <div class="totalAccount">Select appropriate fields below and send document request</div>
  <%-- <div class="thankyou"><%=ViewData["RequestSucess"]%></div>--%>

    <table style="width: 80%" border="1">
        <tr>
            <td>
                <b>Select Year</b>
            </td>
            <td>
                <b>Select Provider</b>
            </td>
            <td>

            </td>
        </tr>
        <tr>
            <td>
              <%= Html.Action("BatchYearComboBox","PQRSReport") %>
            </td>

            <td>
              <%= Html.Action("ParentChildProviderDropdown" )%>
                  
            </td>
            <td class="floatLeft">
                <% Html.DevExpress().Button(
                                   RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                           settings =>
                           {
                               settings.Name = "Continue";
                               settings.UseSubmitBehavior = true;
                               settings.ControlStyle.CssClass = "greyBtn";
                               settings.Text = "Continue";
                               settings.ClientSideEvents.Click = "LoadGridView";
                           })).GetHtml(); %>

            </td>
        </tr>
        
    </table>
    <br />
    <br />
      <%= Html.Action("_gvRequestDocument", "PQRSReport")%>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
  <script type="text/javascript">
      
      var textSeparator = ";";
      var values;

      function OnListBoxSelectionChanged(listBox, args) {
          //debugger;
          if (args.index == 0)
              args.isSelected ? listBox.SelectAll() : listBox.UnselectAll();
          //UpdateSelectAllItemState();
          UpdateText();

      }
      function UpdateSelectAllItemState() {
          //debugger;
          IsAllSelected() ? checkListBox.SelectIndices([0]) : checkListBox.UnselectIndices([0]);
      }
      function IsAllSelected() {
          //debugger;
          for (var i = 1; i < checkListBox.GetItemCount() ; i++)
              if (!checkListBox.GetItem(i).selected)
                  return false;
          return true;
      }
      function UpdateText() {
         // debugger;
          var selectedItems = checkListBox.GetSelectedItems();
          checkComboBox.SetText(GetSelectedItemsText(selectedItems));
      }
      function SynchronizeListBoxValues(dropDown, args) {
         // debugger;
          checkListBox.UnselectAll();
          var texts = dropDown.GetText().split(textSeparator);
          values = GetValuesByTexts(texts);
          checkListBox.SelectValues(values);
          UpdateSelectAllItemState();
          UpdateText(); // for remove non-existing texts
      }
      function GetSelectedItemsText(items) {
          //debugger;
          var texts = [];
          for (var i = 0; i < items.length; i++)
              if (items[i].index != 0)
                  texts.push(items[i].text);
          return texts.join(textSeparator);
      }

      function GetValuesByTexts(texts) {
        //  debugger;
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
         // debugger;
          //Show below grids 
          $("#ShowHide").addClass("show").removeClass("hide");
          //
          var Texts = $("#checkComboBox_I").val();
          var TextArr = Texts.split(textSeparator);
          var ValueArr = GetValuesByTexts(TextArr);
          var providerListIDs = ValueArr.toString();

          //if (providerListIDs != "") {
          //    gvPendingBucketWorkBook.PerformCallback({ ProviderIdList: providerListIDs });

      }
      

      function LoadGridView() {
          //debugger;
          var BatchYear = $("BatchYearcomboBox").val();

          var Texts = $("#checkComboBox_I").val();
          var TextArr = Texts.split(textSeparator);
          var ValueArr = GetValuesByTexts(TextArr);
          var providerListIDs = ValueArr.toString();

          if (providerListIDs != "" && BatchYear != "") {
              gvRequestDocument.PerformCallback({ Year: BatchYear, ProviderIds: providerListIDs });
          }
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


    </script>

    </asp:Content>
