<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.eTAR.Model.AccountDetailsMain>" %>
<script type="text/javascript">
    function EnableDisableSubmitBtn(s, e) {
        var status = StatusComboBox.GetValue();
        if (status == 6) {
            statusSubmitBtn.SetEnabled(false);
            $("#statusSubmitBtn").removeClass("orangeBtn").addClass("greyBtn");
        }
        else {
            statusSubmitBtn.SetEnabled(true);
            $("#statusSubmitBtn").removeClass("greyBtn").addClass("orangeBtn");
        }
    }
</script>

      <%  
        if (ViewData["eNoteSearchFlag"] != null && (bool)ViewData["eNoteSearchFlag"] == false && (Model.HasExternalNoteAccess || Model.IsProviderEtar_LoggedInUser))
          {%>
       <div class="sglNoteBotBorder">External Note</div>
      
        <table class='cls720width'>
        <tr>
            <td>
                <div class="interMemo">
                    <% Html.DevExpress().Memo(
                            settings =>
                            {
                                settings.Name = "popupExternalNoteMemo";
                                settings.Width = Unit.Percentage(104);
                                settings.Height = 28;
                                settings.ShowModelErrors = true;
                                settings.ControlStyle.BackColor = System.Drawing.ColorTranslator.FromHtml("#f7f7f7");
                                settings.Properties.FocusedStyle.BackColor = System.Drawing.ColorTranslator.FromHtml("#ffffff");
                     
                            }).GetHtml();
                    %>
                </div>
                <div class="AddButton">
                    <%  Html.DevExpress().Button(
                    AddButton =>
                    {
                        AddButton.Name = "popupExternalAddButton";
                        AddButton.ControlStyle.CssClass = "DoneButton";
                        AddButton.ControlStyle.HorizontalAlign = HorizontalAlign.Center;
                        AddButton.Width = Unit.Pixel(70);
                        AddButton.Height = 28;
                        AddButton.ControlStyle.CssClass = "orangeBtn";
                        AddButton.Text = "Add";
                        AddButton.EnableClientSideAPI = true;
                        AddButton.ClientSideEvents.Click = "AddExternalNotePopup";
                    }).GetHtml();
                    %>
                </div>
                <tr>
                    <td>&nbsp;</td>
                </tr>
        <tr>
            <td>
                <%  System.Web.Mvc.Html.ChildActionExtensions.RenderAction(Html, "ExternalNoteGridCallback", "AccountDetails", new { TCNIdentificationID = Model.TCNIdentificationID, SenderProviderID = Model.SenderProviderID, controlFlag = true }); %>
            </td>
        </tr>
    </table>
     <% }%>


    <%  Html.DevExpress().PageControl(
        NoteTabs =>
        {
            NoteTabs.Name = "popupNoteTabs";
            NoteTabs.Width = 720;
            NoteTabs.ShowLoadingPanel = true;
            NoteTabs.Height = 250;
            //Tabs control loading panel 
            NoteTabs.LoadingPanelText = " ";
            NoteTabs.Images.LoadingPanel.Url = Url.Content("~/Images/icons/LoadingLogo.gif");
            NoteTabs.Images.LoadingPanel.Width = 76;
            NoteTabs.Images.LoadingPanel.Height = 100;  

            NoteTabs.Styles.ActiveTab.BackColor = System.Drawing.ColorTranslator.FromHtml("#ececec");
            NoteTabs.Styles.ActiveTab.CssClass = "TabActive";

            NoteTabs.Styles.Tab.VerticalAlign = VerticalAlign.Middle;

            NoteTabs.Styles.ActiveTab.BorderTop.BorderColor = System.Drawing.ColorTranslator.FromHtml("#ff6600");
            NoteTabs.Styles.ActiveTab.BorderTop.BorderWidth = 2;

            NoteTabs.Styles.ActiveTab.BorderBottom.BorderWidth = 0;
            NoteTabs.Styles.SpaceAfterTabsTemplate.Paddings.Padding = 0;

            NoteTabs.Styles.Content.BackColor = System.Drawing.ColorTranslator.FromHtml("#ececec");

            //To increse tab height 
            NoteTabs.Styles.Tab.Height = 30;

            if (ViewData["eNoteSearchFlag"] != null && (bool)ViewData["eNoteSearchFlag"] == true && ViewData["enoteID"] != null)
            {
                NoteTabs.TabPages.Add("e-Note", "ReplyENote").SetContent(() =>
                {
                    Html.RenderPartial("PopupENoteTabContent", Model, new ViewDataDictionary { { "EnotePopUp", true }, { "eNoteID", ViewData["enoteID"] }, { "DocumentID", ViewData["DocumentID"] } });
                });
            }
        }).GetHtml();
    %>


