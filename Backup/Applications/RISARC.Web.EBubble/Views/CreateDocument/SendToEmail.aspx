<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.Master" Inherits="System.Web.Mvc.ViewPage<RISARC.Documents.Model.DocumentSend>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Send Document To Non-Organization Member
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
        <%= Html.Partial("ReleaseFile") %>
    <form id="form1" runat="server">
        <h2>Send Document To Non-Organization Member</h2>
        <p class="Instructions">
            To send a document to an Organization or Individual that is not a member in your, RMSe-bubble network, fill out the necessary information below and submit.
        </p>
        <%= Html.ValidationInstructionHeader() %>
        <ul id="toggleReleaseFormsRequiredDDL">
            <li>
                <label>
                    Does your Organization verify a Release Form for the Individual(s)? <span class="ValidationInstructor">*Can only be set to <i>No</i> if BAA Agreement exists with selected provider</span></label>
                <select class="input_radio" id="ReleaseFormsRequiredDDL">
                    <option selected="selected" value="">Please select...</option>
                    <option value="Yes">Yes</option>
                    <option value="No">No</option>
                </select>
            </li>
        </ul>

        <ul id="toggleIsReleaseOnFileDDL">
            <li>
                <label>
                    Do you have the release form?</label>
                <select class="input_radio" id="IsReleaseOnFileDDL">
                    <option selected="selected" value="">Please select...</option>
                    <option value="Yes">Yes</option>
                    <option value="No">No</option>
                </select>
            </li>
        </ul>
        <%--<div id="modalIsReleaseOnFileMsgBox" class="modalDivBoxBg"></div>--%>
        <div id="modalIsReleaseOnFileMsgBox" class="modalDivBox">
            <h3>Release File Required
            </h3>
            You have selected "No", a release form is required to have on file before releasing information.
           Please verify a copy on file thru your organization to proceed.
            <div class="modalDivBoxFooter">
                <br />
                <input id="modalIsReleaseOnFileMsgBoxContinue" type="button" value="Go Back to Upload Release File." />
                <input id="modalIsReleaseOnFileMsgBoxClose" type="button" value="Close" />
            </div>
        </div>
        <div id="status">
        </div>
    </form>

    <script type="text/javascript">
        $(this).submit(function () {
            var isFileUploaded = $("#IsFileUploaded").val();
            if (isFileUploaded == 'false') {
                alert("Alert: File Missing, please select file(s) and upload before submitting.");
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
                $("#toggleReleaseFormsRequiredDDL").show();
                $("#toggleIsReleaseOnFileDDL").show();
                $("#ReleaseFormsRequiredDDL").val("Yes");
                $("#IsReleaseOnFileDDL").val("Yes");
                $("#toggleForm").show();
            }
            // Added by Dnyaneshwar
            //$('#recipientEmailAddress, #recipientEmailAddressRetype').attr('autocomplete', 'off');
            var isCountZero;
            $('#recipientEmailAddress, #recipientEmailAddressRetype').bind('copy paste cut drag drop', function (e) {
                e.preventDefault()
            }).attr('autocomplete', 'off');

            $('#recipientEmailAddress').focus();
            $('#ReleaseFormsRequiredDDL').focus();
            //$('#recipientEmailAddress').focus();
            $('#recipientEmailAddress').bind('focus', function () {
                if (this.value.length > 0) {
                    this.type = "password";
                    isCountZero = false;
                }
                else {
                    isCountZero = true;
                    this.type = "text";
                }

            });

            $('#recipientEmailAddress').keypress(function () {
                if (this.selectionStart == 0 && this.selectionEnd == this.value.length)
                    isCountZero = true;
            });

            $('#recipientEmailAddress').keyup(function () {
                if (isCountZero == false && this.value.length > 0)
                    this.type = "password";
                else {
                    isCountZero = true;
                    this.type = "text";
                }
            });

            $('#recipientEmailAddress').bind('blur', function () {
                this.type = "password";
            });
            // End Added
        });


    </script>

    <%using (Html.BeginForm("SendToEmail", "CreateDocument"))
      {%>
    <%= Html.AntiForgeryToken() %>

    <div id="toggleForm" style="display: none;">
        <h3>Upload Document(s)<font color="#FF0000">*</font><span>Step 1</span></h3>
        <div class="FieldInstructions">
        </div>
        <%= Html.ValidationMessage("DocumentFileRequired", "File Required to Upload Before Sending")%>
        <span id="fileUploaderHoler"></span>
        <div class="TableInnerContainer">
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
                        <%-- <span class="BoldUnderline">Upload Files From SFTP Folder</span>
                        <span class="redText">(Click the below button to select files from SFTP folder, large size files are allowed from this link)</span>
                        <div class="FixiedHT20"></div>

                    <% Html.RenderPartial("_ServerFileUploadPartial"); %>--%>
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
        </div>


        <%= Html.Hidden("IsReleaseOnFileHf", Model.IsReleaseOnFile)%>
        <h3>Information about Recipient <span>Step 2</span></h3>
        <ul>
            <li>
                <label for="EmailToSendDocumentTo">
                    Email Address of Recipient to Send the Document To <span class="ValidationInstructor">*</span></label>
                <%= Html.StyledTextBox("recipientEmailAddress", ViewData["RecipientEmailAddress"])%>
                <%= Html.ValidationMessage("RecipientEmailRequired", "Required") %>
                <%= Html.ValidationMessage("RecipientEmailInvalid", "Invalid Email Address")%>
                <%= Html.ValidationMessage("NonMemberEmailInvalid", "The Email provided is not a registered User")%>

                <div class="FieldInstructions">
                    An email will be sent to this address with a link to the document.
                </div>
            </li>
            <%--Added by Dnyaneshwar--%>
            <li>
                <label for="EmailToSendDocumentTo">
                    Retype Email Address of Recipient <span class="ValidationInstructor">*</span></label>
                <%= Html.StyledTextBox("recipientEmailAddressRetype")%>
                <%= Html.ValidationMessage("RetyprEmailNotMatch")%>
                <%= Html.ValidationMessage("RetyprEmailRequired")%>
            </li>
            <li>
                <label for="EmailToSendDocumentTo">
                    Phone Number of Recipient </label>
                <%= Html.StyledTextBox("recipientPhoneNumber", ViewData["RecipientPhoneNumber"])%>

                <%= Html.ValidationMessage("RecipientPhoneNumberRequired") %>
                <%= Html.ValidationMessage("RecipientPhoneNumberInvalid") %>
                <div class="FieldInstructions">
                    Verification Code text message will be sent to this Phone number.
                </div>
            </li>
            <%--End Added--%>
        </ul>
        <h3>Information about Document <span>Step 3</span></h3>
        <ul>
            <li>
                <label for="DocumentType">
                    Type of Document <span class="ValidationInstructor">*</span></label>
                <% Html.RenderAction<RISARC.Web.EBubble.Controllers.DocumentController>(
               x => x.DocumentTypesDropDown("DocumentTypeId", "-Select", Model.DocumentTypeId)
               ); %>
                <%= Html.ValidationMessage("DocumentTypeRequired", "Required")%>
            </li>
        </ul>
        <%
                   Html.RenderPartial("DocumentSendToNonMember", Model);
          } %>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
