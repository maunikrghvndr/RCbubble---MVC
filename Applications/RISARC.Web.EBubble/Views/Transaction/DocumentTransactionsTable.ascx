<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IEnumerable<RISARC.Documents.Model.Document>>" %>
<%@ Import Namespace="RISARC.Documents.Model.DocumentReception" %>


<% 
    var grid = Html.DevExpress().GridView(settings =>
    {
        settings.Name = "gvDocumentTransactionLog";
        settings.KeyFieldName = "DocumentTypeName";
        settings.CallbackRouteValues = new { Controller = "Transaction", Action = "_DocumentTransactionLog",  startDate = ViewData["StartDate"], endDate = ViewData["EndDate"], acn = ViewData["Acn"], patientFName = ViewData["PatientFName"], patientLName = ViewData["PatientLName"], accountNo = ViewData["AccountNo"] };

        
        settings.Width = System.Web.UI.WebControls.Unit.Percentage(100);

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

     
        settings.Styles.Table.ForeColor = System.Drawing.ColorTranslator.FromHtml("#333333");
        
        //Account# column
        settings.Columns.Add(column =>
        {
            column.Caption = "Document Type";
            column.FieldName = "DocumentTypeName";
            column.ReadOnly = true;
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.Width = 100;
        });
        
              
        settings.Columns.Add(column =>
        {
            column.Caption = "Status";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.Width = 85;
            column.SetDataItemTemplateContent(c =>
            {
                RISARC.Documents.Model.DocumentStatus DocumentStatus = (RISARC.Documents.Model.DocumentStatus)DataBinder.Eval(c.DataItem, "DocumentStatus");

                Html.RenderPartial("~/Views/ViewDocuments/DocumentStatusDescription.ascx", new ViewDataDictionary {
                                        {"DocumentStatus",DocumentStatus }});
            });
            column.ReadOnly = true;
        });


        settings.Columns.Add(column =>
        {
            column.Caption = "Sent On";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.FieldName = "CreateUTCDate";
            column.ReadOnly = true;
            column.Width = Unit.Pixel(250);
            column.SetDataItemTemplateContent(c =>
            {
                string uploadeDate = Convert.ToString(DataBinder.Eval(c.DataItem, "CreateUTCDate"));
                if (!string.IsNullOrEmpty(uploadeDate))
                {
                    Html.DevExpress().Label(lblSettings =>
                    {
                        lblSettings.Name = "CreateUTCDate" + c.VisibleIndex;
                        lblSettings.Text = string.Format("{0} {1}", uploadeDate, TimeZoneInfo.Utc.StandardName);
                        lblSettings.Properties.ClientSideEvents.Init = "function(s,e){SetLocalDate(s,e,'" + uploadeDate + "')}";
                        lblSettings.EncodeHtml = false;
                    }).GetHtml();
                }
            });

        });

        settings.Columns.Add(column =>
        {
            column.Caption = "Downloaded";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.FieldName = "ActionTime";
            column.ReadOnly = true;
            column.Width = Unit.Pixel(250);
            column.SetDataItemTemplateContent(c =>
            {
                string uploadeDate = Convert.ToString(DataBinder.Eval(c.DataItem, "ActionTime"));
                if (!string.IsNullOrEmpty(uploadeDate))
                {
                    Html.DevExpress().Label(lblSettings =>
                    {
                        lblSettings.Name = "ActionTime" + c.VisibleIndex;
                        lblSettings.Text = string.Format("{0} {1}", uploadeDate, TimeZoneInfo.Utc.StandardName);
                        lblSettings.Properties.ClientSideEvents.Init = "function(s,e){SetLocalDate(s,e,'" + uploadeDate + "')}";
                        lblSettings.EncodeHtml = false;
                    }).GetHtml();
                }
            });

        });

        settings.Columns.Add(column =>
        {
            column.Caption = "ACN/DCN/ICN #";
            column.FieldName = "ACN.ACNNumber";
            column.Width = 100;
            column.ReadOnly = true;
            column.HeaderStyle.Wrap = DefaultBoolean.True;
        });

        settings.Columns.Add(column =>
        {
            column.Caption = "Account #";
            column.FieldName = "AccountNoRac"; 
            column.Width = 100;
            column.ReadOnly = true;
            column.HeaderStyle.Wrap = DefaultBoolean.True;
        });

        settings.Columns.Add(column =>
        {
            column.Caption = "Sent By (Provider)";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.Width = 150;
            column.SetDataItemTemplateContent(c =>
            {

                string sentFromProviderName = Convert.ToString(DataBinder.Eval(c.DataItem, "SentFromProviderName"));
                RISARC.Common.Model.UserDescription UserDescription = new RISARC.Common.Model.UserDescription();
                UserDescription = (RISARC.Common.Model.UserDescription)DataBinder.Eval(c.DataItem, "CreatedByUserDescription");
                Html.RenderPartial("UserDescription", UserDescription);
                ViewContext.Writer.Write(Html.Encode(sentFromProviderName));

            });
        });

        settings.Columns.Add(column =>
        {
            column.Caption = "Sent for Request";
            column.FieldName = "DocumentRequestId";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.SetDataItemTemplateContent(c =>
            {
                int documentRequestId = Convert.ToInt32(DataBinder.Eval(c.DataItem, "DocumentRequestId"));
                if (documentRequestId > 0)
                {
                    Html.ActionLink("Request details", "DocumentRequestTransaction",new { requestID = Html.Encrypt(documentRequestId)});
                }
                else
                {
                    ViewContext.Writer.Write("No");
                }
                
                
            });
        });

        settings.Columns.Add(column =>
        {
            column.Caption = "First Name";
            column.FieldName = "PatientFirstname";
            column.ReadOnly = true;
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.Width = 100;
        });

        settings.Columns.Add(column =>
        {
            column.Caption = "Last Name";
            column.FieldName = "PatientLastname";
            column.ReadOnly = true;
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.Width = 100;
        });

        settings.Columns.Add(column =>
        {
            column.Caption = "Sent To";
            column.FieldName = "DocumentRecipient";
            column.Width = 180;
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.SetDataItemTemplateContent(c =>
            {
                int recipientCount = Convert.ToInt32(DataBinder.Eval(c.DataItem, "RecipientCount"));
                string multipleRecipients = Convert.ToString(DataBinder.Eval(c.DataItem, "MultipleRecipients"));
                Object documentRecipient = DataBinder.Eval(c.DataItem, "DocumentRecipient");
                if (recipientCount == 1)
                {
                    if (multipleRecipients.Length > 0)
                    {
                        ViewContext.Writer.Write(multipleRecipients.Replace(",", "<br />").ToString());
                    }
                    else
                    {
                        Html.RenderPartial("~/Views/ViewDocuments/DocumentRecipientProvider.ascx", documentRecipient);
                    }
                }
                else if (recipientCount > 1)
                {
                    ViewContext.Writer.Write(@"<u>List of all recipients:</u><br />");
                    var recipients = Convert.ToString(DataBinder.Eval(c.DataItem, "MultipleRecipients")).Replace(",", @"<br/>");
                    ViewContext.Writer.Write(recipients);
                }
                else
                {
                    ViewContext.Writer.Write("SENT TO EVERYONE");
                }

            });
        });

        settings.Columns.Add(column =>
        {
            column.Caption = "Cost";
            column.FieldName = "Cost";
            column.ReadOnly = true;
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.PropertiesEdit.DisplayFormatString = "c2";
            column.Width = 50;
        });

        settings.Columns.Add(column =>
        {
            column.Caption = "Billing Method";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.Width = 100;
            column.SetDataItemTemplateContent(c =>
            {
                
                Html.RenderPartial("~/Views/ViewDocuments/DocumentBillingMethodDescription.ascx", Model.ElementAt(c.VisibleIndex));
            });
        });

        settings.Columns.Add(column =>
        {
            column.Caption = "# of Pages";
            column.FieldName = "NumberOfPages";
            column.ReadOnly = true;
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.Width = 50;
        });

        settings.Columns.Add(column =>
        {
            column.Caption = "Details";
            column.Width = 65;
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.SetDataItemTemplateContent(c =>
            {

                int documentId = Convert.ToInt32(DataBinder.Eval(c.DataItem, "Id"));
                string encryptedDocumentId = Html.Encrypt(documentId);
                ViewContext.Writer.Write(Html.ActionLink("Details", "DocumentTransaction", new { documentId = encryptedDocumentId }));

            });
        });


    }).Bind(Model).GetHtml(); //grid ends 

%>
 
