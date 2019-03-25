<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<RISARC.eTAR.Model.SearchFieldWorklist>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Worklist
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Worklist</h2>
    <div class="totalAccount">Total <%= Model.SearchedWorklistData.Count() %> Accounts are available in our bucket </div>
    <div class="worklistTopSearch">

        <ul class="color_balls">
            <li class="RedBall">Deadline/Past- <%=  Model.DeadLineRecordCount %>  </li>
            <li class="YellowBall">2 Days to Deadline-<%=  Model.TwoDaysToDeadLineRecordCount %>  </li>
            <li class="GreenBall">3 Days to Deadline- <%=  Model.ThreeDaysToDeadLineRecordCount %>  </li>
            <li class="BlueBall">More than 3 Days-<%=  Model.MoreThanThreeDaysToDeadLineRecordCount %>  </li>
        </ul>

    </div>

 
    <% using (Html.BeginForm("WorklistSearch", "WorkList", FormMethod.Post))
       { %>
  
    <div class="worklist_search">
        <%if (Session["IsFieldOffierLogin"] != null && (bool)Session["IsFieldOffierLogin"])
          {%>
        <span style="display: none;">
            <%= Html.Action("TimeSpent","AccountDetails") %>
        </span>
        <%} %>
      

        <table class="SearchTable TableLayoutFixed7">
            <tr>
                <td class="width50Precent blockTblTd">
                      <% Html.DevExpress().LabelFor(model => model.AccountNo,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                    <% Html.DevExpress().TextBoxFor(model => model.AccountNo, RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                        settings =>
                        {
                            settings.Width = Unit.Percentage(95);
                        //    settings.Properties.NullText = "Account #";
                            settings.Height = 35;
                        })
                    ).GetHtml();
                    %>
                </td>
                <td class="width50Precent blockTblTd">
                   <% Html.DevExpress().LabelFor(model => model.TCNNo,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                    <% Html.DevExpress().TextBoxFor(model => model.TCNNo, RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                settings =>
                {
                    settings.Width = Unit.Percentage(95);
                    //settings.Properties.NullText = "TCN #";
                    settings.Height = 35;
                })
            ).GetHtml(); %>

                </td>
                <td>&nbsp;</td>
            </tr>
           <%-- <tr>
                <td colspan="3">&nbsp;</td>
            </tr>--%>
            <tr>
                <td class="width50Precent blockTblTd">
                     <% Html.DevExpress().LabelFor(model => model.PatientName,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                    <%
           Html.DevExpress().TextBoxFor(model => model.PatientName, RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
              settings =>
              {
                  settings.Width = System.Web.UI.WebControls.Unit.Percentage(95);
                 // settings.Properties.NullText = "Patient Name";
                  settings.Height = 35;
              })
          ).GetHtml();
                    %>
                </td>
                <td class="width50Precent blockTblTd">
                      <% Html.DevExpress().LabelFor(model => model.POENoOrCINNo,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                    <%  Html.DevExpress().TextBoxFor(model => model.POENoOrCINNo, RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                settings =>
                {
                    settings.Width = System.Web.UI.WebControls.Unit.Percentage(95);
                   // settings.Properties.NullText = "POE/CIN #";
                    settings.Height = 35;
                })
            ).GetHtml();
                    %>

                </td>
                <td>&nbsp;</td>
            </tr>
        
            <tr>
                <td>

                    <% 
           Html.DevExpress().Button(
                         settings =>
                         {
                             settings.Name = "btnSearch";
                             settings.Width = System.Web.UI.WebControls.Unit.Pixel(100);
                             settings.Height = 34;
                             settings.EnableTheming = false;
                             settings.ControlStyle.CssClass = "orangeBtn";
                             settings.ControlStyle.HorizontalAlign = System.Web.UI.WebControls.HorizontalAlign.Center;
                             settings.Text = "Search";
                             settings.UseSubmitBehavior = true;

                         }).GetHtml();
                    %>

                </td>
            </tr>
        </table>
    </div>

    <% } %>

    <div class="font16">
        <%
            string TableHeader = "";
            if (!string.IsNullOrEmpty(Model.AccountNo) || !string.IsNullOrEmpty(Model.PatientName) || !string.IsNullOrEmpty(Model.TCNNo) || !string.IsNullOrEmpty(Model.POENoOrCINNo))
                TableHeader += "<p> You have Searched for:<b>";

            if (!string.IsNullOrEmpty(Model.AccountNo))
                TableHeader += " Account No " + Model.AccountNo + ",";
            if (!string.IsNullOrEmpty(Model.PatientName))
                TableHeader += " Patient Name " + Model.PatientName + ",";
            if (!string.IsNullOrEmpty(Model.TCNNo))
                TableHeader += " TCN No " + Model.TCNNo + ",";
            if (!string.IsNullOrEmpty(Model.POENoOrCINNo))
                TableHeader += " POE/CIN No " + Model.POENoOrCINNo + "<br>";

            TableHeader += "</p></b></span>";
        %>
        <%=TableHeader %>
    </div>
    <div class="search_result">
        <%= Html.Action("AccountNotesPopup", "AccountDetails", new { openfmWorklist="worklist"})%>
        <%--<%= Html.Action("AccountNotesPopup", "AccountDetails", new {eNoteSearchFlag  = false ,enoteID = -1, DocumentID = -1})%>--%>
        <%= Html.Action("WorklistGridCallback") %>
        <%= Html.Hidden("hdnTcnId","") %>
        <%= Html.Hidden("hdnAccountNumberId","") %>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">

    <script type="text/javascript">
        var AccountSubmissionDetailsID;

        var TCNIdentificationId;
        var TCNNumber;
      
        function statusAccount(accountNumberId, tcnNumbers, SenderProviderId, tcnId, accountNumber) {
            //Html.RenderAction("AccountNotesPopup", new {accountNumberId, tcnNumbers, SenderProviderId, controlFlag});
            AccountNotesPopup.PerformCallback({ AccountSubmissionDetailsID: accountNumberId, TCNIdentificationID: tcnId, TCNNo: tcnNumbers, SenderProviderID: SenderProviderId, AccountNo: accountNumber, controlFlag: true });
            AccountNotesPopup.Show();
            TCNIdentificationId = tcnId;
            AccountSubmissionDetailsID = accountNumberId;
            TCNNumber = tcnNumbers;
            $("#hdnTcnId").val(tcnId);
            $("#hdnAccountNumberId").val(accountNumberId);
            //BindRLGrid(AccountSubmissionDetailsID, true);
            
        }

        //Call below function on AccountNotesPopup Endcallback becuase there
        //was issue on production for PerformCallback to sync 
        function AccountNotesPopup_EndCallback(s, e) {
            BindRLGrid(AccountSubmissionDetailsID, true);
        }
        function StatusCancelBtnClick(s, e) {
            if (!($("#InternalNoteGrid").length == 0)) {
                InternalNoteGrid.PerformCallback();
            }
            if ($("#ExternalNoteGrid").length != 0)
                ExternalNoteGrid.PerformCallback();

            AccountNotesPopup.Hide();
            jQuery.get('../AccountDetails/CleareSessionForRLUpload');
        }

        function AddExternalNotePopup(s, e) {
            if (document.getElementById('popupExternalNoteMemo') != null) {
                if (popupExternalNoteMemo.GetText() == '') {
                    alert("Please add External note and then click Add.");
                    return false;
                }
            }
            else {
                return false;
            }
            var routData = {
                Note: popupExternalNoteMemo.GetText(),
                TCNIdentificationID: TCNIdentificationId
            };

            $.ajax({
                url: "<%:(Url.Action("AddExternalNote","AccountDetails"))%>",
                type: 'POST',
                datatype: 'json',
                data: routData,
                cache: false,
                success: function (data) {
                    if (data == "Success" && !$('#ExternalNoteGridPopup').length == 0)
                        ExternalNoteGridPopup.PerformCallback();
                    popupExternalNoteMemo.SetText("");
                },
                error: function (data) {
                    alert('Something might went wrong!');
                },
                autoLoad: true
            });
        }

        function StatusSaveSubmitBtnClick(s, e, btnValue) {

            //saveBtn  //submitBtn
            // alert(btnValue);
            var flag = false;
            var Button = "Save";
            if (btnValue == 'submitBtn') {
                flag = true;
                Button = "Submit";
            }

            //stop time tracker
            //StopTaskTimer();
            var status = StatusComboBox.GetValue();
            if (flag == true && status == 6) {
                alert("Do Not Notify Provider does not allow submit operation.Please click save");
                return false;
            }
            if (status != null) {
                //get confimration
                if (flag && !confirm('Do you want to submit this record to Provider?')) {
                    return false;
                }
                var routData = {
                    //SubmitTcnStatus
                    accountSubmissionId: AccountSubmissionDetailsID,
                    statusId: status,
                    TCNIdentificationID: TCNIdentificationId,
                    flag: flag,
                    TCNNumber: TCNNumber
                };

                $.ajax({
                    url: "<%:(Url.Action("SubmitTcnStatus","AccountDetails"))%>",
                    type: 'POST',
                    datatype: 'json',
                    data: routData,
                    cache: false,
                    success: function (data) {
                        PatientAcountDetails.PerformCallback();
                        //window.location = $("#worklistPath").val();
                        AccountNotesPopup.Hide();
                    },
                    error: function (data) {
                        alert('Something might went wrong!');
                    },
                    autoLoad: true
                });
            }
            else
                alert('Please Select the Status before ' + Button);
        }

        function CheckLockStatus(TCNIdentification) {
            generalizedShowLoader();

            var isTCNLockedOut = false;
            $.ajax({
                type: "GET",
                url: "<%:(Url.Action("IsTCNLockedOut","WorkList"))%>",
                data: { TCNIdentification: TCNIdentification },
                cache: false,
                async: false,
                success: function (result) {
                    if (result != "False") {
                        CustomLoadingPanelHide();
                        alert("This TCN is under review by " + result);
                    }
                    isTCNLockedOut = (result != "False" ? false : true);
                },
                error: function (request, status, error) {
                    console.error("Error occured while accessing the document.")
                    alert("Error occured while accessing the document.");
                }

            });
            return isTCNLockedOut;

        }

    </script>
    <script src="<%: Url.Content("~/Scripts/TimeTracker.js") %>" type="text/javascript"></script>
    <script type="text/javascript" src="<%: Url.Content("~/Scripts/NotesCommon.js") %>"> </script>
</asp:Content>
