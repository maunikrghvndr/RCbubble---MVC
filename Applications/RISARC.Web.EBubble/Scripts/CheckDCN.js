

//$(document).ready(function () {
    //$("select[name='DocumentTypeId']").change(CheckHIC);

    //$(".ProviderDocumentTypesDropDown").change(alert("Check: HIC AND DCN CHECK")).change();
    //$("select[name='DocumentTypeId']").change(alert("Check: HIC AND DCN CHECK")).change(); //CheckHIC).change();
    //$("form").submit( ValidateDCN()); 


//    $("form").submit(function () {
//        var strDCN = $("#ManualACNNumber").val();

//        if (strDCN.length > 0) {
//            if ((strDCN.length == 15) || (strDCN.length == 14) || (strDCN.length == 13)) {
//                if ($.isNumeric(strDCN) == false) {

//                    alert("DCN ERROR: The DCN entered must be numeric at the length of " + strDCN.length + " charactors.");
//                    //$("form").submit(false);
//                    return false;
//                }
//                else {
//                    return true;
//                }
//            }
//            else if (strDCN.length > 16) {
//                return true;
//            }
//            else {
//                alert("DCN ERROR: Please correct the DCN entered. There might not be enough charactors.");
//                //$("form").submit(false);
//                return false;
//            };
//        }
//        else {
//            return true;
//        }
//    });

    
    // $("#ManualACNNumber").change(CheckMyDCN());
//});

$(document).ready(function () {
    $("form").submit(function (e) {
        //<input type="submit" value="Send Document" />
        var selectedProviderID = $('.ProvidersInNetworkDropDown').val();
        var selectedTypeID = $('.ProviderDocumentTypesDropDown').val();

        //if (selectedProviderID == '15') //&& (selectedTypeID == '12')) {
        //if (e.originalEvent.explicitOriginalTarget.id == "SubmitButton") 
        if (selectedProviderID == "15" || selectedProviderID == "307" || selectedProviderID == "469" || selectedProviderID == "323" || selectedProviderID == "312" || selectedProviderID == "314" || selectedProviderID == "320" || selectedProviderID == "322" || selectedProviderID == "321" || selectedProviderID == "319" || selectedProviderID == "318" || selectedProviderID == "306" || selectedProviderID == "316" || selectedProviderID == "317" || selectedProviderID == "309" || selectedProviderID == "305" || selectedProviderID == "2387" || selectedProviderID == "2393" || selectedProviderID == "299" || selectedProviderID == "304" || selectedProviderID == "307"   || selectedProviderID == "469"   || selectedProviderID == "308" || selectedProviderID == "309" || selectedProviderID == "313" || selectedProviderID == "315" || selectedProviderID == "314" || selectedProviderID == "310" || selectedProviderID == "311" || selectedProviderID == "323" || selectedProviderID == "316" || selectedProviderID == "317") {
            //only check for ADR and REDET
            if (selectedTypeID == "11" || selectedTypeID == "12" || selectedTypeID == "22" || selectedTypeID == "23") {
                if (ValidateDCN() == true) {
                    return true;
                    //If the status above is false continue to prompt the user if they want to submit or not
                    //var ok = confirm('Do you really want to save your data?');
                    //if (ok) {                
                    //   return true;
                }
                else {
                    //Prevent the submit event and remain on the screen
                    e.preventDefault();
                    return false;
                }
            }
        };
    });

    return;
});
 // below will cause all document types drop downs to toggle corresponding validator instructor







//$(".ProviderDocumentTypesDropDown").change(function () {
//    alert("WHY?????");
//})


function ValidateDCN() {
    var strDCN = $("#ManualACNNumber").val();

    var selectedProviderID = $('.ProvidersInNetworkDropDown').val();
    var selectedTypeID = $('.ProviderDocumentTypesDropDown').val();
    var strHIC = $("#HicNumDiv").val();
    if ((selectedProviderID == '15') && (selectedTypeID == '12')) {
        if (selectedTypeID == '12') {
            //show HIC;
            // Process HIC Check HERE
            $("#HicNumDiv").show();
        }
        else {
            $("#HicNumDiv").hide();
        };

        /* alert(strHIC);
        // Check the HIC FIRST if REDET (DocType = 12), other wise proceed to DCN CHECK
        if ((selectedTypeID == '12') && (strHIC == ''))
        {
                      alert("HIC NUMBER ERROR: The HIC NUMBER is a required field.");
                      return false;
        }*/
        //else
        //{
        if (strDCN.length > 0) {
            if ((strDCN.length == 15) || (strDCN.length == 14) || (strDCN.length == 13)) {
                if ($.isNumeric(strDCN) == false) {

                    alert("DCN/ICN ERROR: The DCN/ICN entered must be numeric at the length of " + strDCN.length + " characters.");
                    return false;
                }
                else {
                    return true;
                }
            }
            else if (strDCN.length > 16) {
                return true;
            }
            else {
                alert("DCN/ICN ERROR: Please verify the DCN/ICN entered. There may not be enough characters.");
                return false
            };
        }
        else {
            alert("DCN/ICN ERROR: DCN/ICN Number Required!");
            return false;
        }

        //}

    }
}


 // Under Palmetto and A REDITetermination is selected then HIC # and DCN is required
 //  Palmetto and ADR is selected then only DCN is required, and hide HIC number.
 // this function has been intergrate in common because there was a problem with raising the event. 
