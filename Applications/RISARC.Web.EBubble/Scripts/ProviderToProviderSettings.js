$(document).ready(function () {
    $("input[name='DocumentRelatesToPatient']").click(showHidePersonalInformation);
    // invoke click events of selected item to ensure proper state
    $("input[name='DocumentRelatesToPatient']:checked").click();
    //ReviewerForNoPatientIdentification();
    if ($('#SendtoOrgSendButton').length != 0) {
        $('#SendtoOrgSendButton').click(function () {
            enbaleWhileSending();
        });
    }
});

function showHidePersonalInformation() {
    var selectedValue = $(this).val();

    if (selectedValue == 'True') {
        var targetElement = $('.PatientInformationHolder:hidden');
        // get patient identification required radio and copy this value to it
        targetElement.find("input[name='PatientIdentificationVerificationRequired']").val(selectedValue);
        targetElement.fadeIn();
    } else {
        var targetElement = $('.PatientInformationHolder:visible');
        // get patient identification required radio and copy this value to it
        targetElement.find("input[name='PatientIdentificationVerificationRequired']").val(selectedValue);
        targetElement.fadeOut();
        // will make sure all expanders are hidden that could have been opened from check boxes
        ensureExpandedCorrectly();
    }
    ReviewerForNoPatientIdentification();
}

// Added By Dnyaneshwar
function ReviewerForNoPatientIdentification() {
    if ($('#ProviderIsEtar').length != 0 && $('#ProviderIsEtar').val() != 'true' && $('#DocumentRelatesToPatientFalse').is(':checked')) {
        //$('#DocumentReviewerRequiredTrue').attr('checked', 'checked');
        $('#DocumentReviewerRequiredFalse').attr('checked', '');
        $("input[name='DocumentReviewerRequired']:checked").click();
        $("input:radio[name='DocumentReviewerRequired']").attr('disabled', true);
    }
    else {
        $("input:radio[name='DocumentReviewerRequired']").attr('disabled', false);
    }
}

function enbaleWhileSending()
{
    $("input:radio[name='DocumentReviewerRequired']").attr('disabled', false);
}
// End Added