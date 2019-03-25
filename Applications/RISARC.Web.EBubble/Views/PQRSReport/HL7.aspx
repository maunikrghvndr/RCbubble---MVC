<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<RISARC.Files.Model.HL7Data>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Health-Level-7
</asp:Content>



<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <style type="text/css">
        /*.SearchTable td, tr, th
        {
            border: 1px solid red;
        }*/

        .width250
        {
            width: 200px;
        }

        .width
        {
            width: 135px;
        }

        

    </style>
    <h2>Health Level 7 Report</h2>
    <div class="totalAccount">Select patient from the below list for which to view the report.</div>
  
      <!-- patient info -->
      <div class="worklist_search">
        <div class="underline">
            <div class="subheader">Patient Information</div>
        </div>
        <table>
            <tr>
                <td class="width">First Name: </td>
                <td class="width250"><b><%:Model.PatientFirstName %></b></td>
                <td class="width">Last Name: </td>
                <td class="width250"><b><%:Model.PatientLastName %></b></td>
                <td class="width">Birth Date:</td>
                <td><b><%:Model.PatientDOB %></b></td>
            </tr>
            <tr>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td class="width">Patient Address:</td>
                <td><b><%:Model.PatientAddress %></b></td>
                <td class="width">Patient Address2:</td>
                <td><b><%:Model.Address2 %></b></td>
                <td class="width">City:</td>
                <td><b><%:Model.City %></b></td>
            </tr>
            <tr>
                <td>&nbsp;</td>
            </tr>

            <tr>
                <td class="width">State:</td>
                <td><b><%:Model.State %></b></td>
                <td class="width">Zip Code:</td>
                <td><b><%:Model.ZipCode %></b></td>
                <td class="width">AddressID:</td>
                <td><b><%:Model.AddressID %></b></td>
            </tr>

            <tr>
                <td>&nbsp;</td>
            </tr>

            <tr>
                <td class="width">Patient External ID:</td>
                <td><b><%:Model.PatientExternalID %></b></td>
                <td class="width">Patient Internal ID:</td>
                <td><b><%:Model.PatientInternalID %></b></td>
                <td class="width">Patient Alternate ID:</td>
                <td><b><%:Model.PatientAlternateID %></b></td>

            </tr>

            <tr>
                <td>&nbsp;</td>
            </tr>

            <tr>
                <td class="width">Home Phone No:</td>
                <td><b><%:Model.HomePhoneNo %></b></td>
                <td class="width">Work Phone No:</td>
                <td><b><%:Model.WorkPhoneNo %></b></td>
                <td class="width">EmailAddress:</td>
                <td><b><%:Model.EmailAddress %></b></td>
            </tr>

            <tr>
                <td>&nbsp;</td>
            </tr>

            <tr>
                <td class="width">Sex:</td>
                <td><b><%:Model.PatientSex %></b></td>
                <td class="width">Marital Status:</td>
                <td><b><%:Model.MaritalStatus %></b></td>
                <td class="width">Patient Race:</td>
                <td><b><%:Model.PatientRace %></b></td>
            </tr>

            <tr>
                <td>&nbsp;</td>
            </tr>

            <tr>
                <td class="width">Primary Language:</td>
                <td><b><%:Model.PrimaryLanguage %></b></td>
                <td class="width">SSN Number:</td>
                <td><b><%:Model.SSN %></b></td>
                <td class="width">Contact Method:</td>
                <td><b><%:Model.ContactMethod %></b></td>
            </tr>

            <tr>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td class="width">Ethnic Group:</td>
                <td><b><%:Model.EthnicGroup %></b></td>
                <td class="width">Death Date Time:</td>
                <td><b><%:Model.DeathDateTime %></b></td>
                <td class="width">Death Indicator:</td>
                <td><b><%:Model.DeathDateTime %></b></td>
            </tr>


        </table>
    </div>


    <!-- patient Visit -->
    <div class="worklist_search">
        <div class="underline">
             <div class="subheader">Patient Visit Details</div>
        </div>
        <table>
           

             <tr>
                <td class="width">SetID: </td>
                <td class="width250"><b><%:Model.PatientVisitSetID %></b></td>
                <td class="width">Assigned Patient Location: </td>
                <td class="width250"><b><%:Model.AssignedPatientLocation %></b></td>
                <td class="width">Attending Doctor:</td>
                <td><b><%:Model.AttendingDoctor %></b></td>
            </tr>
            <tr>
                <td>&nbsp;</td>
            </tr>

              <tr>
                <td class="width">Attending Last Name: </td>
                <td class="width250"><b><%:Model.AttendingLastName %></b></td>
                <td class="width">Attending First Name:</td>
                <td><b><%:Model.AttndingFirstName %></b></td>
                  <td class="width">Attending Middle: </td>
                <td><b><%:Model.AttendingMiddle %></b></td>
            </tr>
            <tr>
                <td>&nbsp;</td>
            </tr>

            <tr>
                <td class="width">Attending DoctorID: </td>
                <td class="width250"><b><%:Model.AttendingDoctorID %></b></td>
                <td class="width">Referring Doctor: </td>
                <td><b><%:Model.RefferingDoctor%></b></td>
                 <td class="width">Visit Number: </td>
                <td><b><%:Model.VisitNumber%></b></td>
            </tr>
            <tr>
                <td>&nbsp;</td>
            </tr>
           
             <tr>
                <td class="width">Alternate VisitID: </td>
                <td class="width250"><b><%:Model.AlternateVisitID %></b></td>
               
            </tr>
           
        </table>


    </div>


    <!-- Problems Visit grid -->
    <div class="worklist_search">
        <div class="underline">
             <div class="subheader">Problems</div>
        </div>
         <% Html.RenderPartial("_gvPatientProblems", Model.Problems); %>
    </div>

     <!-- patient Medication grid -->
    <div class="worklist_search">
        <div class="underline">
             <div class="subheader">Medications</div>
        </div>
         <% Html.RenderPartial("_gvPatientMedications", Model.Medications); %>
    </div>


     <!-- patient Directive  --> 
    <div class="worklist_search">
        <div class="underline">
             <div class="subheader">Patient Directive</div>
           
        </div>
         <% Html.RenderPartial("_gvPatientDirective", Model.Directives); %>
    </div>



    <!-- Flow Sheets --> 
    <div class="worklist_search">
        <div class="underline">
             <div class="subheader">Flow sheets</div>
        </div>
        <% Html.RenderPartial("_gvFlowSheets", Model.Flowsheets); %>
    </div>



      <!-- Orders --> 
    <div class="worklist_search">
        <div class="underline">
             <div class="subheader">Orders</div>
        </div>
        <% Html.RenderPartial("_gvOrders", Model.Orders); %>
    </div>


    <!-- Observation Result -->
    <div class="worklist_search">
        <div class="underline">
            <div class="subheader">Observation Result</div>
        </div>
       <% Html.RenderPartial("_gvObservation", Model.ObservationData); %>
    </div>



   
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>

