// JavaScript source code

var documentFileId = "";
var TCNIdentificationIDH = "";
var doubleClickIndex = 0;
var documentTypeId = "";
var preViousDocumentFileID;
var UserIndex = 0;

//close account notes popup 
//on popup close need to remove entered text from text box
function AccountNotesPopupClose() {
    AccountNotesPopup.Hide();
}

function AttachRemoveTCNPopUpClose() {
    //Removing enter TCN Text on close in textaea
    if ($("#txtTCNNumber").length != 0) {
        txtTCNNumber.SetText("");
    }
    AttachRemoveTCN.Hide();
}



function OnDocumentIndexBeginCallback(s, e) {     // ASPxCallbackPanel BeginCallback
    var commndName = e.command;
    //Reset time remaining if user is modifying the document index.
    if (commndName == "STARTEDIT" || commndName == "UPDATEEDIT")
        RestartExpirationTime();

    e.customArgs["documentFileId"] = documentFileId;
}

function OnDocumentGridBeginCallback(s, e) {     // ASPxCallbackPanel BeginCallback
    e.customArgs["documentTypeIdvalue"] = documentTypeId;
}

// This function is useed to set focus when response letter is perview in viewer
function OnDocumentGridEndCallback(s, e) {
   
    // RLFieldID its value is set from RL upload function in  File _responseLetterUpload.acx

    if ($("#RLFieldID").val() != "") {
        //We have assign current opened files id to this so that it can delete record from viewer
        removeCurrentFileIDForResponseLetter = $("#RLFieldID").val();
        var visibleRowIndex = s.cpVisibleRowCount
        RMSDocumentsGrid.SelectRowOnPage(visibleRowIndex - 1);
        visibleRowIndex = "";
        $("#RLFieldID").val("");
    }
}



function OnDoubleClick(s, e) {
    doubleClickIndex = e.visibleIndex;
    s.GetRowValues(doubleClickIndex, 'DocumentFileID', OnGetRowValue);
    s.GetRowValues(doubleClickIndex, 'IsSender', CheckIfRowEditable);
}

function OnGetRowValue(documentId) {
    documentFileId = documentId;
}

function CheckIfRowEditable(isSender) {
    if (isSender) {
        alert("You don't have rights to modify the document indexes.");
        return false;
    }
    else
        DocumentIndexGrid.StartEditRow(doubleClickIndex);
}


function DocumentComboBoxInit(s, e) {
    s.SetText('--Select Document to Display--');
}
function SelectReassignComboBox(s, e) {
    UserIndex = s.GetValue();

}

////======On Selection changes of Select Document Type//======
function OnSelectionGetDocTypeID(s, e) {

    var TCNNo = $("#TCNNo").val();
    var AccountSubmissionDetailsID = $("#AccountSubmissionDetailsID").val();
    var DocumentFileID = $("#DocumentFileID").val();
    var SenderProviderID = $("#SenderProviderID").val();
    documentTypeId = s.GetValue();

    RMSDocumentsGrid.PerformCallback({ DocumentTypeID: s.GetValue(), DocumentFileID: DocumentFileID, TCNNo: TCNNo, AccountSubmissionDetailsID: AccountSubmissionDetailsID, SenderProviderID: SenderProviderID });
    //Reset time remaining
    RestartExpirationTime();
  

}

////======On Document List row Cliked will populate Document Index //======


//================================ All pane resizing  code ========================

function OnSplitterPaneResized(s, e) {
    var name = e.pane.name;

    if (name == 'DocumentViewerPanes') {
        ResizeDocViewerHeight(e.pane);
    }

    if (name == 'paneRight') {
        TcnViewerWidthIncrease(e.pane);
    }


}//Resize function ends

function PaneCollapsed(s, e) {
    var PaneName = e.pane.name;

    if (PaneName == "paneLeft") {
        $(".btnExpandLeft").show();
    }

    if (PaneName == "paneRight") {
        $(".btnExpandRight").show();
    }

}

function PaneExpanded(s, e) {
    var PaneName = e.pane.name;

    if (PaneName == "paneLeft") {
        $(".btnExpandLeft").hide();
    }

    if (PaneName == "paneRight") {
        $(".btnExpandRight").hide();
    }

}






