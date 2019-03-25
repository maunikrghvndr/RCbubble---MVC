<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<% 
    var grid = Html.DevExpress().GridView(settings =>
    {
        settings.Name = "gvDocumentsRejectedByReviewer";

        //Scroll Settings 
        settings.KeyFieldName = "AccountSubmissionDetailsID";
        
        settings.Width = System.Web.UI.WebControls.Unit.Percentage(100);
        //settings.Width = 1500;
        //  settings.SettingsPager.Mode = GridViewPagerMode.ShowAllRecords;
        // settings.SettingsPager.PageSize = 20;

        settings.SettingsText.EmptyDataRow = "No documents present which are Erroneous or Rejected";
        settings.Settings.ShowFilterRow = true;
       // settings.Caption = "List of Accounts";
        settings.ImagesEditors.DropDownEditDropDown.Url = Url.Content("~/Images/icons/calenderIcon.png"); 
        
       settings.Settings.VerticalScrollBarMode = ScrollBarMode.Visible;
        settings.Settings.HorizontalScrollBarMode = ScrollBarMode.Auto;
       settings.Settings.VerticalScrollableHeight = 555;

        settings.Styles.Table.ForeColor = System.Drawing.ColorTranslator.FromHtml("#333333");
        
        settings.Styles.AlternatingRow.BackColor = System.Drawing.ColorTranslator.FromHtml("#f7f7f7");
        settings.Styles.Header.BackColor = System.Drawing.ColorTranslator.FromHtml("#e3f3f4");
        settings.Styles.Header.CssClass = "gvworklistHeader";

        settings.Styles.FilterCell.CssClass = "fillterCell";

        //settings.Styles.FilterBar = System.Drawing.ColorTranslator.FromHtml("#FF00FF");
        
        
      //  settings.SettingsPager.PageSize = 5;
        
        settings.Settings.VerticalScrollBarMode = ScrollBarMode.Visible;
        settings.CallbackRouteValues = new { Action = "GridViewForErroneousRejectedDocuments", Controller = "ViewDocuments" };
        //resizing mode
        settings.SettingsBehavior.ColumnResizeMode = ColumnResizeMode.Control;
        //==================== Changing Grid Loading Icons ===================
        settings.Images.LoadingPanel.Url = Url.Content("~/Images/icons/LoadingLogo.gif");
        settings.SettingsLoadingPanel.Text = " ";
        settings.Images.LoadingPanel.Width = 76;
        settings.Images.LoadingPanel.Height = 100; 

        settings.AutoFilterCellEditorInitialize = (sender, e) =>
        {
            ASPxTextBox filterTextBox = (e.Editor as ASPxTextBox);

            ASPxDateEdit fillterCombo = (e.Editor as ASPxDateEdit);

            if (filterTextBox != null)
            {
                filterTextBox.NullText = "Search";
            }

            if (fillterCombo != null)
            {
                fillterCombo.NullText = "Select date";
            }

        };

        
        
        settings.Columns.Add(column =>
        {
            column.Caption = "Account#";
            column.FieldName = "AccountNumberIdentification.AccountNumber";
            //column.SetDataItemTemplateContent(c =>
            //{
            //    string accountNumber = Convert.ToString(DataBinder.Eval(c.DataItem, "AccountNumberIdentification.AccountNumber"));
            //    short sendersProviderId = (short)DataBinder.Eval(c.DataItem, "SentFromProviderId");
            //    string accountNumberId = Html.Encrypt((long)DataBinder.Eval(c.DataItem, "AccountSubmissionDetailsID"));
            //    if (!string.IsNullOrEmpty(accountNumber))
            //    {
            //        ViewContext.Writer.Write(Html.ActionLink(accountNumber, "AccountDetailsMaster", "AccountDetails", new { AccountNo = accountNumber, SenderProviderId = Html.Encrypt(sendersProviderId), sourceFlag = 1, AccountSubmissionDetailsID = accountNumberId }, new { onclick = " generalizedShowLoader();" }));
            //    }
            //});
          // column.Width = Unit.Percentage(10);
            column.Settings.AllowAutoFilter = DefaultBoolean.True;
            column.ReadOnly = true;

        });
       
        settings.Columns.Add(column =>
        {
            column.Caption = "Sent to Organization";
            column.FieldName = "DocumentRecipient.ProviderName";
          //  column.Width = Unit.Percentage(8);
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.ReadOnly = true;
        });

        //Sent Date column
        settings.Columns.Add(column =>
        {
            column.Caption = "Uploaded Date";
            column.FieldName = "CreateUTCDate";
            column.ColumnType = MVCxGridViewColumnType.DateEdit;
            column.Width = Unit.Pixel(250);
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.FilterCellStyle.CssClass = "removeFillter";
            
            column.SetDataItemTemplateContent(c =>
            {
                string uploadeDate = Convert.ToString(DataBinder.Eval(c.DataItem, "CreateUTCDate"));
                if (!string.IsNullOrEmpty(uploadeDate))
                {
                    Html.DevExpress().Label(lblSettings =>
                    {
                        lblSettings.Name = "lblUploadedDate_" + c.VisibleIndex;
                        lblSettings.Text = string.Format("{0} {1}", uploadeDate, TimeZoneInfo.Utc.StandardName);
                        lblSettings.Properties.ClientSideEvents.Init = "function(s,e){SetLocalDate(s,e,'" + uploadeDate + "')}";
                        lblSettings.EncodeHtml = false;
                    }).GetHtml();
                }
            });
            
            column.ReadOnly = true;
        });

        //Patient First Name column
        settings.Columns.Add(column =>
        {
            column.Caption = "Patient First Name";
            column.FieldName = "PatientFirstname";
            column.Width = Unit.Pixel(180);
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.ReadOnly = true;
        });

        //Patient Last Name column
        settings.Columns.Add(column =>
        {
            column.Caption = "Patient Last Name";
            column.FieldName = "PatientLastname";
            column.Width = Unit.Pixel(180);
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.ReadOnly = true;
        });
        //Reviewed by UserName
        settings.Columns.Add(column =>
        {
            column.Caption = "Reviewed by UserName";
            column.FieldName = "ReviewedByUserName";
            column.Width = Unit.Pixel(180);
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.ReadOnly = true;
        });

        //DOS From Column
        settings.Columns.Add(column =>
        {
            column.Caption = "DOS-From";
            column.Width = Unit.Pixel(250);
            column.FieldName = "AccountNumberIdentification.AccountDateOfServiceFrom";
            column.ColumnType = MVCxGridViewColumnType.DateEdit;
            column.FilterCellStyle.CssClass = "removeFillter";
            
          //  column.Width = Unit.Percentage(12);
            column.SetDataItemTemplateContent(c =>
            {
                string dosFrom = Convert.ToString(DataBinder.Eval(c.DataItem, "AccountNumberIdentification.AccountDateOfServiceFrom"));
                if (!string.IsNullOrEmpty(dosFrom))
                {
                    Html.DevExpress().Label(lblSettings =>
                    {
                        lblSettings.Name = "lblDosFrom_" + c.VisibleIndex;
                        lblSettings.Text = string.Format("{0} {1}", dosFrom, TimeZoneInfo.Utc.StandardName);
                        lblSettings.Properties.ClientSideEvents.Init = "function(s,e){SetLocalDate(s,e,'" + dosFrom + "')}";
                        lblSettings.EncodeHtml = false;
                    }).GetHtml();
                }
            });
        });

        //DOS To Column
        settings.Columns.Add(column =>
        {
            column.Caption = "DOS-To";
            column.Width = Unit.Pixel(250);
            column.FieldName = "AccountNumberIdentification.AccountDateOfServiceTo";
            column.ColumnType = MVCxGridViewColumnType.DateEdit;
            column.FilterCellStyle.CssClass = "removeFillter";
          //  column.Width = Unit.Percentage(12);
            column.SetDataItemTemplateContent(c =>
            {
                string dosTo = Convert.ToString(DataBinder.Eval(c.DataItem, "AccountNumberIdentification.AccountDateOfServiceTo"));
                if (!string.IsNullOrEmpty(dosTo))
                {
                    Html.DevExpress().Label(lblSettings =>
                    {
                        lblSettings.Name = "lblDosTo_" + c.VisibleIndex;
                        lblSettings.Text = string.Format("{0} {1}", dosTo, TimeZoneInfo.Utc.StandardName);
                        lblSettings.Properties.ClientSideEvents.Init = "function(s,e){SetLocalDate(s,e,'" + dosTo + "')}";
                        lblSettings.EncodeHtml = false;
                    }).GetHtml();
                }
            });
        });
    });
    if (ViewData["EditError"] != null)
    {
        grid.SetEditErrorText((string)ViewData["EditError"]);
    }


    grid.Bind(Model).GetHtml();
%>
