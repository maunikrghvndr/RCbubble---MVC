<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<RISARC.eTAR.Model.ConfigurationDetails>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Configuration
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Configuration</h2>
    
    <%  if (Convert.ToBoolean( ViewData["Status"]))
       { %>
      <div class="statusMessage">
        Successfully Updated the deadline
    </div>
     <% } %>
    
    
    <% using (Html.BeginForm("DeadlineConfiguration", "AccountDetails", FormMethod.Post))
       { %>

    <div class="configuration">
        <table class="configurationTbl">
            <tr><td><span class="clsGreyText">Deadline in days </span></td><td>&nbsp;</td></tr>
            <tr>
                <td>
                   
                    <%  Html.DevExpress().SpinEditFor(model => model.DeadlineinDays,
                           settings =>
                           {

                               settings.Properties.MinValue = 1;
                               settings.Properties.MaxValue = 30;
                               settings.Properties.NullText = "Select deadline in days";
                               settings.Properties.NumberType = SpinEditNumberType.Integer;
                              // settings.ControlStyle.CssClass = "AllScanedDoc";
                               settings.Width = Unit.Percentage(100);
                               settings.Properties.ButtonStyle.CssClass = "spinBtn";
                           }
                        ).Bind(Model.DeadlineinDays).GetHtml();
                    %>

                </td>
                <td>&nbsp;</td>
                 <td>
                    <% Html.DevExpress().Button(
                                   RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                           settings =>
                           {
                               settings.Name = "DoneButton";
                               settings.Text = "Save";
                               settings.Width = Unit.Percentage(80);
                               
                           })).GetHtml(); %>
                </td>
            </tr>
            
        </table>
    </div>



    <% } %>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
</asp:Content>


