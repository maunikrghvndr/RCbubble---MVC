<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<%@Import Namespace="RISARC.Common.Model" %>
<%@ Import Namespace="RISARC.Documents.Model" %>

<%= Html.DevExpress().GridView(
    settings => {
        settings.Name = "gridDownloadDocumentType";
        settings.KeyFieldName = "Id";
        settings.Width = Unit.Percentage(100);
      
        
        //========== Grid View Resizing Column Header of Grid View ===========
         settings.SettingsBehavior.ColumnResizeMode = ColumnResizeMode.Control;

         settings.Settings.HorizontalScrollBarMode = ScrollBarMode.Auto;
         settings.Settings.VerticalScrollBarMode = ScrollBarMode.Visible;
         settings.Settings.VerticalScrollableHeight = 555;


        settings.Styles.AlternatingRow.BackColor = System.Drawing.ColorTranslator.FromHtml("#f7f7f7");
        settings.Styles.Header.BackColor = System.Drawing.ColorTranslator.FromHtml("#e3f3f4");
        settings.Styles.Header.CssClass = "gvworklistHeader";
       
        
           //======================== fillter cell style =======================
         // settings.StylesEditors.CalendarButton.i = Url.Content("~/Images/icons/search_im.png");
       
        settings.Styles.FilterCell.CssClass = "fillterCell";
        settings.Settings.ShowFilterRow = true;
        settings.ImagesEditors.DropDownEditDropDown.Url = Url.Content("~/Images/icons/calenderIcon.png"); 
    
        
        settings.Images.FilterRowButton.Url = Url.Content("~/Images/icons/search_im.png");
        settings.Styles.Table.ForeColor = System.Drawing.ColorTranslator.FromHtml("#333333");
        
                //==================== Changing Grid Loading Icons ===================
        settings.Images.LoadingPanel.Url = Url.Content("~/Images/icons/LoadingLogo.gif");
        settings.SettingsLoadingPanel.Text = " ";
        settings.Images.LoadingPanel.Width = 76;
        settings.Images.LoadingPanel.Height = 100; 
        
        settings.Styles.SelectedRow.ForeColor = System.Drawing.ColorTranslator.FromHtml("#000");
        settings.Styles.SelectedRow.BackColor = System.Drawing.ColorTranslator.FromHtml("#fffedf");

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

        settings.ClientSideEvents.ColumnResizing = "stopResizingActionCol";
        
    //    settings.SettingsBehavior.AllowSelectByRowClick = true;  //commented bu sukha
        settings.CallbackRouteValues = new
                                        {
                                            Controller = "ViewDocuments",
                                            Action = "GridViewForDocumentsDownloaded"
                                        };

        //column
        settings.Columns.Add(column =>
        {
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.Caption = "Document";
            column.Name = "ActionColumn";
            column.Width = Unit.Pixel(110);
         
            column.CellStyle.CssClass = "tableBorderShadow";
            column.HeaderStyle.CssClass = "tableBorderShadow";
            column.FilterCellStyle.CssClass = "tableBorderShadow";
          
            column.SetDataItemTemplateContent(c =>
            {
                DocumentStatus status = (DocumentStatus)DataBinder.Eval(c.DataItem, "DocumentStatus"); // ViewData["DocumentStatus"];
                int documentId = (int)DataBinder.Eval(c.DataItem, "Id"); // ViewData["DocumentId"];
                string encryptedDocumentId = Html.Encrypt(documentId);
                string actionDescription=  null, actionDescriptionView = null;
                switch (status)
                {
                    case DocumentStatus.ReadyForDownload:
                        actionDescription = "Download";
                        actionDescriptionView = "View";
                        break;
                    case DocumentStatus.AwaitingVerification:
                        actionDescription = "Verify Patient Identification";
                        break;
                    case DocumentStatus.ReadyForCompliance:
                        actionDescription = "Submit Release Forms";
                        break;
                    case DocumentStatus.ReadyForPurchase:
                        actionDescription = "Purchase";
                        break;
                    
                    //default:
                    //    actionDescription = null;
                    //    actionDescriptionView = null;
                        //break;
                }
             

                DocumentStatus Docstatus = (DocumentStatus)DataBinder.Eval(c.DataItem, "DocumentStatus"); // ViewData["DocumentStatus"];
                int DocumentFileId = (int)DataBinder.Eval(c.DataItem, "DocumentFileId"); // ViewData["DocumentId"];
                ViewContext.Writer.Write("<div class='floatLeft'>");
                if (!string.IsNullOrEmpty(actionDescriptionView) && actionDescriptionView == "View")
                {
                    ViewContext.Writer.Write(Html.ActionLink(actionDescriptionView, "AccountDetailsMaster", "AccountDetails", new { DocumentFileId = Html.Encrypt(DocumentFileId), documentId = encryptedDocumentId }, new { @class = "clsLoader", onclick = string.Format("return CheckDocumentAccess('{0}', '{1}');", null, DocumentFileId) }));
                }
              
                ViewContext.Writer.Write("</div><div class='floatRight'>");
                if (!string.IsNullOrEmpty(actionDescription))
                {
                    ViewContext.Writer.Write(Html.ActionLink(actionDescription, "Index", "Document", new { documentId = encryptedDocumentId }, null));
                }
                ViewContext.Writer.Write("</div>"); 
                
            });
            column.ReadOnly = true;
        });
        
        
        
        
        settings.Columns.Add(column =>
        {
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.FieldName = "DocumentTypeName";
            column.Caption = "Document Type";
            column.ReadOnly = true;
            column.Width = Unit.Pixel(150);
        });


        settings.Columns.Add(column =>
        {
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.Caption = "Downloaded";
            column.ReadOnly = true;
            column.Width = Unit.Pixel(250);
            column.FilterCellStyle.CssClass = "removeFillter";
            column.FieldName = "ActionUTCTime";
            column.ColumnType = MVCxGridViewColumnType.DateEdit;

            column.SetDataItemTemplateContent(c =>
            {
                string actionUTCDateTime = Convert.ToString(DataBinder.Eval(c.DataItem, "ActionUTCTime"));
                if (!string.IsNullOrEmpty(actionUTCDateTime))
                {
                    Html.DevExpress().Label(lblSettings =>
                    {
                        lblSettings.Name = "lblDownloadedOn_" + Convert.ToString(DataBinder.Eval(c.DataItem, "Id"));
                        lblSettings.Text = string.Format("{0}<br />{1}", actionUTCDateTime, TimeZoneInfo.Utc.StandardName);
                        lblSettings.Properties.ClientSideEvents.Init = "function(s,e){SetLocalDate(s,e,'" + actionUTCDateTime + "')}";
                        lblSettings.EncodeHtml = false;
                    }).GetHtml();
                }
            });
        });
        
        settings.Columns.Add(column => 
        {
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.FieldName = "DocumentDescription";
            column.Caption = "Document Description";
            column.ReadOnly = true;
            column.Width = Unit.Pixel(200);
        });
        settings.Columns.Add(column =>
        {
            column.Caption = "Sent By (Provider)";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.Width = Unit.Pixel(200);
            column.FieldName = "CreatedByUserDescription.Email";
            
            column.SetDataItemTemplateContent( c =>{
                
                ViewContext.Writer.Write(
                    (DataBinder.Eval(c.DataItem, "CreatedByUserDescription.FirstName") as string) + " " + (DataBinder.Eval(c.DataItem, "CreatedByUserDescription.LastName") as string)
                );
                
                if (!String.IsNullOrEmpty(DataBinder.Eval(c.DataItem, "CreatedByUserDescription.Email") as string))
                {
                    ViewContext.Writer.Write(
                       " " + Html.Mailto((DataBinder.Eval(c.DataItem, "CreatedByUserDescription.Email") as string), (DataBinder.Eval(c.DataItem, "CreatedByUserDescription.Email") as string))
                    );
                }
                ViewContext.Writer.Write(
                    " " + (DataBinder.Eval(c.DataItem, "CreatedByUserDescription.Title") as string)
                );
                ViewContext.Writer.Write(
                    " " + (DataBinder.Eval(c.DataItem, "SentFromProviderName") as string)
                );
            });
            column.ReadOnly = true;
        });
        settings.Columns.Add(column =>
        {
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.FieldName = "PatientFirstname";
            column.Caption = "First Name";
            column.ReadOnly = true;
            column.Width = Unit.Pixel(120);
        });
        settings.Columns.Add(column =>
        {
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.FieldName = "PatientLastname";
            column.Caption = "Last Name";
            column.ReadOnly = true;
            column.Width = Unit.Pixel(120);
        });
        settings.Columns.Add(column =>
        {
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.Caption = "Sent On";
            column.ReadOnly = true;
            column.Width = Unit.Pixel(250);

            column.FieldName = "CreateUTCDate";
            column.ColumnType = MVCxGridViewColumnType.DateEdit;

            column.FilterCellStyle.CssClass = "removeFillter";
            

           // ((DateEditProperties)column.PropertiesEdit).CalendarProperties.ButtonStyle.CssClass = "CalIcon";
            
            column.SetDataItemTemplateContent(c =>
            {
                string createdUTCDate = Convert.ToString(DataBinder.Eval(c.DataItem, "CreateUTCDate"));
                if (!string.IsNullOrEmpty(createdUTCDate))
                {
                    Html.DevExpress().Label(lblSettings =>
                    {
                        lblSettings.Name = "lblSentOn_" + Convert.ToString(DataBinder.Eval(c.DataItem, "Id"));
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
            column.FieldName = "Cost";
            column.Caption = "Cost";
            column.PropertiesEdit.DisplayFormatString = "c";
            column.ReadOnly = true;
        });
        settings.Columns.Add(column =>
        {
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.Caption = "Billing Method";
            column.FieldName = "BillingMethodMessage";
            
            //column.SetDataItemTemplateContent(c => {
            //    if (((BillingMethod)DataBinder.Eval(c.DataItem, "BillingMethod")) == (BillingMethod.InvoiceProvider))
            //    {
            //        ViewContext.Writer.Write("Bill to sender");
            //    }
            //    else if (((BillingMethod)DataBinder.Eval(c.DataItem, "BillingMethod")) == (BillingMethod.CreditCard))
            //    {
            //        ViewContext.Writer.Write("Bill to receiver by credit/debit card");
            //    }
            //    else if (((BillingMethod)DataBinder.Eval(c.DataItem, "BillingMethod")) == (BillingMethod.Free))
            //    {
            //        ViewContext.Writer.Write("Document is free");
            //    }
                 
            //    else if (((BillingMethod)DataBinder.Eval(c.DataItem, "BillingMethod")) == (BillingMethod.PaymentReceived))
            //    {
            //        ViewContext.Writer.Write("Payment received");
            //    }
            //});
            column.ReadOnly = true;
        });
        settings.Columns.Add(column =>
        {
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.Caption = "Status";
            column.Width = Unit.Percentage(25);
            column.FieldName = "DocumentStatusMessage";
            //column.SetDataItemTemplateContent(c => {
            //    DocumentStatus status = (DocumentStatus)DataBinder.Eval(c.DataItem, "DocumentStatus");// ViewData["DocumentStatus"];
            //    if (status == DocumentStatus.ReadyForDownload)
            //    {
            //        ViewContext.Writer.Write("Available to download");
            //    }
            //    else if (status == DocumentStatus.Expired)
            //    {
            //        ViewContext.Writer.Write("Download has expired");
            //    }
            //    else if (status == DocumentStatus.AwaitingVerification)
            //    {
            //        ViewContext.Writer.Write("Identity verification needed");
            //    }
            //    else if (status == DocumentStatus.LockedOutFromAttemptedVerifications)
            //    {
            //        ViewContext.Writer.Write("Locked");
            //    }
            //    else if (status == DocumentStatus.ReadyForCompliance)
            //    {
            //        ViewContext.Writer.Write("Release form needed");
            //    }
            //    else if (status == DocumentStatus.AwaitingComplianceApproval)
            //    {
            //        ViewContext.Writer.Write("Pending release form approval");
            //    }
            //    else if (status == DocumentStatus.ReadyForPurchase)
            //    {
            //        ViewContext.Writer.Write("Available for purchase");
            //    }
               
               
            //});
            column.ReadOnly = true;
        });
        
        //settings.Columns.Add(column =>
        //{
        //    column.HeaderStyle.Wrap = DefaultBoolean.True;
        //    column.Caption = "Document link";
        //    column.SetDataItemTemplateContent(c => {
        //        DocumentStatus status = (DocumentStatus)DataBinder.Eval(c.DataItem, "DocumentStatus"); // ViewData["DocumentStatus"];
        //        int documentId = (int)DataBinder.Eval(c.DataItem, "Id"); // ViewData["DocumentId"];
        //        string encryptedDocumentId = Html.Encrypt(documentId);
        //        string actionDescription;
        //        switch (status)
        //        {
        //            case DocumentStatus.AwaitingVerification:
        //                actionDescription = "Verify Patient Identification";
        //                break;
        //            case DocumentStatus.ReadyForCompliance:
        //                actionDescription = "Submit Release Forms";
        //                break;
        //            case DocumentStatus.ReadyForPurchase:
        //                actionDescription = "Purchase Document";
        //                break;
        //            case DocumentStatus.ReadyForDownload:
        //                actionDescription = "Download Document";
        //                break;
        //            default:
        //                actionDescription = null;
        //                break;
        //        }
        //        if (!string.IsNullOrEmpty(actionDescription)) {
        //            ViewContext.Writer.Write(Html.ActionLink(actionDescription, "Index", "Document", new { documentId = encryptedDocumentId }, null));
        //        }
        //    });
        //    column.ReadOnly = true;
        //});

        //settings.Columns.Add(column =>
        //{
        //    column.HeaderStyle.Wrap = DefaultBoolean.True;
        //    column.Caption = "View Document link";
        //    column.SetDataItemTemplateContent(c =>
        //    {
        //        DocumentStatus status = (DocumentStatus)DataBinder.Eval(c.DataItem, "DocumentStatus"); // ViewData["DocumentStatus"];
        //        int DocumentFileId = (int)DataBinder.Eval(c.DataItem, "DocumentFileId"); // ViewData["DocumentId"];
        //        //string encryptedDocumentId = Html.Encrypt(documentId);
        //        string actionDescription;
        //        switch (status)
        //        {
        //            case DocumentStatus.AwaitingVerification:
        //                actionDescription = "Verify Patient Identification";
        //                break;
        //            case DocumentStatus.ReadyForCompliance:
        //                actionDescription = "Submit Release Forms";
        //                break;
        //            case DocumentStatus.ReadyForPurchase:
        //                actionDescription = "Purchase Document";
        //                break;
        //            case DocumentStatus.ReadyForDownload:
        //                actionDescription = "View Document";
        //                break;
        //            default:
        //                actionDescription = null;
        //                break;
        //        }
        //        if (!string.IsNullOrEmpty(actionDescription) && actionDescription == "View Document")
        //        {
        //            ViewContext.Writer.Write(Html.ActionLink(actionDescription, "AccountDetailsMaster", "AccountDetails", new { DocumentFileId = Html.Encrypt(DocumentFileId) }, new { onclick = string.Format("return CheckDocumentAccess('{0}', '{1}');", null, DocumentFileId) }));
        //        }
        //    });
        //    column.ReadOnly = true;
        //});
    }
).Bind(Model).GetHtml()
%>


