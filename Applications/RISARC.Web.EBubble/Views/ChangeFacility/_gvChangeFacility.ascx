<%@ Control Language="C#"  Inherits="System.Web.Mvc.ViewUserControl<IEnumerable<RISARC.Membership.Model.ProviderList>>" %>


<%  
    var grid = Html.DevExpress().GridView(
     settings =>
     {
         settings.Name = "gvChangeFacility";
         settings.KeyFieldName = "ProviderId";
         settings.Width = Unit.Percentage(100);

         settings.CallbackRouteValues = new { Controller = "ChangeFacility", Action = "_gvChangeFacility" };

         settings.ClientSideEvents.BeginCallback = "gvChangeFacility_BeginCallback";
      //   settings.ClientSideEvents.EndCallback = "gvChangeFacility_EndCallback";

         settings.Styles.Header.BackColor = System.Drawing.ColorTranslator.FromHtml("#e3f3f4");
         //  settings.Styles.Header.CssClass = "gvworklistHeader";

         //==================== Changing Grid Loading Icons ===================
         settings.Images.LoadingPanel.Url = Url.Content("~/Images/icons/LoadingLogo.gif");
         settings.SettingsLoadingPanel.Text = " ";
         settings.Images.LoadingPanel.Width = 76;
         settings.Images.LoadingPanel.Height = 100; 

         settings.SettingsEditing.AddNewRowRouteValues = new { Controller = "ChangeFacility", Action = "AddNewChangeFacility", collec = Model };
         settings.SettingsEditing.UpdateRowRouteValues = new { Controller = "ChangeFacility", Action = "EditChangeFacility", collec = Model };
         settings.SettingsEditing.DeleteRowRouteValues = new { Controller = "ChangeFacility", Action = "DeleteChangeFacility", collec = Model };


         settings.SettingsEditing.Mode = GridViewEditingMode.Inline;
         settings.SettingsPopup.EditForm.Width = 600;

         //This for nowmal row.
         settings.Styles.Cell.VerticalAlign = VerticalAlign.Middle;
         settings.Styles.Cell.Paddings.PaddingTop = Unit.Pixel(15);
         settings.Styles.Cell.Paddings.PaddingBottom = Unit.Pixel(15);


         settings.Width = Unit.Percentage(100);

         settings.CommandColumn.Width = 80;
         settings.CommandColumn.CellStyle.HorizontalAlign = HorizontalAlign.Center;
         settings.CommandColumn.Visible = true;
         settings.CommandColumn.CellStyle.Cursor = "pointer";
         settings.CommandColumn.ButtonType = GridViewCommandButtonType.Image;

         settings.CommandColumn.ShowNewButtonInHeader = true;
         settings.SettingsCommandButton.NewButton.Image.Url = Url.Content("~/Images/icons/AddNew.png");
         //settings.CommandColumn.CellStyle.Paddings.PaddingLeft = 20;

         settings.CommandColumn.ShowDeleteButton = true;
         settings.SettingsCommandButton.DeleteButton.Image.Url = Url.Content("~/Images/icons/icon_bin_remove.png");
         

         settings.CommandColumn.ShowEditButton = true;
         settings.SettingsCommandButton.EditButton.Image.Url = Url.Content("~/Images/icons/icon_pencil_edit.png");
         settings.SettingsBehavior.ConfirmDelete = true;
         settings.SettingsText.ConfirmDelete = "Are you sure you want to delete this record?";


         settings.SettingsCommandButton.CancelButton.Image.Url = Url.Content("~/Images/icons/icon_cross_cancel.png");
         settings.SettingsCommandButton.UpdateButton.Image.Url = Url.Content("~/Images/icons/icon_tick_update.png");
        
         settings.Settings.HorizontalScrollBarMode = ScrollBarMode.Auto;
         settings.SettingsBehavior.ColumnResizeMode = ColumnResizeMode.Control;
         
         settings.Columns.Add(column =>
         {
             column.Width = 180;
             string actioncommand = Convert.ToString(ViewData["actioncommand"]);
             if (!string.IsNullOrEmpty(actioncommand) && actioncommand =="STARTEDIT")
             {
                 column.ReadOnly = true;
             }
             column.FieldName = "ProviderName";
             column.Caption = "Organization Name";
             column.HeaderStyle.CssClass = "clsBold";
             column.ColumnType = MVCxGridViewColumnType.ComboBox;
           
             var comboBoxProperties = column.PropertiesEdit as ComboBoxProperties;

             comboBoxProperties.DataSource = RISARC.Membership.Implementation.Service.MembershipAdministrationService.GetAvailableProviders();
             comboBoxProperties.TextField = "ProviderName";
             comboBoxProperties.ValueField = "ProviderId";
             comboBoxProperties.ValueType = typeof(string);
             comboBoxProperties.Style.CssClass = "OrgNameSeachboxCls changeBgColor";
             comboBoxProperties.ButtonStyle.Paddings.Padding = 0;
             comboBoxProperties.ButtonStyle.Border.BorderWidth = 0;
             comboBoxProperties.DropDownButton.Image.Url = @Url.Content("~/Images/icons/dropdown_button.png");
             comboBoxProperties.ButtonStyle.CssClass = "dropdownButton";

             //comboBoxProperties.DropDownStyle = DropDownStyle.DropDown;
             //comboBoxProperties.IncrementalFilteringMode = IncrementalFilteringMode.Contains;
             
             comboBoxProperties.ValidationSettings.ErrorDisplayMode = ErrorDisplayMode.ImageWithText;
             comboBoxProperties.ValidationSettings.EnableCustomValidation = true;
             comboBoxProperties.ValidationSettings.ErrorTextPosition = DevExpress.Web.ASPxClasses.ErrorTextPosition.Bottom;

         });

         
         
         settings.Columns.Add(column =>
         {
          
             column.HeaderStyle.CssClass = "clsBold";
             column.FieldName = "Roles";
             column.ColumnType = MVCxGridViewColumnType.DropDownEdit;
             column.Width = 769;
             column.CellStyle.CssClass = "clsWorkBreak";
             
             column.SetEditItemTemplateContent(cont =>
             {
                   var CoommaSeperatedRoles = DataBinder.Eval(cont.DataItem, "Roles");
                   Html.DevExpress().DropDownEdit(
                    DropDownSettings =>
                     {
                            DropDownSettings.Name = "RolesComboBox";
                            DropDownSettings.Width = Unit.Pixel(245);
                            DropDownSettings.ControlStyle.CssClass = "OrgNameSeachboxCls";
                            DropDownSettings.Properties.DropDownButton.Image.Url = @Url.Content("~/Images/icons/dropdown_button.png");
                            DropDownSettings.Properties.ButtonStyle.Border.BorderWidth = 0;
                            DropDownSettings.Properties.ButtonStyle.Paddings.Padding = 0;
                            DropDownSettings.Properties.ButtonStyle.CssClass = "dropdownButton";
                            DropDownSettings.Text = Convert.ToString(CoommaSeperatedRoles);
                          // DropDownSettings.Text = "SA_User;SA_DocumentAdmin;
                               
                            DropDownSettings.Properties.AnimationType = AnimationType.None;
                            DropDownSettings.Properties.ClientSideEvents.TextChanged = "SynchronizeListBoxValues";
                            DropDownSettings.Properties.ClientSideEvents.DropDown = "SynchronizeListBoxValues";
                            DropDownSettings.ControlStyle.Wrap = DefaultBoolean.True;  
                         
                            DropDownSettings.SetDropDownWindowTemplateContent(c =>
                                {
                                    Html.DevExpress().ListBox(listBoxSettings =>
                                        {
                                            listBoxSettings.Name = "RoleNamesListBox";
                                            listBoxSettings.Width = Unit.Percentage(95);
                                            listBoxSettings.ControlStyle.Border.BorderWidth = 0;
                                            listBoxSettings.ControlStyle.BorderBottom.BorderColor = System.Drawing.Color.FromArgb(0xDCDCDC);
                                            listBoxSettings.Properties.ItemStyle.Border.BorderWidth = 1;
                                            listBoxSettings.Properties.ItemStyle.Border.BorderStyle = System.Web.UI.WebControls.BorderStyle.Solid;
                                            listBoxSettings.Properties.ItemStyle.Border.BorderColor = System.Drawing.Color.LightGray;
                                            listBoxSettings.Properties.SelectionMode = ListEditSelectionMode.CheckColumn;
                                    
                                               List<RISARC.Membership.Model.Role> rolelist = new List<RISARC.Membership.Model.Role>(); 
                                      rolelist = ViewData["roleList"] as List<RISARC.Membership.Model.Role>;

                                           listBoxSettings.Properties.ValueField = "RoleId";
                                            listBoxSettings.Properties.ValueType = typeof(string);
                                            listBoxSettings.Properties.TextField = "RoleName";
                                            listBoxSettings.Properties.ClientSideEvents.SelectedIndexChanged = "OnListBoxSelectionChanged";
                                            listBoxSettings.ControlStyle.CssClass = "OrgNameSeachboxCls";

                                        }).BindList(ViewData["roleList"]).Render();

                                });//WINDOW TEMPLATE ENDS 

                           
                        }).GetHtml(); // DROP DOWN EDIT ENDS 
               
               }); // edit item templete ends 

        
             
         }); // column ends 


         settings.CellEditorInitialize = (s, e) =>
         {
             ASPxEdit editor = (ASPxEdit)e.Editor;
             editor.ValidationSettings.Display = Display.Dynamic;
         };
         
     });

    if( ViewData["ProviderIdError"] != null)
    {
      
        grid.SetEditErrorText((string)ViewData["ProviderIdError"]);
    }
     
grid.Bind(Model).GetHtml();%>