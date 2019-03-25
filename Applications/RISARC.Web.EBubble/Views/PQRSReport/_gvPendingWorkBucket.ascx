<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IEnumerable<RISARC.ACO.Model.PendingBucket>>" %>

<%  
    var grid = Html.DevExpress().GridView(
     settings =>
     {
         settings.Name = "gvPendingBucketWorkBook";
         //  settings.KeyFieldName = "SrNo";
         settings.Width = Unit.Percentage(100);

         settings.CallbackRouteValues = new { Controller = "PQRSReport", Action = "_gvPendingWorkBucket", ProviderIdList = Session["ProviderIds"]};

         //==================== Changing Grid Loading Icons ===================
         settings.Images.LoadingPanel.Url = Url.Content("~/Images/icons/LoadingLogo.gif");
         settings.SettingsLoadingPanel.Text = " ";
         settings.Images.LoadingPanel.Width = 76;
         settings.Images.LoadingPanel.Height = 100;
         
         settings.Settings.ShowFilterRow = true;

         settings.AutoFilterCellEditorInitialize = (sender, e) =>
         {
             ASPxTextBox textBox = (e.Editor as ASPxTextBox);
             ASPxDateEdit dateBox = (e.Editor as ASPxDateEdit);

             if (textBox != null)
             {
                 textBox.NullText = "Search";

             }
         };
         
        
         //Alterring color
         settings.Styles.AlternatingRow.BackColor = System.Drawing.ColorTranslator.FromHtml("#f7f7f7");
         settings.Styles.Header.BackColor = System.Drawing.ColorTranslator.FromHtml("#e3f3f4");
         settings.Styles.Header.CssClass = "gvworklistHeader";

         settings.Styles.Header.Wrap = DefaultBoolean.True;
         
         settings.SettingsEditing.Mode = GridViewEditingMode.Inline;
         settings.SettingsPopup.EditForm.Width = 600;

         //This for nowmal row.
         settings.Styles.Cell.VerticalAlign = VerticalAlign.Middle;
         settings.Styles.Cell.Paddings.PaddingTop = Unit.Pixel(15);
         settings.Styles.Cell.Paddings.PaddingBottom = Unit.Pixel(15);
         settings.Width = Unit.Percentage(100);



         settings.Settings.HorizontalScrollBarMode = ScrollBarMode.Auto;
         settings.SettingsBehavior.ColumnResizeMode = ColumnResizeMode.Control;


         settings.Columns.Add(column =>
         {
             column.FieldName = "MedicareId";
             column.Caption = "Medicare ID";
             column.CellStyle.HorizontalAlign = System.Web.UI.WebControls.HorizontalAlign.Center;
         });

         settings.Columns.Add(column =>
         {
             column.Width = 200;
             column.FieldName = "PatientName";
             column.SetDataItemTemplateContent(c =>
             {
                 string PatientId = Convert.ToString(DataBinder.Eval(c.DataItem, "PatientId"));
                 string PatientName = Convert.ToString(DataBinder.Eval(c.DataItem, "PatientName"));
                 string MedicareId = Convert.ToString(DataBinder.Eval(c.DataItem, "MedicareId"));
                 
                 if (!string.IsNullOrEmpty(PatientId))
                 {
                     ViewContext.Writer.Write(Html.ActionLink(PatientName, "AccountDetailsMaster", "AccountDetails", new { PatientId = Html.Encrypt(PatientId), bk = "pending", pn = PatientName, mid = MedicareId }, null));
                 }
                 column.Settings.AllowAutoFilter = DefaultBoolean.True;
                 column.ReadOnly = true;
             });
         });

         ////Account# column
         //settings.Columns.Add(column =>
         //{
         //    column.Caption = "Account#";
         //    column.FieldName = "AccountNumberIdentification.AccountNumber";
         //    column.SetDataItemTemplateContent(c =>
         //    {
         //        string accountNumber = Convert.ToString(DataBinder.Eval(c.DataItem, "AccountNumberIdentification.AccountNumber"));
         //        short sendersProviderId = (short)DataBinder.Eval(c.DataItem, "SentFromProviderId");
         //        string accountNumberId = Html.Encrypt((long)DataBinder.Eval(c.DataItem, "AccountSubmissionDetailsID"));

         //        bool isTCNSubmitted = isDocumentReadyForSubmission;

         //        if (!string.IsNullOrEmpty(accountNumber))
         //        {
         //            ViewContext.Writer.Write(Html.ActionLink(accountNumber, "AccountDetailsMaster", "AccountDetails", new { AccountNo = accountNumber, SenderProviderId = Html.Encrypt(sendersProviderId), sourceFlag = 1, AccountSubmissionDetailsID = accountNumberId, IsTCNSubmitted = isTCNSubmitted }, new { onclick = string.Format("return CheckDocumentAccess('{0}', '{1}'); ", accountNumberId, null) }));
         //        }
         //    });

         //    column.Settings.AllowAutoFilter = DefaultBoolean.True;
         //    column.ReadOnly = true;

         //});
         
         
         settings.Columns.Add(column =>
         {
             column.Width = 200;
              column.FieldName = "ProviderName";
           
         });

         settings.Columns.Add(column =>
        {
           // column.Width = 150;
             column.FieldName = "Gender";
           
        });

           settings.Columns.Add(column =>
        {
           // column.Width = 150;
            column.FieldName = "Age";
           
        });

         

         settings.Columns.Add(column =>
         {
             // column.Width = 150;
             column.Caption = "CAD Rank";
             column.FieldName = "MeasuresRanks.cadrank";
             
         });

         settings.Columns.Add(column =>
         {
             column.FieldName = "MeasuresRanks.dmrank";
             column.Caption = "DM Rank";
         });

         settings.Columns.Add(column =>
         {

             column.FieldName = "MeasuresRanks.hfrank";
             column.Caption = "HF Rank";
         });
         settings.Columns.Add(column =>
         {

             column.FieldName = "MeasuresRanks.htnrank";
             column.Caption = "HTN Rank";
         });

         settings.Columns.Add(column =>
         {

             column.FieldName = "MeasuresRanks.ivdrank";
             column.Caption = "IVD Rank";
         });

         settings.Columns.Add(column =>
         {

             column.FieldName = "MeasuresRanks.pcbloodpressurerank";
             column.Caption = "BP Rank";
         });
         
         
         
          settings.Columns.Add(column =>
         {
             
             column.FieldName = "MeasuresRanks.pcdepressionrank";
             column.Caption = "DEPRESSION";
         });
        
           settings.Columns.Add(column =>
         {
             
             column.FieldName = "MeasuresRanks.pcflushotrank";
             column.Caption = "FLUSHOT Rank";
         });
       
             settings.Columns.Add(column =>
         {
             
             column.FieldName = "MeasuresRanks.pcmammogramrank";
             column.Caption = "MAMMOGRAM Rank";
         });
        
              settings.Columns.Add(column =>
         {
             
             column.FieldName = "MeasuresRanks.pcpneumoshotrank";
             column.Caption = "NEUMOSHOT Rank";
         });
     
        settings.Columns.Add(column =>
         {
             
             column.FieldName = "MeasuresRanks.pctobaccouserank";
             column.Caption = "BACCOUSER Rank";
         });
                 
         settings.Columns.Add(column =>
         {
             
             column.FieldName = "MeasuresRanks.carefallsrank";
             column.Caption = "CAREFALLS Rank";
         });
       
            settings.Columns.Add(column =>
         {
             
             column.FieldName = "MeasuresRanks.caremedconrank";
             column.Caption = "CAREMEDCON Rank";
         });

       
         
              settings.Columns.Add(column =>
         {
             
             column.FieldName = "MeasuresRanks.pcbmiscreenrank";
             column.Caption = "MIS SCREEN Rank";
         });
         
                  settings.Columns.Add(column =>
         {
             
             column.FieldName = "MeasuresRanks.pccolorectalrank";
             column.Caption = "COLORECTAL Rank";
         });
         
     });


    grid.Bind(Model).GetHtml();%>





