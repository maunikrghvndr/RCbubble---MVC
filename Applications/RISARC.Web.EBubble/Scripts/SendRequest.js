// Add by Michael Bert to stop catching of dropdown list data
$.ajaxSetup ({    
    // Disable caching of AJAX responses    
    cache: false
});

    $(document).ready(function () {
    
    $(".ProvidersMembersDropDown").click(function () {
        var str = "";
        $(".ProvidersMembersDropDown option:selected").each(function () {
            str += $(this).text() + " ";
        });
        $("span").text(str);
    }).trigger('change');
        //var $j = jQuery.noConflict();

        // Commented by Dnyaneshwar "Find of no use"
        //$("#PatientInformation_PatientIdentificationMethods_MedicalRecordNoIdentification_DateOfServiceFrom").datepicker();
        // End Commented.

        //$(".chkBOX").change(CheckSendToEveryOne());
});


// will have required validation instructor appear for document description if 'other' document type is selected
function DisplayRequiredValidatorIfOther() {
    var selectedDocumentType = $(this).val();

    var Prov_ID = $('#ProviderId').val(); 

    // OK Mike Populate All Memebers With This Provider Id and The Typeof Select ID.
    //Call this method for json ProvidersMembersByDocTypeListBox

    // LOAD Members under that Provider Id and UserTypeID


    var MyTargetDropDown = $('.ProvidersMembersDropDown'); //#recipientEmailAddress');
    if (!(selectedDocumentType == null || selectedDocumentType == ''))
    {
        //alert("ProviderId=" + Prov_ID + "   selectedDocumentType=" + selectedDocumentType);

        clearDropDownOptionsAndDisable(MyTargetDropDown, 'Loading...');
        $.get('../CreateDocument/ProvidersMembersListBoxByType', {
            fieldName: MyTargetDropDown.attr('name'),
            emptyOptionText: '-Select-',
            selectedProviderId: Prov_ID, 
            selectedDocumentType: selectedDocumentType
        },loadProviderMembers, 'html');
    }
    else
    {
        //ClearMembersBox();
        clearDropDownOptionsAndDisable(MyTargetDropDown, '-Select Members-');
        MyTargetDropDown.change();
        //break;
    }

    ListTheSelectedUsers();
  //  populateProviderMembersUnderDocType();
}


function SendProviderWide() {
    if ($('#chkSendToEveryOne').attr('checked')) {
    //if ($("#chkSendToEveryOne").val() == 'true') {

        alert("Attention: Your request will be sent to all members under the selected Organization.");
        //jQuery('#recipientEmailAddress').attr('disabled', 'disabled');
        $(".ProvidersMembersDropDown").find("option").attr("selected", false);
        $(".ProvidersMembersDropDown").trigger('change');
        //$("#SelectedRecipientsPanel").hide();
        $("#SelectedRecipientsPanel").slideUp('slow');  
    }
    else {
        $("#SelectedRecipientsPanel").slideDown('slow');
    }
}

function loadProviderMembers(data, textStatus) {
    var elementToPopulate = $('.RecipientEmailHolder');
    elementToPopulate.html(data);

//    var populatedDropDown = $('.ProvidersMembersDropDown');
//    // rebind change event since element was cleared
//    populatedDropDown.change(populateProviderDocumentTypes);
//    // fire its on change event, to update bindings on its child drop downs
//    populatedDropDown.change();
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

function ProcessOnChange()
{
    // return nothing
}


function changeHandler() {
    //$('.ProvidersMembersDropDown').change(ListTheSelectedUsers()).trigger('change');
    ListTheSelectedUsers();
}





function ListTheSelectedUsers() {

    var str = "";

    //var targetDropDown = $('.ProvidersMembersDropDown');
    $(".ProvidersMembersDropDown option:selected").each(function () {
        str += $(this).text() + "<br /> ";
    });
    //$("span").html(str);
    if (str.length > 0) {
        $("#MyRecipientList").html("<ul>" + str + "</ul>");
    }
    else {
        $("#MyRecipientList").html("<p><font color='gray' face='Arial'>You have not selected any recipients, please select one or more members before submitting<br /><br /><b><font color='red'>Note:</font></b>To select more than one member, hold down Ctrl key and select.<br /><br /><b><font color='red'>**</font></b> If recipient is not listed from the document type you selected, please contact your Provider Administrator</font></p>");
       // $("#MyRecipientList").html("<font color=red>You have not selected any recipients, please select one or more members before submitting. Note: To select more than one member, hold down ctrl key and select.</font>");
    }

    // MIKES HACK, reload event, sometihng was not working with jQuery and due to time, this hack for a clearing of click events and a reassigning of a click event produced a second "AFTER CLICK EVENT" that handled the changes in the list box
    /*
    var events = $('".ProvidersMembersDropDown').attr('onclick');
    $('".ProvidersMembersDropDown').removeAttr('onclick');

    $('".ProvidersMembersDropDown').click(function () {
        eval(events);
        alert("We came second");
    })
    */
}


