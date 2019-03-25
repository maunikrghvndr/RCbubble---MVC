<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.Master" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="RISARC.Documents.Model" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Cancel the Request
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <% string encryptedRequestId = Html.Encrypt(ViewData["RequestId"]); %>
    <h2>
        Cancel Request</h2>
        <p class="Instructions">
            Cancel the request if the document is unavailable.
        </p>
    
    <%= Html.FormStepHeader("Review the Request") %>
    <div class="SubDetails">
    <%System.Web.Mvc.Html.ChildActionExtensions.RenderAction(this.Html, "RequestDetails", "DocumentAdmin", new { requestId = encryptedRequestId }); %>
    </div>
    
        <%= Html.FormStepHeader("Indicate Reason Why to Cancel the Request") %>     
    <%--Approval form--%>
    <%
        using (Html.BeginForm("CancelRequest", "DocumentAdmin"))
      { %>
      <%= Html.AntiForgeryToken() %>
      <%= Html.Hidden("requestId", Html.Encrypt(ViewData["RequestId"])) %>
    <ul>
        <li>
            <label for="reason">Reason to Cancel the Request <span class="ValidationInstructor">*</span></label>
            <%= Html.StyledTextArea("reason", ViewData["Reason"] as string) %>
            <%= Html.ValidationMessage("RejectionReason", "Required") %>
        </li>
        <li>
            <input type="submit" value="Cancel Request" />
        </li>
    </ul>
    <%} %>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>
