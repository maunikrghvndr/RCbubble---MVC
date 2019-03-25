<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<script type="text/javascript">
    // Response Letter Upload Functions

    var flag = false;
    function AddRLFileToContainer(callbackData) {
        if ($('#fileUploadGrid_RL').length != 0) {
            fileUploadGrid_RL.PerformCallback();
        }
    }

    //do upload button enable when some file are selected.
    function UpdateRLUploadButton() {
            btnUploadRL.SetEnabled(RLMultiSelectUploadControl.GetText(0) != "");
    }

    //Its detect that file uploading has been statred...
    function Uploader_OnFileUploadStart() {
        flag = true;
    }


    function SendRLDocument(accountSubmissionDetailsID, TcnNumber, IsPreviewDoc) {
        if (!flag) {
            alert("Please Upload files before clicking on Attach & Preview Button");
            return;
        }
       
        flag = false; var DocumentFileID;
        generalizedShowLoader();
        var routData = {
            AccountSubmissionDetailsID: accountSubmissionDetailsID,
            tcnNumber: TcnNumber
        };

        $.ajax({
            type: "GET",
            url: "<%:(Url.Action("SendResponseLetter","AccountDetails"))%>",
            data: routData,
            success: function (result) {
                   //Refresh RMS document index grid.
                  DocumentFileID = result;
               
                $("#RLFieldID").val(DocumentFileID);
                     if (typeof DocumentFileID != 'object') {
                         var TCNNo = $("#TCNNo").val();
                         var AccountSubmissionDetailsID = $("#AccountSubmissionDetailsID").val();
                         var SenderProviderID = $("#SenderProviderID").val();
                         RMSDocumentsGrid.PerformCallback({ TCNNo: TCNNo, AccountSubmissionDetailsID: AccountSubmissionDetailsID, SenderProviderID: SenderProviderID });
                         if ($("#ExternalNoteGrid").length != 0) {
                             ExternalNoteGrid.PerformCallback({ SenderProviderID: SenderProviderID, TCNNo: TCNNo });
                         }
                         AccountNotesPopup.Hide();
                     } else {
                         alert("Please Upload files before clicking on Attach & Preview Button");
                     }
                   
                  
                }, //sucess function edns of first ajax calll
                error: function (request, status, error) {
                    alert(error);
                }

        }).done(function () {
            CustomLoadingPanelHide();
            //Update current opened Document file ID in Hideen fields 
            //   $("#DocumentFileID").val(DocumentFileID); // I was raising bug for RMS Document type filltering in left panel  
             //  Load Document which file ID is provide3d.
              $.ajax({
                  type: "GET",
                  cache: false,
                  url: "../AccountDetails/DocumentViewer",
                  data: { DocumentFileID: DocumentFileID },
                  success: function (result) {
                      if (result != null) {
                          if ($('#documentViewer_DocumentPath').length != 0)
                              $('#documentViewer_DocumentPath').val(result.DocumentPath);
                          if ($('#documentViewer_DocumentFileName').length != 0)
                              $('#DocumentFileName').val(result.DocumentFileName);
                          if ($('#documentViewer_NumberOfPages').length != 0)
                              $('#documentViewer_NumberOfPages').val(parseInt(result.NumberOfPages + ""));
                          if ($('#documentViewer_ContentType').length != 0)
                              $('#documentViewer_ContentType').val(result.ContentType);
                          if (preViousDocumentFileID == DocumentFileID) {
                              LoadDocument();
                          }
                          else {
                              preViousDocumentFileID = DocumentFileID;
                              LoadDocument(true);
                          }
                      }
                      
                  },
                  error: function (request, status, error) {
                      $("#removeError").show();
                  }
              });
        })

    }//Function ends 

    function removeRLFile(id) {

        var conf = confirm("Are you sure you want to delete this record?");
        if (conf == true) {
            $.ajax({
                type: "GET",
                url: "<%:(Url.Action("RemoveRLUploadedFile","File"))%>",
                data: { documentFileId: id },
                success: function (result) {
                //    debugger;
                    var currentOpenedFileId = $("#RLFieldIDPopup").val();
                    deletedFileID = result;
                    if ($('#fileUploadGrid_RL').length != 0)
                        fileUploadGrid_RL.PerformCallback();
                  
                    if (currentOpenedFileId == deletedFileID) // Current File ID == Selcted One Then Remove files from Document Viewer.
                    {
                        $("#pluginPageView").html("");
                        $("#txtGoToPage").val("");
                        $("#totalPageCount").val("");
                    }

                },
                error: function (request, status, error) {
                    alert(status + " "+ error);
                }
            });
    }

    }

    function BindRLGrid(accountSubmissionDetailsID, isClearSession) {
        if (isClearSession == null)
            isClearSession = false;

        if ($('#fileUploadGrid_RL').length != 0) {
            fileUploadGrid_RL.PerformCallback({ AccountSubmissionDetailsID: accountSubmissionDetailsID, IsClearSession: isClearSession });
        }
    }

    function btnCancle_Click(s, e) {
        jQuery.get('../AccountDetails/CleareSessionForRLUpload');
        AccountNotesPopup.Hide();
    }
    // End Response Letter Upload
