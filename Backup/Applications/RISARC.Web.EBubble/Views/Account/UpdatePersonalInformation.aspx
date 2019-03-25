<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<RISARC.Membership.Model.PersonalInformation>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Edit Your Personal Information
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Edit Your Personal Information</h2>
    <p class="Instructions">
       To edit your personal information, locate the fields you want to edit, then select     
       submit changes.
</p>
    
    <%using(Html.BeginForm())
      { %>
    <ul>
    <% 
          Html.RenderPartial("PersonalInformationFields", Model); %>
    <li>
        <input type="submit" value="Submit Changes" />
    </li>
    <%} %>
</ul>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
    <script type="text/javascript" src="<%: Url.Content("~/scripts/Address.js")%>"></script>
</asp:Content>
