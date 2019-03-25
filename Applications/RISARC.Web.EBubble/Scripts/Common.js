/// <reference name="jquery-1.3.2.js"/>

$(document).ready(function () {
    BindNumbersOnlyBoxes();
});

function SwitchToLoading(sender) {
    var linkWrapper = $(sender).parents('.linkWrapper:first');
}



function BindNumbersOnlyBoxes() {
    $('.numbersonly').keydown(CheckNumbersOnly);
}

function CheckNumbersOnly(event) {
    var validKeyKode = (
    // numbers 0 through 9
    (event.keyCode >= 48 && event.keyCode <= 57)
    // enter key
    || (event.keyCode == 8)
    // tab key
    || (event.keyCode == 9)
    // control key
    || (event.keyCode == 17)
    // number keypad codes
    || (event.keyCode >= 96 && event.keyCode <= 105));
    if (!validKeyKode)
        event.preventDefault();

}

// clears the options of a drop down, sets the default option, and disables it
function clearDropDownOptionsAndDisable(dropDown, newEmptyOptionText) {
    var emptyOption = document.createElement('option');
    emptyOption.value = '';
    $(emptyOption).html(newEmptyOptionText);
    var jDropDown = $(dropDown);
    jDropDown.empty();
    jDropDown.append(emptyOption);
    disable(jDropDown);
}

function disable(element) {
    $(element).attr('disabled', 'disabled');
}

function enable(element) {
    $(element).removeAttr('disabled');
}

function clearAllEntriesOnPage() {
    $("input[type='text']").val('');
    $('select').val('');
}

// navigation menu expander
$(document).ready(function () {
    $('.navL1').click(clickNavItem);
});

function clickNavItem() {
    var jThis = $(this);

    jThis.siblings('.navL1').children('ul:visible').hide();
    // show this nav items direct child
    jThis.children('ul').slideDown();
}

// below will cause all document types drop downs to toggle corresponding validator instructor
$(document).ready(function () {
    $("select[name='DocumentTypeId']").change(DisplayRequiredValidatorIfOther).change();
});


// will have required validtion instructor appear for document description if 'other' document type is selected
function DisplayRequiredValidatorIfOther() {
    var selectedDocumentType = $(this).val();
    var targetElementToShow = $('.DescriptionValidationInstructor');
    if (selectedDocumentType == '10' || selectedDocumentType == '3'/* hack - id of document type other*/)
        targetElementToShow.show();
    else
        targetElementToShow.hide();
    // Next form mike...this might not be global.
    var selectedProviderID = $('.ProvidersInNetworkDropDown').val();
    if ((selectedProviderID == '15' || selectedProviderID == '469' || selectedProviderID == '307') && (selectedDocumentType == '12')) {
        //show HIC;
        // Process HIC Check HERE
        $("#HicNumDiv").show();
    }
    else {
        $("#HicNumDiv").hide();
    };

}

//======================== Showing loading panel & hiding it ============
$(document).load(function () {
    CustomLoadingPanelHide();

});

function showLoadingPanelCenter() {

    try {
        var divWidth = 100;
        var divHeight = 100;
        var divId = 'loadingPanelCustom'; // id of the div that you want to show in center
        //This is done for IE verstion animation working 

        // Get the x and y coordinates of the center in output browser's window
        var centerX, centerY;
        if (self.innerHeight) {
            centerX = self.innerWidth;
            centerY = self.innerHeight;
        }
        else if (document.documentElement && document.documentElement.clientHeight) {
            centerX = document.documentElement.clientWidth;
            centerY = document.documentElement.clientHeight;
        }
        else if (document.body) {
            centerX = document.body.clientWidth;
            centerY = document.body.clientHeight;
        }

        var offsetLeft = (centerX - divWidth) / 2;
        var offsetTop = (centerY - divHeight) / 2;



        $("#loadingPanelCovered").css({ 'width': $(document).width(), 'height': $(document).height() });

        // The initial width and height of the div can be set in the
        // style sheet with display:none; divid is passed as an argument to // the function
        var data = "<div class='padder'><img  alt='Loading...' src='../Images/icons/LoadingLogo.gif' width='76' height='100' /></div>";

        document.getElementById(divId).innerHTML = data

        var ojbDiv = document.getElementById(divId);
        ojbDiv.style.top = offsetTop + 'px';
        ojbDiv.style.left = offsetLeft + 'px';
    }

    catch (e) {
        alert(e.description);
    }
}

function generalizedShowLoader() {
    isIE11 = !!window.MSStream;

    if (document.all || isIE11) { //It is only for IE browses loader animation working 
        showLoadingPanelCenter();
        $("#loadingPanelCovered").show();

    } else { // for other browsers 
        loadingPanel.Show();

    }
}

function CustomLoadingPanelHide() {
    loadingPanel.Hide();
    $("#loadingPanelCovered").hide();
    $("#loadingPanelCustom").hide();
}


$(document).ready(function () {
    var hideLoader = false;
    //Hide loader when user opens new tab useing cntl+mouser left button.
    $(".navL1 ul li a").mousedown(function (event) {

        if (event.which == 1 && event.ctrlKey) {
            hideLoader = true;
        }
    });

    $(".navL1 ul li a").click(function () {
        //  debugger;
        if (($.active > 0) || hideLoader) {
            CustomLoadingPanelHide();
            //$.active gives you current no of ajax call in progress
            //if active is greater than 0 than no need to show loader.
        }
        else {
            // generalizedShowLoader();
            generalizedShowLoader();


        }

    });

    // Show this loader on links other than navigation
    $(".clsLoader").click(function () {
        generalizedShowLoader();
    });


});//Document ready ends

function AddFileToContainer(callbackData) {
    $("#fileContainer").html(callbackData);
    $("#uploadedFiles").show();
    $("#IsFileUploaded").val("true");

    if ($(".field-validation-error").length === 1)
        $(".field-validation-error").hide();

    if (!(document.getElementById('fileUploadGrid') == null)) {
        fileUploadGrid.PerformCallback();
    }
}

function AddClaimFileToContainer(callbackData) {
    redirectPath = $("#redirectToWorkBucket").val();
    window.location = redirectPath + "?u=1";
}



function AddReleaseFileToContainer(callbackData) {
    $("#fileUploader").hide();
    previewComplianceFileLink();
}
function ClearFileContainer() {
    $("#uploadedFiles").hide();
    $("#fileContainer").empty();
}

function UpdateUploadButton() {
    btnUpload.SetEnabled(MultiSelectUploadControl.GetText(0) != "");
}

function UpdateTCNUploadButton() {
    btnUpload.SetEnabled(TCNMultiSelectUploadControl.GetText(0) != "");
}

function UpdateSingleUploadButton() {
    btnUpload.SetEnabled(SingleFileUploadControl.GetText(0) != "");
    return false;
}

function UpdateSingleFileUploadButton() {
    btnUpload.SetEnabled(ClaimFileUpload.GetText(0) != "");
    return false;
}

//Stop resizing action column
function stopResizingActionCol(s, e) {
    if (e.column.name == "ActionColumn") {
        e.cancel = true;
    }
}

// This functiom to disbale button doublt click 
//05.11.2014 surekha
//Modified By Abhishek (19-Jan-2015)
//Time increased from 1 second to 3.5 seconds
function disableDoubleClick(s, e) {

    setTimeout(function () {
        s.SetEnabled(false);
    }, 1);

    setTimeout(function () {
        s.SetEnabled(true);
    }, 3500);
}
