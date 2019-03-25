<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.eTAR.Model.SearchFieldENotes>" %>

<%--ViewData["EnotesCount"]--%>
<%
    var grid = Html.DevExpress().GridView(settings =>
    {
        settings.Name = "gvReceivedEnotes";
        settings.KeyFieldName = "ID";
        settings.Width = Unit.Percentage(100);
        //settings.Width = 1040;
       
        settings.CallbackRouteValues = new { Controller = "WorkList", Action = "ENotesGridCallBack" };
        settings.ControlStyle.CssClass = "PatientAcountDetails";


        //====================== scroll bars =============================
        settings.Settings.HorizontalScrollBarMode = ScrollBarMode.Auto;
        settings.Settings.VerticalScrollableHeight = 555;
        settings.Settings.VerticalScrollBarMode = ScrollBarMode.Visible;
        
        //========== Grid View Resizing Column Header of Grid View ===========
        settings.SettingsBehavior.ColumnResizeMode = ColumnResizeMode.Control;
        
        //==================== Changing Grid Loading Icons ===================
        settings.Images.LoadingPanel.Url = Url.Content("~/Images/icons/LoadingLogo.gif");
        settings.SettingsLoadingPanel.Text = " ";
        settings.Images.LoadingPanel.Width = 76;
        settings.Images.LoadingPanel.Height = 100; 
        
        //ALternate color & header color
        settings.Styles.AlternatingRow.BackColor = System.Drawing.ColorTranslator.FromHtml("#F1F1F1");
        settings.Styles.Header.BackColor = System.Drawing.ColorTranslator.FromHtml("#e3f3f4");
        settings.Styles.Header.CssClass = "gvworklistHeader";

        settings.Styles.AlternatingRow.BackColor = System.Drawing.ColorTranslator.FromHtml("#F1F1F1");

        settings.Styles.Table.ForeColor = System.Drawing.ColorTranslator.FromHtml("#333333");

        settings.ClientSideEvents.ColumnResizing = "stopResizingActionCol";
        //settings.ClientSideEvents.Init = "";
        //+========================= Action Column Statred =========================
        settings.Columns.Add(column =>
        {

            column.HeaderStyle.Wrap = DefaultBoolean.True;
            //================= Header styles ============================================
            //column.HeaderStyle.BorderRight.BorderWidth = 3;
            //column.HeaderStyle.BorderRight.BorderColor = System.Drawing.ColorTranslator.FromHtml("#c3c3c3");
            ////================== action column border changing ======================= 
            //column.CellStyle.BorderRight.BorderWidth = 3;
            //column.CellStyle.BorderRight.BorderColor = System.Drawing.ColorTranslator.FromHtml("#c3c3c3");

            column.CellStyle.CssClass = "tableBorderShadow";
            column.HeaderStyle.CssClass = "tableBorderShadow";
            column.FilterCellStyle.CssClass = "tableBorderShadow";
            column.Name = "ActionColumn";
            
            column.CellStyle.HorizontalAlign = HorizontalAlign.Center;
            column.Caption = "Reply to eNote";
            column.Width = Unit.Pixel(60);
            column.SetDataItemTemplateContent(c =>
            {   
                short SenderProviderId = Convert.ToInt16(DataBinder.Eval(c.DataItem, "SenderProviderId"));
                long enoteID = Convert.ToInt64(DataBinder.Eval(c.DataItem, "ENoteID"));
                long DocumentID = Convert.ToInt64(DataBinder.Eval(c.DataItem, "DocumentID"));
                
                ViewContext.Writer.Write(
                   @Html.DevExpress().Image(
                            Imgsettings =>
                            {
                                Imgsettings.Name ="REceivedAction"+c.VisibleIndex;
                                Imgsettings.ControlStyle.Cursor = "pointer";
                                Imgsettings.ImageUrl = Url.Content("~/Images/icons/ActionArrowOrange.png");
                                Imgsettings.ClientEnabled = true;
                                Imgsettings.Properties.ClientSideEvents.Click = string.Format("function(s, e) {{ EnoteStatus('{0}','{1}','{2}') }}", SenderProviderId, enoteID, DocumentID);
                                //Imgsettings.Properties.ClientSideEvents.Click = "function(s,e){  AccountNotesPopup.Show(); }";
                            }).GetHtml());
            });
        });
        //+========================= Action Column End s ==================================
        
        settings.Columns.Add(column =>
        {
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.FieldName = "DeadLineInDays";
            column.Width = Unit.Pixel(25);
            column.Caption = " ";
            column.CellStyle.HorizontalAlign = HorizontalAlign.Center;
            column.SetDataItemTemplateContent(c =>
            {
                int DeadlineStaus;
                DeadlineStaus = Convert.ToInt32(DataBinder.Eval(c.DataItem, "DeadLineInDays"));
                
                if(DeadlineStaus > 3)
                    Response.Write("<div class=\"BlueBall\"></div>");
                else if (DeadlineStaus == 3)
                    Response.Write("<div class=\"GreenBall\"></div>");
                else if (DeadlineStaus == 2)
                    Response.Write("<div class=\"YellowBall\"></div>");
                else if (DeadlineStaus <= 1)
                    Response.Write("<div class=\"RedBall\"></div>");
            });
        }); 
        settings.Columns.Add(column =>
        {
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.FieldName = "eNote_DeadLine";
            column.Caption = "Deadline";
            //column.Width = Unit.Percentage(17);
            column.Width = Unit.Pixel(250);
            column.SetDataItemTemplateContent(c =>
            {
                string createdUTCDate = Convert.ToString(DataBinder.Eval(c.DataItem, "eNote_DeadLine"));
                if (!string.IsNullOrEmpty(createdUTCDate))
                {
                    Html.DevExpress().Label(lblSettings =>
                    {
                        lblSettings.Name = "lblSentOn_" + c.VisibleIndex;
                        lblSettings.Text = string.Format("{0}<br />{1}", createdUTCDate, TimeZoneInfo.Utc.StandardName);
                        lblSettings.Properties.ClientSideEvents.Init = "function(s,e){SetLocalDate(s,e,'" + createdUTCDate + "')}";
                        lblSettings.EncodeHtml = false;
                    }).GetHtml();
                }
            });
        });
        settings.Columns.Add(column =>
        {
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.FieldName = "ENoteID";
            column.Caption = "ENote #";
            //column.Width = Unit.Percentage(7);
            column.CellStyle.HorizontalAlign = HorizontalAlign.Center;
            column.SetDataItemTemplateContent(c =>
            {
                //ViewContext.Writer.Write(Html.ActionLink(Convert.ToString(DataBinder.Eval(c.DataItem, "TCNNo")), "AccountDetailsMaster", "AccountDetails", new { AccountNo = Convert.ToString(DataBinder.Eval(c.DataItem, "AccountNo")), TCNNo = Convert.ToString(DataBinder.Eval(c.DataItem, "TCNNo"))}, new { }));
                ViewContext.Writer.Write(Html.ActionLink(Convert.ToString(DataBinder.Eval(c.DataItem, "eNoteTokenID")), "AccountDetailsMaster", "AccountDetails", new { eNoteID = Convert.ToString(DataBinder.Eval(c.DataItem, "ENoteID")), SenderProviderID = Html.Encrypt(Convert.ToString(DataBinder.Eval(c.DataItem, "SenderProviderId"))), DeadLineDate = Convert.ToString(DataBinder.Eval(c.DataItem, "DocumentDeadLine")), DocumentFileID = Html.Encrypt(Convert.ToString(DataBinder.Eval(c.DataItem, "DocumentFileID"))), DocumentID = Html.Encrypt(Convert.ToString(DataBinder.Eval(c.DataItem, "DocumentID"))), sourceFlag = 4 }, new { onclick = "generalizedShowLoader();" }));
                
            });
        });

        settings.Columns.Add(column =>
        {
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.FieldName = "SenderProviderId";
            column.Caption = "Sender Provider Id";
            //column.Width = Unit.Percentage(10);
            column.Visible = false;
        }); 

        settings.Columns.Add(column =>
        {
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.FieldName = "DocumentDeadLine";
            column.Caption = "Document DeadLine";
            //column.Width = Unit.Percentage(10);
            column.Visible = false;
        });
        settings.Columns.Add(column =>
        {
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.FieldName = "PatientFirstName";
            column.Caption = "Patient First Name";
            //column.Width = Unit.Percentage(12.5);
        });

        settings.Columns.Add(column =>
        {
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.FieldName = "PatientLastName";
            column.Caption = "Patient Last Name";
            //column.Width = Unit.Percentage(12.5);
        });
        settings.Columns.Add(column =>
        {
            column.FieldName = "SenderOrReceiverName";
            column.Caption = "Sender Name";
            column.Width = Unit.Percentage(18);
        });
        settings.Columns.Add(column =>
        {
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.FieldName = "Description";
            column.Caption = "Description";
            //column.Width = Unit.Percentage(12.5);
            //column.Width = Unit.Percentage(17);
            column.Width = Unit.Percentage(25);
            column.SetDataItemTemplateContent(container =>
            {
                string description = DataBinder.Eval(container.DataItem, "Description").ToString().Trim();
                ViewContext.Writer.Write(string.Format("<div style='text-overflow:ellipsis;overflow:hidden; white-space:nowrap'>{0}</div>", description));
            });
           
            //column.ToolTip = "hint text...";
        });
        settings.Columns.Add(column =>
        {
            column.HeaderStyle.Wrap = DefaultBoolean.True;
           column.Name = "CompletDescription";
           column.FieldName = "Description";
           column.Visible = false;
           column.Width = 200;
       });
        settings.HtmlDataCellPrepared = (sender, e) =>
        {
            e.Cell.Attributes.Add("title",
                "NOTE: " + e.GetValue("Description").ToString());
        };
        settings.ClientSideEvents.Init = "function (s, e){ oneEndCallback(s, e," + Model.DeadLineRecordCount + ", " + Model.TwoDaysToDeadLineRecordCount + ", " + Model.ThreeDaysToDeadLineRecordCount + ", " + Model.MoreThanThreeDaysToDeadLineRecordCount + ", " + Model.TotalAccountsInBucket + " );}";
        settings.ClientSideEvents.EndCallback = "function (s, e){ oneEndCallback(s, e," + Model.DeadLineRecordCount + ", " + Model.TwoDaysToDeadLineRecordCount + ", " + Model.ThreeDaysToDeadLineRecordCount + ", " + Model.MoreThanThreeDaysToDeadLineRecordCount + ", " + Model.TotalAccountsInBucket + " );}";
        settings.ClientSideEvents.BeginCallback = "onBeingCallback_RecivedGrid";
    });
    
    grid.Bind(Model.SearchedENotesData).GetHtml();
%>

