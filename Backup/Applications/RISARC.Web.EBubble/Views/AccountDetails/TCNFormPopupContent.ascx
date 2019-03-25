<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<%   
   
    Html.DevExpress().GridView(
      settings =>
      {
          settings.Name = "TCNFormGrid";
          settings.KeyFieldName = "FileID";
          settings.CallbackRouteValues = new { Controller = "AccountDetails", Action = "TCNFormPopupContent" };
          settings.Width = Unit.Percentage(100);

          settings.Settings.VerticalScrollBarMode = ScrollBarMode.Auto;
          settings.Settings.VerticalScrollableHeight = 260;

        //  settings.ShowCloseButton = true;
          
          var srNoColumn = settings.Columns.Add("Sr.No.");
          srNoColumn.PropertiesEdit.DisplayFormatString = "c";
          srNoColumn.UnboundType = DevExpress.Data.UnboundColumnType.String;
          srNoColumn.Width = Unit.Pixel(50);
          srNoColumn.CellStyle.HorizontalAlign = HorizontalAlign.Center;

          //========== Grid View Resizing Column Header of Grid View ===========
          settings.SettingsBehavior.ColumnResizeMode = ColumnResizeMode.Control;
          //==================== Changing Grid Loading Icons ===================
          settings.Images.LoadingPanel.Url = Url.Content("~/Images/icons/LoadingLogo.gif");
          settings.SettingsLoadingPanel.Text = " ";
          settings.Images.LoadingPanel.Width = 76;
          settings.Images.LoadingPanel.Height = 100; 

          settings.Styles.Table.BackColor = System.Drawing.ColorTranslator.FromHtml("#F7F7F7");
          
          
          //Event handler for custom unbound column
          settings.CustomUnboundColumnData = (sender, e) =>
          {
              if (e.Column.FieldName == "Sr.No.")
              {
                  e.Value = Convert.ToString(e.ListSourceRowIndex + 1);
              }
          };

          settings.Columns.Add("FileName");

          settings.Columns.Add(column =>
          {
              column.FieldName = "DocumentTypeId";
              column.Caption = "Document Type";
              column.Settings.AllowAutoFilter = DefaultBoolean.False;
              column.Width = Unit.Percentage(30);
             // column.CellStyle.VerticalAlign = VerticalAlign.Middle;
              column.CellStyle.CssClass = "AlignCenter";
              column.SetDataItemTemplateContent(c =>
              {
                  System.Web.Mvc.Html.ChildActionExtensions.RenderAction(Html, "TCNDocumentTypeDropDownDevExp", "AccountDetails", new
                  {
                      comboBoxSettings = RISARC.Web.EBubble.Models.DevxControlSettings.ComboBoxSetting.ComboBoxSettingsMethodAdditional(settingcmbo =>
                      {
                          settingcmbo.Name = "DocumentTypeId" + c.VisibleIndex;
                          settingcmbo.Properties.EnableClientSideAPI = true;
                          settingcmbo.Properties.ClientSideEvents.SelectedIndexChanged = "function(s, e){ UpdateTCNDocType(s,e," + c.VisibleIndex + ");}";
                          settingcmbo.Properties.ValueType = typeof(int);
                         // settingcmbo.Properties.EnableDefaultAppearance = true;

                          settingcmbo.ControlStyle.CssClass = "allCombobox";
                      }),
                      selectedDocumentType = Convert.ToString(DataBinder.Eval(c.DataItem, "DocumentTypeId"))
                  });
              });
          });

          //Date Uploaded Column
          settings.Columns.Add(column =>
          {
              column.Caption = "Date Uploaded";
              column.FieldName = "DateUploaded";
              column.SetDataItemTemplateContent(c =>
              {
                  DateTime? dosFrom = (DateTime?)DataBinder.Eval(c.DataItem, "DateUploaded");
                  if (dosFrom.HasValue)
                  {
                      ViewContext.Writer.Write(dosFrom.Value.ToString("MMM dd, yyyy hh:mm:ss tt"));
                  }
              });
              column.ReadOnly = true;
          });

          //  settings.Columns.Add("UploadedFrom");


          //Date Uploaded Column
          settings.Columns.Add(column =>
          {
              column.FieldName = "UploadedFrom";
              column.Width = Unit.Percentage(12);
          });





          //Delete button
          settings.Columns.Add(column =>
          {
              column.FieldName = "DeleteLink";
              column.Caption = "Delete";
              column.Width = Unit.Percentage(7);
              column.SetDataItemTemplateContent(c =>
              {
                  ViewContext.Writer.Write(DataBinder.Eval(c.DataItem, "DeleteLink"));
              });

              column.Settings.AllowAutoFilter = DefaultBoolean.False;
          });
          settings.Columns.Add("TCNNumber").GroupIndex = 0;

          settings.Settings.ShowGroupPanel = false;

      }).Bind(Model).GetHtml();
%>
