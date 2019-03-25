<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<RISARC.ACO.Model.Dates>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Upload Patient Data
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Upload Patient Data</h2>
    <input type="hidden" name="redirectToWorkBucket" id="redirectToWorkBucket" />
    <% using (Html.BeginForm("ValidateUploadedFiles", "PQRSReport", FormMethod.Post))
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
                <td class=" blockTblTd"><b>From Date</b>
                    <%= Html.DevExpress().DateEditFor(model => model.FromDate, RISARC.Web.EBubble.Models.DevxControlSettings.DateEditSetting.DateEditSettingsMethodAdditional(settings =>
                        {
                            settings.Name = "FromDate";
                            settings.Width = System.Web.UI.WebControls.Unit.Percentage(95);
                            settings.Properties.MaxDate = DateTime.UtcNow;
                            settings.Properties.ValidationSettings.ErrorText="Please select valid date.";
                            settings.ShowModelErrors = true;
                            
                        })).Bind(Model.FromDate).GetHtml()%>
                </td>
                <td class=" blockTblTd"><b>To Date</b>
                    <%= Html.DevExpress().DateEditFor(model => model.ToDate, RISARC.Web.EBubble.Models.DevxControlSettings.DateEditSetting.DateEditSettingsMethodAdditional(settings =>
                        {
                            settings.Name = "ToDate";
                            settings.Width = System.Web.UI.WebControls.Unit.Percentage(95);
                            settings.Properties.MaxDate = DateTime.UtcNow;
                            settings.Properties.ValidationSettings.ErrorText="Please select valid date.";
                            settings.ShowModelErrors = true;
                            
                        })).Bind(Model.ToDate).GetHtml()%>
                </td>
                <td>&nbsp;</td>
            </tr>

            <tr>
                <%--<td class="width50Precent blockTblTd"><b>Select File Type</b>
                      <% Html.RenderPartial("_UploadFileTypeChombo"); %>
                </td>--%>
                 
                <td class=" blockTblTd" colspan="2"  ><b>Select Files</b>
                       <% Html.RenderPartial("_PQRSUploadControl"); %>
                </td>
                <td>&nbsp;</td>
            </tr>


        </table>
    </div>

    <% if (ViewData["Success"] != null)
       { %>
    <div class="statusMessage">
          <% Response.Write(ViewData["Success"]);  %>
    </div>
 <% } %>
    <%= Html.ValidationMessage("upload")%>

    <h2>Upload Summary Report</h2>
    <%= Html.Action("PatientsUploadedDocument", "File") %>

    <br />

    <div class="viewerActionBtnADetails">
        <div class="floatLeft">
            <% Html.DevExpress().Button(
                                   RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                           settings =>
                           {
                               settings.Name = "ConfirmBtn";
                               settings.UseSubmitBehavior = true;
                               settings.Text = "Confirm";
                               //settings.ClientSideEvents.Click = "disableDoubleClick";
                           })).GetHtml(); %>
        </div>

        <%--<div class="floatRight">
            <% Html.DevExpress().Button(
                                   RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                                   settings =>
                                   {
                                       settings.Name = "DiscardBtn";
                                       settings.ControlStyle.CssClass = "greyBtn";
                                       settings.UseSubmitBehavior = false;
                                     //  settings.RouteValues = new { Controller = "CreateDocument", Action = "Send" };
                                       settings.Text = "Discard";

                                   })).GetHtml(); %>
        </div>--%>

    </div>

    <% } %>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
    <script type="text/javascript">
        function UpdateDocType(s, e, visibleIndex) {
            if (visibleIndex != null && s.GetValue() != null) {
                var routData = {
                    FileID: fileUploadGrid.GetRowKey(visibleIndex),
                    DocumentTypeId: s.GetValue(),
                    IsTcnFileType: false,
                    DocumentTypeName: ''
                };

                $.ajax({
                    type: "GET",
                    url: "<%:(Url.Action("UpdateDocumentType","File"))%>",
                    cache: false,
                    data: routData,
                    success: function (result) {
                        if (result == "Success")
                            return true;
                    },
                    error: function (request, status, error) {
                        alert("Something might went wrong.");
                    }
                });
            }
        }

        function removeUploadedFile(id) {
            var totalFilesCount = $("#fileContainer div").length;
            var currentFileCount;
            //ajax request to RemoveFile action method and if the response is true then hide file from the screen.
            $.ajax({
                type: "GET",
                url: "<%:(Url.Action("RemoveUploadedFile","PQRSReport"))%>",
                data: { documentFileId: id },
                success: function (result) {
                    $("#removeError").hide();
                    if (result == "True") {
                        $("a[encid='" + id + "']").parent().next("br").remove();
                        $("a[encid='" + id + "']").parent().remove()
                        currentFileCount = $("#fileContainer div").length;
                        if (!(document.getElementById('fileUploadGrid') == null))
                            currentFileCount = (fileUploadGrid.pageRowCount - 1);
                        //hide file container if all files are removed.
                        if (currentFileCount === 0) {
                            $("#uploadedFiles").hide();
                            $("#IsFileUploaded").val("false");
                        }

                    }
                    else {
                        $("#removeError").show();
                    }
                    if (!(document.getElementById('fileUploadGrid') == null))
                        fileUploadGrid.PerformCallback();
                },
                error: function (request, status, error) {
                    $("#removeError").show();
                }
            });
        }
    </script>
</asp:Content>


