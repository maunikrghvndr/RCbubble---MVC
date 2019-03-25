<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.eTAR.Model.AccountDetailsMain>" %>

<%
    @Html.DevExpress().PopupControl(settings =>
    {
        settings.Name = "OpenProviderPatientInfoPopup";
        settings.CloseAction = CloseAction.OuterMouseClick;
       // It shows collapse button on header of popup
        settings.PopupElementID = "DownArrow"; // Image Id On which click popup will display.

        settings.Styles.Header.BackColor = System.Drawing.ColorTranslator.FromHtml("#595959");
        settings.Styles.Header.ForeColor = System.Drawing.ColorTranslator.FromHtml("#FFFFFF");
        settings.Styles.Header.Paddings.Padding = 5;
            
        //settings.PopupVerticalAlign = PopupVerticalAlign.Below;
        //settings.PopupHorizontalAlign = PopupHorizontalAlign.LeftSides;

        settings.ShowCloseButton = true;

        settings.PopupHorizontalAlign = PopupHorizontalAlign.LeftSides;
        settings.PopupVerticalAlign = PopupVerticalAlign.Below;
        settings.PopupVerticalOffset = 10;
        settings.ControlStyle.CssClass = "providerPatientCls";

        settings.Styles.Header.BackColor = System.Drawing.ColorTranslator.FromHtml("#595959");
        settings.Styles.Header.ForeColor = System.Drawing.ColorTranslator.FromHtml("#ffffff");
     //   settings.Styles.Header.Paddings.Padding = 7;
        
        settings.AllowDragging = true;
        settings.MinHeight = Unit.Pixel(150);
        settings.Width = Unit.Pixel(1220);
        settings.PopupAction = PopupAction.LeftMouseClick; // It automatic take action.

        settings.HeaderText = "Provider Patient Information";
        settings.ShowCollapseButton = true;
        
        settings.SetHeaderTemplateContent(c =>
        {

            ViewContext.Writer.Write("<div class=\"cutomeHeaderPopup\">Rights Documents snapshot");
            ViewContext.Writer.Write("<span class=\"moveRight dxc-close-position\">");
            Html.DevExpress().Image(image =>
            {
                image.Name = "PatientProviderCloseImage";
                image.ImageUrl = Url.Content("~/Images/icons/closePopup.jpg");
                image.ControlStyle.Cursor = "pointer";

                image.Properties.EnableClientSideAPI = true;
                image.Properties.ClientSideEvents.Click = "function(s,e){  OpenProviderPatientInfoPopup.Hide();  }";
            }).Render();
            ViewContext.Writer.Write("</span></div>");

        });
       
      
        settings.SetContent(() =>
        {
            System.Web.Mvc.Html.ChildActionExtensions.RenderAction(Html, "ProviderPatientInfoData",Model);   
            
        });

        settings.ClientSideEvents.CloseUp = "function(s, e) { SetImageState(false); }";
        settings.ClientSideEvents.PopUp = "function(s, e) { SetImageState(true); }";

    }).GetHtml();

    %>