<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.eTAR.Model.eNote>" %>


<%   
    var grid = Html.DevExpress().GridView(settings =>
        {
            if (ViewData["PopUpEnoteGrid"] != null && (bool)ViewData["PopUpEnoteGrid"] == true)
            {
                settings.Name = "ENoteGridPopUp";
                settings.CallbackRouteValues = new { Controller = "AccountDetails", Action = "eNotesCallbackMethod", PopUpEnoteFlag = true };
                settings.Settings.VerticalScrollableHeight = 160;
                settings.Settings.VerticalScrollBarMode = ScrollBarMode.Auto;
                settings.Height = 200;
            }
            else
            {
                settings.Name = "ENoteGrid";
                //settings.CallbackRouteValues = new { Controller = "AccountDetails", Action = "eNotesCallbackMethod", AccountNo = Model.AccountNo, SenderProviderID = Model.SenderProviderID, TCNNo = Model.TCNNo, eNoteID = Model.eNoteID };
                settings.CallbackRouteValues = new { Controller = "AccountDetails", Action = "eNotesCallbackMethod" };
             
            }
            settings.KeyFieldName = "eNoteID";
           // settings.Width = Unit.Pixel(700);

            // Surekahs 15/09/2014
            //To hiding Empty Row data as well remove border width also.
            settings.DataBound = (sender, e) =>
            {
                MVCxGridView gv = sender as MVCxGridView;
                if (gv.VisibleRowCount <= 0)
                {
                    gv.SettingsText.EmptyDataRow = " ";
                    gv.ControlStyle.BorderWidth = 0;
                }
                else
                {
                    gv.ControlStyle.CssClass = "dxc-borderVisible";
                }
            };
            settings.Width = Unit.Percentage(100);
            settings.Height = Unit.Percentage(100);

           
            
            //========== Grid View Resizing Column Header of Grid View ===========
            settings.SettingsBehavior.ColumnResizeMode = ColumnResizeMode.Control;
            //==================== Changing Grid Loading Icons ===================
            settings.Images.LoadingPanel.Url = Url.Content("~/Images/icons/LoadingLogo.gif");
            settings.SettingsLoadingPanel.Text = " ";
            settings.Images.LoadingPanel.Width = 76;
            settings.Images.LoadingPanel.Height = 100;  
          
            settings.SettingsPager.Mode = GridViewPagerMode.ShowAllRecords;
           // settings.Settings.VerticalScrollBarMode = ScrollBarMode.Auto;
          
            settings.Settings.ShowColumnHeaders = false;
            settings.SettingsDetail.AllowOnlyOneMasterRowExpanded = true;
            settings.SettingsDetail.ShowDetailRow = true;

            settings.Styles.Table.BackColor = System.Drawing.ColorTranslator.FromHtml("#ececec");
            settings.ControlStyle.ForeColor = System.Drawing.ColorTranslator.FromHtml("#333333");
            
            settings.Columns.Add(column =>
            {
                column.Width = Unit.Percentage(92);
                column.CellStyle.CssClass = "cdv-lineHeight";
                column.SetDataItemTemplateContent(c =>
                {
                    ViewContext.Writer.Write(
                              "<div><b>" + Convert.ToString(DataBinder.Eval(c.DataItem, "Note")).Replace("\n", "<br/>") + "</b></div>" + "<span class=\"greyColor\">Created by " + DataBinder.Eval(c.DataItem, "CreatedByName") + " on " + "</span>");
                    string createdUTCDate = Convert.ToString(DataBinder.Eval(c.DataItem, "CreatedOn"));
                    if (!string.IsNullOrEmpty(createdUTCDate))
                    {
                        Html.DevExpress().Label(lblSettings =>
                        {
                            if (ViewData["controlFlag"] != null && (bool)ViewData["controlFlag"] == true)
                            {
                                lblSettings.Name = "lblCreatedOneNotePopup_" + Convert.ToString(DataBinder.Eval(c.DataItem, "eNoteID"));
                            }
                            else
                                lblSettings.Name = "lblCreatedOneNote_" + Convert.ToString(DataBinder.Eval(c.DataItem, "eNoteID"));

                            lblSettings.Text = string.Format("{0} {1}", createdUTCDate, TimeZoneInfo.Utc.StandardName);
                            lblSettings.Properties.ClientSideEvents.Init = "function(s,e){SetLocalDateNote(s,e,'" + createdUTCDate + "')}";
                            lblSettings.ControlStyle.ForeColor = System.Drawing.Color.Gray;
                            lblSettings.EncodeHtml = false;
                        }).GetHtml();
                    }
                });

            });
            settings.SetDetailRowTemplateContent(c => {
                 ViewContext.Writer.Write("<div id=\"replyTableContainer\" class=\"replyTableContainer\">");
                System.Web.Mvc.Html.ChildActionExtensions.RenderAction(Html, "eNotesRecipientsCallbackMethod", "AccountDetails", new { replyToeNoteID = DataBinder.Eval(c.DataItem, "eNoteID") });
                ViewContext.Writer.Write("</div>");
            });
            settings.PreRender = (sender, e) =>
            {
                if (Model != null && Model.PresenteNotes != null && Model.PresenteNotes.Count > 0)
                    ((MVCxGridView)sender).DetailRows.ExpandRow(0);
            };

            
                settings.ClientSideEvents.BeginCallback = "EnoteGrid_BeginCallback";

            settings.CommandColumn.Visible = true;
            settings.CommandColumn.ButtonType = GridViewCommandButtonType.Image;                                  
           GridViewCommandColumnCustomButton customButton = new GridViewCommandColumnCustomButton() { ID = "btnReply", Text = "Reply" };
            customButton.Image.Url = "../../Images/icons/ActionArrowOrange.png";
            //settings.CommandColumn.CellStyle.CssClass = "ReplyImage";
            settings.CommandColumn.CustomButtons.Add(customButton);
            
            settings.ClientSideEvents.CustomButtonClick = "Enote_CustomButtonClick";
            settings.SetEditFormTemplateContent(c =>
            {
                ViewContext.Writer.Write("<div id=\"main\" class=\"addCommentContainer\">");
                ViewContext.Writer.Write("<div id=\"txtcombo\">");
                ViewContext.Writer.Write("<span class=\"floatLeft lightGeyText margin\">Add Comments");
                ViewContext.Writer.Write("<div class=\"enote_reply\">");
                Html.DevExpress().Memo(
                               textarea =>
                               {
                                   if (Convert.ToBoolean(ViewData["EnotePopUp"]))
                                   {
                                       textarea.Name = "PopupeNote";
                                   }
                                   else
                                   {
                                       textarea.Name = "eNoteReply";
                                   }
                                   
                                   if (Request.QueryString["eNoteID"] != null)
                                   {textarea.Width = Unit.Pixel(700);   }
                                   else
                                   {textarea.Width = Unit.Pixel(400);  }
                                   
                                   textarea.Height = 25;
                               }).GetHtml();
                ViewContext.Writer.Write("</div>");
                ViewContext.Writer.Write("</span>");
                ViewContext.Writer.Write("<span class=\"floatLeft lightGeyText \">Select Status");
                ViewContext.Writer.Write("<div class=\"enote_reply\">");
                Html.DevExpress().ComboBox(
                                cmbsettings =>
                                {
                                    if (Convert.ToBoolean(ViewData["EnotePopUp"]))
                                    {
                                        cmbsettings.Name = "PopupStatuscomboBox";
                                    }
                                    else
                                    {
                                        cmbsettings.Name = "StatuscomboBox";
                                    }
                                    cmbsettings.Width = 173;
                                    cmbsettings.SelectedIndex = 0;
                                  
                                    cmbsettings.ControlStyle.CssClass = "AllScanedDoc";
                                    cmbsettings.Properties.Items.Add("Completed").Value = true;
                                    cmbsettings.Properties.Items.Add("Not Completed").Value = false;

                                }
                            ).GetHtml();
                ViewContext.Writer.Write("</div>");
                ViewContext.Writer.Write("</span>");
                ViewContext.Writer.Write("</div>");
                ViewContext.Writer.Write("<div class=\"clear\">");
                ViewContext.Writer.Write("</div>");
                                 
                ViewContext.Writer.Write("<div class=\"clear FixiedHT12\">");
                ViewContext.Writer.Write("</div>");
                
                ViewContext.Writer.Write("<div id=\"replycancelbutton\">");
                ViewContext.Writer.Write("<span>");
                Html.DevExpress().Button(btnSettings =>
                {
                    btnSettings.Name = "eNoteReplyButton";
                    btnSettings.ClientSideEvents.Click = "ReplyeNote";
                    btnSettings.ControlStyle.HorizontalAlign = HorizontalAlign.Center;
                    btnSettings.Width = Unit.Pixel(70);
                    btnSettings.Height = 28;
                    btnSettings.Text = "Reply";
                    btnSettings.ControlStyle.CssClass = "orangeBtn margin";
                }).GetHtml();
                ViewContext.Writer.Write("</span>");
                ViewContext.Writer.Write("<span>");
                Html.DevExpress().Button(
                        btnSettings =>
                        {
                            btnSettings.Name = "btnCancel";
                            btnSettings.ControlStyle.CssClass = "greyBtn";
                            btnSettings.Text = "Cancel";
                            btnSettings.ClientSideEvents.Click = "CancelEdit_eNOteGrid";
                        }).GetHtml();
                ViewContext.Writer.Write("</span>");
                ViewContext.Writer.Write("</div>");                
                ViewContext.Writer.Write("</div>");
                
            });
            
        });

    grid.Bind(Model.PresenteNotes).GetHtml();
%>


