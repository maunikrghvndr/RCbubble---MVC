
var checkedIds = [];
var uncheckedIds = [];


var AllRespMemb = [];


var checkUnchecked;
var userNameChecked;
var btnDisableflag = 0;


$(window).load(function () {
    $("#btnSave").addClass("disableOrangeBtn");
})

$(document).ready(function () {
    //On load Support indexOf function for IE < 9 ie. IE8,7
    if (!Array.prototype.indexOf) {
        Array.prototype.indexOf = function (val) {
            return jQuery.inArray(val, this);
        };
    }
});


function CollectAllRespMember(s, e) {
   // alert("we are ready ");
    var rowIndex = s.cpRowIndex; // this is custome JS value send from grid

    if (s.GetChecked()) {
        AllRespMemb.push(rowIndex);
       
    } //if ends 

  //  console.log(AllRespMemb);

}

function ResponsibleMemberCheck(s, e) {
 
    $("#btnSave").removeClass("disableOrangeBtn");
    btnSave.SetEnabled(true);

    var rowIndex = s.cpRowIndex; // this is custome JS value send from grid

    var RespMembCheckdIndex = AllRespMemb.indexOf(rowIndex);

    if (s.GetChecked()) {
        
            if (RespMembCheckdIndex != -1) { // do nothing  
            } else { AllRespMemb.push(rowIndex); }
     } else {
       
        if (RespMembCheckdIndex != -1) { AllRespMemb.splice(RespMembCheckdIndex, 1); } 

    }
   
    $("#ResponsibleMemValues").val(AllRespMemb);
}



function GiveExternalNoteAcess(s, e) {
    // s.GetSelectedFieldValues("UserName;UserIndex", StoreExternalAcessMemb);
    $("#btnSave").removeClass("disableOrangeBtn");
    btnSave.SetEnabled(true);

    //Collect resposible memeber values and put it in hidden filesd 
    //when we are not doing any action on responsible member
    $("#ResponsibleMemValues").val(AllRespMemb);


    var rowIndex = s.cpRowIndex; // this is custome JS value send from grid
    checkUnchecked = s.GetChecked();
    UserAdminTableGrid.GetRowValues(rowIndex, "UserIndex", StoreExternalAcessMemb );

}

function StoreExternalAcessMemb(rowValues) {

    if (checkUnchecked) {
        var indexExsist = uncheckedIds.indexOf(rowValues);
        if (indexExsist != -1) uncheckedIds.splice(indexExsist, 1);
        checkedIds.push(rowValues);
        $("#ExtAcessMemCheck").val(checkedIds);
        $("#ExtAcessMemUnCheck").val(uncheckedIds);
    } else {

        var indexExsist = checkedIds.indexOf(rowValues);
        if (indexExsist != -1)  checkedIds.splice(indexExsist, 1);

        uncheckedIds.push(rowValues);
        $("#ExtAcessMemUnCheck").val(uncheckedIds);
        $("#ExtAcessMemCheck").val(checkedIds);
   }
       
}


function Save(s, e) {
  
    $(".statusMessage").hide();
    adminSavePopup.Show();
}

function Cancel(s, e) {
    $(".statusMessage").hide();
    UserAdminTableGrid.PerformCallback();
    $("#ExtAcessMemCheck").val("");
    $("#ExtAcessMemUnCheck").val("");
    uncheckedIds.splice(0, uncheckedIds.length);
    checkedIds.splice(0, checkedIds.length);
  
}

function popUpCancel() {
    adminSavePopup.Hide();
    $(".statusMessage").hide();
}

function Confirm() {

    var accessUserIndexes = $("#ExtAcessMemCheck").val();
    var deniedUserIndexes = $("#ExtAcessMemUnCheck").val();
    var emailAddresses =  $("#ResponsibleMemValues").val();

    AllRespMemb = []; //clearing array .


    var routedata = { accessUserIndexes: accessUserIndexes, deniedUserIndexes: deniedUserIndexes, emailAddresses: emailAddresses };
    $.ajax({
        type: "POST",
        cache: false,
        datatype: 'json',
        url: "../AccountAdministration/UserAccountSettings?",
        data: routedata,
        success: function (data) { UserAdminTableGrid.PerformCallback(); adminSavePopup.Hide(); $(".statusMessage").show(); },
        error: function (data) {
            alert('Something might went wrong!');
            UserAdminTableGrid.PerformCallback();
        }
    });

   
}