function TcnViewerWidthIncrease(splitterPane) {
    $("#TCNFormDisplay_PreviewIFrame").css("width", splitterPane.GetClientWidth() - 5);

}

function ResizeDocViewerHeight(splitterPane) {
    var panWidth = splitterPane.GetClientWidth();

    if (panWidth < 700) { // Means top scroll of tool buttons are active top increase its height
        $("#MainImageWindow").css("height", splitterPane.GetClientHeight() - 56);
        $(".setToolBorder").removeClass("setHeight").addClass("setHeightExpanded");
    } else {
        $("#MainImageWindow").css("height", splitterPane.GetClientHeight() - 41);
        $(".setToolBorder").removeClass("setHeightExpanded").addClass("setHeight");
    }
}

//========================================== Attached or Remove TCN Files Function =========================
function OnTcnDoneButtonClick() {
    var isValid = true;

    $('.allCombobox').each(function () {
        var value = $("#" + this.id + " input").val();
        if (value == "" || value == "undefined") {
            $(".error").show();
            $(".error").html("* Please select document type values.");
            isValid = false;
        }
    });

    if (isValid) {
      
        $(".error").hide();
        SendTCNDocument();

        //Reset time remaining
        RestartExpirationTime();

        $(window).scroll(function () {

            $(window).unbind('scroll');
        });

    }
    return false;

  
}



// External Note Start
var selecteItemTCNDropDown;
function TCNId_SelectedIndexChange(s, e) {
    if ($("#ExternalNoteGrid").length != 0) {
        selecteItemTCNDropDown = s.GetSelectedItem();
        ExternalNoteGrid.PerformCallback({ TCNIdentificationID: s.GetSelectedItem().value, TCNNo: s.GetSelectedItem().text });
    }
}

function TCNID_EndCallback(s, e) {
    if (selecteItemTCNDropDown != null)
        s.SetSelectedItem(selecteItemTCNDropDown);
}
// External Note End
//========= Status Popup cancel button click ========
function StatusCancelBtnClick(s, e) {
  
    if ($("#ExternalNoteGrid").length != 0) {
        ExternalNoteGrid.PerformCallback();
    }
    //Refresh RMSDocumentsGrid On popup close
    if ($("#RMSDocumentsGrid").length != 0) {
        RMSDocumentsGrid.PerformCallback();
    }
    //Removing enter text in textaea
    if ($("#popupExternalNoteMemo").length != 0) {
        popupExternalNoteMemo.SetText("");
    }

    AccountNotesPopupClose();
    jQuery.get('../AccountDetails/CleareSessionForRLUpload');
}

//==== below function is written to replace above 
//==== 02.02.2015 fuction work due to new requirments===
function TCNStatusCancelBtnClick(s, e) {
    TCNStatusConfirmation.Hide();
   // window.location = $("#worklistPath").val();
    // redirect to worklist screen / global function.
}



//<![CDATA[
$(document).ready(function () {
    //============== Collapse Expand Left  =================
    $("#btnCollapseLeft").click(function () {

        var paneLeft = Splitter.GetPaneByName("paneLeft");
        var allowCollapse = !paneLeft.IsCollapsed();
        if (allowCollapse) {
            $(".btnExpandLeft").show();
            paneLeft.Collapse(Splitter.GetPaneByName("paneMiddle"));
        }
    });

    $("#btnExpandLeft").click(function () {
        var paneLeft = Splitter.GetPaneByName("paneLeft");
        var allowExpand = paneLeft.IsCollapsed();
        if (allowExpand) {
            $(".btnExpandLeft").hide();
            paneLeft.Expand(Splitter.GetPaneByName("paneMiddle"));
        }
    });





    //============== Collapse Expand Right  =================
    $("#btnCollapseRight").click(function () {

        var paneRight = Splitter.GetPaneByName("paneRight");
        var allowCollapse = !paneRight.IsCollapsed();
        if (allowCollapse) {
            $(".btnExpandRight").show();
            paneRight.Collapse(Splitter.GetPaneByName("paneMiddle"));
        }
    });

    $("#btnExpandRight").click(function () {
        var paneRight = Splitter.GetPaneByName("paneRight");
        var allowExpand = paneRight.IsCollapsed();
        if (allowExpand) {
            $(".btnExpandRight").hide();
            paneRight.Expand(Splitter.GetPaneByName("paneMiddle"));
        }
    });

    $(document).ajaxComplete(function () {
      
        $("#pluginPageView div div").hover(function () {
            $(this).css('cursor', 'pointer');
        }, function () {
            $(this).css('cursor', 'auto');
        });
    });

}); //document ready 
// ]]>
//=====================================================================

