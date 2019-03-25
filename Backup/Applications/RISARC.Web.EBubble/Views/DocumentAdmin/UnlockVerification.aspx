<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<RISARC.Documents.Model.Document>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Unlock Document
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Unlock Document</h2>
    
    <p class="Instructions">The document of type <i><%= Html.Encode(Model.DocumentTypeName) %></i> is currenctly locked.  Click the button below
    to unlock it.</p>

    <% using(Html.BeginForm("UnlockVerification", "DocumentAdmin", new {documentId = Html.Encrypt(Model.Id)})){ %>
        <%= Html.AntiForgeryToken() %>
        <ul>
            <li>
                <input type="submit" value="Unlock Document" />
            </li>
        </ul>
    <%} %>
    
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>
