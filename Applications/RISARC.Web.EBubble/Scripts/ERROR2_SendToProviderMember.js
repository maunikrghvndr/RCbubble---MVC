$(document).ready(function () {
    var Prov_ID;
    $('.ProvidersInNetworkDropDown').change(function () {
//        var selectedVal = $(this).val();
//        var targetDropDown = $("select[name='DocumentTypeId']")
//        selectedTypeVal = targetDropDown.val();
//        if ($(this).attr("name") != "recipientEmailAddress") {
//            if (selectedVal == '' || selectedVal == null) {
//                clearDropDownOptionsAndDisable(targetDropDown, "-Select Provider-");
//            } else {
//                clearDropDownOptionsAndDisable(targetDropDown, 'Loading...');
//                jQuery.get('../CreateDocument/UserDocumentTypesDropDown', {
//                    fieldName: targetDropDown.attr('name'),
//                    emptyOptionText: '-Select-',
//                    selectedProviderId: selectedVal,
//                    selectedDocumentType: selectedTypeVal
//                },
//        loadProviderMemberDocumentTypes, 'html');
//            }
        //        }

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
    });






    /*
    $('.ProvidersInNetworkDropDown').change(function () {
        var selectedVal = $(this).val();
        var targetDropDown = $('.ProviderDocumentTypesDropDown');
        selectedTypeVal = targetDropDown.val();
        if ($(this).attr("name") != "recipientEmailAddress") {
            if (selectedVal == '' || selectedVal == null) {
                clearDropDownOptionsAndDisable(targetDropDown, "-Select Provider-");
            } else {
                clearDropDownOptionsAndDisable(targetDropDown, 'Loading...');
                jQuery.get('../CreateDocument/ProvidersMembersByDocTypeListBox', {
                    fieldName: targetDropDown.attr('name'),
                    emptyOptionText: '-Select-',
                    selectedProviderId: selectedVal,
                    selectedDocumentType: selectedTypeVal
                },
        loadProviderMemberDocumentTypes, 'html');
            }
        }
    });
    */
//    var selectedVal = $(this).val();
//    var targetDropDown = $('.ProviderDocumentTypesDropDown');
//    selectedTypeVal = targetDropDown.val();
//    if ($(this).attr("name") != "recipientEmailAddress") {
//        if (selectedVal == '' || selectedVal == null) {
//            clearDropDownOptionsAndDisable(targetDropDown, "-Select Provider-");
//        } else {
//            clearDropDownOptionsAndDisable(targetDropDown, 'Loading...');
//            jQuery.get('../CreateDocument/ProvidersMembersByDocTypeListBox', {
//                fieldName: targetDropDown.attr('name'),
//                emptyOptionText: '-Select-',
//                selectedProviderId: selectedVal,
//                selectedDocumentType: selectedTypeVal
//            },
//        loadProviderMemberDocumentTypes, 'html');
//        }
    //    }
// clean up after testing
    //ProviderDocumentTypesDropDown
    //$('.ProviderDocumentTypesDropDown').change(populateProviderMembers());
    //$("select[name='DocumentTypeId']").change(alert("OK")).change();

    //populateProviderMemberDocumentTypes); //populateProviderMembers);
    // $('.ProviderDocumentTypesDropDown').change('.ProvidersMembersDropDown');
    //populateProviderMemberDocumentTypes);
    $("select[name='DocumentTypeId']").change(DisplayRequiredValidatorIfOther).change(); // bind on change event and call change
});



// mikes Function (string fieldName, string emptyOptionText, short? selectedProviderId ,string selectedUserName, short? selectedDocumentType)
function populateMembersBySelectDocumentTypes(selectedVal, selectedTypeVal) {

    //var selectedVal = 39; // $('.ProvidersInNetworkDropDown').Val();
    //var selectedTypeVal = 15; // $("select[name='DocumentTypeId']").Val();
    //(string fieldName, string emptyOptionText, short? selectedProviderId , short? selectedDocumentType)

    var selectedVal = $(this).val();
    var targetDropDown = $('.ProviderDocumentTypesDropDown');
    selectedTypeVal = targetDropDown.val();
    if ($(this).attr("name") != "recipientEmailAddress") {
        if (selectedVal == '' || selectedVal == null) {
            clearDropDownOptionsAndDisable(targetDropDown, "-Select Provider-");
        } else {
            clearDropDownOptionsAndDisable(targetDropDown, 'Loading...');
            jQuery.get('../CreateDocument/ProvidersMembersByDocTypeListBox', {
                fieldName: targetDropDown.attr('name'),
                emptyOptionText: '-Select-',
                selectedProviderId: selectedVal,
                selectedDocumentType: selectedTypeVal
            },
        loadProviderMemberDocumentTypes, 'html');
        }
    }
}




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
        selectedProviderId: selectedVal }, 
        loadProviderMembers, 'html');
    }
}

function loadProviderMembers(data, textStatus) {
    var elementToPopulate = $('.RecipientEmailHolder');
    elementToPopulate.html(data);
    //var populatedDropDown = $('.ProvidersMembersDropDown');
    // rebind change event since element was cleared
    //populatedDropDown.change(populateProviderMemberDocumentTypes);
    // fire its on change event, to update bindings on its child drop downs
    //populatedDropDown.change();
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
   // var selectedVal = $(this).val(); // Doc Type ID 
    var selectedDocumentType = $(this).val();
    var ProvID = $('.ProvidersInNetworkDropDown :selected').val(); 
    var targetDropDown = $('.ProviderDocumentTypesDropDown');

    selectedTypeVal = targetDropDown.val();
    //if ($(this).attr("name") != "recipientEmailAddress") {
    if (selectedDocumentType == '' || selectedDocumentType == null) {
            clearDropDownOptionsAndDisable(targetDropDown, "-Select Provider-");
        } else {
            clearDropDownOptionsAndDisable(targetDropDown, 'Loading...');
            jQuery.get('../CreateDocument/ProvidersMembersByDocTypeListBox', {
                fieldName: targetDropDown.attr('name'),
                emptyOptionText: '-Select-',
                selectedProviderId: ProvID,
                selectedDocumentType: selectedDocumentType
            },
        loadProviderMemberDocumentTypes, 'html');
       }
    //}

    
    var targetElementToShow = $('.DescriptionValidationInstructor');
    if (selectedDocumentType == '10' || selectedDocumentType == '3' /* hack - id of document type other or report*/)
        targetElementToShow.show();
    else
        targetElementToShow.hide();

   


}