<%if (ViewData["eNoteSearchFlag"] != null && (bool)ViewData["eNoteSearchFlag"] == true && ViewData["enoteID"] != null)
  {%>
<div class="floatRight">
    <div class="clear">
        <br />
    </div>
    <% Html.DevExpress().Button(
                                   RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                           settings =>
                           {
                               settings.Name = "EnoteDone";
                               settings.Text = "Done";
                               settings.Width = System.Web.UI.WebControls.Unit.Percentage(100);
                               settings.ClientSideEvents.Click = "PopupEnoteDoneClick";
                           })).GetHtml(); %>
</div>
<div class="clear"></div>
<%}else{%>
<div class="clear"> <br /></div>
  <div class="sglNoteBotBorder">Add Response Letter</div>
   <%= Html.Partial("_ResponseLetterUpload") %>
<div class="clear"> <br /></div>
<div class="statusOuter">
    <table class="StatusTB">
       
        <tr>
            <td colspan="2" class="boldText">Select Status</td>
        </tr>
        <tr>
            <td colspan="2"><%
      Html.DevExpress().ComboBox(
                     settings =>
                     {
                         settings.Name = "StatusComboBox";
                         settings.Width = System.Web.UI.WebControls.Unit.Percentage(95);
                         settings.Properties.TextField = "StatusName";
                         settings.Properties.ValueField = "StatusId";
                         settings.Properties.ValueType = typeof(int);
                         settings.Properties.NullText = "--Please Select--";
                         settings.ControlStyle.CssClass = "AllScanedDoc";
                         settings.Properties.ClientSideEvents.SelectedIndexChanged = "EnableDisableSubmitBtn";
                         settings.Properties.ClientSideEvents.Init = "EnableDisableSubmitBtn";

                         settings.ControlStyle.CssClass = "OrgNameSeachboxCls";
                         settings.Properties.DropDownButton.Image.Url = "~/Images/icons/dropdown_button.png";
                         settings.Properties.ButtonStyle.Border.BorderWidth = 0;
                         settings.Properties.ButtonStyle.Paddings.Padding = 0;
                         settings.Properties.ButtonStyle.CssClass = "dropdownButton";
                         
                     }
                     ).BindList(Model.TcnStatusList).Bind(Model.CurrentTcnStatus).GetHtml();
            %></td>
        </tr>
        <tr>
            <td>&nbsp;
               
            </td>
        </tr>
    </table>
    <div class="statusButtons">
        <ul class="StatusTBUl">
            <li><% Html.DevExpress().Button(
                                   RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                           settings =>
                           {
                               settings.Name = "statusSaveBtn";
                               settings.Text = "Save Record To Continue";
                               settings.Width = System.Web.UI.WebControls.Unit.Percentage(100);
                               settings.ClientSideEvents.Click = "function(s,e){ StatusSaveSubmitBtnClick(s,e,\"saveBtn\"); }";
                           })).GetHtml(); %></li>
            <li>
                <% Html.DevExpress().Button(
                                   RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                           settings =>
                           {
                               settings.Name = "statusSubmitBtn";
                               settings.Text = "Submit To Provider";
                               settings.Width = System.Web.UI.WebControls.Unit.Percentage(100);
                               settings.ClientSideEvents.Click = "function(s,e){ StatusSaveSubmitBtnClick(s,e,\"submitBtn\"); }";
                               settings.ClientEnabled = true;
                           })).GetHtml(); %>
            </li>
            <li>
                <% Html.DevExpress().Button(
                                   RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                           settings =>
                           {
                               settings.Name = "statusCancelBtn";
                               settings.Text = "Cancel";
                               settings.ControlStyle.CssClass = "greyBtn";
                               settings.Width = System.Web.UI.WebControls.Unit.Percentage(100);
                               settings.ClientSideEvents.Click = "function(s, e) { StatusCancelBtnClick(s,e) }";
                           })).GetHtml();
                %>
            </li>
        </ul>
    </div>
</div>
<% }%>


            
