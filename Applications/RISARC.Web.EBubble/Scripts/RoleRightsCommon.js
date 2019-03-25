
//===============================  User Roles & Rights All Script ==============================

//============= Add & Edit Roles Validation ===============
$(function () {
    //For Add Edit Role
    $(".AddEditRoleSaveButton").click(function (e) {
        if (!OnSaveClick()) {
            return false;
        } else {
            if ($("#AccessType_I").length > 0) { 
                $('#AccessType_I').removeAttr("disabled")
                AccessType.SetEnabled(true);
            }
            $("#AddEditForm").submit();
            return true;
        }
    });

    //For Add User
    $(".AddUserSaveButton").click(function (e) {

        if (!AddUserSaveClick()) {
            return false;
        } else {
            $("form").submit();
            return true;
        }
    });
})


//function SetEnableOrNot() {
//    alert("disabled");
//    $('#AccessType_I').prop('disabled', true);

//}

function OnSaveClick() {
    
    var checkedVal = $("#all_checkbox_value").val();
    var RoleName = $("#RoleName_I").val();
    var msg = "";

    if (checkedVal.length == 0) {
        msg = "* Please tick at least one right \n\r\n<br>";
    }

    if (RoleName == null || RoleName == 'undefined' || RoleName == '') {
        msg += "* Please enter role name \n\r<br>";
    } else {
          var regex = /^[a-zA-Z_ ]*$/;
          if (!regex.test(RoleName)) msg += "* Role name should contains alphabets and _ only. \n\r<br>";
    }

   

    if (($("#AccessType").length!=0) && ($("#AccessType_I").val()) == "Select access type") {

        msg += "* Please select access type \n\r<br>";

    }


    if (msg.length == 0) {
        return true;
    } else {
        $(".error").html(msg);
        return false;
    }

}// function OnDownClick ends

// Add User Actula Validation 
function AddUserSaveClick() {

    var Email = $("#Email").val();
    var FirstName = $("#PersonalInformation_FirstName").val();
    var LastName = $("#PersonalInformation_LastName").val();
    var msg = "";

    if (Email == null || Email == 'undefined' || Email == '') {
        msg += "* Email should not be blank! \n\r<br>";
    } else {
        regex = /^[a-zA-Z0-9._-]+@([a-zA-Z0-9.-]+\.)+[a-zA-Z0-9.-]{2,4}$/;
        if (!regex.test(Email)) {
            msg += '\n\t* Email should be valid! \n\r\n<br>';
        }

    }

    if (FirstName == null || FirstName == 'undefined' || FirstName == '') {
        msg += "* Please enter first name!  \n\r\n<br>";
    }

    if (LastName == null || LastName == 'undefined' || LastName == '') {
        msg += "* Please enter last name!  \n\r<br>";
    }


    if (msg.length == 0) {
        return true;
    } else {
        $(".error").html(msg);
        msg = "";
        return false;
    }

}



//===================================
function OnGetSelectedRoleName(name) {

    selectedRoleName = name;
}

function OnBeginRolesCallback(s, e) {
    //alert(selectedRoleId + "\n" + selectedRoleName);
    e.customArgs["rolename"] = selectedRoleName;
}
//======================================



//Add New user Time 
var selectedRoleId = "";
var selectedRoleName = "";
function SelectionChanged(s, e) {
    // s.GetSelectedFieldValues("RoleId", OnGetSelectedFieldValues);
    s.GetSelectedFieldValues("RoleName", OnGetSelectedFieldValues);
}

function OnGetSelectedFieldValues(selectedValues) {

    $("#all_checkbox_value").val(selectedValues);
}

function GetSelectUserRoleNames(selectedValues) {
    $("#UserRoleNames").val(selectedValues);
}

//Initail User All Right Should be Displayed Script
function GetDefaultUserRoleId(roleId) {
    $("#RightList").show();  //show rights block.

    $("#current_selected_row").val(roleId);
    RolesList.GetSelectedFieldValues("AccessType", SetAccessType);
    RolesList.GetSelectedFieldValues("RoleName", SetRoleName); //Setting RoleName To Delete
    if ($("#cell_0").html() != '') {//show first row selected 
        $("#cell_0").removeClass("RightArrow").addClass("RightArrowClicked");// hard coded 
    }

    UserRights.PerformCallback({ selectedID: roleId });
}
//+ Rights script ends 


//========= Get & Set Requited Value ON Role Selected On left Side ==========
function RowClick(s, e) {
    selectedRoleId = s.GetRowKey(e.visibleIndex);
    s.GetSelectedFieldValues("AccessType", SetAccessType);
    s.GetSelectedFieldValues("RoleName", SetRoleName); //Setting RoleName To Delete
    //Setting RoleName To Delete

    $("#current_selected_row").val(selectedRoleId);
    //for showing rights block displyed

    $("#RightList").show(); //show rights block.
    UserRights.PerformCallback({ selectedID: selectedRoleId });
    HideValidationError(s, e);
}

