<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Public.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Contact / Support
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>
        Contact / Support</h2>
    <table class="data_table">
        <tr>
            <td class="headerCell">
                Contact
            </td>
            <td>
                Sales & Marketing Team<br />
                818.953.3020<br />
                Email:
                <%= Html.Mailto("risarc-contact@risarconline.com", "risarc-contact@risarconline.com") %><br />
                <a href="http://www.risarc.com" target="_blank">www.risarc.com</a><br />
                Monday-Friday 8:30a.m.-5:30p.m.(Pacific Time) 
            </td>
        </tr>
    </table>
    <table class="data_table">
        <tr>
            <td class="headerCell">
                Support
            </td>
            <td>
                RISARC Support Team<br />
                            818.953.3020<br />
                            Email: <%= Html.Mailto("risarc-support@risarconline.com", "risarc-support@risarconline.com") %><br />
                <a href="http://www.risarc.com" target="_blank">www.risarc.com</a><br />
                Monday-Friday 8:30a.m.-5:30p.m.(Pacific Time) 
            </td>
        </tr>
    </table>
    <p><strong>RISARC’s Privacy Statement:</strong> The information we collect from you will not be shared with organizations and will only be used for the purpose of providing you with the information you requested. 
    </p>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>
