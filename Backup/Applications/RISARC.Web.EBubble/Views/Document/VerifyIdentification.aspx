<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.Master" Inherits="System.Web.Mvc.ViewPage<RISARC.Documents.Model.PatientIdentification.APatientIdentification>" %>

<%@ Import Namespace="RISARC.Documents.Model.PatientIdentification" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Verify You Are The Proper Recipient Of The Document
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Verify You Are The Proper Recipient Of The Document</h2>
    <p>
        For security purposes, in order to receive this document, you must first verify that you know the information about the patient this document is for.
    </p>
    <%= Html.ValidationInstructionHeader() %>
    <% using (Html.BeginForm("VerifyIdentification", "Document", new { documentId = Html.Encrypt(ViewData["DocumentId"]) }))
       { %>
    <%= Html.AntiForgeryToken() %>
    <%= Html.ValidationMessage("Verification", "We're sorry, but the information you entered did not match the information we have in our system.  Please try again") %>
    <ul>
        <li>
            <label>Please choose how you want to identify the patient</label>
            <%= Html.ValidationMessage("PatientIdentificationRequired", "Required") %>
            <% Html.RenderPartial("~/Views/PatientIdentification/PatientIdentificationOptions.ascx",
                            Model); %>
        </li>
        <li>
            <input type="submit" value="Get Document" />
        </li>
    </ul>
    <%} %>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
    <script type="text/javascript" src="<%: Url.Content("~/Scripts/OptionEnabler.js")%>"></script>

    <link rel="Stylesheet" type="text/css" href="<%: Url.Content("~/Content/custom-theme/jquery-ui-1.7.2.custom.css")%>" />
    <script type="text/javascript" src="<%: Url.Content("~/Scripts/jquery-ui-1.9.2.custom.min.js")%>"></script>
    <script type="text/javascript" src="<%: Url.Content("~/Scripts/LoadDatePickers.js")%>"></script>
</asp:Content>
