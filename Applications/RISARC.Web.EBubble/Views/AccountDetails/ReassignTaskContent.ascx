<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<%Html.DevExpress().ComboBox(
    settings =>
    {
        settings.Name = "Reassign";
        settings.ControlStyle.CssClass = "AllScanedDoc";
        settings.Width = System.Web.UI.WebControls.Unit.Percentage(96);
        // settings.Properties.DropDownWidth = 550;
        settings.Properties.DropDownStyle = DropDownStyle.DropDownList;
        //settings.CallbackRouteValues = new { Controller = "AccountDetails", Action = "TCNDocumentCombo", AccountSubmissionDetailsID = Model.AccountSubmissionDetailsID, SenderProviderID = Model.SenderProviderID, TCNNo = Model.TCNNo };
        settings.Properties.CallbackPageSize = 30;
        settings.Properties.IncrementalFilteringMode = IncrementalFilteringMode.StartsWith;
        //settings.Properties.TextFormatString = "{0}";
        settings.Properties.ValueField = "ReviewerUserIndex";
        settings.Properties.NullText = "--Please Select a value--";
        settings.Properties.ValueType = typeof(string);
        settings.Properties.Columns.Add("ReviewerName", "Reviewer", 20).Visible = true;
        settings.Properties.Columns.Add("ReviewerProviderName", "Organization Name", 20);
       
        //settings.Properties.Columns.Add("ExternalFileName", "Ext File Name", 20);
        //settings.Properties.Columns.Add("TCNNumber", "TCN #", 15);
        settings.Properties.EnableClientSideAPI = true;
        
        //settings.Properties.ClientSideEvents.EndCallback = "DocumentComboBoxInit";
        //settings.Properties.ClientSideEvents.Init = "DocumentComboBoxInit";
        settings.Properties.ClientSideEvents.SelectedIndexChanged = "function(s, e){ SelectReassignComboBox(s, e)}";

    }
).BindList(Model.ReviewerInformationList).GetHtml();
     %>
 <div class="floatLeft">
                                    <% Html.DevExpress().Button(
                                   RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                                   settings =>
                                   {
                                       settings.Name = "ReassignDoneButton";
                                       settings.Height = 32;
                                       settings.Width = 83;
                                       settings.ControlStyle.CssClass = "orangeBtn";
                                       settings.UseSubmitBehavior = false;
                                       //ViewData["sourceFlag"] == 1 Means its came from document pending for TSN screen
                                        settings.ClientSideEvents.Click = "function(s,e){ ReassignpDoneButtonClick(s,e) } ";
                                        settings.Text = "Done";

                                   })).GetHtml(); %>
                                </div>
                            
                                  <div class="floatRight" >
                                    <% Html.DevExpress().Button(
                                   RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                                   settings =>
                                   {
                                       settings.Name = "ReassignCancelButton";
                                       settings.Height = 32;
                                       settings.Width = 83;
                                       settings.ControlStyle.CssClass = "greyBtn";
                                       settings.UseSubmitBehavior = false;                                      
                                        settings.Text = "Cancel";
                                        settings.ClientSideEvents.Click = "function(s,e){ ReassignTaskPopup.Hide(); } ";
                                       
                                   })).GetHtml(); %>
                                      </div>