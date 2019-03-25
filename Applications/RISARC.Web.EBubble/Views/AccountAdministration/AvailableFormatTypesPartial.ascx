<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<% var grid = Html.DevExpress().GridView(
        settings =>
        {
            settings.Name = "AvailabelFTEdit";
            settings.KeyFieldName = "Id";
            settings.CallbackRouteValues = new { Controller = "AccountAdministration", Action = "AvailableFormatTypesPartial" };
            settings.SettingsEditing.AddNewRowRouteValues = new { Controller = "AccountAdministration", Action = "AddDocumentFormatType" };
            settings.SettingsEditing.UpdateRowRouteValues = new { Controller = "AccountAdministration", Action = "EditDocumentFormatType" };
            settings.SettingsEditing.DeleteRowRouteValues = new { Controller = "AccountAdministration", Action = "DeleteDocumentFormatType" };
            settings.SettingsBehavior.ConfirmDelete = true;
            settings.Width = Unit.Percentage(100);

            //========== Grid View Resizing Column Header of Grid View ===========
            settings.SettingsBehavior.ColumnResizeMode = ColumnResizeMode.Control;
            //==================== Changing Grid Loading Icons ===================
            settings.Images.LoadingPanel.Url = Url.Content("~/Images/icons/LoadingLogo.gif");
            settings.SettingsLoadingPanel.Text = " ";
            settings.Images.LoadingPanel.Width = 76;
            settings.Images.LoadingPanel.Height = 100;  

            //=================== Incresing Row Height =============================
            settings.Styles.Cell.VerticalAlign = VerticalAlign.Middle;
            settings.Styles.Cell.Paddings.PaddingTop = Unit.Pixel(14);
            settings.Styles.Cell.Paddings.PaddingBottom = Unit.Pixel(14);
            //+ ends  

            settings.Styles.Header.BackColor = System.Drawing.ColorTranslator.FromHtml("#e3f3f3");
            settings.Styles.Header.CssClass = "gvworklistHeader";


            settings.AutoFilterCellEditorInitialize = (sender, e) =>
            {
                ASPxTextBox textBox = (e.Editor as ASPxTextBox);
                ASPxDateEdit dateBox = (e.Editor as ASPxDateEdit);

                if (textBox != null)
                {
                    textBox.NullText = "Search";
                }

                if (dateBox != null)
                {
                    dateBox.NullText = "Select date";
                }

            };
            
            
            settings.SettingsEditing.Mode = GridViewEditingMode.PopupEditForm;

            settings.CommandColumn.Width = Unit.Pixel(125);
            settings.CommandColumn.Visible = true;
            // settings.CommandColumn.EditButton.Visible = true; is obsolete now
            settings.CommandColumn.ShowNewButton = true;
            settings.CommandColumn.ShowEditButton = true;
            settings.CommandColumn.ShowDeleteButton = true;

            settings.CommandColumn.Caption = "Actions";
            settings.CommandColumn.CellStyle.CssClass = "cmdColumnLinks";
           
            
            
             
            settings.SettingsPopup.EditForm.HorizontalAlign = PopupHorizontalAlign.WindowCenter;
            settings.SettingsPopup.EditForm.VerticalAlign = PopupVerticalAlign.WindowCenter;

            
            

          //  settings.SettingsPopup.EditForm. = System.Drawing.ColorTranslator.FromHtml("#595959");
         //   settings.Styles.Header.ForeColor = System.Drawing.ColorTranslator.FromHtml("#FFFFFF");
         //   settings.SettingsPopup.EditForm.hhhhh
            
          
            settings.SettingsPopup.EditForm.Modal = true;
            settings.SettingsPopup.EditForm.Width = Unit.Pixel(700);
            settings.SettingsPopup.EditForm.Height = Unit.Pixel(120);
            
            
            
            //settings.SettingsPopup.EditForm.

            settings.Columns.Add("DocumentFormat").Width = 250;

            settings.Columns.Add(col =>
            {
                col.FieldName = "CreatorName";
                col.EditFormSettings.Visible = DefaultBoolean.False;
                col.Caption = "Created By";
                col.Width = 250;
                

            });     
            
            settings.Columns.Add("Description");
           
            
            //for Fillter
            settings.Settings.ShowFilterRow = true;
            settings.Styles.FilterCell.CssClass = "fillterCell";
           // settings.Settings.ShowFilterRowMenu = true;
            settings.ImagesEditors.DropDownEditDropDown.Url = Url.Content("~/Images/icons/calenderIcon.png"); 
            
        });

   if (ViewData["EditError"] != null)
   {
       grid.SetEditErrorText((string)ViewData["EditError"]);
   }
grid.Bind(Model).GetHtml(); %>