</script>

<%   Html.BeginForm("MultiSelectRLFileUploadControlUpload", "UploadControl", FormMethod.Post); %>

<ul class="UploadHeader UploadHeaderResponseLetter">
    <li>
        <%  Html.DevExpress().UploadControl(settingsUpload =>
                   {
                       settingsUpload.Name = "RLMultiSelectUploadControl";
                       settingsUpload.CallbackRouteValues = new { Controller = "File", Action = "MultiSelectRLFileUploadControlUpload" };
                       settingsUpload.AdvancedModeSettings.EnableMultiSelect = true;
                       settingsUpload.Width = 300;
                       settingsUpload.Height = 32;
                       
                       settingsUpload.Styles.TextBox.BackColor = System.Drawing.ColorTranslator.FromHtml("#f7f7f7");
                       settingsUpload.Styles.NullText.BackColor = System.Drawing.ColorTranslator.FromHtml("#f7f7f7");
                       
                      //settingsUpload.ControlStyle.Paddings.Padding = 10;
                       settingsUpload.ShowUploadButton = false;
                       settingsUpload.ShowProgressPanel = true;
                       settingsUpload.ShowClearFileSelectionButton = true;
                       RISARC.Web.EBubble.Models.DevxControlSettings.FileUploadControlSettings fileUploadControlSettings =
                       new RISARC.Web.EBubble.Models.DevxControlSettings.FileUploadControlSettings();

                       settingsUpload.ValidationSettings.Assign(fileUploadControlSettings.ValidationSettings);
                       settingsUpload.NullText = "Select File(s) to Upload";
                       settingsUpload.BrowseButton.Text = "Browse";
                       settingsUpload.ClientSideEvents.FileUploadComplete = "function(s,e) { if(e.callbackData == 'true') AddRLFileToContainer(e.callbackData); }";
                       settingsUpload.ClientSideEvents.TextChanged = "function(s, e) { UpdateRLUploadButton(); }";

                       settingsUpload.ClientSideEvents.FileUploadStart = "function(s,e) {  Uploader_OnFileUploadStart(); }";
                       
                       
                   }).Render();
        %>
 </li>
    <li>
        <%   Html.DevExpress().Button(
                        settingsUpload =>
                        {
                            settingsUpload.Name = "btnUploadRL";
                            settingsUpload.Text = "Upload";
                            settingsUpload.ControlStyle.CssClass = "orangeBtn";
                            settingsUpload.Width = Unit.Pixel(100);
                            settingsUpload.Height = Unit.Pixel(32);
                            settingsUpload.UseSubmitBehavior = false;
                            settingsUpload.ClientSideEvents.Click = "function(s,e) { RLMultiSelectUploadControl.Upload(); }";
                            settingsUpload.ClientEnabled = false;
                        }).GetHtml();

             Html.EndForm();
        %>
    </li>

   <% if (!Request.Url.AbsolutePath.ToString().Contains("/AccountDetails/AccountNotesPopup"))
      { %>
     <li>
        <%   Html.DevExpress().Button(
                        settings =>
                        {
                            settings.Name = "attachAndPreview";
                            settings.Text = "Attach & Preview";
                            settings.ControlStyle.CssClass = "greyBtn";
                            settings.Width = Unit.Pixel(100);
                            settings.Height = Unit.Pixel(32);
                            settings.UseSubmitBehavior = false;
                            settings.ClientSideEvents.Click = "function(s,e) { SendRLDocument(AccountSubmissionDetailsID, TCNNumber, false); }";
                     
                        }).GetHtml();

             Html.EndForm();
        %>
    </li>
    <% } %>
</ul>
<div class="FixiedHT10 clear">&nbsp;&nbsp; </div>
<% Html.RenderPartial("_UploadedRLDocument", new List<RISARC.Common.Model.UploadedFiles>()); %>
       
       
