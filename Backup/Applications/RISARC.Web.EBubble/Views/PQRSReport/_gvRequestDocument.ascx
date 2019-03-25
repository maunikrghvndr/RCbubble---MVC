<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IEnumerable<RISARC.ACO.Model.RaiseRequest>>" %>

<%   
    
    var grid = Html.DevExpress().GridView(settings =>
    {
        settings.Name = "gvRequestDocument";

        settings.CallbackRouteValues = new { Controller = "PQRSReport", Action = "_gvRequestDocument" };
        settings.SettingsEditing.BatchUpdateRouteValues = new { Controller = "PQRSReport", Action = "BatchUpdatePartial" };
        settings.SettingsEditing.Mode = GridViewEditingMode.Batch;
        
        settings.SettingsText.CommandBatchEditUpdate = "Raise Request";
        settings.SettingsText.CommandBatchEditCancel = "Cancel";
                

        settings.Width = Unit.Percentage(100);
        settings.KeyFieldName = "PatientId";

        settings.Styles.AlternatingRow.BackColor = System.Drawing.ColorTranslator.FromHtml("#f7f7f7");
        settings.Styles.Header.BackColor = System.Drawing.ColorTranslator.FromHtml("#e3f3f4");
        settings.Styles.Header.CssClass = "gvworklistHeader";
        settings.Styles.Header.Wrap = DefaultBoolean.True;

        settings.Styles.Cell.VerticalAlign = VerticalAlign.Middle;
        settings.Styles.Cell.Paddings.PaddingTop = Unit.Pixel(15);
        settings.Styles.Cell.Paddings.PaddingBottom = Unit.Pixel(15);
        settings.Width = Unit.Percentage(100);
        
        settings.Settings.HorizontalScrollBarMode = ScrollBarMode.Auto;
        settings.SettingsBehavior.ColumnResizeMode = ColumnResizeMode.Control;
       // settings.ClientSideEvents.BatchEditRowValidating = "Grid_BatchEditRowValidating";
        
        settings.Columns.Add(column =>
       {
           column.FieldName = "IsSelected";
           column.Caption = "Select";
           column.ColumnType = MVCxGridViewColumnType.CheckBox;
       });

        settings.Columns.Add(column =>
        {
            column.ColumnType = MVCxGridViewColumnType.TextBox;
            column.FieldName = "PhysicianName";
            column.ReadOnly = true;
            //column.Width = 0;
            //column.Visible = false;
        });
         settings.Columns.Add(column =>
        {
            column.FieldName = "ProviderId";
            column.ReadOnly = true;
            column.Width = 0;
           // column.Visible = false;
        });
        
        settings.Columns.Add(column =>
       {
           column.Width = 180;
           column.FieldName = "PatientName";
           column.Caption = "Patient Name";
           column.ReadOnly = true;
       });

        settings.Columns.Add(column =>
        {
            column.Width = 180;
            column.FieldName = "ProviderName";
            column.Caption = "Select Provider Member(s) (To Send Request To)";
            column.ColumnType = MVCxGridViewColumnType.ComboBox;
            column.ReadOnly = true;
        });


        settings.Columns.Add(column =>
         {
             column.Width = 200;
             column.FieldName = "PurposeOfRequest";
             column.ColumnType = MVCxGridViewColumnType.TextBox;
             column.PropertiesEdit.NullDisplayText = "Medical Treatment Request";
         });

        settings.Columns.Add(column =>
        {
            column.Width = 200;
            column.FieldName = "ResponseDueDate";
            column.ColumnType = MVCxGridViewColumnType.DateEdit;
           
        });

        settings.Columns.Add(column =>
            {
                column.FieldName = "FromServiceDate";
                column.ColumnType = MVCxGridViewColumnType.DateEdit;
            });
      
        settings.Columns.Add(column =>
            {
                column.FieldName = "ToServiceDate";
                column.ColumnType = MVCxGridViewColumnType.DateEdit;
            });
        settings.Columns.Add(column =>
        {
            column.FieldName = "DocumentsStatus";
            column.ReadOnly = true;
        });
        settings.CellEditorInitialize = (s, e) =>
        {
            ASPxEdit editor = (ASPxEdit)e.Editor;
            editor.ValidationSettings.Display = Display.Dynamic;
        };

        settings.CustomJSProperties += (s, e) =>
        {
            if (ViewData["StatusFlag"] != null)
                e.Properties["cpMessage"] = ViewData["StatusFlag"];
        };

        settings.ClientSideEvents.EndCallback = "function(s, e) { if (s.cpMessage) { alert(s.cpMessage); delete s.cpMessage;} }";
        
        
    });

    grid.Bind(Model).GetHtml(); %>

