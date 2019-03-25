function AddInternalNote(s, e) {
    
   

    if (!Validate_InternalNote())
        return false;
    var routData = {
        Note: InternalNoteMemo.GetText(),
        DocumentID: $('#DocumentID').val()
    };
    $.ajax({
        url: '../AccountDetails/AddInternalNote',
        type: 'POST',
        datatype: 'json',
        data: routData,
        cache: false,
        success: function (data) {
            if (data == "Success" && !($('#InternalNoteGrid').length == 0))
                InternalNoteGrid.PerformCallback({ DocumentID: $('#DocumentID').val() });
            InternalNoteMemo.SetText("");
        },
        error: function (data) {
            alert('Something might went wrong!');
        },
        complete: function () {
            RestartExpirationTime();
        },
        autoLoad: true
    });

    //alert(enoteHT);
    //$("#ENoteGrid").css("height", enoteHT);
    //$("#ENoteGrid .dxgvCSD").css("height", enoteHT);
}

function CallbackToInternalNote(values) {
    $('#DocumentID').val(values);
    if ($('#InternalNoteCallbackPanel').length != 0)
        InternalNoteCallbackPanel.PerformCallback({ DocumentID: values });
}

function Validate_InternalNote() {
    if ($('#DocumentID').length != 0) {
        if ($('#DocumentID').val() == null || $('#DocumentID').val() == -1 || $('#DocumentID').val() == 0) {
            alert("Please select a document to add internal note.");
            return false;
        }
    }
    if (document.getElementById('InternalNoteMemo') != null) {
        if (InternalNoteMemo.GetText() == '') {
            alert("Please add note and then click Add.");
            return false;
        }
    }
    return true;
}

