<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/StatusMessage.master"
    Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Document Request Successfully Sent
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StatusContents" runat="server">
    <p class="Instructions">
     Thank you for your request. You will receive an email notification from the Provider/Facility when document is ready for download.
    </p>
    <%--<p>
        Your request has been received.
    </p>--%>
    <%--<p>
        <%= Html.ActionLink("Return to your documents", "MyDocuments", "ViewDocuments")%>
    </p>--%>
    <%--<%= Html.ActionLink("Click here", "MyRequests", "DocumentRequest")%>
        to view your pending requests.--%>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="StatusHeader" runat="server">
    Document Request Successfully Sent
</asp:Content>
