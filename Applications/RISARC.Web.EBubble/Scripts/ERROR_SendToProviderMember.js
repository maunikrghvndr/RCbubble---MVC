$(document).ready(function () {
    //$('.ProvidersInNetworkDropDown').change(populateProviderMembers);
    //$('.ProvidersMembersDropDown').change(populateProviderMemberDocumentTypes);
    // Setup 1: Get Document Types after Providers Has Been Selection was changed
    $('.ProvidersInNetworkDropDown').change(populateProviderDocumentTypes);
    //Step 2: Get Members After Documents slection has changed.
    //$("select[name='DocumentTypeId']").change(DisplayRequiredValidatorIfOther).change(); // bind on change event and call change
    $("select[name='DocumentTypeId']").change(populateMembersBySelectDocumentTypes);
   
   
   
   
    //$('.ProviderDocumentTypesDropDown').change(populateProviderMemberDocumentTypes);

    //$('.ProvidersInNetworkDropDown').change(populateProviderDocumentTypes);
    //$("#DocumentTypeId").removeAttr("disabled");


    //$('.ProvidersMembersDropDown').change(populateProviderMemberDocumentTypes);



    function populateProviderMembers() {
        var selectedVal = $(this).val();
        var targetDropDown = $('.ProvidersMembersDropDown');

        if (selectedVal == '' || selectedVal == null) {
            clearDropDownOptionsAndDisable(targetDropDown, '-Select Provider-');
            targetDropDown.change();
        } else {
            //   clearDropDownOptionsAndDisable(targetDropDown, 'Loading...');
            jQuery.get('../CreateDocument/ProvidersMembersListBox', {
                fieldName: targetDropDown.attr('name'),
                emptyOptionText: '-Select-',
                selectedProviderId: selectedVal
            },
        loadProviderMembers, 'html');
        }
    }

    function loadProviderMembers(data, textStatus) {
        // MIKE : This function call the type and stats a infinite loop

        var elementToPopulate = $('.RecipientEmailHolder');
        elementToPopulate.html(data);


        //var populatedDropDown = $('.ProvidersMembersDropDown');
        // rebind change event since element was cleared

        //populatedDropDown.change(populateProviderDocumentTypes);
        // fire its on change event, to update bindings on its child drop downs
        //populatedDropDown.change();

    }

    function populateProviderMemberDocumentTypes() {
        var selectedVal = $(this).val();
        var targetDropDown = $('.ProvidersInNetworkDropDown');

        if (selectedVal == '' || selectedVal == null) {
            clearDropDownOptionsAndDisable(targetDropDown, '-Select Provider Member-');
        } else {
            clearDropDownOptionsAndDisable(targetDropDown, 'Loading...');
            jQuery.get('../CreateDocument/UserDocumentTypesDropDown', {
                //    jQuery.get('../CreateDocument/ProviderDocumentTypesDropDown', {
                fieldName: targetDropDown.attr('name'),
                emptyOptionText: '-Select-',
                selectedUserName: selectedVal,
                selectedDocumentType: 0
            },
        loadProviderMemberDocumentTypes, 'html');
        }
    }


    function populateProviderDocumentTypes() {
        var selectedVal = $(this).val();
        var targetDropDown = $('.ProviderDocumentTypesDropDown');
        if ($(this).attr("name") != "recipientEmailAddress") {
            if (selectedVal == '' || selectedVal == null) {
                clearDropDownOptionsAndDisable(targetDropDown, "-Select Provider-");
            } else {
                clearDropDownOptionsAndDisable(targetDropDown, 'Loading...');
                jQuery.get('../CreateDocument/ProviderDocumentTypesDropDown', {
                    fieldName: targetDropDown.attr('name'),
                    emptyOptionText: '-Select-',
                    selectedProviderId: selectedVal,
                    selectedDocumentType: 0
                },
        loadProviderMemberDocumentTypes, 'html');
            }
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

        //populateProviderMembers();
        //populateProviderMembers();

        //populateProviderMemberDocumentTypes();

        // populateProviderMembers()
        // $('.ProvidersInNetworkDropDown').change(populateProviderMembers);
        // var populatedDropDown = $('.ProvidersMembersDropDown');
        // rebind change event since element was cleared

        // populatedDropDown.change(populateProviderDocumentTypes);
        // fire its on change event, to update bindings on its child drop downs
        // populatedDropDown.change();
        populateMembersBySelectDocumentTypes(selectedVal, selectedDocumentType);


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








    // mikes Function (string fieldName, string emptyOptionText, short? selectedProviderId ,string selectedUserName, short? selectedDocumentType)
    function populateMembersBySelectDocumentTypes(selectedVal, selectedTypeVal) {

        //var selectedVal = 39; // $('.ProvidersInNetworkDropDown').Val();
        //var selectedTypeVal = 15; // $("select[name='DocumentTypeId']").Val();
        //(string fieldName, string emptyOptionText, short? selectedProviderId , short? selectedDocumentType)


        var selectedVal = 39; // $(this).Val();
        //var targetDropDown = $('.ProviderDocumentTypesDropDown');
        //selectedTypeVal = targetDropDown.val();
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

});
