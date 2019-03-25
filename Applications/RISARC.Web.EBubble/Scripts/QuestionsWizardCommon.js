$(document).ready(function () {

            $(".SubmitQuestion").click(function () {
                var PatientId = $("#PatientId").val();
                //================================== Coomment box Set ================//
                if ($('#CommentsBox').length > 0) {

                    var CommentsBox = $("#CommentsBox").val();
                    var questionID = jQuery("#questionID").val();

                    if (!cbpQuestionsAnswers.InCallback())
                        cbpQuestionsAnswers.PerformCallback({ PatientId: PatientId, baseQid: questionID, answerValue: CommentsBox });

                   
                }
                //================================== Coomment box Set ================//

                //================================== Input Value Range ================//
                if ($('#NumericValueRange').length > 0) {
                  
                    var questionID = jQuery("#questionID").val();
                    var NumericValue = $("#NumericValueRange_I").val();
                    var foundvalue = NumericValue.substring(0, 4);
                    //this is the case when prepoppulated value if string.
                    if (foundvalue=="From") {
                        alert("Please select value in correct range");
                        return false;
                    } else {
                        if (!cbpQuestionsAnswers.InCallback())
                            cbpQuestionsAnswers.PerformCallback({ PatientId: PatientId, baseQid: questionID, answerValue: NumericValue });
                       
                    } // else Ends
                }
                //================================== Input Value Range Ends  ================//


                //================================== DatePickar Start ================//
                if ($('#SelectDateValue').length > 0) {
                    var UserSelectDate = SelectDateValue.GetDate(); // Selected Date Object
                    var d = new Date(UserSelectDate);
                    var finalDate = (d.getMonth() + 1) + '/' + d.getDate() + '/' + d.getFullYear()
                    //Make it in required formate and send it to database.
                    var questionID = jQuery("#questionID").val();

                    if (!cbpQuestionsAnswers.InCallback())
                        cbpQuestionsAnswers.PerformCallback({ PatientId: PatientId, baseQid: questionID, answerValue: finalDate });
                    

                }
                //================================== DatePickar Ends  ================//


                //================================== Redio Button Set ================//
                if ($('#AnswerId').length > 0) {
                 
                    var AnswerId = $("input[name=AnswerId]:checked").val();
                    var questionID = $("#questionID").val();
                    if (!AnswerId) {
                        alert("Please check question's answer.");
                        return false;
                    } else {
                       
                        var AnswersID = AnswerId.split(":");
                        //take option inside cliked radio button : take control type & accordingly write script.
                        var optionType = $("#attribute_" + AnswersID[0] + " > div.attributeTypeCont .attributeType").val();

                        var selectedOptionId;
                        var attrOptionValue="";
                        var AttrId;
                        switch (optionType) {
                            case "RB": 
                                 selectedOptionId = jQuery("input[name=attrId]:checked").val();
                                 attrOptionValue = selectedOptionId + ": ";
                                break;
                            case "DP": 
                                AttrId = $("#attribute_" + AnswersID[0] + " > div.attributeTypeCont #AttrId").val();
                                var d = new Date(DP.GetDate());
                                var finalDate = (d.getMonth() + 1) + '/' + d.getDate() + '/' + d.getFullYear()
                                attrOptionValue = AttrId + ":" + finalDate;
                                 break;
                            case "IB": 
                                AttrId = $("#attribute_" + AnswersID[0] + " > div.attributeTypeCont #AttrId").val();
                                attrOptionValue = AttrId + ":" + $("#NumericValue");
                                break;

                        }
                       
                        if (!cbpQuestionsAnswers.InCallback())
                            cbpQuestionsAnswers.PerformCallback({PatientId: PatientId, baseQid: questionID, baseOid: AnswersID[0], AttributeOptionValue: attrOptionValue });
                    } // else Ends 
                }
                //================================== Radio Button Set Ends ================//

                //====================== Combo box values ============================

                if ($('#cmbSelectValue').length > 0) {
                   // debugger;
                    //cmbValue = $("#cmbSelectValue").val();
                    cmbValue = cmbSelectValue.GetValue()
                  
                    var questionID = jQuery("#questionID").val();

                    if (!cmbValue) {
                        alert("Please select atleast 1 value.");
                        return false;
                    } else {
                        if (!cbpQuestionsAnswers.InCallback())
                            cbpQuestionsAnswers.PerformCallback({ PatientId: PatientId, baseQid: questionID, baseOid: cmbValue });
                      
                    } // else Ends 
                }

                //====================== Combo box values ends ====================

            }); // Submit ends 

        }); // Ready function ends 


//Collect spin edit value 
function CollectSpinEditValue(s, e) {
    $("#NumericValue").val(s.GetValue());
}


// Callback Panel End Call Back ====
function OnEndCallback(s, e) {
    var questionDesc = $("#questionDesc").val();
    if (typeof (questionDesc) == "undefined") {
        gvViewerGroupStatus.PerformCallback({ patientId: $("#PatientId").val(), isViwer: 1 });
        $(".viewerActionBtnADetails").hide();
        var measure = $("#measureName").val();
        var finalMeasure =  measure.toUpperCase();
        $(".thankyou").html("Questions for the measure <b>" + finalMeasure + "</b> successfully answered.</br></br> Please choose next measure in analysis stage to answer the questions.");
        
        $(".measure-name").html(""); // erased seelectd measure name value.
    }
}

function cmbGetSelectedOptionValue(s, e) {
    $("#cmbSelectValue").val(s.GetValue());
}


