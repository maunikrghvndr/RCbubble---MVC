<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.Master" Inherits="System.Web.Mvc.ViewPage<RISARC.Payment.Model.CreditCardPaymentInfo>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Payment for your Document by Credit Card
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Payment for your Document by Credit Card</h2>
    <p class="Instructions">
        Fill out the necessary payment information to retrieve and download your document.</p>
        <%= Html.ValidationInstructionHeader() %>
    <h3>Review Payment Amount <span>Step 1</span></h3>
    
    <ul>
        <li> <label style="font-weight:bold;padding:10px 0 0 25px;font-size:14px;color:#666;">Total Charge: $<%= Html.Encode(ViewData["RequiredPaymentAmount"]) %></label>
        </li>
    </ul>
    <% using (Html.BeginForm("PayByCreditCard", "Document", 
           new { documentId = Html.Encrypt(ViewData["DocumentId"]) }))
       {%>
       <%= Html.AntiForgeryToken() %>
        <% Html.RenderPartial("CreditCardInfo", Model); %>
    <%} %>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
    <script type="text/javascript" src="<%: Url.Content("~/Scripts/Address.js")%>"></script>
</asp:Content>
