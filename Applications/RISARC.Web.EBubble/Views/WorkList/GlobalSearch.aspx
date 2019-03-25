<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<RISARC.eTAR.Model.SearchFieldWorklist>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Global Search
</asp:Content>



<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Global Search</h2>
    <div class="totalAccount">Total <%= Model.SearchedWorklistData.Count() %> Accounts are available in our bucket</div>
    <div class="worklistTopSearch">
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
        <ul class="color_balls">
            <li class="RedBall">Deadline/Past- <%=  Model.DeadLineRecordCount %>  </li>
            <li class="YellowBall">2 Days to Deadline-<%=  Model.TwoDaysToDeadLineRecordCount %>  </li>
            <li class="GreenBall">3 Days to Deadline- <%=  Model.ThreeDaysToDeadLineRecordCount %>  </li>
            <li class="BlueBall">More than 3 Days- <%=  Model.MoreThanThreeDaysToDeadLineRecordCount %>  </li>
        </ul>

    </div>

    <%--<span class="font16">Total <% if (!(Model == null || Model.SearchedWorklistData == null)) Model.SearchedWorklistData.Count().ToString(); %> Accounts are available in our bucket</span>--%>


    <% using (Html.BeginForm("GlobalSearch", "WorkList", FormMethod.Post))
       { %>
    <%-- <div class="font14 Width280">
        <div class="ArrowDownBlack"></div>
        <div class="FloatRight">Search by any of the following fields</div>
    </div>--%>
    <div class="worklist_search">

        <table class="SearchTable TableLayoutFixed7">
            <tr>
                <td class="width50Precent blockTblTd">
                    <% Html.DevExpress().LabelFor(model => model.AccountNo,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                    <% Html.DevExpress().TextBoxFor(model => model.AccountNo, RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                        settings =>
                        {
                            settings.Width = Unit.Percentage(95);
                            // settings.Properties.NullText = "Account #";
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
                    //  settings.Properties.NullText = "TCN #";
                    settings.Height = 35;
                })
            ).GetHtml(); %>

                </td>
                <td>&nbsp;</td>
            </tr>
           <%-- <tr>
                <td class="FixiedHT20"></td>
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
                  //settings.Properties.NullText = "Patient Name";
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
            <%--<tr>
                 <td class="blockTblTd"></td>
            </tr>--%>
            <tr>
                <td>

                    <% 
           Html.DevExpress().Button(
                         settings =>
                         {
                             settings.Name = "btnSearch";
                             settings.Width = System.Web.UI.WebControls.Unit.Pixel(100);
                             settings.Height = 32;
                             //Depricated in newer version 13.2.8
                             //settings.Styles.EnableDefaultAppearance = false;
                             settings.EnableTheming = false;
                             settings.ControlStyle.CssClass = "orangeBtn";
                             settings.ControlStyle.HorizontalAlign = System.Web.UI.WebControls.HorizontalAlign.Center;
                             settings.Text = "Search";
                             settings.UseSubmitBehavior = true;
                         }).GetHtml();
                    %>

                </td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>


            </tr>
        </table>
    </div>

    <% } %>

    <div class="search_result">
        <%= Html.Action("GlobalSearchGridCallback") %>
    </div>
</asp:Content>


<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>


