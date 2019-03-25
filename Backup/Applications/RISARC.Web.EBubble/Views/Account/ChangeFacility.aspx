<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<RISARC.Setup.Model.ProviderInfo>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	ChangeFacility
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <p class="Instructions">
        <%= Html.Encode(ViewData.GetValue(GlobalViewDataKey.PageDesc)) %> </p>
        <%= Html.ValidationInstructionHeader() %>
    <%using (Html.BeginForm("ChangeFacility", "Account"))
      { %>
    <h2>ChangeFacility</h2>

        <h3>
        Information about Recipient <span>Step 2</span></h3>
    <ul>
        <li>
            <label for="recipientProviderId">
                Provider to Send Document To<span class="ValidationInstructor">*</span></label>
           <% Html.RenderAction<RISARC.Web.EBubble.Controllers.CreateDocumentController>(drc =>
              drc.ProvidersOtherFacilityDropDown("recipientProviderId", "-Select-", (short?)ViewData["RecipientProviderId"], true)); %>                
       
         <input type="submit" value="Update Provider Information" />
         
<%} %>
           
               
 
            
        </li>
    </ul>
       
           
        </li>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>
