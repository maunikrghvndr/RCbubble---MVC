<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Documents.Model.PatientIdentification.PatientIdentificationMethods>" %>
<%@ Import Namespace="RISARC.Documents.Model.PatientIdentification" %>
 <script runat="server">
 
</script>
<ul class="patientIdentifiaction">
     <li>
        <% bool containsAccountId = Model.AccountNumberIdentification != null; %>
        <input type="checkbox" class="input_checkbox expandingOption" name="<%= typeof(AccountNumberIdentification).Name %>" id="AccountNumberIdentification"
        <%= containsAccountId ? "checked='checked'" : "" %> />
<%--        <label for="AccountNumberIdentification">Account Number</label>--%>
   <label for="AccountNumberIdentification" id="AccountNumIdentification">Account Number</label>
        <ul class="expandable" <%= containsAccountId ? "class='enabled'" : "style='display:none'" %>>
            <% Html.RenderPartial("~/Views/PatientIdentification/AccountNumberIdentification.ascx",
                   (Model.AccountNumberIdentification ?? new AccountNumberIdentification()), 
                   ViewData.CloneWithBindingPrefix("AccountNumberIdentification")); %>
        </ul>
    </li>
    <li>
        <% bool conatinsMedicalRecId = Model.MedicalRecordNoIdentification != null; %>
        <input type="checkbox" class="input_checkbox expandingOption" name="<%= typeof(MedicalRecordNoIdentification).Name %>" id="MedicalRecordNoIdentification"
        <%=conatinsMedicalRecId ? "checked='checked'" : "" %> />
        <label for="MedicalRecordNoIdentification">Medical Record Number</label>
        <ul class="expandable" <%= conatinsMedicalRecId ? "class='enabled'" : "style='display:none'" %>>
            <% Html.RenderPartial("~/Views/PatientIdentification/MedicalRecordNoIdentification.ascx",
                   (Model.MedicalRecordNoIdentification ?? new MedicalRecordNoIdentification()),
                   ViewData.CloneWithBindingPrefix("MedicalRecordNoIdentification")); %>
        </ul>
    </li>
  
     <li>
        <% bool containsSSNId = Model.SSNIdentification != null; %>
        <input type="checkbox" class="input_checkbox expandingOption" name="<%= typeof(SSNIdentification).Name %>" id="SSNIdentification"
        <%= containsSSNId ? "checked='checked'" : "" %> />
        <label for="SSNIdentification">Social Security Number</label>
        <ul class="expandable" <%= containsSSNId ? "class='enabled'" : "style='display:none'" %>>
            <% Html.RenderPartial("~/Views/PatientIdentification/SSNIdentification.ascx",
                   (Model.SSNIdentification ?? new SSNIdentification()),
                   ViewData.CloneWithBindingPrefix("SSNIdentification")); %>
</ul>
   </li>
   
        <li>
        <% bool containsDateOfBirthIdentification = Model.DateOfBirthIdentification != null; %>
        <input type="checkbox"  style = "visibility:hidden;" checked ="checked" name="<%= typeof(DateOfBirthIdentification).Name %>" id="DateOfBirthIdentification"
        <%= containsDateOfBirthIdentification ? "checked='checked'" : "" %> />
<%--        <label for="DateOfBirthIdentification">Date Of Birth</label>--%>
        <ul class="expandable" <%= containsDateOfBirthIdentification ? "class='enabled'" : "style='display:true'" %>>
            <% Html.RenderPartial("~/Views/PatientIdentification/DateOfBirthIdentification.ascx",
                   (Model.DateOfBirthIdentification ?? new DateOfBirthIdentification()),
                   ViewData.CloneWithBindingPrefix("DateOfBirthIdentification")); %>
        </ul>
    </li>

  
</ul>
