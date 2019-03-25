<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    PatientSummaryReport
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Patient Summary Report</h2>
    <div class="totalAccount">Select patient from the below list for which to view the Summary report.</div>


    <% Html.DevExpress().ComboBox(
                settings =>
                {
                    settings.Name = "PatientDetails";
                    settings.Width = 180;
                    settings.Height = 20;
                    // settings.SelectedIndex = 0;
                    //  settings.Properties.DisplayFormatString = "Select Patient From List";
                    settings.Properties.ValueType = typeof(string);
                    settings.Properties.Items.Add("King James");
                    settings.Properties.Items.Add("Carter John");
                    settings.Properties.Items.Add("Turner Alan");
                    settings.Properties.Items.Add("Elliott Matthew");
                    settings.Properties.ClientSideEvents.ValueChanged = "selectionChanged";
                }
            ).GetHtml();
    %>
    <br />
    <div class="MichaelClark" style="display: none">
        <img src=" <%: Url.Content("~/Images/ACO_GPRO/KingJames.jpg") %> " />
    </div>
    <div class="LavinaDcosta" style="display: none">
        <img src=" <%: Url.Content("~/Images/ACO_GPRO/KingJames.jpg") %> " />
    </div>
    <div class="AnthonyJonathan" style="display: none">
        <img src=" <%: Url.Content("~/Images/ACO_GPRO/KingJames.jpg") %> " />
    </div>
    <div class="MonaDsouza" style="display: none">
        <img src=" <%: Url.Content("~/Images/ACO_GPRO/KingJames.jpg") %> " />
    </div>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
    <script type="text/javascript">
        function selectionChanged(s, e) {
            var patientName = s.GetValue();
            switch (patientName) {
                case "King James": $(".MichaelClark").show(); $(".LavinaDcosta").hide(); $(".AnthonyJonathan").hide(); $(".MonaDsouza").hide();

                    break;
                case "Carter John": $(".LavinaDcosta").show(); $(".MichaelClark").hide(); $(".AnthonyJonathan").hide(); $(".MonaDsouza").hide();
                    break;
                case "Turner Alan": $(".AnthonyJonathan").show(); $(".MichaelClark").hide(); $(".LavinaDcosta").hide(); $(".MonaDsouza").hide();
                    break;
                case "Elliott Matthew": $(".MonaDsouza").show(); $(".MichaelClark").hide(); $(".LavinaDcosta").hide(); $(".AnthonyJonathan").hide();
                    break;

            }
        }


    </script>
</asp:Content>

