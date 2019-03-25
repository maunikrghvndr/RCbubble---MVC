<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Documents.Model.PatientIdentification.APatientIdentification>" %>
<%@ Import Namespace="RISARC.Documents.Model.PatientIdentification" %>
<%  /// get all available identification options and render only options which are available

    IEnumerable<Type> availableIdentificationOptions = (IEnumerable<Type>)ViewData["AvailableIdentificationOptions"];
    if (availableIdentificationOptions.Count() == null)
        throw new InvalidOperationException("No identification options available for patient.");
    Type selectedIdentificationType = null;
    if (Model != null)
    {
        selectedIdentificationType = Model.GetType();
    }


        // below will render check box list, for each available identification option.  If that is the one currently used,
        // the corresponding radio will be selected and its details expanded.
%>
<ul class="expandableHolder limitwidth">
    <%if (availableIdentificationOptions.Contains(typeof(AccountNumberIdentification)))
      { %>
    <li>
        <input type="radio" class="input_radio enableingOption" name="PatientIdentificationTypeName" value="<%= typeof(AccountNumberIdentification).Name %>" id="AccountNumberIdentification"
            <%= selectedIdentificationType == typeof(AccountNumberIdentification) ? "checked='checked'" : "" %> />
        <label for="AccountNumberIdentification">Account Number</label>
        <ul class="expandable" <%= selectedIdentificationType != typeof(AccountNumberIdentification) ? "class='expanded' style='display:none'" : "" %>>
            <% Html.RenderPartial("~/Views/PatientIdentification/AccountNumberIdentification.ascx",
                   (Model is AccountNumberIdentification ? Model : new AccountNumberIdentification()),
                   ViewData.CloneWithBindingPrefix("AccountNumberIdentification")); %>
        </ul>
    </li>
    <%} %>
    <%if (availableIdentificationOptions.Contains(typeof(MedicalRecordNoIdentification)))
      { %>
    <li>
        <input type="radio" class="input_radio enableingOption" name="PatientIdentificationTypeName" value="<%= typeof(MedicalRecordNoIdentification).Name %>" id="MedicalRecordNoIdentification"
            <%= selectedIdentificationType == typeof(MedicalRecordNoIdentification) ? "checked='checked'" : "" %> />
        <label for="MedicalRecordNoIdentification">Medical Record Number</label>
        <ul class="expandable" <%= selectedIdentificationType != typeof(MedicalRecordNoIdentification) ? "class='expanded' style='display:none'" : "" %>>
            <% Html.RenderPartial("~/Views/PatientIdentification/MedicalRecordNoIdentification.ascx",
                   (Model is MedicalRecordNoIdentification ? Model : new MedicalRecordNoIdentification()),
                   ViewData.CloneWithBindingPrefix("MedicalRecordNoIdentification")); %>
        </ul>
    </li>
    <%} %>
    <%if (availableIdentificationOptions.Contains(typeof(SSNIdentification)))
      { %>
    <li>
        <input type="radio" class="input_radio enableingOption" name="PatientIdentificationTypeName" value="<%= typeof(SSNIdentification).Name %>" id="SSNIdentification"
            <%= selectedIdentificationType == typeof(SSNIdentification) ? "checked='checked'" : "" %> />
        <label for="SSNIdentification">Social Security Number</label>
        <ul class="expandable" <%= selectedIdentificationType != typeof(SSNIdentification) ? "class='expanded' style='display:none'" : "" %>>
            <% Html.RenderPartial("~/Views/PatientIdentification/SSNIdentification.ascx",
                   (Model is SSNIdentification ? Model : new SSNIdentification()),
                   ViewData.CloneWithBindingPrefix("SSNIdentification")); %>
        </ul>
    </li>
    <%} %>
    <%--Added by Guru for DOB verification check--%>
    <%if (availableIdentificationOptions.Contains(typeof(DateOfBirthIdentification)))
    {%>
        <li>
            <input type="radio" class="input_radio enableingOption" name="PatientIdentificationTypeName" value="<%= typeof(DateOfBirthIdentification).Name %>" id="DateOfBirthIdentification"
                <%= selectedIdentificationType == typeof(DateOfBirthIdentification) ? "checked='checked'" : "" %> />
            <label for="DateOfBirthIdentification">Date Of Birth</label>
            <ul class="expandable" <%= selectedIdentificationType != typeof(DateOfBirthIdentification)? "class='expanded' style='display:none'" : "" %>>
                <% Html.RenderPartial("~/Views/PatientIdentification/DateOfBirthIdentification.ascx",
                        (Model is DateOfBirthIdentification ? Model : new DateOfBirthIdentification()),
                        ViewData.CloneWithBindingPrefix("DateOfBirthIdentification")); %>
            </ul>
        </li>
    <%} %>
</ul>