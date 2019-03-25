<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IEnumerable<RISARC.Common.Model.UploadedFiles>>" %>

<%= Html.DevExpress().GridView(settings =>
   {
       settings.Name = "fileUploadGrid";
       settings.CallbackRouteValues = new { Controller = "File", Action = "UploadedDocument" };
       settings.KeyFieldName = "FileID";
       
      //========== Grid View Resizing Column Header of Grid View ===========
   //  settings.SettingsBehavior.ColumnResizeMode = ColumnResizeMode.Control;
     //==================== Changing Grid Loading Icons ===================
     settings.Images.LoadingPanel.Url = Url.Content("~/Images/icons/LoadingLogo.gif");
     settings.SettingsLoadingPanel.Text = " ";
     settings.Images.LoadingPanel.Width = 76;
     settings.Images.LoadingPanel.Height = 100;   

     settings.Settings.HorizontalScrollBarMode = ScrollBarMode.Auto;

     settings.Width = Unit.Percentage(100);  
       
     //settings.Settings.VerticalScrollBarMode = ScrollBarMode.Auto;
     //settings.Settings.VerticalScrollableHeight = 80;

    // settings.Settings.HorizontalScrollBarMode = ScrollBarMode.Auto;
       
    
     // settings.Styles.EmptyDataRow.h 

     settings.AutoFilterCellEditorInitialize = (sender, e) =>
     {
         ASPxTextBox filterTextBox = (e.Editor as ASPxTextBox);

         ASPxDateEdit fillterCombo = (e.Editor as ASPxDateEdit);

         if (filterTextBox != null)
         {
             filterTextBox.NullText = "Search";
         }

         if (fillterCombo != null)
         {
             fillterCombo.NullText = "Select date";
         }

     };
 
       
    // settings.SettingsLoadingPanel.ImagePosition =   
       settings.Columns.Add(column =>
           {
               column.FieldName = "Sr.No.";
               //column.Width = 50;
                  column.Width = Unit.Percentage(10);
               column.Settings.AllowAutoFilter = DefaultBoolean.False;
               column.MinWidth = 100;
           });

       settings.CustomColumnDisplayText = (sender, e) =>
       {
           if (e.Column.FieldName == "Sr.No.")
           {
               e.DisplayText = (e.VisibleRowIndex + 1).ToString();
           }
       };
       settings.Columns.Add(column =>
       {
           column.FieldName = "FileID";
           column.Caption = "File Id";
           column.Visible = false;
       });
       settings.Columns.Add(column =>
       {
           column.FieldName = "FileName";
           column.Caption = "File Name";
           column.SetDataItemTemplateContent(c =>
           {
               ViewContext.Writer.Write(DataBinder.Eval(c.DataItem, "PreViewLink"));
           });
           column.Width = Unit.Percentage(50);
           column.Settings.ShowFilterRowMenu = DefaultBoolean.True;
           column.MinWidth = 490;
       });
       settings.Columns.Add(column => {
           column.FieldName = "DocumentTypeId";
           column.CellStyle.CssClass = "DocumentType";
           column.Caption = "Document Type";
           column.Settings.AllowAutoFilter = DefaultBoolean.False;
           column.Width = Unit.Percentage(28);
          // column.MinWidth = 200;
           column.CellStyle.CssClass = "AlignCenter";
           
           column.SetDataItemTemplateContent(c => {
                System.Web.Mvc.Html.ChildActionExtensions.RenderAction(Html, "ProviderDocumentTypeDropDownDevExp", "CreateDocument", new
                {
                    comboBoxSettings = RISARC.Web.EBubble.Models.DevxControlSettings.ComboBoxSetting.ComboBoxSettingsMethodAdditional(settingcmbo =>
                    {
                        settingcmbo.Name = "DocumentTypeId" + c.VisibleIndex;
                        settingcmbo.Properties.EnableClientSideAPI = true;
                        settingcmbo.Properties.ClientSideEvents.SelectedIndexChanged = "function(s, e){ UpdateDocType(s,e," + c.VisibleIndex + ");}";
                        settingcmbo.Properties.ValueType = typeof(int);
                       // settingcmbo.Properties.EnableDefaultAppearance = true;
                        settingcmbo.Properties.IncrementalFilteringMode  = IncrementalFilteringMode.StartsWith;
                    }),
                    selectedProviderId = Convert.ToString(DataBinder.Eval(c.DataItem, "SendToProviderId")),
                    selectedDocumentType = Convert.ToString(DataBinder.Eval(c.DataItem, "DocumentTypeId"))
                });
           });
           //Settings added to fix TTPro defect 185 
           column.Visible = false;
           column.VisibleIndex = 2;
           
       });
       
       settings.Columns.Add(column =>
           {
               column.FieldName = "UploadedFrom";
               column.Caption = "Uploaded From";
               column.Width = Unit.Percentage(32);
              //column.Width = 250;
               column.Settings.ShowFilterRowMenu = DefaultBoolean.True;
               column.MinWidth = 300;
           });
       settings.Columns.Add(column =>
       {
           column.FieldName = "DeleteLink";
           column.Caption = "Delete";
           column.SetDataItemTemplateContent(c =>
           {
               ViewContext.Writer.Write(DataBinder.Eval(c.DataItem, "DeleteLink"));
           });
          //column.Width = 100;
           
           column.Settings.AllowAutoFilter = DefaultBoolean.False;
           column.MinWidth = 60;
           column.Width = 80;
       });
     
       //settings.SettingsPager.Mode = GridViewPagerMode.ShowAllRecords;
       settings.EnablePagingGestures = AutoBoolean.True;
       settings.SettingsPager.PageSize = 10;
       settings.Settings.ShowFilterRow = true;
       
   }).Bind(Model).GetHtml() %>