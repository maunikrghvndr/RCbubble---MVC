<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.eTAR.Model.SearchFieldWorklist>" %>

<%

    var grid = Html.DevExpress().GridView(settings =>
    {
        settings.Name = "PatientAcountDetails";
        settings.KeyFieldName = "ID";
        settings.Width = Unit.Percentage(100);
                 
        settings.CallbackRouteValues = new { Controller = "WorkList", Action = "WorklistGridCallback", AccountNo = Model.AccountNo, TCNNo = Model.TCNNo, PatientName = Model.PatientName, POENoOrCINNo = Model.POENoOrCINNo};
        settings.ControlStyle.CssClass = "PatientAcountDetails";

        settings.Styles.AlternatingRow.BackColor = System.Drawing.ColorTranslator.FromHtml("#F1F1F1");
        
        
        settings.Styles.Header.BackColor = System.Drawing.ColorTranslator.FromHtml("#e3f3f4");
        settings.Styles.Header.CssClass = "gvworklistHeader";

        //========== Grid View Resizing Column Header of Grid View ===========
        settings.SettingsBehavior.ColumnResizeMode = ColumnResizeMode.Control;
        //==================== Changing Grid Loading Icons ===================
        settings.Images.LoadingPanel.Url = Url.Content("~/Images/icons/LoadingLogo.gif");
        settings.SettingsLoadingPanel.Text = " ";
        settings.Images.LoadingPanel.Width = 76;
        settings.Images.LoadingPanel.Height = 100; 

        //====================== scroll bars =============================
        settings.Settings.HorizontalScrollBarMode = ScrollBarMode.Auto;
       
        settings.Settings.VerticalScrollableHeight = 555;
        settings.Settings.VerticalScrollBarMode = ScrollBarMode.Visible;

        settings.Styles.Table.ForeColor = System.Drawing.ColorTranslator.FromHtml("#333333");
        
        
        settings.ClientSideEvents.ColumnResizing = "stopResizingActionCol";

        settings.Columns.Add(column =>
        {
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.Caption = "Submit to Provider";
            column.Width = 70;
            column.Name = "ActionColumn";

            column.SetDataItemTemplateContent(c =>
            {
                string tcnNumbers = Convert.ToString(DataBinder.Eval(c.DataItem, "TCNNo"));
                string accountNumberId = Convert.ToString(DataBinder.Eval(c.DataItem, "AccountSubmissionDetailsID"));
                string tcnId = Convert.ToString(DataBinder.Eval(c.DataItem, "ID"));
                short SenderProviderId = Convert.ToInt16(DataBinder.Eval(c.DataItem, "SenderProviderId"));
                string accountNumber = Convert.ToString(DataBinder.Eval(c.DataItem, "AccountNo"));


                ViewContext.Writer.Write(
                   @Html.DevExpress().Image(
                            Imgsettings =>
                            {
                                Imgsettings.Name = "Action" + c.VisibleIndex;
                                Imgsettings.ControlStyle.Cursor = "pointer";
                                Imgsettings.ImageUrl = Url.Content("~/Images/icons/ActionArrowOrange.png");
                                Imgsettings.ClientEnabled = true;
                                Imgsettings.Properties.ClientSideEvents.Click = string.Format("function(s, e) {{ statusAccount('{0}','{1}','{2}',{3},'{4}') }}", accountNumberId, tcnNumbers, SenderProviderId, tcnId, accountNumber);

                            }).GetHtml());
            });

        });
        
        
        
        settings.Columns.Add(column =>
        {
            column.FieldName = "DeadLineInDays";
            column.Caption = " ";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.Width = 30;

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
            column.FieldName = "DeadLine";
            column.Caption = "Deadline";
            column.Width = 250;
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.SetDataItemTemplateContent(c =>
            {
                string createdUTCDate = Convert.ToString(DataBinder.Eval(c.DataItem, "DeadLine"));
                if (!string.IsNullOrEmpty(createdUTCDate))
                {
                    Html.DevExpress().Label(lblSettings =>
                    {
                        lblSettings.Name = "lblDeadLineOn_" + c.VisibleIndex;
                        lblSettings.Text = string.Format("{0} {1}", createdUTCDate, TimeZoneInfo.Utc.StandardName);
                        lblSettings.Properties.ClientSideEvents.Init = "function(s,e){SetLocalDate(s,e,'" + createdUTCDate + "')}";
                        lblSettings.EncodeHtml = false;
                    }).GetHtml();
                }
            });
        });
        settings.Columns.Add(
            column => {
                column.FieldName = "SentDate";
                column.Caption = "Sent Date";
                column.Width = 250;
                column.HeaderStyle.Wrap = DefaultBoolean.True;
                column.SetDataItemTemplateContent(c =>
                {
                    string sentUTCDate = Convert.ToString(DataBinder.Eval(c.DataItem, "SentDate"));
                    if (!string.IsNullOrEmpty(sentUTCDate))
                    {
                        Html.DevExpress().Label(lblSettings =>
                    {
                        lblSettings.Name = "lblSentOn_" + c.VisibleIndex;
                        lblSettings.Text = string.Format("{0} {1}", sentUTCDate, TimeZoneInfo.Utc.StandardName);
                        lblSettings.Properties.ClientSideEvents.Init = "function(s,e){SetLocalDate(s,e,'" + sentUTCDate + "')}";
                        lblSettings.EncodeHtml = false;
                    }).GetHtml();
                    }
                });
            });
        settings.Columns.Add(column =>
        {
            column.FieldName = "AccountNo";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.CellStyle.HorizontalAlign = System.Web.UI.WebControls.HorizontalAlign.Center;
            column.Caption = "Account #";
          //  column.Width = Unit.Percentage(12.5);
        });
        settings.Columns.Add(column =>
        {
            column.FieldName = "TCNNo";
            column.Caption = "TCN #";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
          //  column.Width = Unit.Percentage(12.5);
            column.SetDataItemTemplateContent(c => {
                var linkText = String.IsNullOrEmpty(Convert.ToString(DataBinder.Eval(c.DataItem, "TCNNo"))) ? "_" : Convert.ToString(DataBinder.Eval(c.DataItem, "TCNNo"));
                //string accountNumberId = Html.Encrypt((long)DataBinder.Eval(c.DataItem, "AccountSubmissionDetailsID"));
                string TCNNo = Html.Encrypt(Convert.ToString(DataBinder.Eval(c.DataItem, "TCNNo")));
                //ViewContext.Writer.Write(Html.ActionLink(linkText, "AccountDetailsMaster", "AccountDetails", new { TCNIdentificationID = Html.Encrypt(Convert.ToString(DataBinder.Eval(c.DataItem, "ID"))), AccountNo = Convert.ToString(DataBinder.Eval(c.DataItem, "AccountNo")), SenderProviderID = Html.Encrypt(Convert.ToString(DataBinder.Eval(c.DataItem, "SenderProviderID"))), TCNNo = Convert.ToString(DataBinder.Eval(c.DataItem, "TCNNo")), AccountSubmissionDetailsID = Html.Encrypt(Convert.ToString(DataBinder.Eval(c.DataItem, "AccountSubmissionDetailsID"))), DeadLineDate = Convert.ToString(DataBinder.Eval(c.DataItem, "DeadLine")) }, new { onclick = " generalizedShowLoader();" }));
                ViewContext.Writer.Write(Html.ActionLink(linkText, "AccountDetailsMaster", "AccountDetails", new { TCNIdentificationID = Html.Encrypt(Convert.ToString(DataBinder.Eval(c.DataItem, "ID"))), AccountNo = Convert.ToString(DataBinder.Eval(c.DataItem, "AccountNo")), SenderProviderID = Html.Encrypt(Convert.ToString(DataBinder.Eval(c.DataItem, "SenderProviderID"))), TCNNo = Convert.ToString(DataBinder.Eval(c.DataItem, "TCNNo")), AccountSubmissionDetailsID = Html.Encrypt(Convert.ToString(DataBinder.Eval(c.DataItem, "AccountSubmissionDetailsID"))), DeadLineDate = Convert.ToString(DataBinder.Eval(c.DataItem, "DeadLine")) },
                    new { onclick = string.Format("return CheckLockStatus('{0}'); ", TCNNo, null) }));
            });
        });

        
        //To Display Document Status in field officer work bucket
        //Added on 09-Feb-2015
        //Added by Abhishek
        settings.Columns.Add(column =>
        {
            column.FieldName = "DocumentStatus";
            column.Caption = "Document Status";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.Width = 140;            
        });
        //End Added
        
        settings.Columns.Add(column => {
            column.FieldName = "POENoAndCINNo";
            column.Caption = "POE / CIN #";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
        });
        settings.Columns.Add(column =>
        {
            column.FieldName = "PatientFirstName";
            column.Caption = "Patient First Name";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
          //  column.Width = Unit.Percentage(12.5);
        });

        settings.Columns.Add(column =>
        {
            column.Width = 150;
            column.FieldName = "PatientLastName";
            column.Caption = "Patient Last Name";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
           // column.Width = Unit.Percentage(12.5);
        });
        settings.Columns.Add(column =>
        {
            column.FieldName = "SenderProviderName";
            column.Caption = "Sent By Organization";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            //   column.Width = Unit.Percentage(12.5);
            column.Width = 200;
        });
        settings.Columns.Add("SenderProviderId").Visible = false;
    });
    
    grid.Bind(Model.SearchedWorklistData).GetHtml();
%>