$(window).load(function () {
    DownloadedDocument();
});

//================== Set Document Viewer Tool Button ===============
function setToolButtonActiveCls(id) {
    $(".AccessOption1").removeClass("toolbtnActive");
    $("#" + id).addClass("toolbtnActive");
}

function gotoKeyPress(event) {
    if (event.which == 13) {
        goToPageToolButton_onClick();
        event.preventDefault();
    }
};

//********************************************************************************************************************************************************
//Document Viewer script start
var count = 0;
var totalPageCount = 0;
var disableCount = 0;
var disableTotalPagCount = 0
var len = 0;
var selectedIndex = -1;
var NotFoundPageNo = 0;
var disableRotateButton = false;

function enableNextPrevButton(btnDirtion) {

    if (btnDirtion == "nextPage") {
        $("#NextPage").removeClass("NextPageDisable").addClass("NextPage");
        $('#NextPage').removeAttr("disabled");

    } else if (btnDirtion == "prevPage") {
        $("#PrevPage").removeClass("PrevPageDisable").addClass("PrevPage");
        $('#PrevPage').removeAttr("disabled");

    } else if (btnDirtion == "bothPage") {
        $("#NextPage").removeClass("NextPageDisable").addClass("NextPage");
        $("#PrevPage").removeClass("PrevPageDisable").addClass("PrevPage");
        //
        $('#NextPage').removeAttr("disabled");
        $('#PrevPage').removeAttr("disabled");

    } else if (btnDirtion == "Allacess") {
        $("#PrevIndex").removeClass("PrevIndexDisable").addClass("PrevIndex");
        $("#NextIndex").removeClass("NextIndexDisable").addClass("NextIndex");
        $('#PrevIndex').removeAttr("disabled");
        $('#NextIndex').removeAttr("disabled");
    }
}

function disableNextPrevButton(btnDirtion) {

    if (btnDirtion == "nextPage") {
        $("#NextPage").removeClass("NextPage").addClass("NextPageDisable");
        $("#NextPage").attr('disabled', true);
    } else if (btnDirtion == "prevPage") {
        $("#PrevPage").removeClass("PrevPage").addClass("PrevPageDisable");
        $("#PrevPage").attr('disabled', true);



    } else if (btnDirtion == "bothPage") {
        //Changing icons images 
        $("#NextPage").removeClass("NextPage").addClass("NextPageDisable");
        $("#PrevPage").removeClass("PrevPage").addClass("PrevPageDisable");
        //Adding Disable attribute to element 
        $("#NextPage").attr('disabled', true);
        $("#PrevPage").attr('disabled', true);

    } else if (btnDirtion == "Allacess") {
        $("#NextPage").removeClass("NextPage").addClass("NextPageDisable");
        $("#PrevPage").removeClass("PrevPage").addClass("PrevPageDisable");
        $("#PrevIndex").removeClass("PrevIndex").addClass("PrevIndexDisable");
        $("#NextIndex").removeClass("NextIndex").addClass("NextIndexDisable");

        $("#NextPage").attr('disabled', true);
        $("#PrevPage").attr('disabled', true);
        $("#PrevIndex").attr('disabled', true);
        $("#NextIndex").attr('disabled', true);
    }

}


function disableNextPrevIndex() {
    $("#PrevIndex").removeClass("PrevIndex").addClass("PrevIndexDisable");
    $("#NextIndex").removeClass("NextIndex").addClass("NextIndexDisable");

    $("#PrevIndex").attr('disabled', true);
    $("#NextIndex").attr('disabled', true);

}

