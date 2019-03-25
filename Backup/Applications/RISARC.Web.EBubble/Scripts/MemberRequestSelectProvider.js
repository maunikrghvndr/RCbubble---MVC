$(document).ready(function () {
    $('.ProvidersInNetworkDropDown').change(populateProviderMembers);
 });

function populateProviderMembers() {
    var selectedVal = $(this).val();
    var targetDropDown = $('.ProvidersMembersDropDown');

    if (selectedVal == '' || selectedVal == null) {
        clearDropDownOptionsAndDisable(targetDropDown, '-Select Provider-');
        targetDropDown.change();
    } else {
        clearDropDownOptionsAndDisable(targetDropDown, 'Loading...');
        jQuery.get('../CreateDocument/ProvidersMembersDropDown', {
            fieldName: targetDropDown.attr('name'),
            emptyOptionText: '-Select-',
            selectedProviderId: selectedVal
        },
        loadProviderMembers, 'html');
    }
}
function ProcessOnChange(DrpDwnID)
{
 
 
}
function loadProviderMembers(data, textStatus) {
    var elementToPopulate = $('.RecipientEmailHolder');
    elementToPopulate.html(data);
    var populatedDropDown = $('.ProvidersMembersDropDown');
    // rebind change event since element was cleared
    populatedDropDown.change(populateProviderMemberDocumentTypes);
    // fire its on change event, to update bindings on its child drop downs
    populatedDropDown.change();
}

function populateProviderMemberDocumentTypes() {
    var selectedVal = $(this).val();
    var targetDropDown = $('.UserDocumentTypesDropDown');

    if (selectedVal == '' || selectedVal == null) {
        clearDropDownOptionsAndDisable(targetDropDown, '-Select Provider Member-');
    } else {
        clearDropDownOptionsAndDisable(targetDropDown, 'Loading...');
        jQuery.get('../CreateDocument/UserDocumentTypesDropDown', {
            fieldName: targetDropDown.attr('name'),
            emptyOptionText: '-Select-',
            selectedUserName: selectedVal,
            selectedDocumentType: 0
        },
        loadProviderMemberDocumentTypes, 'html');
    }
}

function loadProviderMemberDocumentTypes(data, textStatus) {
    var elementToPopulate = $('.DocumentTypeHolder');
    elementToPopulate.html(data);
    // rebind change event
    elementToPopulate.find('select').change(DisplayRequiredValidatorIfOther).change();
}

// will have required validation instructor appear for document description if 'other' document type is selected
function DisplayRequiredValidatorIfOther() {
    var selectedDocumentType = $(this).val();
    var targetElementToShow = $('.DescriptionValidationInstructor');
    if (selectedDocumentType == '10' || selectedDocumentType == '3' /* hack - id of document type other or report*/)
        targetElementToShow.show();
    else
        targetElementToShow.hide();

}