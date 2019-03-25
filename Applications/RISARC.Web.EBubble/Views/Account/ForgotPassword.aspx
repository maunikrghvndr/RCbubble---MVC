<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Public.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Forgot Your Password?
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Forgot Your Password?</h2>
<p class="Instructions">Enter your Email Address to begin the process of resetting your password.</p>
    <%= Html.ValidationInstructionHeader() %>
<%using (Html.BeginForm())
  { %>
<ul>
    <li>
        <label for="emailAddress">Email</label> <%= Html.StyledTextBox("emailAddress", ViewData.GetValue(GlobalViewDataKey.Email), 256, null)%>
        <%= Html.ValidationMessage("NoUserWithEmailAddress", "No user exists with that email address.") %>
    </li>
    <li>
        <input type="submit" value="Continue" />
    </li>
</ul>
<%} %>
    
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>
