<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Documents.Model.DocumentSend>" %>
<% RISARC.Documents.Model.DocumentSettings documentSettings = (RISARC.Documents.Model.DocumentSettings)ViewData["DocumentSettings"]; %>

<div class="lightGery setBottomSpace"><span class="darkGrey">Step 3 - </span>Provide Document Information</div>
<div class="worklist_search">
    <% Html.RenderPartial("CommonDocumentSendFields", Model); %>
    <%= Html.ValidationSummary()  %>
    <ul class="noMargin">
        <li>
            <label class="setSpace">Require release form from recipient? <span class="ValidationInstructor redText">*Can only be set to <i>No</i> if BAA Agreement exists with selected provider</span></label>

            <div class="clsWidth100px">
                <div class="floatLeft">
                    <input type="radio" class="input_radio" name="ReleaseFormsRequired"
                        id="ReleaseFormsRequiredTrue" value="True" <%= documentSettings.ReleaseFormsRequired ? "checked='checked'" : (string)null %> />
                    <label class="floatRight" for="ReleaseFormsRequiredTrue">Yes</label>
                </div>
                <div class="floatRight">
                    <input type="radio" class="input_radio" name="ReleaseFormsRequired"
                        id="ReleaseFormsRequiredFalse" value="False" <%= !documentSettings.ReleaseFormsRequired ? "checked='checked'" : (string)null %> />
                    <label class="floatRight" for="ReleaseFormsRequiredFalse">No</label>
                </div>
            </div>
            <%= Html.ValidationMessage("ReleaseFormsRequiredCannotBeFalse", "Can only be set to No if BAA Agreement exists with your provider and the selected provider.  Please select Yes.") %>
            <div class="FieldInstructions">This will require the recipient of the document to submit release forms in order to receive the document.</div>
        </li>
    </ul>
</div>
<!-- # Step 3  -->
<div class="lightGery setBottomSpace"><span class="darkGrey">Step 4 - </span>Information about Patient this Document Relates To</div>
<div class="worklist_search">
    <ul>
        <li>
            <label>
                Does this document relate to a patient? If more than one patient, select no. <span class="ValidationInstructor">*</span></label>
              <div class="clsWidth100px">
                  <div class="floatLeft">
            <input type="radio" class="input_radio" name="DocumentRelatesToPatient" id="DocumentRelatesToPatientTrue"
                value="True" <%= documentSettings.DocumentRelatesToPatient ? "checked='checked'" : (string)null %> />
            <label class="floatRight" for="DocumentRelatesToPatientTrue">
                Yes</label>
                      </div>
                   <div class="floatRight">
            <input type="radio" class="input_radio" name="DocumentRelatesToPatient" id="DocumentRelatesToPatientFalse"
                value="False" <%= !documentSettings.DocumentRelatesToPatient ? "checked='checked'" : (string)null %> />
            <label class="floatRight" for="DocumentRelatesToPatientFalse">
                No</label>
                       </div>
                  </div>
        </li>
    </ul>
    <div class="PatientInformationHolder" <%= !documentSettings.DocumentRelatesToPatient ? "style='display: none'" : (string)null  %>>
        <% Html.RenderPartial("PatientInformationFields", Model.PatientInformation, ViewData.CloneWithBindingPrefix("PatientInformation")); %>
       <%-- <div class="clear"></div>--%>
         <div class="clear"></div>
        <ul class="noMargin">
            <li>
                <label>
                    Require recipient to verify patient identification? <span class="ValidationInstructor">*</span></label>
                <div class="clsWidth100px">
                     <div class="floatLeft">
                <input type="radio" class="input_radio" name="PatientIdentificationVerificationRequired"
                    id="PatientIdentificationVerificationRequiredTrue" value="True" <%= documentSettings.PatientIdentificationVerificationRequired ? "checked='checked'" : (string)null %> />
                <label class="floatRight" for="PatientIdentificationVerificationRequiredTrue">
                    Yes</label>
                         </div>
                     <div class="floatRight">
                <input type="radio" class="input_radio" name="PatientIdentificationVerificationRequired"
                    id="PatientIdentificationVerificationRequiredFalse" value="False" <%= !documentSettings.PatientIdentificationVerificationRequired ? "checked='checked'" : (string)null %> />
                <label class="floatRight" for="PatientIdentificationVerificationRequiredFalse">
                    No</label>
                         </div>
                    </div>
                <div class="FieldInstructions">This will require the recipient of the document to verify the above patient information in order to receive the document.</div>
            </li>
        </ul>
        <div class="clear"></div>
    </div>
</div>
<!-- .worklist_search Step4 -->
<div id="ReviewerSection">
    <div class="lightGery setBottomSpace"><span class="darkGrey">Step 5 - </span>Review documents before sending.</div>
    <div class="worklist_search">
        <ul class="noMargin">
            <li>
                <label>Do you want to have these documents reviewed before sending to final recipient?<span class="ValidationInstructor">*</span></label>
                <div class="clsWidth100px">
                    <div class="floatLeft">
                        <input type="radio" class="input_radio" name="DocumentReviewerRequired" id="DocumentReviewerRequiredTrue"
                            value="True" <%= documentSettings.DocumentReviewerRequired ? "checked='checked'" : (string)null %> />
                        <label for="DocumentReviewerRequiredTrue" class="floatRight">Yes</label>
                    </div>
                    <div class="floatRight">
                        <input type="radio" class="input_radio" name="DocumentReviewerRequired" id="DocumentReviewerRequiredFalse"
                            value="False" <%= !documentSettings.DocumentReviewerRequired ? "checked='checked'" : (string)null %> />
                        <label for="DocumentReviewerRequiredFalse" class="floatRight">No</label>
                    </div>
                </div>
                <div class="clear"></div>
            </li>
            <li class="expandCollapse">
                    <%= System.Web.Mvc.Html.InputExtensions.HiddenFor(Html, model => model.SelectedReviewers) %>
                 
                    <ul>
                        <li>
                           <label style="float:left;margin-right:10px;">Select Reviewers from the below list</label>
                           <%= Html.CheckBoxFor(model => model.ShowSelectedReviewerOnly, new {onclick = "ApplyFilterForSelected();", style="float:left;" })%>
                           <%= Html.LabelFor(model => model.ShowSelectedReviewerOnly) %>
                        </li>
                    </ul>
                
                
                    <ul class="ReviewersList">
                        <li>
                            <%= Html.Action("DocumentReviewers", "CreateDocument") %>
                            <%= Html.ValidationMessage("DocumentReviewerRequiredRequired")%>
                        </li>
                       <%-- <li>
                            <div style="display:inline-block;">
                            <label style="float:left;margin-right:10px;width:100%;">E-Note<span style="color:red;" >Add E-Note for reviewers</span></label>
                            </div>
                            <% Html.DevExpress().Memo(
                            textarea =>                            {
                                textarea.Name = "DSNote";                                
                                textarea.Width = Unit.Pixel(1000);
                                textarea.Height = 50;
                            }).GetHtml();
                           %>
                        </li>--%>
                    </ul>
               
            </li>
           
        </ul>
    </div>
    <!-- .worklist_search Step 5 -->
</div>







