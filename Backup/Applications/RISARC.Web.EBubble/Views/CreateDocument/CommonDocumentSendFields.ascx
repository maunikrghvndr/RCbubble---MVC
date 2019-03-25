<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Documents.Model.DocumentSend>" %>
<input type="hidden" id="DocumentFileId" name="DocumentFileId" value="<%= Html.Encrypt(Model.DocumentFileId, true) %>" />
<%= Html.Hidden("SentFromProviderId", Model.SentFromProviderId)%>
<%= Html.ErrorMessage(ViewData) %>
<ul>
    <li>
        <label for="BillingMethod" class="setSpace">Select Document Billing Method <span class="ValidationInstructor">*</span></label>
        <% Html.RenderAction<RISARC.Web.EBubble.Controllers.DocumentAdminController>(x => x.DocumentBillingMethodOptions(Model.BillingMethod)); %>
        <%= Html.ValidationMessage("BillingMethodRequired", "Required") %>
        <%= Html.ValidationMessage("WrongBillingMethod", "You can only select Bill To Sender for this provider")%>
    </li>
    <li>
        <label for="Description" class="setSpace">
            Enter Document Description  <span class="redText OtherHide">
                <%--This code is added to check "DescriptionRequired" error in model state,
                    If this error exist that means Document Description is required field
                    Added on 10-Feb-2015
                    Added by Abhishek--%>
            <% var error = ViewData.ModelState["DescriptionRequired"];                                           
               if(error==null) 
               { %>
                    (Optional)
               <%} 
               else 
               { %> 
                    *
               <%} 
            %>
             </span>
            <span class="ValidationInstructor DescriptionValidationInstructor" style="display: none">*</span>
        </label>
        
        <%= Html.StyledTextBox("DocumentDescription", Model.DocumentDescription)%>
        <%= Html.ValidationMessage("DescriptionRequired", "Required")%>
    </li>
    <li>
        <label for="Comments" class="setSpace">Purpose for Sending Document <span class="redText">Minimum 25 characters</span></label>
        <%= Html.TextArea("Comments", Model.Comments, 4, 20 , new {onkeyup="CharCount()"}) %><br />
        <span id="CharCountDisplay"></span>
        <!--%= Html.StyledTextArea("Comments", Model.Comments) %-->
        <div class="clear"></div>
        <%= Html.ValidationMessage("CommentsRequired", "Required") %>
        <%= Html.ValidationMessage("CommentsMinimumLength", "Must contain at least 25 characters") %>
    </li>
    <li>
        <div id="MemNumDiv" style='display: none'>
            <b>Member Number <span class="ValidationInstructor">*</span></b><br />
            <%= Html.StyledTextBox("MemberNumber", Model.MemberNumber)%>
            <%= Html.ValidationMessage("MemberNumberRequired", "Please enter a Member Number")%>
            <%= Html.ValidationMessage("MemberClaimNumberRequired", "A member Number and Claim Number are both required")%>
        </div>

        <div id="ClaimIDDiv" style='display: none'>
            <b>Claim ID <span class="ValidationInstructor">*</span></b><br />
            <%= Html.StyledTextBox("ClaimID", Model.ClaimID)%><div id="DCNstatus"></div>
            <%= Html.ValidationMessage("MemberNumberRequired", "Please enter a Member Number")%>
            <%= Html.ValidationMessage("MemberClaimNumberRequired", "A member Number and Claim Number are both required")%>
        </div>

        <div id="CaseIDDiv" style='display: none'>
            <b>Case ID <span class="ValidationInstructor">*</span></b><br />
            <%= Html.StyledTextBox("CaseID", Model.CaseID)%>
            <%= Html.ValidationMessage("HicNumberRequired", "Please enter a H.I.C Number")%>
            <%= Html.ValidationMessage("NPIMissing", "The file has not been sent. Your NPI has not been registered or is waiting for approval to submit to Palmetto, please check with a RMSe-bubble Support Team Member for status.")%>
            <%= Html.ValidationMessage("HICICNNumberRequired", "A H.I.C Number and the ICN are both required")%>
        </div>

        <%--Modified By Dnyaneshwar--%>
        <%--<div id="HicNumDiv" style='display:none'>
       <b>(Required) H.I.C Number <span class="ValidationInstructor"></span></b><br />
        <%= Html.StyledTextBox("HICNUMBER", Model.HICNumber)%>
         <%= Html.ValidationMessage("HicNumberRequired", "Please enter a H.I.C Number")%>
         <%= Html.ValidationMessage("NPIMissing", "The file has not been sent. Your NPI has not been registered or is waiting for approval to submit to Palmetto, please check with a RMSe-bubble Support Team Member for status.")%>
         <%= Html.ValidationMessage("HICICNNumberRequired", "A H.I.C Number and the ICN are both required")%>
        </div>--%>
        <div id="HicNumDiv" style='display: none'>
            <div id ="HIcNumberDescription"></div>
            <%= Html.StyledTextBox("HICNumber", Model.HICNumber) %>
            <%= Html.ValidationMessage("HIC_NoValidationError") %>
        </div>
        <%--<span id="Span1"></span>--%>
        <%--End Modified--%>
        
        <%--Commented by Dnyaneshwar Showing error message text two times.
        <%= Html.ValidationMessage("CommentsRequired", "Required") %>
        End Commented--%>
        <%--<%= Html.ValidationMessage("CommentsMinimumLength", "Must contain at least 25 characters") %>--%>
    </li>

    <%--Modified By Dnyaneshwar--%>
    <%--<li>
        <a href="#" id="manualACNHolderLINK" name="manualACNHolderLINK" title="Enter Payor Identifier">Enter Payor Identifier</a>
        <label for="ManualACNNumber" id="ManualACNNumberG6" name="ManualACNNumberG6">(Optional) Enter Payor Identifier to manually assign to requested document</label>
        <%= Html.StyledTextBox("ManualACNNumber", Model.ManualACNNumber, 25, null) %>
        <%= Html.ValidationMessage("ClaimNumberRequired", "Claim Number Required")%>
        <%= Html.ValidationMessage("ICNRequired")%>
        <%= Html.ValidationMessage("ICNDCNLengthViolation")%>
        <div class="DCNstatus"></div>
    </li>
    <li <%= String.IsNullOrEmpty(Model.ManualACNNumber) ? "style='display:none'" : "" %> class="manualACNHolder">
        <%= Html.ValidationMessage("ACNTaken", "The Payor Identifier you entered is already taken by another document or request.")%>
        <%= Html.ValidationMessage("ACNInvalidForProvider", "The Payor Identifier you entered is invalid for your provider.")%>
        <%= Html.ValidationMessage("ACNRequired", "The claim number you entered is invalid for your provider.")%>
        <%= Html.ValidationMessage("ClaimNumberRequired", "Please enter a Claim Number")%>
        <%= Html.ValidationMessage("RequestIDRequired", "Please enter the Request ID")%>
    </li>--%>
    <li>
        <div id ="MannualACNNumDIV" style='display: none'>
            <div id="MannualACNDescription"></div>
            <%= Html.StyledTextBox("ManualACNNumber", Model.ManualACNNumber) %>
            <%= Html.ValidationMessage("MannualACNValidationError") %>
            <%= Html.ValidationMessage("CaseIdMinimumLength", "Must be 11 alphanumeric characters.")%>        
        </div>
    </li>
    <%--End Modified--%>
