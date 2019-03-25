<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.eTAR.Model.AccountDetailsMain>" %>

<table class="clsWidth720">
    <tr>
        <td class='dxc-padding12Left'>
            <% if (!Model.TCNIdentificationID.HasValue)
               {%>
            <div>
                <span class="lightGeyText">Select TCN to View / Add External Note</span>
                <div class="enote_reply">
                    <% System.Web.Mvc.Html.ChildActionExtensions.RenderAction(Html, "TCNNumberDropDown", "AccountDetails"); %>
                </div>
            </div>
            <% } %>
        </td>
    </tr>
    <tr>
        <td class='dxc-padding12Left'>

            <div class="interMemo">
                <% 
                    Html.DevExpress().Memo(
                                settings =>
                                {
                                    settings.Name = "ExternalNoteMemo";
                                    settings.Width = Unit.Percentage(100);
                                    settings.Height = 28;
                                }).GetHtml();
                %>
            </div>
            <div class="AddButton floatRight">
                <% Html.DevExpress().Button(
                    AddButton =>
                    {
                        AddButton.Name = "ExternalAddButton";
                        AddButton.ControlStyle.HorizontalAlign = HorizontalAlign.Center;
                        AddButton.Width = Unit.Pixel(70);
                        AddButton.Height = 28;
                        AddButton.ControlStyle.CssClass = "greyBtn";
                        AddButton.Text = "Add";
                        AddButton.EnableClientSideAPI = true;
                        AddButton.ClientSideEvents.Click = "AddExternalNote";
                    }).GetHtml();
                %>
            </div>


        </td>


    </tr>
    <tr>
        <td> &nbsp;</td>
    </tr>




    <% System.Web.Mvc.Html.ChildActionExtensions.RenderAction(Html, "ExternalNoteGridCallback", "AccountDetails", new { TCNIdentificationID = Model.TCNIdentificationID, SenderProviderID = Model.SenderProviderID }); %>
</table>