function CheckHIC() {

 
    // rules for hic number

    var selectedProviderID = $('.ProvidersInNetworkDropDown').val();
    var selectedTypeID = $('.ProviderDocumentTypesDropDown').val();

    //if ((selectedProviderID == '15') && (selectedTypeID == '12')) {
     if (selectedTypeID == '12') {
            //show HIC;
            // Process HIC Check HERE
            $("#HicNumDiv").show();
        }
        else {
            $("#HicNumDiv").hide();
        };

}
 
function CheckMyDCN() {
    // DCN Check by Michael Bert
    var strDCN = $('#ManualACNNumber').val();
    var selectedProviderID = $('.ProvidersInNetworkDropDown').val();
    var selectedTypeID = $('.ProviderDocumentTypesDropDown').val();

    //if (selectedProviderID == '15') {
    if (selectedProviderID == "368" || selectedProviderID == "367" || selectedProviderID == "15" || selectedProviderID == "307" || selectedProviderID == "469"|| selectedProviderID == "323" || selectedProviderID == "312" || selectedProviderID == "314" || selectedProviderID == "320" || selectedProviderID == "322" || selectedProviderID == "321" || selectedProviderID == "319" || selectedProviderID == "318" || selectedProviderID == "306" || selectedProviderID == "316" || selectedProviderID == "317" || selectedProviderID == "309" || selectedProviderID == "305" || selectedProviderID == "2387" || selectedProviderID == "2393" || selectedProviderID == "299" || selectedProviderID == "304" || selectedProviderID == "307" || selectedProviderID == "469" || selectedProviderID == "308" || selectedProviderID == "309" || selectedProviderID == "313" || selectedProviderID == "315" || selectedProviderID == "314" || selectedProviderID == "310" || selectedProviderID == "311" || selectedProviderID == "323" || selectedProviderID == "316" || selectedProviderID == "317") {

        var strStatus = "OK";
        //alert(strDCN.length);

        if (strDCN.length > 0) {
            //alert(strDCN.length);
            strStatus = "DCN/ICN ERROR: Length Is Incorrect!"
            if ((strDCN.length == 15) || (strDCN.length == 14) || (strDCN.length == 13)) {
                if ($.isNumeric(strDCN) == true) {
                    strStatus = ""; //DCN Number Has A Correct Format.";
                }
                else {
                    strStatus = "DCN/ICN ERROR: DCN/ICN Number Must Be Numeric!";
                }
            }
            else if (strDCN.length > 16) {
                strStatus = ""; //This is Alpha numeric, if greater then 16 (17-23)";
            }
            else {
                strStatus = "DCN/ICN ERROR: DCN/ICN Number Required!";
            };
        };
        if (strStatus.length > 0) {
            //alert(strStatus);
            $('.DCNstatus').html(strStatus);
        };

    };
/*
function ContractorExisting(obj) {
      return $.ajax({
            url:"http://www.bodyhigh.com/Magenta/WebServices/CheckExistingEmailAddress.php", 
            type:"POST", 
            async:false, 
            data: {check:obj.val()}
      }).responseText;
}




    function IsContractor(ContractorID) {

        var Xurl ='ajax/listcontractors.ashx?id=' + $('.ProvidersInNetworkDropDown').val();
        $('#result').load(Xurl, function() { alert('Load was performed.'); });
        // Current contractors
        var arrContractors = ['15', '299', '304', '305', '306', '307', '308', '309', '310', '311', '312', '313', '314', '315', '316', '317', '318', '319', '320', '321', '322', '323', '367', '368',  '379', '469'];
        var resultOfSearch = false;
        for (var i=0; 0 to (arrContractors.length-1); i++)
        { 
            if (arrContractors[i] == ContractorID){resultOfSearch = true};
        }
        return resultOfSearch;
    }
 */
}





