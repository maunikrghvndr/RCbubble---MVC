//var sessionActiveUrl = '../User/CheckSessionIsActive';
//var tokenExpirationUrl = '../User/GetTokenExpirationTime';

//token expiraiton is set to 15 minutes.
var time = 60;
var countDown = null;
var expirationTime;
$(function () {
    getTokenExpirationTime();
});
function checkSessionActive() {
    $.post(sessionActiveUrl,
    null,
    sessionActiveResult,
    'json');
}

function getTokenExpirationTime() {
    $.get(tokenExpirationUrl,
    null,
    setExpirationTime,
    'json');
}

function RenewSession() {
    // Renew Session
    $.post(keepSessionAlive);
}

function sessionActiveResult(data, textStatus) {
    var sessionIsActive;

    sessionIsActive = data.sessionIsActive;
    if (!sessionIsActive) {
        StopCountdown();
        window.location = timeOutUrl
    }
}

function setExpirationTime(data, textStatus) {
    
    expirationTime = data.expirationTime;
    time = time * parseInt(expirationTime);
    //start counter
    UpdateTime();
    countDown = window.setInterval(UpdateTime, 1000);
}
//Added by Guru to display remianing time on Dockpanel
function UpdateTime() {
    time = time - 1;
    var timeString;
    if (time >= 0) {

        timeString = formatTime(time);
        if (time <= 120) { // change the color to red
            $("#spTimer").text(timeString).attr("class", "lightRed");
            $("#spTimer").prev().attr("class", "lightRed");
        } else {
            $("#spTimer").text(timeString);
        }
    }
    //stop counter when it reaches to 0
    if (time < 0) {
         StopCountdown();
        window.location = timeOutUrl;
    }
}
function formatTime(time) {
    mm = Math.abs(Math.floor(time / 60));
    ss = Math.floor(time - mm * 60);
    return ((mm < 10) ? "0" : "") + mm + ":" + (ss < 10 ? "0" : "") + ss
}
function StopCountdown() {
    clearInterval(countDown);
}

//Restart token expiration time 
function RestartExpirationTime() {
    StopCountdown();
    time = 60;
    time = time * parseInt(expirationTime);
    //Reset time
    UpdateTime();
    countDown = window.setInterval(UpdateTime, 1000);
}