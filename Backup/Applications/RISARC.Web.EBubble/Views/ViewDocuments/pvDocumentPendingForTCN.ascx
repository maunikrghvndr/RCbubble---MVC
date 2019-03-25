<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<% 
    bool isDocumentReadyForSubmission = false;
    var grid = Html.DevExpress().GridView(settings =>
    {
        settings.Name = "gvDocPendingForTCN";

        //Scroll Settings 
        settings.KeyFieldName = "AccountSubmissionDetailsID";
        settings.CallbackRouteValues = new { Controller = "ViewDocuments", Action = "GridViewForDocumentPendingForTCN" };

        settings.Width = System.Web.UI.WebControls.Unit.Percentage(100);

        settings.SettingsText.EmptyDataRow = "No documents present which are pending for TCN#";
        settings.Settings.ShowFilterRow = true;
        settings.ImagesEditors.DropDownEditDropDown.Url = Url.Content("~/Images/icons/calenderIcon.png"); 
        
        settings.Settings.HorizontalScrollBarMode = ScrollBarMode.Auto;
        settings.Settings.VerticalScrollableHeight = 555;
        settings.Settings.VerticalScrollBarMode = ScrollBarMode.Visible;
       
        //resizing mode
        settings.SettingsBehavior.ColumnResizeMode = ColumnResizeMode.Control;
        //==================== Changing Grid Loading Icons ===================
        settings.Images.LoadingPanel.Url = Url.Content("~/Images/icons/LoadingLogo.gif");
        settings.SettingsLoadingPanel.Text = " ";
        settings.Images.LoadingPanel.Width = 76;
        settings.Images.LoadingPanel.Height = 100; 

        //Alterring color
        settings.Styles.AlternatingRow.BackColor = System.Drawing.ColorTranslator.FromHtml("#f7f7f7");
        settings.Styles.Header.BackColor = System.Drawing.ColorTranslator.FromHtml("#e3f3f4");
        settings.Styles.Header.CssClass = "gvworklistHeader";
        
   
        //======================== fillter cell style =======================
        settings.Styles.FilterCell.CssClass = "fillterCell";
        settings.Settings.ShowFilterRow = true;
        settings.Images.FilterRowButton.Url = Url.Content("~/Images/icons/search_im.png");
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

        
        //Action column
        settings.Columns.Add(column =>
        {
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.Caption = "Submit to field office";
            column.Width = Unit.Pixel(84);
            
           column.CellStyle.HorizontalAlign = System.Web.UI.WebControls.HorizontalAlign.Center;

          
           column.CellStyle.CssClass = "tableBorderShadow";
           column.HeaderStyle.CssClass = "tableBorderShadow";
           column.FilterCellStyle.CssClass = "tableBorderShadow";
            
            column.SetDataItemTemplateContent(c =>
            {

                string accountNumber = Convert.ToString(DataBinder.Eval(c.DataItem, "AccountNumberIdentification.AccountNumber"));
                string accountNumberId = Html.Encrypt(Convert.ToString(DataBinder.Eval(c.DataItem, "AccountSubmissionDetailsID")));
                string actionImageUrl = "~/Images/icons/ActionArrowGrey.png";
                string documentId = ""; //will be used in future
              
                bool isSubmitted = Convert.ToBoolean(DataBinder.Eval(c.DataItem, "IsAccountSubmitted"));
                
                RISARC.Common.Enumaration.enumValidationTCNSubmission status = (RISARC.Common.Enumaration.enumValidationTCNSubmission)(DataBinder.Eval(c.DataItem, "ReadyToSubmitStatus"));
                var statusMessgae = "";
                if (status == RISARC.Common.Enumaration.enumValidationTCNSubmission.All_Required_Record_Present)
                {
                    isDocumentReadyForSubmission = true;
                    statusMessgae = "The document Ready to Submit.";
                }
                else if (status == RISARC.Common.Enumaration.enumValidationTCNSubmission.No_Required_record_present) {
                    isDocumentReadyForSubmission = false;
                    statusMessgae = "The document cannot be submitted as the TCN File And Medical Record is not available";
                }
                else if (status == RISARC.Common.Enumaration.enumValidationTCNSubmission.Medical_Record_Not_Present)
                {
                    isDocumentReadyForSubmission = false;
                    statusMessgae = "The document cannot be submitted as Medical Record is not available";
                }
                else if (status == RISARC.Common.Enumaration.enumValidationTCNSubmission.TCN_Summary_Doc_Not_Present)
                {
                    isDocumentReadyForSubmission = false;
                    statusMessgae = "The document cannot be submitted as the TCN File is not available";
                }
                else
                {
                    isDocumentReadyForSubmission = false;
                }
                
                short sourceFlag = 1;
               
                ViewContext.Writer.Write(
                   @Html.DevExpress().Image(
                            Imgsettings =>
                            {
                                Imgsettings.Name = "Action" + c.ItemIndex.ToString();
                                Imgsettings.ControlStyle.Cursor = "pointer";
                                if (isDocumentReadyForSubmission)
                                {
                                    actionImageUrl = "~/Images/icons/ActionArrowOrange.png";
                                    Imgsettings.Properties.ClientSideEvents.Click = string.Format("function(s, e) {{ UpdateReviewStatus('{0}','{1}','{2}','{3}');}}", accountNumberId, documentId, '1', sourceFlag);
                                }
                                else
                                {
                                    Imgsettings.Properties.ClientSideEvents.Click = "function(s, e) { alert('The document cannot be submitted as the TCN File or Medical Record is not available');}";
                                }
                                Imgsettings.ImageUrl = Url.Content(actionImageUrl);
                                Imgsettings.ClientEnabled = true;
                                Imgsettings.ToolTip = statusMessgae;
                            }).GetHtml());
            });
            
        });
        
        
        //Account# column
        settings.Columns.Add(column =>
        {
            column.Caption = "Account#";
            column.FieldName = "AccountNumberIdentification.AccountNumber";
            column.SetDataItemTemplateContent(c =>
            {
                string accountNumber = Convert.ToString(DataBinder.Eval(c.DataItem, "AccountNumberIdentification.AccountNumber"));
                short sendersProviderId = (short)DataBinder.Eval(c.DataItem, "SentFromProviderId");
                string accountNumberId = Html.Encrypt((long)DataBinder.Eval(c.DataItem, "AccountSubmissionDetailsID"));
               
                bool isTCNSubmitted = isDocumentReadyForSubmission;
                
                if (!string.IsNullOrEmpty(accountNumber))
                {
                    ViewContext.Writer.Write(Html.ActionLink(accountNumber, "AccountDetailsMaster", "AccountDetails", new { AccountNo = accountNumber, SenderProviderId = Html.Encrypt(sendersProviderId), sourceFlag = 1, AccountSubmissionDetailsID = accountNumberId, IsTCNSubmitted = isTCNSubmitted }, new { onclick = string.Format("return CheckDocumentAccess('{0}', '{1}'); ", accountNumberId, null) }));
                }
            });
        
            column.Settings.AllowAutoFilter = DefaultBoolean.True;
            column.ReadOnly = true;

        });
        
        //OCR Indexing Status
        settings.Columns.Add(column =>
        {
            column.Caption = "Indexing Status";
            column.FieldName = "DocumentIndexingStatus";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.ReadOnly = true;
        });
        //Sent by user column
        settings.Columns.Add(column =>
        {
            column.Caption = "Sent By Member";
            column.FieldName = "SentByUserName";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.ReadOnly = true;
        });
        //Sent by Organization column
        settings.Columns.Add(column =>
        {
            column.Caption = "Sent By Organization";
            column.FieldName = "SentFromProviderName";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.ReadOnly = true;
        });

        //Sent to column
        settings.Columns.Add(column =>
        {
            column.Caption = "Sent to Organization";
            column.FieldName = "DocumentRecipient.ProviderName";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.ReadOnly = true;
        });

        //Sent Date column
        settings.Columns.Add(column =>
        {
            column.Caption = "Uploaded Date";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.FilterCellStyle.CssClass = "removeFillter";
            
            
            column.FieldName = "LocalCreateDate";
            column.Width = Unit.Pixel(250);
            column.ColumnType = MVCxGridViewColumnType.DateEdit;
            column.HeaderStyle.Wrap = DefaultBoolean.True;
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
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.ReadOnly = true;
        });

        //Patient Last Name column
        settings.Columns.Add(column =>
        {
            column.Caption = "Patient Last Name";
            column.FieldName = "PatientLastname";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.ReadOnly = true;
        });

        //DOS From Column
        settings.Columns.Add(column =>
        {
            column.Caption = "DOS-From";
            column.Width = Unit.Pixel(250);
            column.FilterCellStyle.CssClass = "removeFillter";
            column.FieldName = "AccountNumberIdentification.LocalAccountDateOfServiceFrom";
            column.ColumnType = MVCxGridViewColumnType.DateEdit;
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
           column.FilterCellStyle.CssClass = "removeFillter";
            column.FieldName = "AccountNumberIdentification.LocalAccountDateOfServiceTo";
            column.ColumnType = MVCxGridViewColumnType.DateEdit;
         //  column.Width = Unit.Percentage();
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
