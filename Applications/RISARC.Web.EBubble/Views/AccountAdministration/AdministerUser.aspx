<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<RISARC.Membership.Model.RMSeBubbleMembershipUser>" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Administrate User
    <%= Html.Encode(Model.UserName) %>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <% string encryptedUserName = Html.Encrypt(Model.UserName); 
   string usersProviderName = ViewData["ProviderName"] as string;
     object standardUserNameRouteValues = new { emailAddress = encryptedUserName };  
     IEnumerable<string> userRoles = ViewData["UserRoles"] as IEnumerable<string>;
        %>
    <%  Counter rowCounter = new Counter(1); %>
    <h2>
        Administrate User
        <%= Html.Encode(Model.UserName) %></h2>
    <p class="Instructions">
        Edit and assign user’s account</p>
    <h3>
        Account Summary</h3>
    
    <% Html.RenderPartial("~/Views/Account/AccountSummary.ascx", Model); %>

    <%= Html.ActionLink("View User History", "UserHistory", standardUserNameRouteValues) %>
    <br /><br />
    <h4>
        User's Roles:
    </h4>
    <ul>
        <% foreach(var userRole in userRoles){ %>
            <li>
                    <i><%= Html.Encode(userRole) %></i>
                </li>
        <%} %>
    </ul>
    <h3>
        Status Flags</h3>
    <strong><i>
        <% Html.RenderPartial("StatusFlags", Model); %></i></strong>
        <h3>
        Perform Actions On Account
    </h3>
    <% Html.RenderPartial("AdministrativeUserActions", Model); %>
    <% if (Model.ProviderMembership != null)
       { %>
    <h3>Member's Document Types</h3>
    
    <% Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html,"UserDocumentTypesList", "AccountAdministration", new { userName = encryptedUserName, showFormActions = false }); %>
    
    <%= Html.ActionLink("Edit", "EditUserDocumentTypes", new { userName = Html.Encrypt(Model.UserName) })%>
   
  
    <%} 
    

     { %>
    <h3>Member's Patient Document Alpha Assignment</h3>
       
    <%Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html,"ShowUserDocumentPatientAlpha", "AccountAdministration", new { userName = encryptedUserName });  %>

   <%= Html.ActionLink("Edit", "EditUserDocumentPatientAlpha", new { userName = (Model.UserName) })%>
 
    <%} 
    %>
    <h3>
        Personal Information Summary
    </h3>
    <% Html.RenderPartial("~/Views/Account/PersonalInformationDetails.ascx", Model.PersonalInformation); %>
    
    <%--<h3>Perform Actions on Account</h3>--%>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>
