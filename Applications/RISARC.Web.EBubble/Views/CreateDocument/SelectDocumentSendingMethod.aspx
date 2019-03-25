<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Send a Document
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>
        Send a Document</h2>
    <p class="Instructions">
        To send a document, make a selection to which Organization or Individual you are
        sending the document to.
        <br />
        <br />
        A <span class="style1">Non-Organization</span> member is a user or organization
        that is not a member of your RMSe-bubble network (ie: patient, insurance, attorney)
        <br />
        <br />
        A <span class="style1">Member</span> of An Organization are users that are registered
        members of RMSe-bubble network in your organization in which you will have the capability
        to communicate with individual members. (ie: employees in hospital, insurance company)
        <br />
        <br />
        To an <span class="style1">Organization</span> are registered members of the RMSe-bubble
        network. (ie: hospitals, insurances)
    </p>
    <%= Html.ValidationInstructionHeader() %>
    <%--<%=  Session["DocumentFileID"] = null  %>--%>
    <h3>
        Select Who to Send the Document To <span>Step 1</span></h3>
    <% using (Html.BeginForm("SelectDocumentSendingMethod", "CreateDocument"))
       { %>
    <%= Html.ValidationMessage("DocumentSendingMethodRequired", "You must select who to send the document to.")%>
    <ul class="docSendingMethod">
        <li>
            <%= Html.RadioButton("DocumentSendingMethod", "SendToEmail", false, new { Id="SendToEmail", @class = "input_radio" })%>
            <label for="SendToEmail">
                Send Document To Non-Organization Member</label>
        </li>
        <li>
            <%= Html.RadioButton("DocumentSendingMethod", "SendToProviderMember", false, new { Id = "SendToProviderMember", @class = "input_radio" })%>
            <label for="SendToProviderMember">
                Send Document To a Member of an Organization</label>
        </li>
        <li>
            <%= Html.RadioButton("DocumentSendingMethod", "SendToProvider", false, new { Id = "SendToProvider", @class = "input_radio" })%>
            <label for="SendToProvider">
                Send Document To an Organization</label>
        </li>
        <li>
            <input type="submit" value="Continue" onclick = "generalizedShowLoader();" />
        </li>
    </ul>
    <%} %>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
  
</asp:Content>
