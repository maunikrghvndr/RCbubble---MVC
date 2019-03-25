<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<RISARC.Files.Model.Question>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Questions Answers
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2 class="title">Pending Questions</h2>
    <div class="totalAccount">Answer the question’s below</div>
    <input type="hidden" value="<%=ViewData["ClaimID"] %>" id="claimId" name="claimId" />

    <div class="claimInfo ">
        <table style="width: 60%;">
            <tr>
                <td>Claim ID: <b><%=ViewData["ClaimID"] %></b> </td>
                <td>Uploaded On: <b><%=ViewData["UploadedDate"]  %></b></td>
            </tr>
            <tr>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td>Patient: <b><%=ViewData["PatientName"]  %></b></td>
                <td>Provider:<b> <%=ViewData["ProviderName"]  %></b></td>
            </tr>
        </table>
    </div>

    <div class="selectPage"></div>
    <%  using (Html.BeginForm("ChangeFacility", "_QuestionsList"))
        { %>

    <%= Html.Partial("QuestionsCallbackPanel", Model) %>


    <div class="selectPage"></div>
    <div class="viewerActionBtnADetails">
        <div class="floatLeft">
            <%  Html.DevExpress().Button(
                   settings =>
                   {
                       settings.Name = "SubmitQuestion";
                       settings.ControlStyle.CssClass = "orangeBtn SubmitQuestion";
                       settings.Width = Unit.Pixel(80);
                       settings.Text = "Submit";
                       settings.UseSubmitBehavior = false;

                   }).GetHtml();  %>
        </div>
        <div class="floatRight">
            <%  Html.DevExpress().Button(
                   settings =>
                   {
                       settings.Name = "Cancel";
                       settings.ControlStyle.CssClass = "greyBtn ";
                       settings.Width = Unit.Pixel(80);
                       settings.Text = "Cancel";
                       settings.RouteValues = new { Controller = "ChangeFacility", Action = "WorkBucket" };
                   }).GetHtml();  %>
        </div>
    </div>
    <% } // Form Ends  %>
    <div class="BtnFinish" style="display: none">
        <div class="floatLeft">
            <% 
                Html.DevExpress().Button(
                   settings =>
                   {
                       settings.Name = "FinishQuestion";
                       settings.ControlStyle.CssClass = "orangeBtn";
                       settings.Width = Unit.Pixel(80);
                       settings.Text = "Finish";
                       settings.UseSubmitBehavior = true;
                       settings.RouteValues = new { Controller = "ChangeFacility", Action = "WorkBucket", qa = 1, clm = ViewData["ClaimID"] };

                   }).GetHtml();  %>
        </div>
    </div>


</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">

    <script type="text/javascript">

        ////For one Contros
        //function ChangeSubmitToNext() {
        //    var NextQuestionFlag = jQuery(".NextQuestionFlag").val();
        //    if (NextQuestionFlag == "True") {
        //        $("#SubmitQuestion span").html("Next");
        //    } else {
        //        $("#SubmitQuestion span").html("Submit");
        //    }
        //}

        $(function () {


            //// Radio Button Code
            //$('input:radio[name=AnswerId]').change(function () {
            //    var value = this.value;
            //    var questionFlag = value.split(":");
            //    var NextQuestionFlag = questionFlag[1];
            //    if (NextQuestionFlag == "True") {
            //        $("#SubmitQuestion span").html("Next");
            //    } else {
            //        $("#SubmitQuestion span").html("Submit");
            //    }
            //});
            //// Radio Button Code



            // // Call This function ON Rady of DOM
            //  ChangeSubmitToNext();

            $(".SubmitQuestion").click(function () {

                //================================== Coomment box Set ================//
                if ($('#CommentsBox').length > 0) {

                    var CommentsBox = $("#CommentsBox").val();
                    var questionID = jQuery("#questionID").val();

                    if (!cbpQuestionsAnswers.InCallback())
                        cbpQuestionsAnswers.PerformCallback({ qId: questionID, answers: CommentsBox });
                }
                //================================== Coomment box Set ================//

                //================================== Input Value Range ================//
                if ($('#NumericValueRange').length > 0) {

                    var questionID = jQuery("#questionID").val();
                    var NumericValue = $("#NumericValue").val();

                    if (!NumericValue) {
                        alert("Please select value in correct range");
                        return false;
                    } else {
                        if (!cbpQuestionsAnswers.InCallback())
                            cbpQuestionsAnswers.PerformCallback({ qId: questionID, answers: NumericValue });

                    } // else Ends
                }
                //================================== Input Value Range Ends  ================//


                //================================== DatePickar Start ================//
                if ($('#SelectDateValue').length > 0) {

                    var UserSelectDate = SelectDateValue.GetDate(); // Selected Date Object
                    //Make it in required formate and send it to database.
                    var questionID = jQuery("#questionID").val();

                    if (!cbpQuestionsAnswers.InCallback())
                        cbpQuestionsAnswers.PerformCallback({ qId: questionID, answers: UserSelectDate });


                }
                //================================== DatePickar Ends  ================//





                //================================== Redio Button Set ================//
                if ($('#AnswerId').length > 0) {

                    var AnswerId = jQuery("input[name=AnswerId]:checked").val();
                    //Button Text Code Change
                   // var questionFlag = AnswerId.split(":");

                    var questionID = jQuery("#questionID").val();

                    if (!AnswerId) {
                        alert("Please check question's answer.");
                        return false;
                    } else {
                        if (!cbpQuestionsAnswers.InCallback())
                            cbpQuestionsAnswers.PerformCallback({ qId: questionID, aId: AnswerId });
                    } // else Ends 
                }
                //================================== Radio Button Set Ends ================//

                //====================== Combo box values ============================

                if ($('#cmbSelectValue').length > 0) {

                    cmbValue = $("#cmbSelectValue").val();
                    var questionID = jQuery("#questionID").val();

                    if (!cmbValue) {
                        alert("Please select atleast 1 value.");
                        return false;
                    } else {
                        if (!cbpQuestionsAnswers.InCallback())
                            cbpQuestionsAnswers.PerformCallback({ qId: questionID, aId: cmbValue });
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
                $(".viewerActionBtnADetails").hide();
                $(".BtnFinish").show();
            }




        }

        // Begin callback 
        function OnBeginCallback(s, e) {
            //Every time it will change text of submit button to next button or sumit as it is 

            //if ($('.NextQuestionFlag').length > 0) {
            //    ChangeSubmitToNext();
            //}

            //if ($('#AnswerId').length > 0) {
             
            //    // Radio Button Code
            //    $('input:radio[name=AnswerId]').change(function () {
            //        var value = this.value;
            //        var questionFlag = value.split(":");
            //        alert(questionFlag);
            //        var NextQuestionFlag = questionFlag[1];
            //        if (NextQuestionFlag == "True") {
            //            $("#SubmitQuestion span").html("Next");
            //        } else {
            //            $("#SubmitQuestion span").html("Submit");
            //        }
            //    });
            //    // Radio Button Code
            //}

           


        }

        function cmbGetSelectedOptionValue(s, e) {
            $("#cmbSelectValue").val(s.GetValue());

        }


    </script>

</asp:Content>

