<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IEnumerable<RISARC.Documents.Model.Document>>" %>

<% 
   
    var grid = Html.DevExpress().GridView(settings =>
    {
        settings.Name = "gvRacReport";


        settings.KeyFieldName = "PatientFirstname";
        settings.CallbackRouteValues = new { Controller = "Transaction", Action = "_DocumentRACMoneyTransactions" };

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

        //Table backround color 
        //settings.Styles.Table.BackColor = System.Drawing.ColorTranslator.FromHtml("#ffffff");
        //settings.Styles.Table.ForeColor = System.Drawing.ColorTranslator.FromHtml("#707070");
        settings.Styles.Table.ForeColor = System.Drawing.ColorTranslator.FromHtml("#333333");

        settings.SettingsPager.PageSize = 20;
        //Account# column
        settings.Columns.Add(column =>
        {
            column.Caption = "Account No";
            column.FieldName = "AccountNoRac";
            column.ReadOnly = true;
            column.Width = 100;
        });
        
       
        settings.Columns.Add(column =>
        {
            column.Caption = "First Name";
            column.FieldName = "PatientFirstname";
          //  column.Width = Unit.Percentage(7);
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.ReadOnly = true;
            column.Width = 110;
        });

       
        settings.Columns.Add(column =>
        {
            column.Caption = "Last Name";
            column.FieldName = "PatientLastname";
           // column.Width = Unit.Percentage(16);
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.ReadOnly = true;
            column.Width = 110;
        });


		  settings.Columns.Add(column =>
        {
            column.Caption = "Request Date";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.FieldName = "RequestUTCDate";
            column.ReadOnly = true;
            column.Width = Unit.Pixel(250);
            column.SetDataItemTemplateContent(c =>
            {
                string uploadeDate = Convert.ToString(DataBinder.Eval(c.DataItem, "RequestUTCDate"));
                if (!string.IsNullOrEmpty(uploadeDate))
                {
                    Html.DevExpress().Label(lblSettings =>
                    {
                        lblSettings.Name = "RequestUTCDate" + c.VisibleIndex;
                        lblSettings.Text = string.Format("{0} {1}", uploadeDate, TimeZoneInfo.Utc.StandardName);
                        lblSettings.Properties.ClientSideEvents.Init = "function(s,e){SetLocalDate(s,e,'" + uploadeDate + "')}";
                        lblSettings.EncodeHtml = false;
                    }).GetHtml();
                }
            });
            
        });




     
        settings.Columns.Add(column =>
        {
            column.Caption = "Original Pay";
            column.FieldName = "OriginalPay";
            column.Width = 70;
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.ReadOnly = true;
        });


      
        settings.Columns.Add(column =>
        {
            column.Caption = "Over Payment";
            column.FieldName = "Overpayment";
           //column.Width = Unit.Percentage(8);
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.ReadOnly = true;
            column.Width = 65;
        });

  

     
        settings.Columns.Add(column =>
        {
            column.Caption = "INS / Copay";
            column.FieldName = "InsCopay";
           // column.Width = Unit.Percentage(8);
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.ReadOnly = true;
            column.Width = 65;
        });

       
        settings.Columns.Add(column =>
        {
            column.Caption = "Recoup";
            column.FieldName = "Recouped";
          //  column.Width = Unit.Percentage(8);
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.ReadOnly = true;
            column.Width = 65;
        });

      
        settings.Columns.Add(column =>
        {
            column.Caption = "Return";
           // column.Width = Unit.Pixel(250);
           column.FieldName = "Returned";
           column.Width = 65;
        });
                 
 
        settings.Columns.Add(column =>
        {
            column.Caption = "Total Loss";
           column.FieldName = "TotalLoss";
           column.HeaderStyle.Wrap = DefaultBoolean.True;
           column.Width = 75;
         //  column.Width = Unit.Percentage();
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
        });
           
		 settings.Columns.Add(column =>
      {
            column.Caption = "Notes";
           column.FieldName = "Notes";
           column.HeaderStyle.Wrap = DefaultBoolean.True;
           column.Width = 85;
        
        });

         
		 settings.Columns.Add(column =>
           {
            column.Caption = "Sent By (Provider)";
            column.FieldName = "SentFromProviderName";
            column.Width = 150;
            column.ReadOnly = true;
			column.HeaderStyle.Wrap = DefaultBoolean.True;
			column.SetDataItemTemplateContent(c =>
            {
                string  SentFromProviderName = Convert.ToString(DataBinder.Eval(c.DataItem, "SentFromProviderName"));
               RISARC.Common.Model.UserDescription   UserDescription =  new RISARC.Common.Model.UserDescription();
               UserDescription = (RISARC.Common.Model.UserDescription)DataBinder.Eval(c.DataItem, "CreatedByUserDescription");
               Html.RenderPartial("UserDescription",UserDescription); 
               ViewContext.Writer.Write(Html.Encode(SentFromProviderName)); 
            });
        });

		 settings.Columns.Add(column =>
           {
            column.Caption = "Sent To";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.Width = 120;
			column.SetDataItemTemplateContent(c =>
            {
               object DocumentRecipient = DataBinder.Eval(c.DataItem, "DocumentRecipient");
               Html.RenderPartial("~/Views/ViewDocuments/DocumentRecipient.ascx", DocumentRecipient);

            });
        });
 
                       
		 settings.Columns.Add(column =>
            {
             column.Caption = "# of Pages";
			 column.FieldName = "NumberOfPages";
             column.HeaderStyle.Wrap = DefaultBoolean.True;
             column.Width = 50;
    
        });
           

		 settings.Columns.Add(column =>
           {
            column.Caption = "Details";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.Width = 50;
			column.SetDataItemTemplateContent(c =>
            {
			 // int documentId = Model
                int documentId = Convert.ToInt32(DataBinder.Eval(c.DataItem, "Id"));
                string encryptedDocumentId = Html.Encrypt(documentId);
                 ViewContext.Writer.Write( Html.ActionLink("Details", "DocumentTransaction", "ViewDocuments", new { documentId = encryptedDocumentId }, null));

            });
        });
		

           
         
 
    }); //grid ends 
    grid.Bind(Model).GetHtml();
%>
                			
     
   
