<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IEnumerable<RISARC.Documents.Model.Document>>" %>
<%= Html.DevExpress().GridView(settings => {
    
    settings.Name = "grdReceivedDocuments";


    settings.CallbackRouteValues = new { Controller = "ViewDocuments", Action = "_MyReceivedDocuments", startDate = ViewData["StartDate"], endDate = ViewData["EndDate"], acn = ViewData["Acn"], patientFName = ViewData["PatientFName"], patientLName = ViewData["PatientLName"], accountNo = ViewData["AccountNo"] };

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

    // Columns Add Start
    settings.Columns.Add(column => {
        column.Caption = "Document Type";
        column.FieldName = "DocumentTypeName";
        column.HeaderStyle.Wrap = DefaultBoolean.True;
        column.Width = 130;
        
    });
    settings.Columns.Add(column =>
    {
        column.Caption = "Document Description";
        column.FieldName = "DocumentDescription";
        column.HeaderStyle.Wrap = DefaultBoolean.True;
        column.Width = 165;
    });
    settings.Columns.Add(column =>
    {
        column.Caption = "ACN Number";
        column.FieldName = "ACN.ACNNumber";
        column.HeaderStyle.Wrap = DefaultBoolean.True;
        column.Width = 110;
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

        column.Width = 170;
    });
    settings.Columns.Add(column =>
    {
        column.Caption = "First name";
        column.FieldName = "PatientFirstname";
        column.HeaderStyle.Wrap = DefaultBoolean.True;
        column.Width = 110;
    });
    settings.Columns.Add(column =>
    {
        column.Caption = "Last name";
        column.HeaderStyle.Wrap = DefaultBoolean.True;
        column.FieldName = "PatientLastname";
        column.Width = 110;
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
        column.Width = 55;
    });
    settings.Columns.Add(column =>
    {
        column.Caption = "Billing Method";
        column.Width = 110;


        column.SetDataItemTemplateContent(c =>
        {
            var doc = Model.ToArray<RISARC.Documents.Model.Document>()[c.ItemIndex];
            Html.RenderPartial("DocumentBillingMethodDescription", doc);
        });
    });
    settings.Columns.Add(column =>
    {
        column.Caption = "Status";
        column.FieldName = "DocumentStatusMessage";
        column.Width = 120;
        column.HeaderStyle.Wrap = DefaultBoolean.True;
        //column.SetDataItemTemplateContent(c =>
        //{
        //    Html.RenderPartial("DocumentStatusDescription", null, new ViewDataDictionary { {"DocumentStatus", DataBinder.Eval(c.DataItem, "DocumentStatus")}});
        //});
    });
    settings.Columns.Add(column =>
    {
        column.Caption = "Document Link";
        column.Width = 120;
        column.SetDataItemTemplateContent(c =>
        {
            Html.RenderPartial("ReceivedDocumentStatusAction", null, new ViewDataDictionary { { "DocumentStatus", DataBinder.Eval(c.DataItem, "DocumentStatus") }, { "DocumentId", DataBinder.Eval(c.DataItem, "Id") } }); 
             
        });
    });
    
    
    // Column Add End
    
}).Bind(Model).GetHtml() %>
