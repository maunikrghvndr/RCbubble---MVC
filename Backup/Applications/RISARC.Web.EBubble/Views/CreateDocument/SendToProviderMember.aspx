<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.Master" Inherits="System.Web.Mvc.ViewPage<RISARC.Documents.Model.DocumentSend>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Send Document To Provider Member
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Send Document To Provider Member</h2>
    <p class="Instructions">
        To send a document select a member and  fill out the necessary information 
      below and submit.
    </p>
    <%= Html.ValidationInstructionHeader() %>

    <%= Html.ValidationMessage("DocumentFileRequired", "File Required to Upload Before Sending")%>
    <span id="fileUploaderHoler"></span>

    <%using (Html.BeginForm("SendToProviderMember", "CreateDocument"))
      {%>
    <%= Html.AntiForgeryToken() %>


    <div class="lightGery setBottomSpace"><span class="darkGrey">Step 1 - </span>Information about Recipient </div>

    <div class="worklist_search">
        <div class="doc_recipient-adj">


            <table class="first_block">
                <tr>
                    <td>
                        <ul>
                            <li>
                                <label for="recipientProviderId">
                                    Provider which Member Belongs to <span class="ValidationInstructor">*</span></label>
                                <% Html.RenderAction<RISARC.Web.EBubble.Controllers.CreateDocumentController>(drc =>
                       drc.ProvidersInNetworkDropDown("recipientProviderId", "-Select-", (short?)ViewData["RecipientProviderId"], true, false)); %>
                                <%= Html.ValidationMessage("RecipientProviderRequired", "Required")%>
                            </li>
                        </ul>

                    </td>
                   
                    <td>
                        <ul class="floatRight">
                            <li>
                                <label for="DocumentType">
                                    Type of Document <span class="ValidationInstructor">*</span></label>

                                <div class="DocumentTypeHolder">
                                    <% Html.RenderAction<RISARC.Web.EBubble.Controllers.CreateDocumentController>(
                                           //x => x.UserDocumentTypesDropDown("DocumentTypeId", "-Select-", (string)ViewData["RecipientEmailAddress"], Model.DocumentTypeId)
                x => x.ProviderDocumentTypesDropDown("DocumentTypeId", "-Select-", (short?)ViewData["RecipientProviderId"], Model.DocumentTypeId)
               ); %>
                                    <%= Html.ValidationMessage("DocumentTypeRequired", "Required")%>
                                </div>
                                <div class="FieldInstructions">The types available are based on the types that the provider member accepts</div>

                            </li>
                        </ul>
                    </td>
                </tr>
                <tr><td colspan="2">&nbsp;</td></tr>
            </table>


            <table class="floatLeft">
                <tr>
                    <td>
                        <table border="0" cellpadding="10">
                            <tr>
                                <td nowrap="nowrap">
                                    <label for="recipientEmailAddress">
                                        Provider Member to Send To <span class="ValidationInstructor">*</span>
                                    </label>

                                </td>
                                <td width="5px"></td>
                                <td>
                                    <b>Recipient(s): <font color="red">*</font></b>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top">
                                    <div class="RecipientEmailHolder">
                                        <% Html.RenderAction<RISARC.Web.EBubble.Controllers.CreateDocumentController>(drc =>
                   drc.ProvidersMembersByDocTypeListBox("recipientEmailAddress", "-Select-", (short?)ViewData["RecipientProviderId"], (short?)ViewData["DocumentTypeId"])
                   );//ProvidersMembersListBox %>
                                        <%= Html.ValidationMessage("RecipientEmailRequired", "Required")%>
                                    </div>
                                </td>
                                <td class="clsWidth10"></td>
                                <td valign="top" nowrap="nowrap">
                                    <div style="white-space: normal;">
                                        <span id="MyRecipientList"></span>
                                        <ul id="SelectedItemsListUL"></ul>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>


        </div>
    </div>





    <div class="lightGery setBottomSpace"><span class="darkGrey">Step 2 - </span>Upload Document(s)</div>
    <div class="worklist_search">
        <%--<div class="TableInnerContainer">--%>
        <table class="DocToOrgTable">
            <tr>
                <td style="width: 45%; vertical-align: top;">
                    <span class="BoldUnderline">Files From Client Folder</span>
                    <span class="redText">(Acrobat files and TIFF files are recommended. 'Zip' or Compressed files are not accepted)</span>
                    <div class="FixiedHT20"></div>
                    <% Html.RenderPartial("_FileUploadPartial"); %>
                </td>

                <td style="width: 10%">&nbsp;</td>

                <td style="width: 45%; vertical-align: top;">
                    <span class="BoldUnderline">Upload Files From SFTP Folder</span>
                    <span class="redText">(Click the below button to select files from SFTP folder, large size files are allowed from this link)</span>
                    <div class="FixiedHT20"></div>

                    <% Html.RenderPartial("_ServerFileUploadPartial"); %>
           
                </td>
            </tr>
            <tr>
                <td colspan="3">&nbsp;
                </td>
            </tr>
            <tr>
                <td colspan="3" style="vertical-align: top;">
                    <%= Html.Action("UploadedDocument", "File") %>
                </td>
            </tr>
        </table>
        <%--</div>--%>
    </div>


    <script type="text/javascript">
        $(this).submit(function () {
            var count = 0;
            for (var i = 0; i < document.getElementById("recipientEmailAddress").options.length; i++) {
                if (document.getElementById("recipientEmailAddress").options[i].selected) {
                    count++;
                }
            }

            if (count == 0) {
                alert('Please Select Provider Member(s) To Send Document(s) To.');
                return false;
            }

            var isFileUploaded = $("#IsFileUploaded").val();
            if (isFileUploaded == 'false') {
                alert("Alert: File Missing, please select file(s) and upload before submitting.");
                return false;
            }
            else if (count == 0) // && (document.getElementById("recipientEmailAddress").checked == true) ) 
            {
                alert('Please Select Provider Member(s) To Send Document(s) To.');
                return false;
            }

        });

        $(this).load(function () {
            if ($(".field-validation-error").length > 0 || $(".validation-summary-errors").length > 0) {
                //make ajax call to get uploaded file html string.
                $.ajax({
                    type: "GET",
                    url: "<%:(Url.Action("GetUploadedFilesCallbackString","File"))%>",
                    cache: false,
                    success: function (result) {
                        var fileContainerHtmlString = "";
                        fileContainerHtmlString = result;
                        if (fileContainerHtmlString != "") {
                            $("#fileContainer").html(fileContainerHtmlString).parent().show();
                            $("#IsFileUploaded").val("true");
                        }
                    },
                    error: function (request, status, error) {
                        $("#removeError").show();
                    }
                });
            }
        });
    </script>

    <%-- <h3>Information about Document <span>Step 5</span></h3>--%>
    <% Html.RenderPartial("DocumentSendToProvider", Model); %>

    <div class="clear">
        <br />
    </div>
    <div class="viewerActionBtn">
        <div class="floatLeft">
            <% Html.DevExpress().Button(
                                   RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                           settings =>
                           {
                               settings.Name = "SendtoOrgSendButton";
                               settings.UseSubmitBehavior = true;
                               settings.Text = "Send";
                               settings.ClientSideEvents.Click = "disableDoubleClick";
                           })).GetHtml(); %>
        </div>

        <div class="floatRight">
            <% Html.DevExpress().Button(
                                   RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                                   settings =>
                                   {
                                       settings.Name = "SendtoOrgCancleButton1";
                                       settings.ControlStyle.CssClass = "greyBtn";
                                       settings.UseSubmitBehavior = false;
                                       settings.RouteValues = new { Controller = "CreateDocument", Action = "Send" };
                                       settings.Text = "Cancel";

                                   })).GetHtml(); %>
        </div>

    </div>


    <div class="clear">
        <br />
    </div>



    <% } %>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
    <%--script is unique to this page--%>
  <%--  <script type="text/javascript" src="<%: Url.Content("~/Scripts/jquery.js")%>"></script>--%>
   <%--  <script type="text/javascript" src="<%: Url.Content("~/Scripts/FileUploader.js")%>"></script>--%>
     <script type="text/javascript" src="<%: Url.Content("~/Scripts/FileUploader.min.js")%>"></script>
    <script type="text/javascript" src="<%: Url.Content("~/Scripts/DocumentReviewer.js")%>"></script>
    <script type="text/javascript" src="<%: Url.Content("~/Scripts/SendToProviderMember.js")%>"></script>

   <%-- <script type="text/javascript" src="<%: Url.Content("~/Scripts/ProviderToProviderSettings.js")%>"></script>--%>

 

