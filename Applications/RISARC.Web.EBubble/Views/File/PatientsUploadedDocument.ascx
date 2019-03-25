<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IEnumerable<RISARC.Common.Model.UploadedFiles>>" %>

<%= Html.DevExpress().GridView(settings =>
   {
     //this grid is added to show patient uploaded data of PQRS
       settings.Name = "fileUploadGrid";
       settings.CallbackRouteValues = new { Controller = "File", Action = "PatientsUploadedDocument" };
       settings.KeyFieldName = "FileID";
     
     //==================== Changing Grid Loading Icons ===================
     settings.Images.LoadingPanel.Url = Url.Content("~/Images/icons/LoadingLogo.gif");
     settings.SettingsLoadingPanel.Text = " ";
     settings.Images.LoadingPanel.Width = 76;
     settings.Images.LoadingPanel.Height = 100;   

     settings.Settings.HorizontalScrollBarMode = ScrollBarMode.Auto;
     settings.Width = Unit.Percentage(100);

     settings.CommandColumn.Visible = false;
     settings.CommandColumn.ShowDeleteButton = true;
     settings.SettingsEditing.DeleteRowRouteValues = new { Controller = "File", Action = "PatientDeletek" };
     settings.CommandColumn.ShowSelectCheckbox = true;
     settings.CommandColumn.SelectAllCheckboxMode =  GridViewSelectAllCheckBoxMode.AllPages; 
       
       //settings.Columns.Add(column =>
       //{
       //    column.FieldName = "FileID";
       //    column.Caption = "File Id";
       //    column.Visible = true;
       //});
       
       settings.Columns.Add(column =>
       {
           column.FieldName = "FileName";
           column.Caption = "File Name";
           column.Width = Unit.Percentage(50);
           column.Settings.ShowFilterRowMenu = DefaultBoolean.True;
           column.MinWidth = 490;
       });
       
       settings.Columns.Add(column => {
           column.FieldName = "DocumentTypeId";
           column.CellStyle.CssClass = "DocumentType";
           column.Caption = "File Type";
           column.Settings.AllowAutoFilter = DefaultBoolean.False;
           column.Width = Unit.Percentage(30);
          // column.MinWidth = 200;
           column.CellStyle.CssClass = "AlignCenter";

           column.SetDataItemTemplateContent(c =>
           {
               System.Web.Mvc.Html.ChildActionExtensions.RenderAction(Html, "XMLDocumentTypeDropDownDevExp", "PQRSReport", new
               {
                   comboBoxSettings = RISARC.Web.EBubble.Models.DevxControlSettings.ComboBoxSetting.ComboBoxSettingsMethodAdditional(settingcmbo =>
                   {
                       settingcmbo.Name = "DocumentTypeId" + c.VisibleIndex;
                       settingcmbo.Properties.EnableClientSideAPI = true;
                       settingcmbo.Properties.ClientSideEvents.SelectedIndexChanged = "function(s, e){ UpdateDocType(s,e," + c.VisibleIndex + ");}";
                       settingcmbo.Properties.ValueType = typeof(int);
                       // settingcmbo.Properties.EnableDefaultAppearance = true;
                       settingcmbo.Properties.IncrementalFilteringMode = IncrementalFilteringMode.StartsWith;
                   }),
                   //selectedProviderId = Convert.ToString(DataBinder.Eval(c.DataItem, "SendToProviderId")),
                   selectedDocumentType = Convert.ToString(DataBinder.Eval(c.DataItem, "DocumentTypeId"))
               });
           });
       });

       settings.Columns.Add(column =>
       {
           column.SetDataItemTemplateContent(c =>
           {
               ViewContext.Writer.Write("Ready to upload");
           });
           column.Caption = "Upload Status";
           column.Width = Unit.Percentage(20);
           
       });
       
       settings.Columns.Add(column =>
       {
           column.FieldName = "DeleteLink";
           column.Caption = "Delete";
           column.SetDataItemTemplateContent(c =>
           {
               ViewContext.Writer.Write(DataBinder.Eval(c.DataItem, "DeleteLink"));
           });
           column.Settings.AllowAutoFilter = DefaultBoolean.False;
           column.MinWidth = 60;
           column.Width = 80;
       });
     
       
   }).Bind(Model).GetHtml() %>