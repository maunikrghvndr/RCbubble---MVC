<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.eTAR.Model.SearchFieldENotes>" %>

<%
    Html.DevExpress().PageControl(
    settings =>
    {
        settings.Name = "tbcReceivedSent";
        settings.Width = Unit.Percentage(99);

        settings.ActivateTabPageAction = ActivateTabPageAction.Click;
        settings.TabAlign = TabAlign.Left;
        settings.TabPosition = TabPosition.Top;
        settings.CallbackRouteValues = new { Controller = "WorkList", Action = "ENotesSearchTabCallback" };
        settings.ClientSideEvents.TabClick = "TabClicked";
        settings.ClientSideEvents.ActiveTabChanged = "OnActiveTab_Chnaged";

        settings.Styles.Tab.Height = 30;
        
        //Tabs control loading panel 
        settings.LoadingPanelText = " ";
        settings.Images.LoadingPanel.Url = Url.Content("~/Images/icons/LoadingLogo.gif");
        settings.Images.LoadingPanel.Width = 76;
        settings.Images.LoadingPanel.Height = 100; 
        
        settings.ControlStyle.Paddings.Padding = 0;

        settings.Styles.ActiveTab.BackColor = System.Drawing.ColorTranslator.FromHtml("#ececec");
        settings.Styles.ActiveTab.CssClass = "TabActive";

        
        settings.Styles.ActiveTab.BorderTop.BorderColor = System.Drawing.ColorTranslator.FromHtml("#ff6600");
        settings.Styles.ActiveTab.BorderTop.BorderWidth = 2;

        settings.Styles.ActiveTab.BorderBottom.BorderWidth = 0;
        settings.Styles.SpaceAfterTabsTemplate.Paddings.Padding = 0;

        //    NoteTabs.ControlStyle.BorderRight.BorderStyle = BorderStyle.None;

        settings.Styles.Content.BackColor = System.Drawing.ColorTranslator.FromHtml("#ececec");
        settings.Styles.Content.Border.BorderStyle = BorderStyle.None;

        settings.Styles.Content.Paddings.Padding = 0;
        
        
        

        settings.TabPages.Add(tab =>
        {

            tab.Name = "received";
            tab.Text = "Received";
            //tab.TabStyle.Height = 30;
            tab.TabStyle.Width = 80;

            tab.SetContent(() =>
            {

                //ViewContext.Writer.Write(Html.Action("ReceivedENotesGrid"));
                ViewContext.Writer.Write("<div class=\"recived\">");
                Html.RenderAction("ENotesGridCallBack", new { IsReceived = true });
                ViewContext.Writer.Write("</div>");
            });
        });

        settings.TabPages.Add(tab =>
        {
            tab.Name = "sent";
            tab.Text = "Sent";
            //tab.TabStyle.Height = 30;
            tab.TabStyle.Width = 80;
            tab.SetContent(() =>
            {
                ViewContext.Writer.Write(Html.Action("ENotesGridCallBack"));

            });
        });

        //settings.ActiveTabIndex = 0;
    }).GetHtml();
            
%>