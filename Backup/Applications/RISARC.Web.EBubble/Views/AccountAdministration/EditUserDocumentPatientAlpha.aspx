<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<RISARC.Setup.Model.UserAlphaSettings>" %>



<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Edit User <%= Html.Encode(Model.UserName) %>'s Document Types
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Edit User <%= Html.Encode(Model.UserName) %>'s Document Types</h2>
    <div class="totalAccount">
        These document types will determine what document type user has access and can respond to.
    </div>
    <div class="error"></div>
    <%using (Html.BeginForm("EditUserDocumentPatientAlpha", "AccountAdministration", FormMethod.Post, new { id = "AlphaSettingForm" }))
      { 
    %>
    <%= Html.AntiForgeryToken() %>
    <%= System.Web.Mvc.Html.InputExtensions.HiddenFor(Html,model => model.UserName) %>
    <%= System.Web.Mvc.Html.InputExtensions.HiddenFor(Html,model => model.ReturnUrl) %>
    <%= System.Web.Mvc.Html.InputExtensions.HiddenFor(Html,model => model.UserIndex) %>
    <%= System.Web.Mvc.Html.InputExtensions.HiddenFor(Html,model => model.ShowValidationForAlpha) %>
    <b class="adjPosition">Only receive requests for patients with their last name.</b>



    <div class="alphaSettings">
        <%= System.Web.Mvc.Html.ValidationExtensions.ValidationMessageFor(Html,model => model.patientFirstAlpha,"Patient first alpha is required.") %>
        <%= System.Web.Mvc.Html.ValidationExtensions.ValidationMessageFor(Html,model => model.patientLastAlpha,"Patient last alpha is required.") %>
        <div class="floatLeft">
            <label for="PatientsFirstAlpha">Beginning with</label>
            <%  Html.RenderAction("AlphaSettingsDropDown", Model); %>
        </div>
        <div class="floatRight">

            <label for="PatientsLastAlpha">Ending with</label>
            <%  Html.RenderAction("AlphaSettingsLastDropDown", Model); %>
        </div>
    </div>




    <ul id="alphaActionBtn">
        <li>
            <% Html.DevExpress().Button(
                                   RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                           settings =>
                           {
                               settings.Name = "UpdateBtn";
                               settings.Text = "Update";
                               settings.UseSubmitBehavior = false;
                               settings.Width = 80;
                               settings.Height = 36;
                               settings.ClientSideEvents.Click = "UpdateClick";
                           })).GetHtml(); %>

        </li>
        <li>
            <% Html.DevExpress().Button(
                                   RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                           settings =>
                           {
                               settings.Name = "ClearAlphaSettings";
                               settings.Text = "Reset";
                               settings.UseSubmitBehavior = false;
                               //settings.ControlStyle.CssClass = "orangeBtn";
                               settings.RouteValues = new { Controller = "AccountAdministration", Action = "ClearAlphaSettings", UserName = Model.UserName, UserIndex = Model.UserIndex, ReturnUrl = Model.ReturnUrl, patientFirstAlpha = Model.patientFirstAlpha, patientLastAlpha = Model.patientLastAlpha, ShowValidationForAlpha = false };
                               settings.Width = 80;
                               settings.Height = 36;

                           })).GetHtml(); %>

        </li>
        <li>
            <% Html.DevExpress().Button(
                                   RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                           settings =>
                           {
                               settings.Name = "CancelBtn";
                               settings.Text = "Cancel";
                               settings.UseSubmitBehavior = false;
                               settings.ControlStyle.CssClass = "greyBtn";
                               settings.Width = 80;
                               settings.Height = 36;
                               settings.ClientSideEvents.Click = "GoBackPreviousButton";
                           })).GetHtml(); %>
        </li>
    </ul>


    <%  } %>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
    <script type="text/javascript">


        var selectedVar;
        var FirstDropDownSelection;
        var LastDropdpwnSelection;
        var PerformCallback = false;

        function FirstSettingClick(s, e) {
            var grid = patientFirstAlpha.GetGridView();

            FirstDropDownSelection = ($(grid.GetRow(e.visibleIndex)).text().replace(/\s/g, "").split(":")[0].charAt(0));

            if ($(grid.GetRow(e.visibleIndex)).text().indexOf("False") > -1) {
                PerformCallback = true;
            }
            else {
                e.cancel = true;
            }
        }




        function patientFirstAlphaEndCallback(s, e) {
            if (PerformCallback) {
                FirstDropDownSelection: FirstDropDownSelection;
                patientLastAlpha.SetValue(null);
            }
            PerformCallback = false;
        }

        function OnlastAlphaBeginCallback(s, e) {
            e.customArgs["FirstDropDownSelection"] = FirstDropDownSelection;
        }

        function GoBackPreviousButton() {
            window.location = '<%=Model.ReturnUrl%>';
        }

        function UpdateClick() {

            exsistingFirstSet = $("#patientFirstAlpha_I").val();
            exsistingLastSet = $("#patientLastAlpha_I").val();
            var flagError = false;

            if (exsistingFirstSet != "Select" && exsistingLastSet != "Select") {
                var first = exsistingFirstSet.charCodeAt(0);
                var last = exsistingLastSet.charCodeAt(0);

                if (first > last) {
                    $(".error").html("* Ending with alpha cannot be less that Beginning  with");

                } else {
                    flagError = true;
                }

            } else {
                $(".error").html("* Please select alpha values");

            }

            if (flagError) {
                $(".error").html(" ");
                $("#AlphaSettingForm").submit();
            }
        }
    </script>

</asp:Content>
