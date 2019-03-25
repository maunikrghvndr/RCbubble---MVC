<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Request a Document
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<h2>
        Request a Document</h2>
    <p class="Instructions">
        To request a document, select an organization from the drop down list that is in your RMSe-bubble network.</p>
        <%= Html.ValidationInstructionHeader() %>
        <%using (Html.BeginForm("MemberRequestSelectProvider", "CreateDocument"))
      { %>
    <ul>
        <li>
            <label>
               Select Organization to Request a Document from <span class="ValidationInstructor">*</span></label>
            <% Html.RenderAction<RISARC.Web.EBubble.Controllers.CreateDocumentController>(drc =>
                       drc.ProvidersInNetworkDropDown("ProviderToRequestFromId", "-Select-", null, false,false)); %>
            <%= Html.ValidationMessage("ProviderIdRequired", "Required") %>
        </li>
        <li>
            <input type="submit" value="Continue" />
        </li>
    </ul>
       
    <%} %>

     
    
    <script language="javascript">
        function ProcessOnChange() {
            return true;
        }

    </script>
       <%--<script type="text/javascript" src="<%: Url.Content("~/scripts/SendToProviderMember.js")%>"></script>--%>
   <%-- <script type="text/javascript" src="<%: Url.Content("~/Scripts/ProviderToProviderSettings.js")%>"></script>--%>
    
<%--    <script type="text/javascript" src="<%: Url.Content("~/Scripts/FileUploader.js")%>"></script>--%>
   <%-- <script type="text/javascript" src="<%: Url.Content("~/Scripts/OptionExpander.js")%>"></script>--%>
     
</asp:Content>



<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">

</asp:Content>
