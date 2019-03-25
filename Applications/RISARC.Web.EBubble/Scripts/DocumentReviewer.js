// *********** Reviewer Grid *******************
function OnReviewerGridSelectionChanged(s, e) {
    s.GetSelectedFieldValues("ProviderId", GetSelectedFieldValuesCallback);
}

function GetSelectedFieldValuesCallback(selectedValues) {
    $('#SelectedReviewers').val(selectedValues);
}

function OnReviewerGridBeginCallback(s, e) {
    if ($('#DocumentReviewerRequiredTrue').is(':checked')) {
        e.customArgs["DocumentReviewerRequired"] = true;
    }
    else {
        e.customArgs["DocumentReviewerRequired"] = false;
    }
}

function ApplyFilterForSelected() {
    var filterTex = '';
    if ($('#documentReviewerGrid').length != 0) {
        if ($('#ShowSelectedReviewerOnly').length != 0 && $('#ShowSelectedReviewerOnly').is(':checked')) {
            filterText = "[ProviderId] IN (" + $('#SelectedReviewers').val() + ")";
            documentReviewerGrid.ApplyFilter(filterText);
        }
        else {
            documentReviewerGrid.ClearFilter();
        }
    }
}
// *********** End Reviewer Grid *******************