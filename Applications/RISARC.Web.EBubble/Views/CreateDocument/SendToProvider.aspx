<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.Master" Inherits="System.Web.Mvc.ViewPage<RISARC.Documents.Model.DocumentSend>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Send Document To Provider
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2 class="floatLeft">Send Document To An Organization</h2>
    <span class="floatRight"><%= Html.ValidationInstructionHeader() %></span><br />

    <p class="Instructions">
        To send a document, make a selection to which Organization that is a registered member of the RMSe-bubble network.
       (i.e. hospitals, insurances)
    </p>

    <input type="hidden" name="SendtoOrgCancleButton" id="SendtoOrgCancleButton" value="<%= Url.Content("~/CreateDocument/Send") %>" />

    <%using (Html.BeginForm("SendToProvider", "CreateDocument"))
      {%>
    <%= Html.AntiForgeryToken() %>

    <div class="subtitle">Send Document to an Organization</div>
    <div class="lightGery setBottomSpace"><span class="darkGrey">Step 1 - </span>Provide Information about Recipient(s) and Document Type</div>
    <div id="Step1" class="sendDocument">
     
        <table class="first_block">
            <tr>
                <td class="topAlign" >
                    <label for="recipientProviderId" class="setSpace"><span class="darkGrey">A.</span> Select Recipient(s)<span class="ValidationInstructor">*</span></label>
                    <div>
                        <% Html.RenderAction<RISARC.Web.EBubble.Controllers.CreateDocumentController>(drc => drc.ProvidersInNetworkDropDown("recipientProviderId", "-Select-", (short?)ViewData["RecipientProviderId"], true, true)); %>
                        <%= System.Web.Mvc.Html.InputExtensions.HiddenFor(Html, model => model.ProviderIsEtar)%>
                        <%= Html.ValidationMessage("RecipientProviderRequired", "Required")%>
                        <%= Html.ValidationMessage("ACNNotConfiguredForProvider", "Cannot send documents, the selected provider does not have ACN numbers associate with the document") %>
                        <%= Html.ValidationMessage("NoACNLeft", "Cannot send documents, the selected provider does not have ACN numbers associate with the document")%>
                    </div>
                </td>
                <td class="floatRight">
                    <label for="DocumentType" class="setSpace"><span class="darkGrey">B.</span> Select Document Type<span class="ValidationInstructor">*</span></label>
                    <div class="DocumentTypeHolder">
                        <% Html.RenderAction<RISARC.Web.EBubble.Controllers.CreateDocumentController>(
            x => x.ProviderDocumentTypesDropDown("DocumentTypeId", "-Select-", (short?)ViewData["RecipientProviderId"], Model.DocumentTypeId)
            ); %>
                    </div>
                    <div>
                        <%= Html.ValidationMessage("DocumentTypeRequired", "Required")%>
                    </div>
                    <div class="FieldInstructions">The types available are based on the types that the provider accepts</div>

                </td>
            </tr>


        </table>

    </div>

    <!-- # Step 1  -->

    <div class="lightGery setBottomSpace"><span class="darkGrey">Step 2 - </span>Upload Document(s)</div>
    
    <div id="Step2" class="worklist_search">
        <%= Html.ValidationMessage("DocumentFileRequired", "File Required to Upload Before Sending")%>
        <span id="fileUploaderHoler"></span>


        <table class="DocToOrgTable">
            <tr>
                <td style="width: 45%; vertical-align: top;">
                    <span class="Underline setSpace">Upload Files From Client Folder</span>
                    <span class="redText setBottomSpace">(Acrobat files and TIFF files are recommended. 'Zip' or Compressed files are not accepted)</span>
                    <div class="FixiedHT20"></div>


                    <% Html.RenderPartial("_FileUploadPartial"); %>
                                  
                              
                </td>

                <td style="width: 10%">&nbsp;</td>

                <td style="width: 45%; vertical-align: top;">
                    <table>
                        <tr>
                            <td>
                                <span class="Underline setSpace">Upload Files From SFTP Folder</span>
                                <span class="redText setBottomSpace">(Click the below button to select files from SFTP folder, large size files are allowed from this link)</span>
                                <div class="FixiedHT20"></div>

                                <% Html.RenderPartial("_ServerFileUploadPartial"); %>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

        </table>
        <%= Html.Action("UploadedDocument", "File") %>
        <%= Html.ValidationMessage("eTARDocumentTypeNotAssigned")%>
    </div>
    <!-- # Step 2  -->

    <%  Html.RenderPartial("DocumentSendToProvider", Model);%>


    <script type="text/javascript">           ProcessOnChange(this)</script>
    <script type="text/javascript">           CharCount()</script>

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
    <%--<script type="text/javascript" src="<%: Url.Content("~/Scripts/DocumentReviewer.js")%>"></script>--%>
    <script type="text/javascript" src="<%: Url.Content("~/Scripts/SendToProvider.js")%>"></script>

   <%-- <script type="text/javascript" src="<%: Url.Content("~/Scripts/FileUploader.js")%>"></script>--%>
     <script type="text/javascript" src="<%: Url.Content("~/Scripts/FileUploader.min.js")%>"></script>

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
        // Added by Dnyaneshwar
        $(document).ready(function () {
            // As value of ManualACNNumber is resetting to blank in Telerik Date Picker-Control's Java script (which is generated at runtime); workaround done here by resetting present value in model.
            if (document.getElementById('ManualACNNumber') != null && document.getElementById('ManualACNNumber').value == '')
                document.getElementById('ManualACNNumber').value = '<%: Model.ManualACNNumber %>';
        });
        // End Added

        //added by surekha                
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
        }</script>

  
    <%--  // Jacob/Mike 11/19/2010--%>
    <script type="text/javascript">
        var wordCount = 0;
        function CharCount() {
            var text1 = trim(document.getElementById('Comments').value);
            // var text1 = oldtrim(document.getElementById('Comments').value);
            if (text1.length > -1) {
                document.getElementById('CharCountDisplay').innerHTML = "<span class='setSpace setSpace floatLeft'>Char Count: &nbsp; </span> <span class='redText'>" + (text1.length) + "</span>";
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

        }

        function EnableDisableOnChangeDocType(data, isNewData) {
            var Valenum = {
                NoImplemenationRequired: 1,
                Optional: 2,
                Required: 3
            };

            var OrgEnum = {
                Esmd: 1,
                NonEsmdContractor: 2,
                ExchangePartner: 3
            };
            if (isNewData && data != null) {
                $('#providerDocTypeValidation_DCN_ValidationEnum').val(data.DCN_ValidationEnum);
                $('#providerDocTypeValidation_ICN_ValidationEnum').val(data.ICN_ValidationEnum);
                $('#providerDocTypeValidation_HIC_ValidationEnum').val(data.HIC_ValidationEnum);
                $('#providerDocTypeValidation_CaseID_ValidationEnum').val(data.CaseID_ValidationEnum);
                $('#providerDocTypeValidation_Identifier_ValidationEnum').val(data.Identifier_ValidationEnum);
                $('#providerDocTypeValidation_OrganizationType').val(data.OrganizationType);
                $('#providerDocTypeValidation_ReceivingProvide_OID').val(data.ReceivingProvide_OID);
                $('#providerDocTypeValidation_Description').val(data.Description);
                $('#providerDocTypeValidation_HIC_Description').val(data.HIC_Description);
            }


            if (!($('#providerDocTypeValidation_ReceivingProvide_OID').val() == null || $('#providerDocTypeValidation_ReceivingProvide_OID').val() == '')) {
                if ($('#providerDocTypeValidation_DCN_ValidationEnum').val() == Valenum.Required || $('#providerDocTypeValidation_ICN_ValidationEnum').val() == Valenum.Required || $('#providerDocTypeValidation_CaseID_ValidationEnum').val() == Valenum.Required) {
                    $('#MannualACNDescription').html($('#providerDocTypeValidation_Description').val() + '&nbsp;<span class="ValidationInstructor">*</span>');
                    $('#MannualACNNumDIV').show();
                }
                else if ($('#providerDocTypeValidation_DCN_ValidationEnum').val() == Valenum.Optional || $('#providerDocTypeValidation_ICN_ValidationEnum').val() == Valenum.Optional || $('#providerDocTypeValidation_CaseID_ValidationEnum').val() == Valenum.Optional) {
                    $('#MannualACNDescription').html('(Optional) ' + $('#providerDocTypeValidation_Description').val());
                    $('#MannualACNNumDIV').show();
                }
                else {
                    $('#ManualACNNumber').val('');
                    $('#MannualACNNumDIV').hide();
                }

                if ($('#providerDocTypeValidation_HIC_ValidationEnum').val() == Valenum.Required) {
                    //var textHtml = $('#HIcNumberDescription').html();
                    //textHtml = textHtml.replace('<span class=\"ValidationInstructor\">*</span>', '');
                    //$('#HIcNumberDescription').html(textHtml + '<span class="ValidationInstructor">*</span>');
                    $('#HIcNumberDescription').html($('#providerDocTypeValidation_HIC_Description').val() + '&nbsp;<span class="ValidationInstructor">*</span>');
                    $('#HicNumDiv').show();
                }
                else if ($('#providerDocTypeValidation_HIC_ValidationEnum').val() == Valenum.Optional) {
                    //var textHtml = $('#HIcNumberDescription').html();
                    //textHtml = textHtml.replace('<span class=\"ValidationInstructor\">*</span>', '');
                    //$('#HIcNumberDescription').html(textHtml);
                    $('#HIcNumberDescription').html('(Optional) ' + $('#providerDocTypeValidation_HIC_Description').val());
                    $('#HicNumDiv').show();
                }
                else {
                    $('#HICNumber').val('');
                    $('#HicNumDiv').hide();
                }
            }
            else {
                if ($('#providerDocTypeValidation_OrganizationType').val() != null && $('#providerDocTypeValidation_OrganizationType').val() == OrgEnum.NonEsmdContractor) {
                    // For Non ESMD Provider
                    if ($('#providerDocTypeValidation_Identifier_ValidationEnum').val() == Valenum.Required) {
                        $('#MannualACNDescription').html($('#providerDocTypeValidation_Description').val() + '<span class="ValidationInstructor">*</span>');
                        $('#MannualACNNumDIV').show();
                    }
                    else if ($('#providerDocTypeValidation_Identifier_ValidationEnum').val() == Valenum.Optional) {
                        $('#MannualACNDescription').html('(Optional) ' + $('#providerDocTypeValidation_Description').val());
                        $('#MannualACNNumDIV').show();
                    }
                }
                else if ($('#providerDocTypeValidation_OrganizationType').val() != null && $('#providerDocTypeValidation_OrganizationType').val() == OrgEnum.ExchangePartner) {
                    // For Exchange Partner provider
                }
                else {
                    $('#ManualACNNumber').val('');
                    $('#MannualACNNumDIV').hide();
                    $('#HICNumber').val('');
                    $('#HicNumDiv').hide();
                }
            }
        }
    </script>
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
            }

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
    </script>
    <%-- added by Jacob --%>

    <script type="text/javascript">
        var docTypeArray = []; //array decleration that stores Docuemnt Type Id
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
                //Add Document Type Id to Array and make Document Type required for Other Document Type
                docTypeArray[visibleIndex] = s.GetValue();
                var indexOfDocType = docTypeArray.indexOf(10);
                //If Other document type is there then Document description is required.
                if (indexOfDocType != -1)
                {
                    $("span.OtherHide").html("*");
                }
                else
                {
                    $("span.OtherHide").html("(Optional)");
                }
                //End added
            }
        }
    </script>
</asp:Content>