function disableRotateButtons(flag) {
    if (flag) {
        $("#RotateLeft").removeClass("RotateLeft").addClass("RotateLeftDisable");
        $("#RotateRight").removeClass("RotateRight").addClass("RotateRightDisable");

        $("#RotateLeft").attr('disabled', true);
        $("#RotateRight").attr('disabled', true);

    }
    else {
        if (disableRotateButton == false) {
            $("#RotateLeft").removeClass("RotateLeftDisable").addClass("RotateLeft");
            $("#RotateRight").removeClass("RotateRightDisable").addClass("RotateRight");

            $('#RotateLeft').removeAttr("disabled");
            $('#RotateRight').removeAttr("disabled");

        }
        else
            disableRotateButton = false;
    }
}

function initDocumentViewver() {
    $("#pluginPageView").ImGearPageViewPlugin(
    {
        imageHandlerUrl: "../ImageGearService.svc",
        resourcePath: '../../Images',
        artServiceOption: ImageGear.Web.UI.ImGearArtDataServices.ArtDataService
    });
    $("#pluginPageView").ImGearPageViewPlugin().add_pageOpening(fileOpening);
    //$("#pluginPageView").ImGearPageViewPlugin().add_pageDisplayed(fileDisplayed);
    $("#pluginPageView").ImGearPageViewPlugin().add_pageOpened(fileOpened);
    $("#pluginPageView").ImGearPageViewPlugin().add_pageOpenFailed(fileOpenedFailed)
};

function LoadDocument(resetData) {
   
    if (resetData == true) {
        count = 0;
        totalPageCount = parseInt($('#documentViewer_NumberOfPages').val());
        len = 0;
        selectedIndex = -1;

        disableCount = count;
        disableTotalPagCount = totalPageCount
    }

    initDocumentViewver(totalPageCount);
    OpenPage();
    $("#pluginPageView").ImGearPageViewPlugin().set_mouseTool(ImageGear.Web.UI.MouseTool.HandPan);



} //loadDocument() ends 

function OpenPage(isPageNotFound) {

        $('#HTMLFileLoader').removeAttr("src");

        if (isPageNotFound == null)
            isPageNotFound = false;
        if (isPageNotFound) {
            disableRotateButtons(true); // disable image rottation 
            disableRotateButton = true; // disable image rottation 
            $("#pluginPageView").ImGearPageViewPlugin().openPage(
              {
                  documentIdentifier: 'pageNotAvailable.png',
                  pageNumber: 0,
                  viewFitType: ImageGear.Web.UI.FitType.OneToOne
              });
            $('#txtGoToPage').val(NotFoundPageNo);
            disableRotateButtons(true);
            disableRotateButton = true;
        }
        else {
            $("#pluginPageView").ImGearPageViewPlugin().openPage(
              {
                  documentIdentifier: $('#documentViewer_DocumentPath').val(),
                  pageNumber: count,
                  viewFitType: ImageGear.Web.UI.FitType.FullWidth
              });
            $('#txtGoToPage').val(count + 1);
            if (isNaN(totalPageCount)) {

                $('#totalPageCount').val(" of  1");
            } else {

                totalPageCount = totalPageCount.toString(); // lenght property only works on string
                totalCntLen = totalPageCount.length;

                if (totalCntLen > 3) {
                    $('#totalPageCount').css("width", totalCntLen * 8);
                }
                $('#totalPageCount').val(" of " + totalPageCount + " ");

            }

        }
        ////Reset time remaining
        //RestartExpirationTime();

        //Disable Prev page
        if (disableCount == count) {
            disableNextPrevButton("prevPage");
        } else {
            enableNextPrevButton("prevPage");
        }

        //Disable Next Page
        if (disableTotalPagCount == count + 1) {
            disableNextPrevButton("nextPage");
        } else {
            enableNextPrevButton("nextPage");
        }

        //Single Page Case 
        if (isNaN(totalPageCount) || totalPageCount == 1) {
            disableNextPrevButton("Allacess");
        } else {

            enableNextPrevButton("Allacess");
        }

    //}
}

function fileOpenedFailed(sender, eventArgs) {
    alert(eventArgs.exception.message);
    disableRotateButtons(true);
    CustomLoadingPanelHide();
}

function fileOpening() {
    //  generalizedShowLoader();
    generalizedShowLoader();
}

