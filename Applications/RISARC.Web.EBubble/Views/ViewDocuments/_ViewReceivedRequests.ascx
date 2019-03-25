<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IEnumerable<RISARC.Documents.Model.DocumentRequest>>" %>

<% 
    var grid = Html.DevExpress().GridView(settings =>
    {
        settings.Name = "gvViewReceivedRequests";
        settings.KeyFieldName = "DocumentTypeName";
        settings.CallbackRouteValues = new { Controller = "ViewDocuments", Action = "_MyOutstandingRequests" };

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
        //Account# column
        

        settings.Columns.Add(column =>
        {
          column.Caption = "Request Date";
          column.HeaderStyle.Wrap = DefaultBoolean.True;
          column.FieldName = "RequestUTCDate";
          column.ReadOnly = true;
          column.Width = 250;
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
            column.Caption = "Response Due By";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.FieldName = "RequestUTCDueBy";
            column.ReadOnly = true;
            column.Width = Unit.Pixel(250);
            column.SetDataItemTemplateContent(c =>
            {
                string uploadeDate = Convert.ToString(DataBinder.Eval(c.DataItem, "RequestUTCDueBy"));
                if (!string.IsNullOrEmpty(uploadeDate))
                {
                    Html.DevExpress().Label(lblSettings =>
                    {
                        lblSettings.Name = "RequestUTCDueBy" + c.VisibleIndex;
                        lblSettings.Text = string.Format("{0} {1}", uploadeDate, TimeZoneInfo.Utc.StandardName);
                        lblSettings.Properties.ClientSideEvents.Init = "function(s,e){SetLocalDate(s,e,'" + uploadeDate + "')}";
                        lblSettings.EncodeHtml = false;
                    }).GetHtml();
                }
            });

        });


        settings.Columns.Add(column =>
        {
            column.Caption = "Requested Document Type";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.FieldName = "DocumentTypeName";
            column.ReadOnly = true;
            column.Width = 130;
        });

        settings.Columns.Add(column =>
        {
            column.Caption = "Requested Document Description";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.FieldName = "DocumentDescription";
            column.ReadOnly = true;
            column.Width = 175;
        });

        settings.Columns.Add(column =>
        {
            column.Caption = "Requested By";
            column.FieldName = "SentFromProviderName";
            column.Width = 140;
            column.ReadOnly = true;
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.SetDataItemTemplateContent(c =>
            {
                string SentFromProviderName = Convert.ToString(DataBinder.Eval(c.DataItem, "SentFromProviderName"));
                RISARC.Common.Model.UserDescription UserDescription = new RISARC.Common.Model.UserDescription();
                UserDescription = (RISARC.Common.Model.UserDescription)DataBinder.Eval(c.DataItem, "CreatedByUserDescription");
                Html.RenderPartial("UserDescription", UserDescription);
                ViewContext.Writer.Write(Html.Encode(SentFromProviderName));
            });
        });

        settings.Columns.Add(column =>
        {
            column.Caption = "Requested To";
            column.FieldName = "SentToProviderName";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.Width = 180;
            column.SetDataItemTemplateContent(c =>
            {
                int recipientCount = Convert.ToInt32(DataBinder.Eval(c.DataItem, "RecipientCount"));
                string multipleRecipients = Convert.ToString(DataBinder.Eval(c.DataItem, "MultipleRecipients"));
                if (recipientCount > 0)
                {
                    ViewContext.Writer.Write("SENT TO " + recipientCount.ToString() + " RECIPIENTS" +"<br/>");
                    ViewContext.Writer.Write(multipleRecipients.Replace(",", "<br />").ToString());
                }
                else
                {
                    ViewContext.Writer.Write("SENT TO EVERYONE");
                }

            });
        });

        
        settings.Columns.Add(column =>
        {
            column.Caption = "First Name";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.FieldName = "PatientFirstName";
            column.ReadOnly = true;
            column.Width = 110;
        });
        
        settings.Columns.Add(column =>
        {
            column.Caption = "Last Name";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.FieldName = "PatientLastName";
            column.ReadOnly = true;
            column.Width = 110;
        });

        settings.Columns.Add(column =>
        {
            column.Caption = "Status";
            column.FieldName = "DocumentStatus";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.Width = 125;
            column.SetDataItemTemplateContent(c =>
            {
                object documentStatus = DataBinder.Eval(c.DataItem, "DocumentStatus");

                Html.RenderPartial("RequestStatusDescription", new ViewDataDictionary { { "DocumentStatus", documentStatus } });

            });
        });

        settings.Columns.Add(column =>
        {
            column.Caption = "Request Link";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.Width = 100;
            column.SetDataItemTemplateContent(c =>
            {   
                object documentStatus = DataBinder.Eval(c.DataItem, "DocumentStatus");
                object id = DataBinder.Eval(c.DataItem, "Id");
                Html.RenderPartial("ReceivedRequestStatusAction", new ViewDataDictionary { { "DocumentStatus", documentStatus }, { "RequestId", id } });

            });
        });

    }).Bind(Model).GetHtml();
%>