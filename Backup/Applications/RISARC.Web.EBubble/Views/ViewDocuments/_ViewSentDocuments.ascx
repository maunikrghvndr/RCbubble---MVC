<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IEnumerable<RISARC.Documents.Model.Document>>" %>
<%= Html.DevExpress().GridView(settings => {
    settings.Name = "grdSentDocuments";


    settings.CallbackRouteValues = new { Controller = "ViewDocuments", Action = "grdSentDocuments_Callback", startDate = ViewData["StartDate"], endDate = ViewData["EndDate"], acn = ViewData["Acn"], patientFName = ViewData["PatientFName"], patientLName = ViewData["PatientLName"], accountNo = ViewData["AccountNo"] };

     //==================== Changing Grid Loading Icons ===================
        settings.Images.LoadingPanel.Url = Url.Content("~/Images/icons/LoadingLogo.gif");
        settings.SettingsLoadingPanel.Text = " ";
        settings.Images.LoadingPanel.Width = 76;
        settings.Images.LoadingPanel.Height = 100; 

    settings.SettingsBehavior.ColumnResizeMode = ColumnResizeMode.Control;


    settings.Styles.AlternatingRow.BackColor = System.Drawing.ColorTranslator.FromHtml("#f7f7f7");
    settings.Styles.Header.BackColor = System.Drawing.ColorTranslator.FromHtml("#e3f3f4");
    settings.Styles.Header.CssClass = "gvworklistHeader";

    settings.Width = Unit.Percentage(100);

    settings.Settings.VerticalScrollBarMode = ScrollBarMode.Visible;
    settings.Settings.HorizontalScrollBarMode = ScrollBarMode.Auto;

    settings.Settings.VerticalScrollableHeight = 555;

    // Global Variables
    long? documentId = null;
    string encryptedDocumentId = null;
    // end global variables
    
  
    // Columns Add Start
    settings.Columns.Add(column => {
        column.Caption = "Document Type";
        column.FieldName = "DocumentTypeName";
        column.HeaderStyle.Wrap = DefaultBoolean.True;
        column.Width = 120;
        
    });
    settings.Columns.Add(column =>
    {
        column.Caption = "Document Description";
        column.FieldName = "DocumentDescription";
        column.HeaderStyle.Wrap = DefaultBoolean.True;
        column.Width = 120;
    });
    settings.Columns.Add(column =>
    {
        column.Caption = "ACN Number";
        column.FieldName = "ACN.ACNNumber";
        column.HeaderStyle.Wrap = DefaultBoolean.True;
        column.Width = 120;
    });
    settings.Columns.Add(column =>
    {
        column.Caption = "Account#";
        column.FieldName = "AccountNoRac";
        column.HeaderStyle.Wrap = DefaultBoolean.True;
        column.Width = 120;
    });
    settings.Columns.Add(column =>
    {
        column.Caption = "Sent By (Provider)";
        column.HeaderStyle.Wrap = DefaultBoolean.True;
        column.FieldName = "SentFromProviderName";
        column.SetDataItemTemplateContent(c => {
            Html.RenderPartial("UserDescription", DataBinder.Eval(c.DataItem, "CreatedByUserDescription"));
            ViewContext.Writer.Write(@"<br/>");
            Html.Encode(DataBinder.Eval(c.DataItem, "SentFromProviderName"));
        });

        column.Width = 120;
    });
    settings.Columns.Add(column =>
    {
        column.Caption = "First name";
        column.FieldName = "PatientFirstname";
        column.HeaderStyle.Wrap = DefaultBoolean.True;
        column.Width = 120;
    });
    settings.Columns.Add(column =>
    {
        column.Caption = "Last name";
        column.HeaderStyle.Wrap = DefaultBoolean.True;
        column.FieldName = "PatientLastname";
        column.Width = 120;
    });
    settings.Columns.Add(column =>
    {
        column.FieldName = "CreateUTCDate";
        column.Caption = "Sent on";
        column.Width = 250;
        
        column.HeaderStyle.Wrap = DefaultBoolean.True;
        column.SetDataItemTemplateContent(c =>
        {
            string createdUTCDate = Convert.ToString(DataBinder.Eval(c.DataItem, "CreateUTCDate"));
            if (!string.IsNullOrEmpty(createdUTCDate))
            {
                Html.DevExpress().Label(lblSettings =>
                {
                    lblSettings.Name = "lblCreatedOn_" + c.VisibleIndex;
                    lblSettings.Text = string.Format("{0} {1}", createdUTCDate, TimeZoneInfo.Utc.StandardName);
                    lblSettings.Properties.ClientSideEvents.Init = "function(s,e){SetLocalDate(s,e,'" + createdUTCDate + "')}";
                    lblSettings.EncodeHtml = false;
                }).GetHtml();
            }
        });
    });
    settings.Columns.Add(column =>
    {
        column.Caption = "Sent to";
        column.HeaderStyle.Wrap = DefaultBoolean.True;
        column.Width = 180;
        column.SetDataItemTemplateContent(c => {
            
            var recipientCount = Convert.ToInt32(DataBinder.Eval(c.DataItem, "RecipientCount"));

            if (recipientCount == 1)
            {
                Html.RenderPartial("DocumentRecipientProvider", DataBinder.Eval(c.DataItem, "DocumentRecipient"));
            } 
            else if (recipientCount > 1)
            {
                ViewContext.Writer.Write(@"<u>List of all recipients:</u><br />");
                var recipients = Convert.ToString(DataBinder.Eval(c.DataItem, "MultipleRecipients")).Replace(",", @"<br/>");
                ViewContext.Writer.Write(recipients);
            }
        });
    });
    settings.Columns.Add(column =>
    {
        column.FieldName = "ActionUTCTime";
        column.HeaderStyle.Wrap = DefaultBoolean.True;
        column.Caption = "Downloaded";
        column.Width = 250;
        column.SetDataItemTemplateContent(c =>
        {
            string actionUTCTime = Convert.ToString(DataBinder.Eval(c.DataItem, "ActionUTCTime"));
            if (!string.IsNullOrEmpty(actionUTCTime))
            {
                Html.DevExpress().Label(lblSettings =>
                {
                    lblSettings.Name = "lblDownloadedOn_" + c.VisibleIndex;
                    lblSettings.Text = string.Format("{0} {1}", actionUTCTime, TimeZoneInfo.Utc.StandardName);
                    lblSettings.Properties.ClientSideEvents.Init = "function(s,e){SetLocalDate(s,e,'" + actionUTCTime + "')}";
                    lblSettings.EncodeHtml = false;
                }).GetHtml();
            }
        });
    });
    settings.Columns.Add(column =>
    {
        column.Caption = "Cost";
        column.HeaderStyle.Wrap = DefaultBoolean.True;
        column.FieldName = "Cost";
        column.PropertiesEdit.DisplayFormatString = "c";
        column.Width = 50;
    });
    settings.Columns.Add(column =>
    {
        column.Caption = "Billing Method";
        column.Width = 120;


        column.SetDataItemTemplateContent(c =>
        {
            var doc = Model.ToArray<RISARC.Documents.Model.Document>()[c.ItemIndex];
            Html.RenderPartial("DocumentBillingMethodDescription", doc);
        });
    });
    settings.Columns.Add(column =>
    {
        column.Caption = "Status";
        column.Width = 80;
        column.HeaderStyle.Wrap = DefaultBoolean.True;
        column.SetDataItemTemplateContent(c =>
        {
            Html.RenderPartial("DocumentStatusDescription", null, new ViewDataDictionary { {"DocumentStatus", DataBinder.Eval(c.DataItem, "DocumentStatus")}});
        });
    });
    settings.Columns.Add(column =>
    {
        column.Caption = "Details";
        column.Width = 55;
        column.SetDataItemTemplateContent(c =>
        {
            documentId = Convert.ToInt64(DataBinder.Eval(c.DataItem, "Id"));
            encryptedDocumentId = Html.Encrypt(documentId);
            ViewContext.Writer.Write(Html.ActionLink("Details", "DocumentTransactionUser", "ViewDocuments", new { documentId = encryptedDocumentId }, null));
        });
    });
    settings.Columns.Add(column =>
    {
        column.Caption = "Rac Appeals";
        column.Width = 85;
        column.HeaderStyle.Wrap = DefaultBoolean.True;
        column.SetDataItemTemplateContent(c =>
        {
            ViewContext.Writer.Write(Html.ActionLink("RacAppeals", "RacAppeals", "Transaction", new { documentId = encryptedDocumentId }, null));
        });
    });
    settings.Columns.Add(column =>
    {
        column.Caption = "Show Documents";
        column.Width = 120;
        column.HeaderStyle.Wrap = DefaultBoolean.True;
        column.SetDataItemTemplateContent(c =>
        {
            long DocumentFileId = Convert.ToInt64(DataBinder.Eval(c.DataItem, "DocumentFileId")); 
            string encryptedDocumenFileId = Html.Encrypt(DocumentFileId);
            string documentTypeName = Convert.ToString(DataBinder.Eval(c.DataItem, "DocumentTypeName"));
            if (documentTypeName.Contains("TCN Summary"))
            {
                ViewContext.Writer.Write("Document Cannot Be Viewed");
            }
            else
            {

                ViewContext.Writer.Write(Html.ActionLink("View Document", "AccountDetailsMaster", "AccountDetails", new { DocumentFileId = encryptedDocumenFileId }, new {  onclick = string.Format("return CheckDocumentAccess('{0}', '{1}');", null, DocumentFileId) }));
            }
        });
    });
    // Column Add End
}).Bind(Model).GetHtml() %>