function fileOpened() {
    if (isNaN(totalPageCount)) {
        totalPageCount = $("#pluginPageView").ImGearPageViewPlugin().get_documentPageCount();
        $('#totalPageCount').val(" of  " + totalPageCount);
    }
    if (totalPageCount > 1) {
        $("#NextPage").removeClass("NextPageDisable").addClass("NextPage");
        $('#NextPage').removeAttr("disabled");
    }
    if (totalPageCount == count + 1) {
        disableNextPrevButton("nextPage");
    }
    disableRotateButtons(false);
    CustomLoadingPanelHide();

}



function checkDocPresent() {
    if ($('#documentViewer_DocumentPath').length == 0 || $('#documentViewer_DocumentPath').val() == '') {
        alert('Please select document to View.');
        return false;
    }
}

function GoToIndex(s, e) {
    //Reset time remaining
    RestartExpirationTime();
    if (checkDocPresent() == false)
        return false;

    generalizedShowLoader();
    selectedIndex = e.visibleIndex;
    var previousValue;
    var ctr = $("#documentIndex_" + (selectedIndex));
    if (ctr != null) {
        previousValue = count;
        count = parseInt(ctr.val() - 1);
    }
    if (totalPageCount > count) {
        OpenPage();
        //$('#txtGoToPage').val(count + 1);
    }
    else {
        //alert('Index page no ' + (count + 1) + ' not present.');
        NotFoundPageNo = (count + 1);
        OpenPage(true);
        count = previousValue;
        CustomLoadingPanelHide();
    }
}

function GoToDocumentIndexNext(NextIndex) {
    //Reset time remaining
    RestartExpirationTime();
    if (checkDocPresent() == false)
        return false;

    setToolButtonActiveCls(NextIndex);
    var totalrowCount = $("#IndexRowCount").val();
    generalizedShowLoader();
    selectedIndex = (selectedIndex + 1);
    var ctr = $("#documentIndex_" + (selectedIndex));
    var previousValue;
    if ((selectedIndex) < totalrowCount) {
        if (ctr.length != 0) {
            previousValue = count;
            count = parseInt(ctr.val() - 1);
        }
        else {
            selectedIndex = 0;
            ctr = $("#documentIndex_" + selectedIndex);
            if (ctr.length != 0) {
                previousValue = count;
                count = parseInt(ctr.val() - 1);
            }
            else {
                alert("Document Index not present.");
                CustomLoadingPanelHide();
                return false;
            }
        }
    }
    else {
        selectedIndex = 0;
        ctr = $("#documentIndex_" + selectedIndex);
        if (ctr.length != 0) {
            previousValue = count;
            count = parseInt(ctr.val() - 1);
        }
        else {
            alert("Document Index not present.");
            CustomLoadingPanelHide();
            return false;
        }
    }
    if (totalPageCount > count) {
        OpenPage();
        //$('#txtGoToPage').val(count + 1);
    }
    else {
        //alert('Index page no ' + (count + 1) + ' not present.');
        NotFoundPageNo = (count + 1);
        OpenPage(true);
        CustomLoadingPanelHide();
        count = previousValue;
    }
}

function GoToDocumentIndexPrevious(PrevIndex) {
    //Reset time remaining
    RestartExpirationTime();
    if (checkDocPresent() == false)
        return false;

    setToolButtonActiveCls(PrevIndex); // set button active

    var totalrowCount = $("#IndexRowCount").val();
    generalizedShowLoader();
    var previousValue;

    if (selectedIndex <= 0) {
        selectedIndex = totalrowCount - 1;
    }
    else {
        selectedIndex = selectedIndex - 1;
    }
    var ctr = $("#documentIndex_" + (selectedIndex));

    if ((selectedIndex) < totalrowCount) {
        if (ctr.length != 0) {
            previousValue = count;
            count = parseInt(ctr.val() - 1);
        }
        else {
            selectedIndex = 0;
            ctr = $("#documentIndex_" + selectedIndex);
            if (ctr.length != 0) {
                previousValue = count;
                count = parseInt(ctr.val() - 1);
            }
            else {
                alert("Document Index not present.");
                CustomLoadingPanelHide();
                return false;
            }
        }
    }
    else {
        selectedIndex = 0;
        ctr = $("#documentIndex_" + selectedIndex);
        if (ctr.length != 0) {
            previousValue = count;
            count = parseInt(ctr.val() - 1);
        }
        else {
            alert("Document Index not present.");
            CustomLoadingPanelHide();
            return false;
        }
    }
    if (totalPageCount > count) {
        OpenPage();
        //$('#txtGoToPage').val(count + 1);
    }
    else {
        //alert('Index page no ' + (count + 1) + ' not present.');
        NotFoundPageNo = (count + 1);
        OpenPage(true);
        CustomLoadingPanelHide();
        count = previousValue;
    }
}

