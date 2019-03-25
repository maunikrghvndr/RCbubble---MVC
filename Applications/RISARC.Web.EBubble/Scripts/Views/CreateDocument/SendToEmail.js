//OptionExpander.js 
$(document).ready(function () {
    bindOptionsToExpand();
    ensureExpandedCorrectly();
});


function bindOptionsToExpand() {
    var expandableOptions = $('.expandingOption');
    expandableOptions.click(function () {
        showHideExpandee(this);
    });
}

function ensureExpandedCorrectly() {
    $('.expandingOption').each(function () {
        showHideExpandee(this);
    });
}

function showHideExpandee(senderCheckBox) {

    var expandeeElement = $(senderCheckBox).siblings('.expandable');

    if (senderCheckBox.checked) {
        expandeeElement.fadeIn('fast');
    }
    else
        expandeeElement.hide();
}

//==========================  Code Ends Oprtion expander JS /////////////////

$(document).ready(function () {
   
    $("#toggleForm").hide(0);
    $("#toggleReleaseFormsRequiredReason").hide(0);
    $("#toggleIsReleaseOnFileDDL").hide(0);

    $("#ReleaseFormsRequiredDDL").val("");
    $("#IsReleaseOnFileDDL").val("");

    $("#ReleaseFormsRequiredDDL").change(function() {
        var selectedData = $("#ReleaseFormsRequiredDDL option:selected").val();
        if (selectedData == "Yes") {
            $("#toggleReleaseFormsRequiredReason").fadeOut(500);
            $("#toggleIsReleaseOnFileDDL").fadeIn(500);
            $("#toggleForm").fadeOut(500);
            //TrackUser("Send a Document - Send Document To Non-Organization Member: Require release form from recipient?", selectedData, "N/A");
        }
        else if (selectedData == "No") {
         
            $("#ReleaseFormsRequiredDDL").fadeIn(500);
            $("#toggleIsReleaseOnFileDDL").fadeOut(500);
            $("#IsReleaseOnFileDDL").val("");
            //$("#toggleReleaseFormsRequiredReason").fadeIn(500);
            //TrackUser("Send a Document - Send Document To Non-Organization Member: Require release form from recipient?", selectedData, "N/A");
        }
        else {
            $("#toggleReleaseFormsRequiredReason").fadeOut(500);
            $("#toggleIsReleaseOnFileDDL").fadeOut(500);
            $("#IsReleaseOnFileDDL").val("");
            $("#toggleForm").fadeOut(500);
        }
    });

   

    $("#IsReleaseOnFileDDL").change(function() {
        var selectedData = $("#IsReleaseOnFileDDL option:selected").val();
        if (selectedData == "Yes") {
            $("#toggleForm").fadeIn(500);
            //TrackUser("Send a Document - Send Document To Non-Organization Member: Is the release form on file?", selectedData, "N/A");
        }
        else if (selectedData == "No") {
            releaseFile.Show();
            $("#toggleForm").fadeOut(500);
            //TrackUser("Send a Document - Send Document To Non-Organization Member: Is the release form on file?", selectedData, "N/A");
           
        }
        else {
            $("#toggleForm").fadeOut(500);
        }
    });

    $("#SendToEmail").submit(function() {
        $("#IsReleaseOnFileHf").val($("#IsReleaseOnFileDDL option:selected").val());
        return true;
    });
});
 