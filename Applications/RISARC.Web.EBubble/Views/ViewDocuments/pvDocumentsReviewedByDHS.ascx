<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<% 
    var grid = Html.DevExpress().GridView(settings =>
    {
        settings.Name = "gvDocReviwedByDHS";

        //Scroll Settings 
        settings.KeyFieldName = "TCNNumber";
        settings.CallbackRouteValues = new { Controller = "ViewDocuments", Action = "GridViewForDocumentsReviewedByDHS" };

        settings.Width = System.Web.UI.WebControls.Unit.Percentage(100);
        settings.Height = System.Web.UI.WebControls.Unit.Pixel(600);
        settings.SettingsText.EmptyDataRow = "No documents have been reviewed by DHS.";
     
       // settings.Caption = "List of Documents Reviewed by DHS";
        settings.Settings.HorizontalScrollBarMode= ScrollBarMode.Auto;
        settings.Settings.VerticalScrollBarMode = ScrollBarMode.Visible;
        settings.Settings.VerticalScrollableHeight = 555;


        settings.Styles.AlternatingRow.BackColor = System.Drawing.ColorTranslator.FromHtml("#f7f7f7");
        settings.Styles.Header.BackColor = System.Drawing.ColorTranslator.FromHtml("#e3f3f4");
        settings.Styles.Header.CssClass = "gvworklistHeader";
        
      
        //========== Grid View Resizing Column Header of Grid View ===========
        settings.SettingsBehavior.ColumnResizeMode = ColumnResizeMode.Control;
        //==================== Changing Grid Loading Icons ===================
        settings.Images.LoadingPanel.Url = Url.Content("~/Images/icons/LoadingLogo.gif");
        settings.SettingsLoadingPanel.Text = " ";
        settings.Images.LoadingPanel.Width = 76;
        settings.Images.LoadingPanel.Height = 100; 

        //======================== fillter cell style =======================
        settings.Styles.FilterCell.CssClass = "fillterCell";
        settings.Settings.ShowFilterRow = true;
        settings.Images.FilterRowButton.Url = Url.Content("~/Images/icons/search_im.png");

        settings.ImagesEditors.DropDownEditDropDown.Url = Url.Content("~/Images/icons/calenderIcon.png"); 
        
      

        settings.Styles.Table.ForeColor = System.Drawing.ColorTranslator.FromHtml("#333333");
        
        settings.AutoFilterCellEditorInitialize = (sender, e) =>
        {
            ASPxTextBox textBox = (e.Editor as ASPxTextBox);
            ASPxDateEdit dateBox = (e.Editor as ASPxDateEdit);

            if (textBox != null)
            {
                textBox.NullText = "Search";
            }

            if (dateBox != null)
            {
                dateBox.NullText = "Select date";
            }

        };
         
     
        settings.Columns.Add(column =>
        {
            column.Caption = "TCN#";
            column.FieldName = "TCNNumbers";
            column.HeaderStyle.Wrap = DefaultBoolean.True;

        

            
            column.CellStyle.CssClass = "tableBorderShadow";
            column.HeaderStyle.CssClass = "tableBorderShadow";
            column.FilterCellStyle.CssClass = "tableBorderShadow";
            
            
            column.SetDataItemTemplateContent(c =>
            {
                string tcnNumber = Convert.ToString(DataBinder.Eval(c.DataItem, "TCNNumbers"));
                string accountNumber = Convert.ToString(DataBinder.Eval(c.DataItem, "AccountNumberIdentification.AccountNumber"));
                short sendersProviderId = (short)DataBinder.Eval(c.DataItem, "SentFromProviderId");
                string accountNumberId = Html.Encrypt((long)DataBinder.Eval(c.DataItem, "AccountSubmissionDetailsID"));
                if (!string.IsNullOrEmpty(tcnNumber))
                {
                    ViewContext.Writer.Write(Html.ActionLink(tcnNumber, "AccountDetailsMaster", "AccountDetails", new { AccountNo = accountNumber, SenderProviderId = Html.Encrypt(sendersProviderId), TCNNo = tcnNumber, sourceFlag = 3, AccountSubmissionDetailsID = accountNumberId, extFlag = 1 }, new { @class = "clsLoader"}));
                }
            });
            column.Settings.AllowAutoFilter = DefaultBoolean.True;
            column.ReadOnly = true;

        });
        //Account# column
        settings.Columns.Add(column =>
        {
            column.Caption = "Account#";
            column.FieldName = "AccountNumberIdentification.AccountNumber";
            column.Settings.AllowAutoFilter = DefaultBoolean.True;
            column.ReadOnly = true;
            column.HeaderStyle.Wrap = DefaultBoolean.True;
           // column.Width = 75;
            
        });

        //Review Status
        settings.Columns.Add(column =>
        {
            column.Caption = "Review Status";
            column.FieldName = "ReviewStatus";
            column.ReadOnly = true;
            column.HeaderStyle.Wrap = DefaultBoolean.True;
          //  column.Width = 60;
        });
        
        //Sent by user column
        settings.Columns.Add(column =>
        {
            column.Caption = "Sent By Member";
            column.FieldName = "SentByUserName";
            column.ReadOnly = true;
            column.HeaderStyle.Wrap = DefaultBoolean.True;
           // column.Width = 200;
        });
        //Sent by Organization column
        settings.Columns.Add(column =>
        {
            column.Caption = "Sent By Organization";
            column.FieldName = "SentFromProviderName";
            column.ReadOnly = true;
            column.HeaderStyle.Wrap = DefaultBoolean.True;
           // column.Width = 100;
        });
        //Sent to column
        settings.Columns.Add(column =>
        {
            column.Caption = "Sent to Organization";
            column.FieldName = "DocumentRecipient.ProviderName";
            column.ReadOnly = true;
            column.HeaderStyle.Wrap = DefaultBoolean.True;
           // column.Width = 80;
        });
        
        //Sent Date column
        settings.Columns.Add(column =>
        {
            column.Caption = "Sent Date";
            column.FieldName = "LocalDocumentSubmissionDate";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.ColumnType = MVCxGridViewColumnType.DateEdit;
            column.FilterCellStyle.CssClass = "removeFillter";
            
            //column.Width = 170;
            column.Width = Unit.Pixel(250);
            
            column.SetDataItemTemplateContent(c =>
            {
                string sentDate = Convert.ToString(DataBinder.Eval(c.DataItem, "DocumentSubmissionDate"));
                if (!string.IsNullOrEmpty(sentDate))
                {
                    Html.DevExpress().Label(lblSettings =>
                    {
                        lblSettings.Name = "lblSentDate_" + c.VisibleIndex;
                        lblSettings.Text = string.Format("{0} {1}", sentDate, TimeZoneInfo.Utc.StandardName);
                        lblSettings.Properties.ClientSideEvents.Init = "function(s,e){SetLocalDate(s,e,'" + sentDate + "')}";
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
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.ReadOnly = true;
           // column.Width = Unit.Percentage(20);
        });

        //Patient Last Name column
        settings.Columns.Add(column =>
        {
            column.Caption = "Patient Last Name";
            column.FieldName = "PatientLastname";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.ReadOnly = true;
            //column.Width = Unit.Percentage(20);
        });

        //DOS From Column
        settings.Columns.Add(column =>
        {
            column.Caption = "DOS-From";
            column.Width = Unit.Pixel(250);
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.FieldName = "AccountNumberIdentification.LocalAccountDateOfServiceFrom";
            column.ColumnType = MVCxGridViewColumnType.DateEdit;

            column.FilterCellStyle.CssClass = "removeFillter";
           
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
            column.ReadOnly = true;
        });

        //DOS To Column
        settings.Columns.Add(column =>
        {
            column.Caption = "DOS-To";
            column.Width = Unit.Pixel(250);
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.FieldName = "AccountNumberIdentification.LocalAccountDateOfServiceTo";
            column.ColumnType = MVCxGridViewColumnType.DateEdit;

            column.FilterCellStyle.CssClass = "removeFillter";
          //  column.Width = 170;

          //  column.Width = Unit.Percentage(2);
            
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
            column.ReadOnly = true;
        });

       //Review Date
        settings.Columns.Add(column =>
        {
            column.Caption = "Review Date";
            column.Width = Unit.Pixel(250);
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.FieldName = "LocalDocumentReviewedDate";
            column.ColumnType = MVCxGridViewColumnType.DateEdit;
          //  column.Width = 170;
            column.FilterCellStyle.CssClass = "removeFillter";
            column.SetDataItemTemplateContent(c =>
            {
                string reviewedDate = Convert.ToString(DataBinder.Eval(c.DataItem, "DocumentReviewedDate"));
                if (!string.IsNullOrEmpty(reviewedDate))
                {
                    Html.DevExpress().Label(lblSettings =>
                    {
                        lblSettings.Name = "lblReviewedDate_" + c.VisibleIndex;
                        lblSettings.Text = string.Format("{0} {1}", reviewedDate, TimeZoneInfo.Utc.StandardName);
                        lblSettings.Properties.ClientSideEvents.Init = "function(s,e){SetLocalDate(s,e,'" + reviewedDate + "')}";
                        lblSettings.EncodeHtml = false;
                    }).GetHtml();
                }
            });
            column.ReadOnly = true;
        });

        
        

        //Formatting of validation messages
        foreach (MVCxGridViewColumn c in settings.Columns)
        {
            var prop = (c.PropertiesEdit as EditProperties);
            if (prop != null)
            {
                prop.ValidationSettings.ErrorDisplayMode = ErrorDisplayMode.Text;
                prop.ValidationSettings.ErrorTextPosition = ErrorTextPosition.Bottom;
            }
        }
    });
    
    if (ViewData["EditError"] != null)
    {
        grid.SetEditErrorText((string)ViewData["EditError"]);
    }
    grid.Bind(Model).GetHtml();
%>
