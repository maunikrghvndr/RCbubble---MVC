var textSeparator = ";";
var selectedRecipients;
var selectedReviewers;

function AddeNote() {
    if (Validate_eNote()) {
        var eNoteForUserIndexes;
        if (!(selectedRecipients == null || selectedRecipients.length == 0)) {
            eNoteForUserIndexes = selectedRecipients.join(",");
        }
        if (!(selectedReviewers == null || selectedReviewers.length == 0)) {
            if (eNoteForUserIndexes == null || eNoteForUserIndexes.length == 0)
                eNoteForUserIndexes = selectedReviewers.join(",");
            else
                eNoteForUserIndexes = eNoteForUserIndexes + ',' + selectedReviewers.join(",");
        }
        var routData = {
            Note: eNote.GetText(),
            DocumentID: $('#DocumentID').val(),
            RecipientUserIndex: eNoteForUserIndexes,
            responceWithinDays: responseDays.GetText()
        };
        //"<%:(Url.Action("AddeNote","AccountDetails"))%>"
        $.ajax({
            url: '../AccountDetails/AddeNote',
            type: 'POST',
            datatype: 'json',
            data: routData,
            cache: false,
            success: function (data) {
                if (data == "Success" && !($('#ENoteGrid').length == 0))
                    ENoteGrid.PerformCallback();
                selectedRecipients = null;
                selectedReviewers = null;
                if ($('#selectRecipients').length != 0) {
                    selectRecipients.UnselectAll();
                    eNoteRecipients.SetText('');
                }
                if ($('#selectReviewers').length != 0)
                {
                    selectReviewers.UnselectAll();
                    eNoteReviewer.SetText('');
                }
                if ($('#eNote').length != 0)
                    eNote.SetText("");
                if ($('#responseDays').length != 0)
                    responseDays.SetText("");
            },
            error: function (data) {
                alert('Something might went wrong!');
            },
            complete: function () {
                //Reset time remaining
                RestartExpirationTime();
            },
            autoLoad: true
        });
    }
}

function ReplyeNote(s, e) {
    if ($('#DocumentID').length != 0) {
        if ($('#DocumentID').val() == null || $('#DocumentID').val() == -1 || $('#DocumentID').val() == 0) {
            alert("Please select a document to reply e note.");
            return false;
        }
    }

    if ($("#eNoteReply").length != 0) {
        if ($.trim(eNoteReply.GetText()) == '') {
            alert("Please add reply eNote comments and then click Add.");
            return false;
        }
    }
    if ($("#enote_ReplyToeNoteID") != null && $.trim($("#enote_ReplyToeNoteID").val()) == '') {
        alert("Please select note to reply to");
        return false;
    }

    var routData = {
        ReplyToeNoteID: $("#enote_ReplyToeNoteID").val(),
        Note: eNoteReply.GetText(),
        DocumentID: $('#DocumentID').val(),
        Status: StatuscomboBox.GetValue()
    };
    //"<%:(Url.Action("AddeNote","AccountDetails"))%>"
    $.ajax({
        url: '../AccountDetails/AddeNote',
        type: 'POST',
        datatype: 'json',
        data: routData,
        cache: false,
        success: function (data) {
            if (data == "Success") {
                $("#enote_ReplyToeNoteID").val('');
                if ($('#ENoteGridPopUp').length != 0)
                    ENoteGridPopUp.PerformCallback({ eNoteID: getQuryStringValByName('eNoteID'), PopUpEnoteFlag: true });
                selectedRecipients = null;
                selectedReviewers = null;

                if ($('#ENoteGrid').length != 0) {
                    ENoteGrid.CancelEdit();
                }
                eNoteReply.SetText("");
                //EndCallback_ENoteGrid();
            }
        },
        error: function (data) {
            alert('Something might went wrong!');
        },
        autoLoad: true
    });
}


function CallbackToeNote(values) {
    $('#DocumentID').val(values);
    if ($('#eNoteCallbackPanel').length != 0)
        eNoteCallbackPanel.PerformCallback({ DocumentID: values});
}

