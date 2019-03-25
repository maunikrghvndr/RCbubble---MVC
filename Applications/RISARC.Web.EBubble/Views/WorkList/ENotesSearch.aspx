<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<RISARC.eTAR.Model.SearchFieldENotes>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    e-Notes
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>e-Notes</h2>
    

    <div class="totalAccount">Total  <span id="TotalAccountsInBucket_span"><%= Html.DisplayFor(model => model.TotalAccountsInBucket) %> </span> Accounts are available in our bucket</div>

    <%= Html.Action("AccountNotesPopup", "AccountDetails", new {eNoteSearchFlag  = true ,enoteID = -1, DocumentID = -1})%>

    <div class="worklistTopSearch">

        <ul class="color_balls">
            <li class="RedBall">Deadline/Past- <span id="DeadLineRecordCount_span"><%= Html.DisplayFor(model => model.DeadLineRecordCount) %></span></li>
            <li class="YellowBall">2 Days to Deadline-<span id="TwoDaysToDeadLineRecordCount_span"><%= Html.DisplayFor(model => model.TwoDaysToDeadLineRecordCount) %></span></li>
            <li class="GreenBall">3 Days to Deadline- <span id="ThreeDaysToDeadLineRecordCount_span"><%= Html.DisplayFor(model => model.ThreeDaysToDeadLineRecordCount) %></span></li>
            <li class="BlueBall">More than 3 Days- <span id="MoreThanThreeDaysToDeadLineRecordCount_span"><%= Html.DisplayFor(model => model.MoreThanThreeDaysToDeadLineRecordCount) %></span></li>
        </ul>

    </div>

    <% using (Html.BeginForm("ENotesSearch", "WorkList", FormMethod.Post))
       { %>
    <input type="hidden" id="sentRecivedTabStatus" name="sentRecivedTabStatus" value="received" />

    <div class="worklist_search">
        <%if (Session["IsFieldOffierLogin"] != null && (bool)Session["IsFieldOffierLogin"])
          {%>
        <span style="display: none;">
            <%= Html.Action("TimeSpent","AccountDetails") %>
        </span>
        <%} %>
        <table class="SearchTable TableLayoutFixed7">
            <tr>

                <td class="blockTblTd">
                    <% Html.DevExpress().LabelFor(model => model.ENoteID,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                    <% Html.DevExpress().TextBoxFor(model => model.ENoteID, RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                        settings =>
                        {
                            settings.Name = "ENoteID";
                            settings.Width = Unit.Percentage(95);
                            //  settings.Properties.NullText = "E-Note #";
                            settings.Height = 35;
                        })
                    ).GetHtml();
                    %>
                </td>

                    
                <td class="blockTblTd">
                    <% Html.DevExpress().LabelFor(model => model.PatientName,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                     <%
           Html.DevExpress().TextBoxFor(model => model.PatientName, RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
              settings =>
              {
                  settings.Name = "PatientName";
                  settings.Width = System.Web.UI.WebControls.Unit.Percentage(95);
                  //settings.Properties.NullText = "Patient Name";
                  settings.Height = 35;
              })
          ).GetHtml();
                    %>
                </td>

                    
                <td class="blockTblTd">
                    <% Html.DevExpress().LabelFor(model => model.SenderOrReceiverName,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                    <%  Html.DevExpress().TextBoxFor(model => model.SenderOrReceiverName, RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                settings =>
                {
                    settings.Name = "SenderOrReceiverName";
                    settings.Width = System.Web.UI.WebControls.Unit.Percentage(95);
                    // settings.Properties.NullText = "Sender/Receiver Name";
                    settings.Height = 35;
                })
            ).GetHtml();
                    %>

                </td>

            </tr>


            <tr>
                <td>

                    <% 
           Html.DevExpress().Button(
                         settings =>
                         {
                             settings.Name = "btnSearch";
                             settings.Text = "Search";
                             settings.ControlStyle.HorizontalAlign = System.Web.UI.WebControls.HorizontalAlign.Center;
                             settings.UseSubmitBehavior = false;
                             settings.ClientSideEvents.Click = "enoteFilter";
                             settings.EnableTheming = false;
                             settings.ControlStyle.CssClass = "orangeBtn";
                             settings.Width = System.Web.UI.WebControls.Unit.Pixel(100);
                             settings.Height = 32;

                         }).GetHtml();

                    %>
                </td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
        </table>
    </div>

    <% }


        
       %>



    <div class="search_result">
        <%= Html.Partial("_eNoteSearchTab") %>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
    <script src="<%: Url.Content("~/Scripts/TimeTracker.js") %>" type="text/javascript"></script>
    <script src="<%: Url.Content("~/Scripts/eNote.js") %>" type="text/javascript"></script>
    <script type="text/javascript">
        var eNoteID_global;
        var patientName_Global;
        var senderOrReceiverName_global;
        function enoteFilter(s, e) {
            var IsReceived;

            eNoteID_global = ENoteID.GetValue();
            patientName_Global = PatientName.GetValue();
            senderOrReceiverName_global = SenderOrReceiverName.GetValue();
            if ($("#sentRecivedTabStatus").val() == 'received') {
                IsReceived = true;
                if ($('#gvReceivedEnotes').length != 0)
                    gvReceivedEnotes.PerformCallback();
            }
            else {
                // Call bak of Send Grid
                IsReceived = false;
                if ($('#gvSentEnotes').length != 0)
                    gvSentEnotes.PerformCallback();
            }
        }

        function onBeingCallback_RecivedGrid(s, e)
        {
            e.customArgs["ENoteID"] = eNoteID_global;
            e.customArgs["PatientName"] = patientName_Global;
            e.customArgs["SenderOrReceiverName"] = senderOrReceiverName_global;
            e.customArgs["IsReceived"] = true;
        }

        function onBeingCallback_SentGrid(s, e) {
            e.customArgs["ENoteID"] = eNoteID_global;
            e.customArgs["PatientName"] = patientName_Global;
            e.customArgs["SenderOrReceiverName"] = senderOrReceiverName_global;
            e.customArgs["IsReceived"] = false;
            }

        function OnActiveTab_Chnaged(s, e)
        {
            if (tbcReceivedSent.GetActiveTab().name == "received" && $('#gvReceivedEnotes').length != 0)
                gvReceivedEnotes.PerformCallback();
            else if (tbcReceivedSent.GetActiveTab().name == "sent" && $('#gvSentEnotes').length != 0)
                gvSentEnotes.PerformCallback();
        }

        function TabClicked(s, e) {
            var tabname = e.tab.name;
            $("#sentRecivedTabStatus").val(tabname);
        }

        function EnoteStatus(SenderProviderId, enoteIdetification, documentID) {
            AccountNotesPopup.PerformCallback({ SenderProviderID: SenderProviderId, eNoteSearchFlag: true, enoteID: enoteIdetification, DocumentID: documentID });
            AccountNotesPopup.Show();
        }

        function PopupEnoteDoneClick(s, e) {
            if ($("#sentRecivedTabStatus").val() == 'received') {
               
                if ($('#gvReceivedEnotes').length != 0)
                    gvReceivedEnotes.PerformCallback();
            }
            else {
                // Call bak of Send Grid
              
                if ($('#gvSentEnotes').length != 0) {
                    gvReceivedEnotes.PerformCallback();
                    gvSentEnotes.PerformCallback();
                }
            }
            //tbcReceivedSent.PerformCallback();
            AccountNotesPopup.Hide();

            //AccountNotesPopup.Hide();
        }

        function oneEndCallback(s, e, DeadLineRecordCount, TwoDaysToDeadLineRecordCount, ThreeDaysToDeadLineRecordCount, MoreThanThreeDaysToDeadLineRecordCount, TotalAccountsInBucket) {
            $('#DeadLineRecordCount_span').html(DeadLineRecordCount);
            $('#TwoDaysToDeadLineRecordCount_span').html(TwoDaysToDeadLineRecordCount);
            $('#ThreeDaysToDeadLineRecordCount_span').html(ThreeDaysToDeadLineRecordCount);
            $('#MoreThanThreeDaysToDeadLineRecordCount_span').html(MoreThanThreeDaysToDeadLineRecordCount);
            $('#TotalAccountsInBucket_span').html(TotalAccountsInBucket);
            
        }
        //Added by surekha 24/12/2014
        function SetLocalDateNote(s, e, utcDate) {
            var myDate = new Date();
            var timezone = jstz.determine();
            $.ajax({
                url: "../TimeZoneCalculator.ashx?Date=" + utcDate + "&ClientTimeZone=" + (myDate.getTimezoneOffset() / 60),
                cache: false
            }).done(function (data) {
                var DateCreated = new Date(data);
                s.SetText(DateCreated.format("MMMM dd, yyyy"));
            });
        }

        //Call below function on AccountNotesPopup Endcallback becuase there was issue on production for PerformCallback to sync 
        function AccountNotesPopup_EndCallback(s, e) {
          //  BindRLGrid(AccountSubmissionDetailsID, true);
        }


        //========= Status Popup cancel button click ========
        function StatusCancelBtnClick(s, e) {
            // This code is not need here
            //if ($("#ExternalNoteGrid").length != 0) {
            //    ExternalNoteGrid.PerformCallback();
            //}
            ////Refresh RMSDocumentsGrid On popup close
            //if ($("#RMSDocumentsGrid").length != 0) {
            //    RMSDocumentsGrid.PerformCallback();
            //}

            AccountNotesPopup.Hide();
            //jQuery.get('../AccountDetails/CleareSessionForRLUpload');
        }



</script>
</asp:Content>