</ul>
<%--Hidden field Related To MannualACN & HIC Validation--%>
<%= System.Web.Mvc.Html.InputExtensions.HiddenFor(Html, model => model.providerDocTypeValidation.DCN_ValidationEnum) %>
<%= System.Web.Mvc.Html.InputExtensions.HiddenFor(Html, model => model.providerDocTypeValidation.HIC_ValidationEnum) %>
<%= System.Web.Mvc.Html.InputExtensions.HiddenFor(Html, model => model.providerDocTypeValidation.ICN_ValidationEnum) %>
<%= System.Web.Mvc.Html.InputExtensions.HiddenFor(Html, model => model.providerDocTypeValidation.CaseID_ValidationEnum) %>
<%= System.Web.Mvc.Html.InputExtensions.HiddenFor(Html, model => model.providerDocTypeValidation.Identifier_ValidationEnum) %>
<%= System.Web.Mvc.Html.InputExtensions.HiddenFor(Html, model => model.providerDocTypeValidation.OrganizationType) %>
<%= System.Web.Mvc.Html.InputExtensions.HiddenFor(Html, model => model.providerDocTypeValidation.ReceivingProvide_OID) %>
<%= System.Web.Mvc.Html.InputExtensions.HiddenFor(Html, model => model.providerDocTypeValidation.Description) %>
<%= System.Web.Mvc.Html.InputExtensions.HiddenFor(Html, model => model.providerDocTypeValidation.HIC_Description) %>
<%--end Here for HiddenFields--%>