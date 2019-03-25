function onChangeDatePicker(e) {
    var datePicker = $("#DatePicker").data("tDatePicker");
//    datePicker.bind('valueChange', function (e) { alert('onChange') });
    $("#DateOfServiceFrom").val(e.value);
}

