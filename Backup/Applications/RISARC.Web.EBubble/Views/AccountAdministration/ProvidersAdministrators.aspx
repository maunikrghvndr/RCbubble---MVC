<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<RISARC.Membership.Model.RMSeBubbleMembershipUser>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    <% Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "DisplayProviderName", "Setup", new { eProviderId = Html.Encrypt(ViewData["ProviderIdToAdministrate"]) });  %>'s Administrators
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2><% Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "DisplayProviderName", "Setup", new { eProviderId = Html.Encrypt(ViewData["ProviderIdToAdministrate"]) });  %>'s Administrators</h2>
    <p class="Instructions">
        Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor
        incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud
        exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute
        irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla
        pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia
        deserunt mollit anim id est laborum.
    </p>

    <div class="statusMessage" style="display: none;"></div>
    <div class="error"></div>
    <h4>Organization Document Format</h4>

    <div class="OrignalOrgDocumentFormatTypes">
        <%= Html.Action("OrganizationDocumentFormat", "AccountAdministration",new { providerIdToAdministrate = (short)ViewData["ProviderIdToAdministrate"] }) %>
    </div>
    <div class="OrgDocumentFormatTypes">
    </div>

    <br />
    <%  Html.DevExpress().Button(
                   settings =>
                   {
                       settings.Name = "SaveButton";
                       settings.ControlStyle.CssClass = "AddUserSaveButton";
                       settings.Width = Unit.Pixel(90);
                       settings.Height = 25;
                       settings.Styles.EnableDefaultAppearance = false; //made defult apperance false for applying own styles
                       settings.ControlStyle.Cursor = "pointer";
                       settings.ControlStyle.BackColor = System.Drawing.ColorTranslator.FromHtml("#8CC700");
                       settings.Text = "Save";
                       settings.UseSubmitBehavior = false;
                       settings.ClientSideEvents.Click = "EditProviderDocumentFormatType";
                       // settings.RouteValues = new { Controller = "AccountAdministration", Action = "EditProviderDocumentFormatType", providerId = (short)ViewData["ProviderIdToAdministrate"] };
                   }).GetHtml();
       
    %>

    <br />
    <%= Html.ActionLink("Add New Administrator to Provider", "RegisterProviderAdmin", new { providerIdToAdministrate = (short)ViewData["ProviderIdToAdministrate"] })%>


    <h3>Existing Administrators</h3>

    <table class="data_table">
        <tr>
            <th>Account Email Address</th>
            <th>Name</th>
            <th>Last Activity Date</th>
            <th>Status Flags</th>
            <th>Administrate</th>
        </tr>
        <% Counter counter = new Counter();
           foreach (var user in Model)
           {
               ViewDataDictionary newViewData = new ViewDataDictionary { { "rowIndex", counter.Increment() } };
        %>
        <% Html.RenderPartial("UserAdminRow", user, newViewData); %>
        <%} %>
    </table>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">

    <script type="text/javascript">
        function EditProviderDocumentFormatType(s, e) {

            var DocumentFormatTypesId = OrgDocumentFormatList.GetSelectedValues();

            if (DocumentFormatTypesId == "") {
                $(".error").html("Please select atleast one document format type");
                $(".statusMessage").hide();
                return false;

            }
            $(".error").html("");

            $.ajax({
                url: "<%: Url.Action("EditProviderDocumentFormatType", "AccountAdministration")%>",
                type: 'POST',
                datatype: 'JSON',
                data: "providerId=" + <%: (short)ViewData["ProviderIdToAdministrate"]%> +"&DocumentFormatTypesId=" + DocumentFormatTypesId,
                success: function (data) {
                    $(".statusMessage").html("Organization Document Format Saved Successfully");
                    $(".statusMessage").show();
                },
                error: function (er) {
                    $(".statusMessage").html("Error to save  Organization Document Format");
                    $(".statusMessage").show();
                }

            });
        }

    </script>

</asp:Content>
