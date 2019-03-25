<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.Master" Inherits="System.Web.Mvc.ViewPage<RISARC.Payment.Model.InvoiceInfo>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Get Invoiced For Document
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Please Enter Your Information Below to get Invoiced for this Document</h2>
    <p class="Instructions">
        Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor
        incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud
        exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute
        irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla
        pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia
        deserunt mollit anim id est laborum.</p>
    <h3>Review Payment Amount <span>Step 1</span></h3>
    
    <ul>
        <label><li> Amount owed: $<%= Html.Encode(ViewData["RequiredPaymentAmount"]) %>
        </li>
        </label>
    </ul>
    <%--<table>
        <tr>
            <td class="headerCell">
               
            </td>
            <td class="headerCell">
               
            </td>
        </tr>
    </table>--%>
    <% using (Html.BeginForm("PayByInvoice", "Document", 
           new { documentId = Html.Encrypt(ViewData["DocumentId"]) }))
       {%>
       <%= Html.AntiForgeryToken() %>
        <%--<%= Html.Hidden(Html.Encrypt(ViewData["DocumentId"])) %>--%>
        <% Html.RenderPartial("InvoiceInfo", Model); %>
    <%} %>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
    <script type="text/javascript" src="<%: Url.Content("~/Scripts/Address.js")%>"></script>
</asp:Content>
