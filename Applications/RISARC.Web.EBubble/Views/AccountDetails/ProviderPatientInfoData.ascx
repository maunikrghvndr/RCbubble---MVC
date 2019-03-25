<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.eTAR.Model.AccountDetailsMain>" %>

<div class="ProviderPatientInfo">
    <div class="floatLeft ProviderInfo ">

        <table class="TBProvider">
            <%--  <tr><th colspan="4" class="clsBorderBottom font14">ProviderInfo</th></tr>--%>
            <tr>
                <td colspan="4">&nbsp;</td>
            </tr>
            <tr>
                <td class="clsBold">Provider Name</td>
                <td class="clsBold">Phone</td>
                <td class="clsBold">Fax</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td><%= Model.providerinformation.Name %></td>
                <td><%= Model.providerinformation.ContactPhone %></td>
                <td><%= Model.providerinformation.Fax %></td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td colspan="4">&nbsp;</td>
            </tr>
            <tr>
                <td class="clsBold">Street/Mailing Address</td>
                <td class="clsBold">City</td>
                <td class="clsBold">State</td>
                <td class="clsBold">Zip Code</td>
            </tr>
            <tr>
                <td><%= Model.providerinformation.StreetAddress %></td>
                <td><%= Model.providerinformation.City %></td>
                <td><%= Model.providerinformation.State %></td>
                <td><%= Model.providerinformation.Zip %></td>
            </tr>

            <tr>
                <td colspan="4">&nbsp;</td>
            </tr>
            <tr>
                <td class="clsBold">Contact Name</td>
                <td class="clsBold">Contact Phone #</td>
                <td class="clsBold">Contact Extension</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td><%= Model.providerinformation.ContactName %></td>
                <td><%= Model.providerinformation.AlternateContactPhone %></td>
                <td><%= Model.providerinformation.ContactExtension %></td>
                <td>&nbsp;</td>
            </tr>

        </table>

    </div>
    <div class="floatRight PatientInfo">
        <table class="TBPPatient">
            <%-- <tr><th colspan="4" class="clsBorderBottom font14">PatientInfo</th></tr>--%>
            <tr>
                <td colspan="4">&nbsp;</td>
            </tr>
            <tr>
                <td class="clsBold">Patient First Name</td>
                <td class="clsBold">Patient Last Name</td>
                <td class="clsBold">Date of Birth</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td><%= Model.patientInformation.PatientFirstName %></td>
                <td><%= Model.patientInformation.PatientLastName %></td>
                <td><%= Model.patientInformation.DateOfBirth %></td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td colspan="4">&nbsp;</td>
            </tr>
            <tr>
                <td class="clsBold">Gender</td>
                <td class="clsBold">Phone #</td>
                <td class="clsBold">Worker’s Comp?</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td><%= Model.patientInformation.Gender %></td>
                <td><%= Model.patientInformation.Phone %></td>
                <td><%= Model.patientInformation.WorkerComp %></td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
        </table>
    </div>
</div>



