$(document).ready(function() {
    makeDatePickers();
});


function makeDatePickers() {
    var datePickers1 = $(".datepicker");
    // don't allow to type in.  Only accept date entered from date picker
    datePickers1.keydown(function (event) {
        event.preventDefault();
    });
    // Commented by Dnyaneshwar
    //datePickers1.datepicker({ changeMonth: true, changeYear: true});
    // Throws error as every date picker can change month and year by Default.
}