function ReplyToeNoteIdDetails(values) {
    $('#enote_ReplyToeNoteID').val(values);
}

function EnoteGrid_BeginCallback(s, e) {
    e.customArgs["enote.DocumentID"] = $('#DocumentID').val();
    e.customArgs["enote.eNoteID"] = $('#enote_eNoteID').val();
    //e.customArgs["enote.ReplyToeNoteID"] = $('#enote_ReplyToeNoteID').val();
}

function Enote_CustomButtonClick(s, e) {
    var replyToeNoteID;
    s.StartEditRow(e.visibleIndex);
    replyToeNoteID = s.GetRowKey(e.visibleIndex);
    $("#enote_ReplyToeNoteID").val(replyToeNoteID);
}

function CancelEdit_eNOteGrid(s, e) {
    if ($('#ENoteGrid').length != 0) {
        $("#enote_ReplyToeNoteID").val('');
        ENoteGrid.CancelEdit();
    }
    else if ($('#ENoteGridPopUp').length != 0) {
        $("#enote_ReplyToeNoteID").val('');
        ENoteGridPopUp.CancelEdit();
    }
}

function getQuryStringValByName(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}

function OnReviewerSelectionChanged(listBox, args) {
    ReviewerSelectionChanged(listBox, args);
    UpdateTextReviewer();
}

function ReviewerSelectionChanged(s, e) {
    selectedReviewers = s.GetSelectedValues();
}

function UpdateTextReviewer() {
    var selectedItems = selectReviewers.GetSelectedItems();
    eNoteReviewer.SetText(GetSelectedItemsText(selectedItems));
}

function OnRecipientsSelectionChanged(listBox, args) {
    RecipientSelectionChanged(listBox, args);
    UpdateText();
}

function UpdateText() {
    var selectedItems = selectRecipients.GetSelectedItems();
    eNoteRecipients.SetText(GetSelectedItemsText(selectedItems));
}

function GetSelectedItemsText(items) {
    var texts = [];
    for (var i = 0; i < items.length; i++)
        texts.push(items[i].text);
    return texts.join(textSeparator);
}
function GetValuesByTexts(texts, listbox) {
    var actualValues = [];
    var item;
    for (var i = 0; i < texts.length; i++) {
        item = listbox.FindItemByText(texts[i]);
        if (item != null)
            actualValues.push(item.value);
    }
    return actualValues;
}

function SynchronizeListBoxValues(dropDown, args) {
    selectRecipients.UnselectAll();
    var texts = dropDown.GetText().split(textSeparator);
    var values = GetValuesByTexts(texts, selectRecipients);
    selectRecipients.SelectValues(values);
    UpdateText(); // for remove non-existing texts
}

function SynchronizeListBoxValuesReviewer(dropDown, args) {
    selectReviewers.UnselectAll();
    var texts = dropDown.GetText().split(textSeparator);
    var values = GetValuesByTexts(texts, selectReviewers);
    selectReviewers.SelectValues(values);
    UpdateTextReviewer();
}

function RecipientSelectionChanged(s, e) {
    selectedRecipients = s.GetSelectedValues();
}

function Validate_eNote() {
    var showerror;
    if ((selectedReviewers == null || selectedReviewers.length == 0) && (selectedRecipients == null || selectedRecipients.length ==0))
    {
        showerror = true;
    }
    var selectedUsers = selectedReviewers + selectedRecipients;
    if ($('#DocumentID').length != 0) {
        if ($('#DocumentID').val() == null || $('#DocumentID').val() == -1 || $('#DocumentID').val() == 0) {
            alert("Please select a document to add e note.");
            return false;
        }
    }

    if (showerror) {
        alert("Please select at least one Reviewer or Recipient recipient(s).");
        return false;
    }

    if ($('#eNote').length != 0) {
        if ($.trim(eNote.GetText()) == '') {
            alert("Please add eNote and then click Add.");
            return false;
        }
    }

    if ($('#responseDays').length != 0) {
        if ($.trim(responseDays.GetText()) == '') {
            alert("Please add response within Days and then click Add.");
            return false;
        }
    }


    return true;
}