function SetRoleName(RoleName) {
    $("#current_selected_rolename").val(RoleName); //Set RoleName here
}

function SetAccessType(AccessType) {
   // debugger;
    $("#selected_access_type").val(AccessType); //Set AccessType here
}

//+++ Role Selecction ends 

//==================== Addition of Role: Roles, Selected Rights Right section ==========
function RolesRightsSelectionChanged(s, e) {
    s.GetSelectedFieldValues("MenuId", OnGetSelectedFieldValues);
}



//====================User Right section ===================
//This function for user rights sections  
//function OnButtonClick(s, e) {
//    s.GetRowValues(e.visibleIndex, "ImageUrl", ShowDocumentsPopup);
//}
//This Function are written in specific file
//function ShowDocumentsPopup(url) {
//    alert(url);
//    $('#docImages').attr('src', url);
//    popupControl.Show();
//}


//* This function is for right info  snap shot showing */ 
function ShowDocumentsPopup(imageUrl) {
  //  debugger;
    if ((imageUrl == null) || (imageUrl == "")) {
        var imgUrl = '../Images/RightsSnapShot/NoImage.jpg'
        $('#docImages').attr('src', imgUrl);
        popupControl.Show();

    } else {
        $('#docImages').attr('src', imageUrl);
        popupControl.Show();
    }
}


function OnBeginCallback(s, e) {     // ASPxCallbackPanel BeginCallback
    e.customArgs["roleid"] = selectedRoleId;
}
//====================end  Right section ===================




/* ===================== Cell Background Color Change ================= 
for handling cell click event for changeing background color
*=====================================================================*/

function OnCellClick(cell, index) {
    var parent = $("#" + cell).parent().parent().parent(); // get table here
  
    //Gold Color.
    $(parent).find("td").not("[id$=" + cell + "]").css("background-color", "#F1F1F1"); //get all cell whose id! = current id
    $(parent).find("td").not("[id$=" + cell + "]").prev().removeClass("whitebg"); //get all cell whose id! = current id

    $("td#" + cell).css("background-color", "#ffffff"); //apply css to cliked cell
    $("td#" + cell).prev().addClass("whitebg");

    $(".CustRolesHeader").css("background-color", "#d4ecee");
//    test commadCol.addClass();


    $("#" + cell).removeClass("RightArrow").addClass("RightArrowClicked");  //Remove class of right arrow & add new class 
    //get all cell whose id! = current id REMOVING  class of that
    $(parent).find("td.RightArrowClicked").not("[id=" + cell + "]").removeClass("RightArrowClicked").addClass("RightArrow");

}

//Currently this function is not in use.
///* ======= IN RoleAndRight Action: Change Right Arrow to orange ==========
//*Change arrow color on Cell Click
//*=====================================================================*/
//function RoleRightsCellClick(cellId, fild) {
//    alert(fild);
//    //THis Id which containes cell value
//    $("[id *= " + cellId + "]").addClass("RightArrowClicked").removeClass("RightArrow");
//    $('td:not("[id *= ' + cellId + ']")').addClass("RightArrow").removeClass("RightArrowClicked");

//}


/* ================= Roles And Rights Action method ================= 
  Edit & Delete link functions  event
*=====================================================================*/
//for edit button clicked validation
function editClick() {
    generalizedShowLoader();

    var accessType = $("#selected_access_type").val();
    var currentVal = $("#current_selected_row").val();
    var LogUser_SuperAdmin = $("#LogUser_Superadmin").val();
  
    if ((currentVal.length == 0)) {
        CustomLoadingPanelHide();
        $(".error").html("* Select at least one role to edit");
        return false;
    } else {

        if (LogUser_SuperAdmin == undefined || LogUser_SuperAdmin ==null) {//Super admin dont have any restrction 
            CustomLoadingPanelHide();
            // Changes for aceess type
            if (accessType == "Public" || accessType == "Protected") {
                 $(".error").html("* You do not have sufficient permission to edit this record.");
                //alert("* You do not have sufficient permission to edit this record.");
                return false;
            }
        }
       
            var editPath = $("#EditPath").val();
            window.location = editPath + "?roleId=" + currentVal;
            return true;


    }
}
//TO Hide the Validation If a New Role is Clicked
function HideValidationError(s, e) {
    $(".error").html("");
    $(".validation-summary-errors").html("");
}
function deleteClick() {
    var accessType = $("#selected_access_type").val();
    var currentVal = $("#current_selected_rolename").val();
   
    var LogUser_SuperAdmin = $("#LogUser_Superadmin").val();

    if ((currentVal.length == 0)) {
        $(".error").html("* Select at least one role to delete");
        return false;
    } else {

        if (LogUser_SuperAdmin == undefined) {//Super admin dont have any restrction 
                if (accessType == "Public" || accessType == "Protected") {
                    $(".error").html("* You do not have sufficient permission to delete this record.");
                    return false;
                }
        }

        var deletePath = $("#DeleteRolePath").val();
        window.location = deletePath + "?roleName=" + currentVal;
        return true;
    }

}//function ends

   