<%--    <script type="text/javascript" src="<%: Url.Content("~/Scripts/OptionExpander.js")%>"></script>--%>



     <script type="text/javascript">
           //activate another loader
         $(document).ready(function () {
             generalizedShowLoader();
        });

         jQuery(window).load(function () {
             CustomLoadingPanelHide();
         });
    </script>

    <script type="text/javascript">

         $(document).ready(function () {

            $('input:radio[name=DocumentRelatesToPatient]').change(function () {
                // alert("patient info" +  $(this).val());
                if ($(this).val() == 'True') {
                    $('.PatientInformationHolder').slideDown('slow'); //.hide();
                }
                else {
                    $('.PatientInformationHolder').slideUp('slow'); //.show();

                }
                // Added by Dnyaneshwar
                // As value of ManualACNNumber is resetting to blank in Telerik Date Picker-Control's Java script (which is generated at runtime); workaround done here by resetting present value in model.
                if (document.getElementById('ManualACNNumber') != null && document.getElementById('ManualACNNumber').value == '')
                    document.getElementById('ManualACNNumber').value = '<%: Model.ManualACNNumber %>';
                // End Added
            });

            // Commented by Dnyaneshwar (of No Use)
            //$("DocumentFileId").change(alert("changedit"));

            // Added By Dnyaneshwar
            if ((document.getElementById('_FileManagePartial') == null)) {
                btnAttach.SetVisible(false);
                btnAttachFolder.SetVisible(false);
            }
            if (!(document.getElementById('fileContainer') == null)) {
                document.getElementById('fileContainer').style.display = 'none';
            }
            // End Added
        });

        // performed after file is uploaded, will copy uploaded file id to documents file id hidden field
        function additionalPostUpload() {
            parseResponeInForm();
        }

        function parseResponeInForm() {
            // find file id.
            var fileId = $('#UploadedFileId').val();
            if (fileId != null && fileId != '') {
                var targetElement = $('#DocumentFileId');
                targetElement.val(fileId);
            }

            // If not null or empty populate hidden field on page with file id
        }

        var wordCount = 0;
        function CharCount() {
            var text1 = trim(document.getElementById('Comments').value);
            text1 = oldtrim(document.getElementById('Comments').value);
            if (text1.length > 0) {
                document.getElementById('CharCountDisplay').innerHTML = "Char Count: " + (text1.length + 1);
            }
            else {
                document.getElementById('CharCountDisplay').innerHTML = "";
            }
        }

        function trim(stringToTrim) {
            //return stringToTrim.replace(/^\s+|\s+$/g, "");
            return stringToTrim.replace(/^s*|s(?=s)|s*$/g, "");
        }
        function ltrim(stringToTrim) {
            return stringToTrim.replace(/^\s+/, "");
        }
        function rtrim(stringToTrim) {
            return stringToTrim.replace(/\s+$/, "");
        }
        // works for old browsers
        function oldltrim(str) {
            for (var k = 0; k < str.length && isWhitespace(str.charAt(k)) ; k++);
            return str.substring(k, str.length);
        }
        function oldrtrim(str) {
            for (var j = str.length - 1; j >= 0 && isWhitespace(str.charAt(j)) ; j--);
            return str.substring(0, j + 1);
        }
        function oldtrim(str) {
            return ltrim(rtrim(str));
        }
        function oldisWhitespace(charToCheck) {
            var whitespaceChars = " \t\n\r\f";
            return (whitespaceChars.indexOf(charToCheck) != -1);
        }
        // for old browsers

        function ProcessOnChange(DrpDwnID) {
            // do nothing
        }

    </script>

    <script type="text/javascript">
        $("form").submit(function () {

            var fileId = $('#UploadedFileId').val();

            if (fileId == null || fileId == '') {
                alert("Alert: File Missing, please select file(s) and upload before submitting.");
                return false;
            } else if ((CheckChecker() == false) && (ListHasSelections() == false)) {
                alert('Please Select Provider Member(s) To Send Document(s) To.');
                return false;
            }
        });


        function ListHasSelections() {
            var count = $("#recipientEmailAddress :selected").length;
            if (count > 0)
                return true;
            else
                return false;
        }


    </script>

     

</asp:Content>
