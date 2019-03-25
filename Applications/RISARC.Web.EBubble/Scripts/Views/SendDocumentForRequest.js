$(document).ready(function() {
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
            alert("Thanks for visiting!");
            $("#toggleForm").fadeIn(500);
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

    $("#modalIsReleaseOnFileMsgBoxContinue").click(function() {
        var selectedData = $("#IsReleaseOnFileDDL option:selected").val();
        var testData = $("#IsReleaseOnFileReason").val();
        $("#toggleReleaseFormsRequiredDDL").fadeOut(500);
        $("#toggleReleaseFormsRequiredReason").fadeOut(500);
        //TrackUserSendReason("Send a Document - Send Document To Non-Organization Member: Is the release form on file?", selectedData, testData);
    });

    $("#modalIsReleaseOnFileMsgBoxContinue").click(function() {
        $(".modalDivBox").jqmHide();
        window.location = "../CreateDocument/SelectDocumentSendingMethod";
    });

    $("#modalIsReleaseOnFileMsgBoxClose").click(function() {
        $(".modalDivBox").jqmHide();
    });

    $("#IsReleaseOnFileDDL").change(function() {
        var selectedData = $("#IsReleaseOnFileDDL option:selected").val();
        if (selectedData == "Yes") {
            $("#toggleForm").fadeIn(500);
            //TrackUser("Send a Document - Send Document To Non-Organization Member: Is the release form on file?", selectedData, "N/A");
        }
        else if (selectedData == "No") {
            $("#toggleForm").fadeOut(500);
            //TrackUser("Send a Document - Send Document To Non-Organization Member: Is the release form on file?", selectedData, "N/A");
            $(".modalDivBox").jqmShow();
            // Message box
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

$(document).ready(function () {
    $('#showhidetarget').hide();

    $('a#showhidetrigger').click(function () {
        $('#showhidetarget').toggle(400);
    });
});

//function TrackUserSendReason(dataType, dataValue, dataReason) {
//    $.ajax({
//        type: "POST",
//        contentType: "text/json",
//        data: "{}",
//        url: "../CreateDocument/CreateTrackUser?activityType=" + dataType + "&activityValue=" + dataValue + "&reason=" + dataReason,
//        dataType: 'json',
//        beforeSend: function() {
//            $("#status").html("Sending your information...");
//        },
//        success: function(message) {
//            $("#status").html(""); // This is for user activity logging Json testing
//        },
//        error: function(message) {
//            $("#status").html("Status: " + message); // This is for user activity logging Json testing
//        }
//    });
//}

//function TrackUser(dataType, dataValue, dataReason) {
//    $.ajax({
//        type: "POST",
//        contentType: "text/json",
//        data: "{}",
//        url: "../CreateDocument/CreateTrackUser?activityType=" + dataType + "&activityValue=" + dataValue + "&reason=" + dataReason,
//        dataType: 'json',
//        beforeSend: function() {
//            $("#status").html("Status: Doing something..."); // This is for user activity logging Json testing
//        },
//        success: function(message) {
//            $("#status").html("Status: " + message); // This is for user activity logging Json testing
//        },
//        error: function(message) {
//            $("#status").html("Status: " + message); // This is for user activity logging Json testing
//        }
//    });
//}