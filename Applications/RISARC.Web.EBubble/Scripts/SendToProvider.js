//============================ Option Expander ===========================
$(document).ready(function () {
    bindOptionsToExpand();
    ensureExpandedCorrectly();
});


function bindOptionsToExpand() {
    var expandableOptions = $('.expandingOption');
    expandableOptions.click(function () {
        showHideExpandee(this);
    });
}

function ensureExpandedCorrectly() {
    $('.expandingOption').each(function () {
        showHideExpandee(this);
    });
}

function showHideExpandee(senderCheckBox) {

    var expandeeElement = $(senderCheckBox).siblings('.expandable');

    if (senderCheckBox.checked) {
        expandeeElement.fadeIn('fast');
    }
    else
        expandeeElement.hide();
}

//=========================== Option Expander Ends =======================

//============================== ProviderToProviderSettings.js ==============
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

function enbaleWhileSending() {
    $("input:radio[name='DocumentReviewerRequired']").attr('disabled', false);
}
// End Added
//======================== ProviderToProviderSettig ========================

//============================== DocumentReviewere.js =====================
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
//=========================== Document Reviwere ends =====================








$(document).ready(function () {
    generalizedShowLoader();
    $('.ProvidersInNetworkDropDown').off('onChange');
    $('.ProvidersInNetworkDropDown').change(populateProviderDocumentTypes);
    $("select[name='DocumentTypeId']").change(DisplayRequiredValidatorIfOther).change();
    $('.ProviderDocumentTypesDropDown').change(enableDisableObjects(document.getElementById('ProviderIsEtar').value));
    enableDisableObjects(document.getElementById('ProviderIsEtar').value);
    EnableDisableOnChangeDocType(null, false);
    //Initially hide this grid
    if ($('#DocumentReviewerRequiredTrue').is(':checked')) {
        $(".expandCollapse").show();
    } else {
        $(".expandCollapse").hide();
    }

    $("input:radio[name=DocumentReviewerRequired]").click(function () {
        if ($(this).val() == "True") {
            $(".expandCollapse").show(100);
            if (!($('#documentReviewerGrid').length == 0))
                documentReviewerGrid.PerformCallback();
        } else {
            $(".expandCollapse").hide(500);
        }
    }); //input box ends 

    if ($('#SelectedReviewers').length != 0 && $('#SelectedReviewers').val() != '') {
        if (!($('#documentReviewerGrid').length == 0)) {
            var selectedArray = $('#SelectedReviewers').val().split(',');
            documentReviewerGrid.SelectRowsByKey(selectedArray);
        }
    }

    $('#ShowSelectedReviewerOnly').attr("checked", false);;
}); //document ready ends 

function populateProviderDocumentTypes() {
    generalizedShowLoader();
    // Added for OID validation
    $('#ManualACNNumber').val('');
    $('#MannualACNNumDIV').hide();
    $('#HICNumber').val('');
    $('#HicNumDiv').hide();
    // End Added
    ProcessOnChange($(this));
    var selectedVal = $(this).val();
    var targetDropDown = $('.ProviderDocumentTypesDropDown');
    disable($(this));
    if (selectedVal == '' || selectedVal == null) {
        clearDropDownOptionsAndDisable(targetDropDown, "-Select Provider-");
        CustomLoadingPanelHide();
    } else {
        $.when(FillDocTypeDropDown(selectedVal, targetDropDown), GetIsETARProvider(selectedVal, targetDropDown)).done(function () {
            enableDisableObjects($('#ProviderIsEtar').val());
        });
    }
    enable($(this));
}

function FillDocTypeDropDown(selectedVal, targetDropDown) {
    $.ajaxSetup({ cache: false });
    clearDropDownOptionsAndDisable(targetDropDown, 'Loading...');
    return jQuery.get('../CreateDocument/ProviderDocumentTypesDropDown', {
        fieldName: targetDropDown.attr('name'),
        emptyOptionText: '-Select-',
        selectedProviderId: selectedVal,
        selectedDocumentType: 0
    }, loadProviderMemberDocumentTypes, 'html');
}

function GetIsETARProvider(selectedVal, targetDropDown) {
    clearDropDownOptionsAndDisable(targetDropDown, '');
    $.ajaxSetup({ cache: false });
    return $.ajax({
        type: "GET",
        url: "../CreateDocument/GetETARSatatusForProvider",
        cache: false,
        data: { selectedProviderId: selectedVal },
        success: function (data) {
            populateforETAR(data);
        },
        error: function (request, status, error) {
            alert("Something might went wrong.");
        }

    });
}

$(document).ajaxComplete(function () {
    CustomLoadingPanelHide();
});

