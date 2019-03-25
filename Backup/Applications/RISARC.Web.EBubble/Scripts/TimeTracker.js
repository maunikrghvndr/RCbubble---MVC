
var timeMultiplier = 0;
var timePopupMultiplier = 0;
var taskTimerCountdown;
var popuptaskTimerCountdown;
var logTimerCountdown, logTimerPopupCountdown;
var trackingIntervalTime;
//this method will get called at the time of initialization of label control in Remaining time Dock
function OnTickerInit() {
    taskTimerCountdown = window.setInterval(function () { UpdateTimeTicker(); }, 1000);
    UpdateTimeTicker()
}

function OnPopupTickerInit() {
    popuptaskTimerCountdown = window.setInterval(function () { UpdatePopupTimeTicker(); }, 1000);
    UpdatePopupTimeTicker();
}

function UpdateTimeTicker() {
    var timeString;
    try {
      
        timeMultiplier = timeMultiplier + 1;
        if (timeMultiplier >= 0) {
            timeString = formatTaskTime(timeMultiplier);
            timeSpent.SetText(timeString);
        }

    } catch (e) {
        console.log(e.message);
    }
}
//time ticker for popup
function UpdatePopupTimeTicker() {
    var popupTimeString;
    try {

        //time ticker for popup

        timePopupMultiplier = timePopupMultiplier + 1;
        if (timePopupMultiplier >= 0) {
            popupTimeString = formatTaskTime(timePopupMultiplier);
            timeSpentPopup.SetText(popupTimeString);
        }
    } catch (e) {
        console.log(e.message);
    }
}
function formatTaskTime(time) {
    var hh = Math.floor(time / 3600);
    var mm = Math.abs(Math.floor((time - (hh * 3600)) / 60));
    var ss = Math.floor(time - (hh * 3600) - (mm * 60));
    return ((hh < 10) ? "0" : "") + hh + ":" + ((mm < 10) ? "0" : "") + mm + ":" + (ss < 10 ? "0" : "") + ss;
}

function StopTaskTimer() {
    StopTicker(taskTimerCountdown);
}
function StopPopupTaskTimer() {
    timeSpentPopup.SetText("");
    StopTicker(popuptaskTimerCountdown);
}
function StopTicker(countdown) {
    clearInterval(countdown);
}

//Log start time and end time for current screen.
//if flag=1 then log time for popup otherwise log it for screen
function LogTimeForScreen(flag, accountNumberId, tcnId,isUserLoggingOut) {
    //console.log("Flag: " + flag);
    var locationPath, referredUrl, currentScreenName, referrerScreenName, timeSpentOnScreen = 0,eNoteId;
    //get eNoteId if available
    eNoteId = $('#enote_eNoteID').val() != undefined ? $('#enote_eNoteID').val() : '';

    if (flag == 1) {
        timeSpentOnScreen = formatTaskTime(timePopupMultiplier);
    }
    else
        timeSpentOnScreen = formatTaskTime(timeMultiplier);

    locationPath = window.location.pathname;
    referredUrl = document.referrer;

    currentScreenName = locationPath.substring(locationPath.lastIndexOf("/") + 1, locationPath.length);
    referrerScreenName = referredUrl.substring(referredUrl.lastIndexOf("/") + 1, referredUrl.length);

    //jQuery ajax call to log start time and end time for screen
    var routeData =
        {
            currentScreenName: currentScreenName,
            previousScreen: referrerScreenName,
            isPopup: (flag == 1 ? true : false),
            accountNumberId: accountNumberId,
            tcnId: tcnId,
            eNoteId: eNoteId,
            timeSpent: timeSpentOnScreen,
            isUserLoggingOut: isUserLoggingOut,
            trackingInterval: (trackingIntervalTime / 1000)
        };
    $.ajax({
        type: "GET",
        cache: false,
        url: "../TimeTracker/LogTimeForScreen",
        data: routeData,
        success: function (result) {
            if (result != null) {
                //take action after success
            }
        },
        error: function (request, status, error) {
            //log error
        }
    });
}

//Get time spent on particular screen for the current day.
function GetTimeSpentOnScreen(screenName) {
    var locationPath, currentScreenName;
    locationPath = window.location.pathname;
    currentScreenName = locationPath.substring(locationPath.lastIndexOf("/") + 1, locationPath.length);

    //jQuery ajax call to log start time and end time for screen
    $.ajax({
        type: "GET",
        cache: false,
        url: "../TimeTracker/GetSpentTimeOnScreen",
        data: { currentScreenName: currentScreenName },
        success: function (result) {
            if (result != null) {
                //take action after success
            }
        },
        error: function (request, status, error) {
            //log error
        }
    });
}

//Initiate time tracking for particular screen
function OnTimeTrackerInit(flag) {
    var tcnId = $("#TCNIdentificationID").val();
    var accountNumberId = $("#AccountSubmissionDetailsID").val();
    //Get time tracking interval time    
   
    GetTimeTrackingInterval(flag, accountNumberId, tcnId);
    
   
}

//Stop the time tracker logging for particular screen.
function StopTimeTracker(flag) {
    var tcnId = $("#TCNIdentificationID").val();
    var accountNumberId = $("#AccountSubmissionDetailsID").val();
    if (flag==0) {
        clearInterval(logTimerCountdown);
        LogTimeForScreen(flag, accountNumberId, tcnId, false);
    }
    else if (flag == 1) {
        if ($('#hdnTcnId').val() != undefined)
            tcnId = $('#hdnTcnId').val();
        if ($('#hdnAccountNumberId').val() != undefined)
            accountNumberId = $('#hdnAccountNumberId').val();
        StopPopupTaskTimer();   //stop popup ticker
        clearInterval(logTimerPopupCountdown);
        LogTimeForScreen(flag, accountNumberId, tcnId, false);
        timePopupMultiplier = 0;
    }
}   

function GetTimeTrackingInterval(flag, accountNumberId, tcnId) {
    $.ajax({
        url: timeTrackingIntervalUrl,
        type: "GET",
        dataType: 'json',
        success: function (data) {
            trackingIntervalTime = parseInt(data.intervalTime);
            trackingIntervalTime = trackingIntervalTime * 1000; //converting seconds to milliseconds
        },
        complete: function () {
            if (flag == 0)
                logTimerCountdown = window.setInterval(function () { LogTimeForScreen(flag, accountNumberId, tcnId, false); }, trackingIntervalTime);
            else if (flag == 1) {
                // *********** if time tracking is for workilist screen ***********
                if ($('#hdnTcnId').val() != undefined)
                    tcnId = $('#hdnTcnId').val();
                if ($('#hdnAccountNumberId').val() != undefined)
                    accountNumberId = $('#hdnAccountNumberId').val();
                //******************************************************************
                logTimerPopupCountdown = window.setInterval(function () { LogTimeForScreen(flag, accountNumberId, tcnId, false); }, trackingIntervalTime);
            }
            LogTimeForScreen(flag, accountNumberId, tcnId, false);
        }
    });
}


$(document).ready(function () {
    $(window).load(function () {
        OnTimeTrackerInit(0);
    });

    $("#lnkLogOff").click(function (e) {
        e.preventDefault();
        var url = $(this).attr("href");
        var tcnId = $("#TCNIdentificationID").val();
        var accountNumberId = $("#AccountSubmissionDetailsID").val();
        LogTimeForScreen(0, accountNumberId, tcnId, true);
        setTimeout(function () {
            location.href = url;
        }, 2000);
    });
});
