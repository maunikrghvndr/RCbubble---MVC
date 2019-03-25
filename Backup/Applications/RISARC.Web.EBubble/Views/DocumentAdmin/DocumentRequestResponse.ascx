<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Documents.Model.DocumentRequestResponse>" %>
<input type="hidden" id="DocumentFileId" name="DocumentFileId" value="<%= Html.Encrypt(Model.DocumentFileId, true) %>" />
<%= Html.Hidden("DocumentRequestId", Model.DocumentRequestId) %>
<%= Html.ValidationMessage("DocumentFileId", "You must upload a document first") %>
<%= Html.ErrorMessage(ViewData) %>
<ul>
    <li>
    <label for="BillingMethod">
        Document Billing Method <span class="ValidationInstructor">*</span></label>
        
        <% Html.RenderAction<RISARC.Web.EBubble.Controllers.DocumentAdminController>(x => x.DocumentBillingMethodOptions(Model.BillingMethod)); %>
    
        <%= Html.ValidationMessage("BillingMethodRequired", "Required") %>
    </li>
    <%--<li>
        <label for="DocumentName">
            Document Name <span class="ValidationInstructor">*</span></label>
        <%= Html.StyledTextBox("DocumentName", Model.DocumentName) %>
        <%= Html.ValidationMessage("DocumentNameRequired", "Required")%>
    </li> --%>
    <%--<li>
        <label for="NumberOfPages">
            Number Of Pages in Document, if Document can be Broken into Pages</label>
        <%= Html.StyledTextBox("NumberOfPages", Model.NumberOfPages, 4, "numbersonly") %>
        <%= Html.ValidationMessage("NumberOfPagesRequired", "Required") %>
        <div class="FieldInstructions">
            This will determine how the document is billed. If number is entered, user will
            be billed based on number of pages. Otherwise, if left blank, user will be billed
            based on file size.</div>
    </li>--%>
    <li>
        <label for="Comments">
            Comments</label>
        <%= Html.StyledTextArea("Comments", Model.Comments) %>
    </li>
    <li>
        <input type="submit" value="Respond To Request" />
    </li>
</ul>
