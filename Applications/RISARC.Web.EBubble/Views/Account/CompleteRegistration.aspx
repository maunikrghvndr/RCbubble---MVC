<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Public.Master" Inherits="System.Web.Mvc.ViewPage<RISARC.Membership.Model.RMSeBubbleMembershipUser>" %>

<asp:Content ID="registerTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Please Complete Your Registration
</asp:Content>
<asp:Content ContentPlaceHolderID="AdditionalHeadContent" ID="additionalHead" runat="server">
    <script type="text/javascript" src="<%: Url.Content("~/scripts/Address.js")%>"></script>
</asp:Content>
<asp:Content ID="registerContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2>
        Please Complete Your Registration</h2>
    <p class="Instructions">
        Complete your registration profile below.</p>
    <%= Html.ValidationInstructionHeader() %>
    <%--<%= Html.ValidationSummary("Account creation was unsuccessful. Please correct the errors and try again.") %>--%>
    <% using (Html.BeginForm("CompleteRegistration", "Account"))
       { %>
    <%= Html.AntiForgeryToken() %>
    <h3>
        Account Information <span>Step 1</span></h3>
    <ul>
        <li>
            <label for="UserName">
                Email
            </label>
            <%= Html.Encode(Model.Email) %>
            <%= Html.Hidden("Email", Model.Email) %>
        </li>
        <% if (ViewData["ProviderName"] != null)
           { %>
        <li>
            <label for="Provider">
                Provider
            </label>
            <%= Html.Encode(ViewData["ProviderName"])%>
        </li>
        <%} %>
        <%--<li>
            <label for="Email">
                Email <span class="ValidationInstructor">*</span></label>
            <%= Html.StyledTextBox("Email", Model.Email) %>
            <%= Html.ValidationMessage("Email")%>
        </li>--%>
    </ul>
    <h3>
        Personal Information <span>Step 2</span></h3>
    <ul>
        <% 
            ViewDataDictionary personalInformationViewData = new ViewDataDictionary();
            personalInformationViewData.SetValue(GlobalViewDataKey.BindingPrefix, "PersonalInformation.");
            personalInformationViewData.ModelState.Merge(ViewData.ModelState);
            Html.RenderPartial("PersonalInformationFields", Model.PersonalInformation, personalInformationViewData); %>
            <li>
            
               <div>
                   <div class="floatLeft">
                         <%= Html.CheckBox("AgreeTerms", (bool)ViewData["AgreeTerms"]) %> 
                   </div>
                   <div class="floatLeft">
                     <label for="AgreeTerms">I accept and understand the <%= Html.ActionLink("Terms and Conditions", "Terms", "Legal", null, new { target = "_blank" }) %></label> 
                   </div>
                    <%= Html.ValidationMessage("AgreeTermsRequired", "You must read and accept Terms and Conditions before completing registration.")  %>
               </div>
            
            </li>
        <li>
            <br />
            <div class="clear"></div>
            <input type="submit" value="Complete Registration" />
        </li>
    </ul>
    <% } %>
</asp:Content>
