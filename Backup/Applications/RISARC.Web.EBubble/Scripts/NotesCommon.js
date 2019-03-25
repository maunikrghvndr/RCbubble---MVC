//Internal External and ENote Common Functions

function SetLocalDateNote(s, e, utcDate) {
    var myDate = new Date();
    var timezone = jstz.determine();
    $.ajax({
        url: "../TimeZoneCalculator.ashx?Date=" + utcDate + "&ClientTimeZone=" + (myDate.getTimezoneOffset() / 60),
        cache: false
    }).done(function (data) {
        var DateCreated = new Date(data);
        s.SetText(DateCreated.format("MMMM dd, yyyy"));
    });
}