<%--    <script type="text/javascript" src="<%: Url.Content("~/Scripts/FileUploader.js")%>"></script>--%>
     <script type="text/javascript" src="<%: Url.Content("~/Scripts/FileUploader.min.js")%>"></script>
    <script src="<%: Url.Content("~/Scripts/Views/CreateDocument/SendToEmail.js")%>" type="text/javascript"></script>
    <script type="text/javascript">

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
    </script>
    <%--added by dnyaneshwar to hide Enter Payer Identifier  manualACNHolderLINK --%>
    <script type="text/javascript" src="<%: Url.Content("~/Scripts/jquery-1.7.1.min.js")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            if (document.getElementById('manualACNHolderLINK') != null) {
                document.getElementById('manualACNHolderLINK').style.display = 'none';
            }
            // Added by Dnyaneshwar
            // As value of ManualACNNumber is resetting to blank in Telerik Date Picker-Control's Java script (which is generated at runtime); workaround done here by resetting present value in model.
            if (document.getElementById('ManualACNNumber') != null && document.getElementById('ManualACNNumber').value == '')
                document.getElementById('ManualACNNumber').value = '<%: Model.ManualACNNumber %>';
            // End Added

            // Added By Dnyaneshwar
            if (!(document.getElementById('fileContainer') == null)) {
                document.getElementById('fileContainer').style.display = 'none';
            }
            // End Added
        });
    </script>
    <%--End Added--%>
    <script type="text/javascript">

        var wordCount = 0;
        function CharCount() {
            var text1 = trim(document.getElementById('Comments').value);
            var text1 = oldtrim(document.getElementById('Comments').value);
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

</asp:Content>
