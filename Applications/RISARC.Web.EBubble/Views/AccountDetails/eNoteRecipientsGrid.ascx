<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.eTAR.Model.eNote>" %>

<%   
    var grid = Html.DevExpress().GridView(settings =>
        {
            settings.Name = "ENoteRecepientsGrid_" + Model.ReplyToeNoteID;
            settings.KeyFieldName = "eNoteID";
            //settings.CallbackRouteValues = new { Controller = "AccountDetails", Action = "eNotesCallbackMethod", AccountNo = Model.AccountNo, SenderProviderID = Model.SenderProviderID, TCNNo = Model.TCNNo, ReplyToeNoteID = Model.ReplyToeNoteID };
            settings.CallbackRouteValues = new { Controller = "AccountDetails", Action = "eNotesCallbackMethod", ReplyToeNoteID = Model.ReplyToeNoteID };
            //settings.Settings.VerticalScrollBarMode = ScrollBarMode.Auto;
            //settings.Settings.VerticalScrollableHeight = 200;
            settings.SettingsPager.Mode = GridViewPagerMode.ShowAllRecords;

            //========== Grid View Resizing Column Header of Grid View ===========
            settings.SettingsBehavior.ColumnResizeMode = ColumnResizeMode.Control;
            //==================== Changing Grid Loading Icons ===================
            settings.Images.LoadingPanel.Url = Url.Content("~/Images/icons/LoadingLogo.gif");
            settings.SettingsLoadingPanel.Text = " ";
            settings.Images.LoadingPanel.Width = 76;
            settings.Images.LoadingPanel.Height = 100;  
            
            settings.SettingsText.EmptyDataRow = "No replies for this note";

            settings.Styles.Table.BackColor = System.Drawing.ColorTranslator.FromHtml("#ececec");

            settings.Width = Unit.Pixel(660);
            settings.Settings.ShowColumnHeaders = false;
            settings.Columns.Add(column =>
            {
               // column.Width = Unit.Percentage(100);
                column.CellStyle.CssClass = "testing";
                column.SetDataItemTemplateContent(c =>
                {
                    
                    ViewContext.Writer.Write(
                              "<div class=\"ReplyDetails\"></div><div class=\"ReplyDetailsText\"><b>" + DataBinder.Eval(c.DataItem, "Note") + "</b>" + "<span class=\"greyColor\">Created by " + DataBinder.Eval(c.DataItem, "CreatedByName") + " on " + "</span>");
                    string createdUTCDate = Convert.ToString(DataBinder.Eval(c.DataItem, "CreatedOn"));
                    if (!string.IsNullOrEmpty(createdUTCDate))
                    {
                        Html.DevExpress().Label(lblSettings =>
                        {
                            if (ViewData["controlFlag"] != null && (bool)ViewData["controlFlag"] == true)
                                lblSettings.Name = "lblCreatedOneNotePopup_" + column.VisibleIndex + "_" + Convert.ToString(DataBinder.Eval(c.DataItem, "eNoteID"));
                            else
                                lblSettings.Name = "lblCreatedOneNote_"+ column.VisibleIndex + "_" + Convert.ToString(DataBinder.Eval(c.DataItem, "eNoteID"));

                            lblSettings.Text = string.Format("{0} {1}", createdUTCDate, TimeZoneInfo.Utc.StandardName);
                            lblSettings.Properties.ClientSideEvents.Init = "function(s,e){SetLocalDate(s,e,'" + createdUTCDate + "')}";
                            lblSettings.ControlStyle.ForeColor = System.Drawing.Color.Gray;
                            lblSettings.EncodeHtml = false;
                        }).GetHtml();
                        
                    }
                    ViewContext.Writer.Write("</div>");
                });

            });

        });

    grid.Bind(Model.PresenteNotes).GetHtml();
%>