function nextToolButton_onclick(NextPage) {
    //Reset time remaining
    RestartExpirationTime();
    if (checkDocPresent() == false)
        return false;

    setToolButtonActiveCls(NextPage);

    if (totalPageCount - 1 > count)
        count = count + 1;
    else
        count = 0;

    OpenPage();

    //enable prevPage
    enableNextPrevButton("prevPage");

}

function previousToolButton_onclick(PrevPage) {
    //Reset time remaining
    RestartExpirationTime();
    if (checkDocPresent() == false)
        return false;

    setToolButtonActiveCls(PrevPage);
    if (totalPageCount - 1 >= count && count != 0)
        count = count - 1;
    else
        count = totalPageCount - 1;

    OpenPage();
    //$('#txtGoToPage').val(count + 1);
}

function rotateRightToolButton_onclick(RotateRight) {
    RestartExpirationTime();
    if (checkDocPresent() == false)
        return false;

    setToolButtonActiveCls(RotateRight) //set button active S
    $("#pluginPageView").ImGearPageViewPlugin().rotate(90);
}

function rotateLeftToolButton_onclick(RotateLeft) {
    //Reset time remaining
    RestartExpirationTime();
    if (checkDocPresent() == false)
        return false;

    setToolButtonActiveCls(RotateLeft) //set button active S
    $("#pluginPageView").ImGearPageViewPlugin().rotate(-90);
}

function printCurrentPage_onclick(optionPrint) {
    if (checkDocPresent() == false)
        return false;

    setToolButtonActiveCls(optionPrint); //set button active

    var plugin = $("#pluginPageView").ImGearPageViewPlugin();
    var pageArray = [plugin.get_pageNumber()];
    plugin.showPrintDialog({ pageArray: pageArray, includeAnnotations: true });

}


function goToPageToolButton_onClick() {
    //Reset time remaining
    RestartExpirationTime();
    if (checkDocPresent() == false)
        return false;

    generalizedShowLoader();
    if ($('#txtGoToPage') != null && parseInt($('#txtGoToPage').val()) - 1 >= 0 && totalPageCount >= parseInt($('#txtGoToPage').val())) {
        count = parseInt($('#txtGoToPage').val()) - 1;
        OpenPage();
    }
    else {
        if ($('#txtGoToPage') != null && ($.trim($('#txtGoToPage').val()) == '' || isNaN(parseInt($('#txtGoToPage').val())))) {
            alert('Please enter valid page number to go to.');
            CustomLoadingPanelHide();
            return false;
        }
        //alert("Invalid page Number. Must be between 1 to " + totalPageCount);
        NotFoundPageNo = (parseInt($('#txtGoToPage').val()));
        OpenPage(true);
        CustomLoadingPanelHide();
    }
    //$('#txtGoToPage').val(count + 1);
}

// Docment Viewver script end
//********************************************************************************************************************************************************

// Internal / External And e Note Scripts
function NoteTabs_BeginCallback(s, e) {
    //alert(getUrlParameter('eNoteID').val());
    e.customArgs["DocumentID"] = $('#DocumentID').val();
 
}
// End Internal / External And e Note Scripts

//Added by abdul to get the parameter from the URL
//gets the Query String Parametr Value
function getUrlVars() {
    var vars = [], hash;
    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    for (var i = 0; i < hashes.length; i++) {
        hash = hashes[i].split('=');
        vars.push(hash[0]);
        vars[hash[0]] = hash[1];
    }
    return vars;
}

