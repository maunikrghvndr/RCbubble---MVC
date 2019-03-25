<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.eTAR.Model.SearchFieldWorklist>" %>


<%
    var grid = Html.DevExpress().GridView(settings =>
    {
        settings.Name = "PatientAcountDetails";
        settings.KeyFieldName = "ID";
        settings.CallbackRouteValues = new { Controller = "WorkList", Action = "GlobalSearchGridCallback", AccountNo = Model.AccountNo, TCNNo = Model.TCNNo, PatientName = Model.PatientName, POENoOrCINNo = Model.POENoOrCINNo };


        settings.Width = System.Web.UI.WebControls.Unit.Percentage(100);

        //========== Grid View Resizing Column Header of Grid View ===========
        settings.SettingsBehavior.ColumnResizeMode = ColumnResizeMode.Control;
        //==================== Changing Grid Loading Icons ===================
        settings.Images.LoadingPanel.Url = Url.Content("~/Images/icons/LoadingLogo.gif");
        settings.SettingsLoadingPanel.Text = " ";
        settings.Images.LoadingPanel.Width = 76;
        settings.Images.LoadingPanel.Height = 100; 
        

        settings.Styles.AlternatingRow.BackColor = System.Drawing.ColorTranslator.FromHtml("#F1F1F1");
        settings.Styles.Header.BackColor = System.Drawing.ColorTranslator.FromHtml("#e3f3f4");
        settings.Styles.Header.CssClass = "gvworklistHeader";

        settings.Styles.Table.ForeColor = System.Drawing.ColorTranslator.FromHtml("#333333");

        //====================== scroll bars =============================
        settings.Settings.HorizontalScrollBarMode = ScrollBarMode.Auto;
        settings.Settings.VerticalScrollableHeight = 555;
        settings.Settings.VerticalScrollBarMode = ScrollBarMode.Visible;


        settings.Columns.Add(column =>
        {
            column.FieldName = "DocumentID";
            column.Visible = false;
        });

        settings.Columns.Add(column =>
        {
            column.FieldName = "DeadLineInDays";
            column.Caption = " ";
            column.Width = 25;
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.CellStyle.HorizontalAlign = HorizontalAlign.Center;
            column.SetDataItemTemplateContent(c =>
            {
                int DeadlineStaus;
                DeadlineStaus = Convert.ToInt32(DataBinder.Eval(c.DataItem, "DeadLineInDays"));

                if (DeadlineStaus > 3)
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
            column.Caption = "DeadLine";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.Width = Unit.Pixel(250);
            column.SetDataItemTemplateContent(c =>
            {
                string createdUTCDate = Convert.ToString(DataBinder.Eval(c.DataItem, "DeadLine"));
                if (!string.IsNullOrEmpty(createdUTCDate))
                {
                    Html.DevExpress().Label(lblSettings =>
                    {
                        lblSettings.Name = "lblDeadLineOn_" + c.VisibleIndex;
                        lblSettings.Text = string.Format("{0}<br />{1}", createdUTCDate, TimeZoneInfo.Utc.StandardName);
                        lblSettings.Properties.ClientSideEvents.Init = "function(s,e){SetLocalDate(s,e,'" + createdUTCDate + "')}";
                        lblSettings.EncodeHtml = false;
                    }).GetHtml();
                }
            });
        });
        settings.Columns.Add(
               column =>
               {
                   column.HeaderStyle.Wrap = DefaultBoolean.True;
                   column.FieldName = "SentDate";
                   column.Caption = "Sent Date";
                  // column.Width = Unit.Percentage(30);
                   column.Width = Unit.Pixel(250);
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
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.FieldName = "AccountNo";
            column.Caption = "Account #";
            // column.Width = Unit.Percentage(12.5);
        });
        settings.Columns.Add(column =>
        {
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            //  short sourceFlag = 1;
            column.FieldName = "TCNNo";
            column.Caption = "TCN #";
            //  column.Width = Unit.Percentage(12.5);
            column.SetDataItemTemplateContent(c =>
            {
                ViewContext.Writer.Write(Html.ActionLink(Convert.ToString(DataBinder.Eval(c.DataItem, "TCNNo")), "AccountDetailsMaster", "AccountDetails", new { TCNIdentificationID = Html.Encrypt(Convert.ToString(DataBinder.Eval(c.DataItem, "ID"))), AccountNo = Convert.ToString(DataBinder.Eval(c.DataItem, "AccountNo")), SenderProviderID = Html.Encrypt(Convert.ToString(DataBinder.Eval(c.DataItem, "SenderProviderID"))), TCNNo = Convert.ToString(DataBinder.Eval(c.DataItem, "TCNNo")), AccountSubmissionDetailsID = Html.Encrypt(Convert.ToString(DataBinder.Eval(c.DataItem, "AccountSubmissionDetailsID"))), DeadLineDate = Convert.ToString(DataBinder.Eval(c.DataItem, "DeadLine")), sourceFlag = 2 }, new { onclick = " generalizedShowLoader();" }));
            });
        });
       
        settings.Columns.Add(column =>
        {
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.FieldName = "POENoAndCINNo";
            column.Caption = "POE / CIN #";
        });
        settings.Columns.Add(column =>
        {
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.FieldName = "PatientFirstName";
            column.Caption = "Patient First Name";
            //  column.Width = Unit.Percentage(12.5);
        });

        settings.Columns.Add(column =>
        {
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.FieldName = "PatientLastName";
            column.Caption = "Patient Last Name";
            //   column.Width = Unit.Percentage(12.5);
        });
        settings.Columns.Add(column =>
        {
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.FieldName = "SenderProviderName";
            column.Caption = "Sent By Organization";
              column.Width = Unit.Pixel(132);
        });
    });

    grid.Bind(Model.SearchedWorklistData).GetHtml();
%>