function populateforETAR(data) {
    if ($('#ProviderIsEtar') != null)
        $('#ProviderIsEtar').val(data);
}
function enableDisableObjects(isETAR) {
    if (String(isETAR) == 'true') {
        if ($('#BillingMethod').length != 0) {
            $('#BillingMethod').val('InvoiceProvider');
            $('#BillingMethod').attr('disabled', true);
        }
        if ($('#AccountNumberIdentification').length != 0) {
            $('#AccountNumberIdentification').attr('checked', 'checked');
            showHideExpandee(document.getElementById('AccountNumberIdentification'));
            $('#AccountNumberIdentification').attr('disabled', true);
        }
        if ($('#DocumentRelatesToPatientTrue').length != 0) {
            $('#DocumentRelatesToPatientTrue').attr('checked', 'checked');
            $("input[name='DocumentRelatesToPatient']:checked").click();
            $('#DocumentRelatesToPatientTrue').attr('disabled', true);
            $('#DocumentRelatesToPatientFalse').attr('disabled', true);
        }


        if ($('#DocumentTypeId').length != 0) {
            $('#DocumentTypeId').attr('disabled', 'disable');
            $('#DocumentTypeId').val(-1);
        }

        //## Commented by surekha for BUG #614 20-Oct-2014
        //if ($('#PatientIdentificationVerificationRequiredTrue').length != 0)
        //{
        //    $('#PatientIdentificationVerificationRequiredFalse').attr('checked', 'checked');
        //    $('#PatientIdentificationVerificationRequiredFalse').attr('disabled', true);
        //    $('#PatientIdentificationVerificationRequiredTrue').attr('disabled', true);
        //}

        if ($('#ReviewerSection').length != 0) {
            $('#ReviewerSection').hide();
        }

        if (!($('#fileUploadGrid').length == 0)) {
            fileUploadGrid.MoveColumn(fileUploadGrid.GetColumnByField('DocumentTypeId').index, fileUploadGrid.GetColumnByField('DocumentTypeId').index);
        }
    }
    else {
        if (!($('#fileUploadGrid').length == 0)) {
            fileUploadGrid.MoveColumn('DocumentTypeId');
        }

        if ($('#BillingMethod').length != 0) {
            $('#BillingMethod').attr('disabled', false);
            //$('#AccountNumberIdentification').attr('checked', false);
            showHideExpandee(document.getElementById('AccountNumberIdentification'));
        }

        if ($('#AccountNumberIdentification').length != 0) {
            $('#AccountNumberIdentification').attr('disabled', false);
        }
        if ($('#DocumentRelatesToPatientTrue').length != 0) {
            $('#DocumentRelatesToPatientTrue').attr('disabled', false);
            $('#DocumentRelatesToPatientFalse').attr('disabled', false);
        }

        //## Commented by surekha for BUG #614 20-Oct-2014
        //if ($('#PatientIdentificationVerificationRequiredTrue').length != 0) {
        //    $('#PatientIdentificationVerificationRequiredTrue').attr('checked', 'checked');
        //    $('#PatientIdentificationVerificationRequiredFalse').attr('disabled', false);
        //    $('#PatientIdentificationVerificationRequiredTrue').attr('disabled', false);
        //}

        if ($('#ReviewerSection').length != 0) {
            $('#ReviewerSection').show();
        }
    }
    $('.ProvidersInNetworkDropDown').attr('disabled', false);
    $('.ProviderDocumentTypesDropDown').change(GetProviderDocTypeValidation);
    CustomLoadingPanelHide();
}

function loadProviderMemberDocumentTypes(data, textStatus) {
    var elementToPopulate = $('.DocumentTypeHolder');
    elementToPopulate.html(data);
    // rebind change event
    elementToPopulate.find('select').change(DisplayRequiredValidatorIfOther).change();
}

function GetProviderDocTypeValidation() {
    try {
        var DocumentTypesID = $(this).val();
        var ProviderId = $("#recipientProviderId").val();
        $.ajax({
            url: '../CreateDocument/GetProviderDocTypeValidation',
            type: 'POST',
            data: JSON.stringify({ DocumentTypesID: DocumentTypesID, ProviderId: ProviderId }),
            dataType: 'json',
            contentType: 'application/json',
            success: function (data) {
                EnableDisableOnChangeDocType(data, true);
            }
        });
    }
    catch (ex) {
        alert("Something might went wrong.");
    }
}


// will have required validtion instructor appear for document description if 'other' document type is selected
function DisplayRequiredValidatorIfOther() {
    var selectedDocumentType = $(this).val();

    var targetElementToShow = $('.DescriptionValidationInstructor');
    var targetElementToHide = $('.OtherHide');

    if (selectedDocumentType == '10' || selectedDocumentType == '3' /* hack - id of document type other or report*/) {

        targetElementToShow.show();
        targetElementToHide.hide(); // Optional word is hide ans * is apppended.
    }
    else {
        targetElementToHide.show();
        targetElementToShow.hide();
    }


}

