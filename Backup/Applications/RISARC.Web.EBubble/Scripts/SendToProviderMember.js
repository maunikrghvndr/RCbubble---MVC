
// ============================= OptionExpander.js ========================
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


//============================= Ends  Option Expander JS ========================

//========================== ProviderToProviderSettings.js =================
//Code has be merge for performace hit.

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


//========================== ProviderToProviderSettings.js Ends =================



// Add by Michael Bert to stop catching of dropdown list data
$.ajaxSetup ({    
    // Disable caching of AJAX responses    
    cache: false
});

$(document).ready(function () {
   
    $('.ProvidersInNetworkDropDown').change(populateProviderDocumentTypes); //populateProviderMembers);
    
    $("select[name='DocumentTypeId']").change(DisplayRequiredValidatorIfOther).change(); // bind on change event and call change
  
    $('.ProvidersMembersDropDown').change(ListTheSelectedUsers()).keypress(ListTheSelectedUsers());
    // Added By Dnyaneshwar
    if ($('#ReviewerSection').length != 0) {
        $('#ReviewerSection').hide();
    }
    // End Added
});

function changeHandler() {
    ListTheSelectedUsers();
}

function ListTheSelectedUsers() {
   
        var str = "";

        $(".ProvidersMembersDropDown option:selected").each(function () {
            str += $(this).text() + "<br /> ";
        });
      
        if (str.length > 0) {
            $("#MyRecipientList").html("<ul>" + str + "</ul>");
        }
        else {
            $("#MyRecipientList").html("<font color='gray' face='Arial'>You have not selected any recipients, please select one or more members before submitting<br /><b><font color='red'>Note:</font></b>To select more than one member, hold down Ctrl key and select.<br /><br /><b><font color='red'>**</font></b> If recipient is not listed from the document type you selected, please contact your Provider Administrator</font>");
            //old comment "You have not selected any recipients, please select one or more members before submitting.<br /><font color=red><b>Note:</b></font> To select more than one member, hold down ctrl key and select.");
        }


        var events = $('.ProvidersMembersDropDown').attr('onclick');
        $('.ProvidersMembersDropDown').removeAttr('onclick');

        $('.ProvidersMembersDropDown').click(function () {
            eval(events);
           
        })

}

function populateProviderMembers() {
    var selectedVal = $(this).val();
    var targetDropDown = $('.ProvidersMembersDropDown');

    if (selectedVal == '' || selectedVal == null) {
        clearDropDownOptionsAndDisable(targetDropDown, '-Select Provider-');
        targetDropDown.change();
        
    } else {
    
          jQuery.get('../CreateDocument/ProvidersMembersListBoxByType', {
            fieldName: targetDropDown.attr('name'),
            emptyOptionText: '-Select-',
            selectedProviderId: selectedVal,
            selectedDocumentType: 0
        },
        loadProviderMembers, 'html');
    }
     ClearMemebersBox();
}

function ClearMembersBox()
{
    // clear the memebers box when you change provider/defualt to type to defualt
    var MyMemberDropDown = $('.ProvidersMembersDropDown');
    clearDropDownOptionsAndDisable(MyMemberDropDown, 'Select Provider/Facility!');
}


function loadProviderMembers(data, textStatus) {
    var elementToPopulate = $('.RecipientEmailHolder');
    elementToPopulate.html(data);

}

function populateProviderMemberDocumentTypes() {
    var selectedVal = $(this).val();
    var targetDropDown = $('.ProvidersInNetworkDropDown');

    if (selectedVal == '' || selectedVal == null) {
        clearDropDownOptionsAndDisable(targetDropDown, '-Select Provider Member-');
    } else {
        clearDropDownOptionsAndDisable(targetDropDown, 'Loading...');
   
        jQuery.get('../CreateDocument/ProviderDocumentTypesDropDown', {
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
    if ($(this).attr("name")!="recipientEmailAddress")
        {
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
   // debugger;
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

    var Prov_ID = $('.ProvidersInNetworkDropDown').val();

    // OK Mike Populate All Memebers With This Provider Id and The Typeof Select ID.
    //Call this method for json ProvidersMembersByDocTypeListBox


    var MyTargetDropDown = $('.ProvidersMembersDropDown'); 
    if (!(selectedDocumentType == null || selectedDocumentType == ''))
    {
      

        clearDropDownOptionsAndDisable(MyTargetDropDown, 'Loading...');
        $.get('../CreateDocument/ProvidersMembersListBoxByType', 
           {
            fieldName: MyTargetDropDown.attr('name'),
            emptyOptionText: '-Select-',
            selectedProviderId: Prov_ID, 
            selectedDocumentType: selectedDocumentType
            }
        ,loadProviderMembers, 'html');
    }
    else
    {
        ClearMembersBox();
    }

    MyTargetDropDown.trigger('change');
    $(".ProvidersMembersDropDown").click(ListTheSelectedUsers()).trigger('change');
    ListTheSelectedUsers();

}



function populateProviderMembersUnderDocType() {
    var selectedVal = $(this).val();
    var targetDropDown = $('.ProvidersMembersDropDown');
    if (selectedVal == '' || selectedVal == null) {
        clearDropDownOptionsAndDisable(targetDropDown, '-Select Provider-');
        targetDropDown.change();
    } else {
        clearDropDownOptionsAndDisable(targetDropDown, 'Loading...');
        jQuery.get('../CreateDocument/ProvidersMembersListBox', {
            fieldName: targetDropDown.attr('name'),
            emptyOptionText: '-Select-',
            selectedProviderId: selectedVal
        },
        loadProviderMembers, 'html');
        //break;
    }

}
// *********** Reviewer Tree *******************
function GetSelectedReviewer(s, e) {
    s.GetSelectedNodeValues(["UserIndex", "IsProvider"], setValues);
}

function setValues(selectedValues) {
    var ids = selectedValues;
    var selectedIndex;
    for (i = 0; i < ids.length; i++) {
        if (ids[i].length == 2 && ids[i][1] == false) {
            if (selectedIndex == null || selectedIndex.length == 0) {
                selectedIndex = ids[i][0]
            }
            else {
                selectedIndex = selectedIndex + "," + ids[i][0];
            }
        }
    }
    $('#DocumentReviewers').val(selectedIndex);
}
// *********** End Reviewer Tree *******************