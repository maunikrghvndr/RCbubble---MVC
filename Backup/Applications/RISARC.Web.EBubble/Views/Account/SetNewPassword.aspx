<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Public.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	New Password Required
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>You Must Provide a New Password</h2>
    <p class="Instructions">
            Please confirm your password that was emailed to you and then create a new one. Next time you login, you must use your new password.
</p>
        <h3>Set Your New Password</h3>
        <%= Html.ValidationMessage("ChangePassword") %>
        <%using (Html.BeginForm("SetNewPassword", "Account"))
          {%>
            <%= Html.AntiForgeryToken() %>
            <%= Html.Hidden("emailAddress", ViewData.GetValue(GlobalViewDataKey.Email))%>
            <%= Html.Hidden("ReturnUrl", ViewData.GetValue(GlobalViewDataKey.ReturnUrl)) %>
            <ul>
                <% Html.RenderPartial("ChangePasswordFields"); %>
                <% Html.RenderPartial("PasswordQuestionAnswerFields"); %>
                <li>
                    <input type="submit" value="Set New Password" />
                </li>
            </ul>
          <%
          } %>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>
