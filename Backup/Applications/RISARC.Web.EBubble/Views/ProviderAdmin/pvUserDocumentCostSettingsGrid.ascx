<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<%  
    var grid = Html.DevExpress().GridView(settings =>
            {
                settings.Name = "gvUseDocCostSettings";
                settings.KeyFieldName = "ID";
                settings.CallbackRouteValues = new { Controller = "ProviderAdmin", Action = "GridViewUserCostSettingsPartial" };
                settings.SettingsEditing.AddNewRowRouteValues = new { Controller = "ProviderAdmin", Action = "GridViewUserCostSettingsAddNewPartial" };
                settings.SettingsEditing.UpdateRowRouteValues = new { Controller = "ProviderAdmin", Action = "GridViewUserCostSettingsUpdatePartial" };
                settings.SettingsEditing.DeleteRowRouteValues = new { Controller = "ProviderAdmin", Action = "GridViewUserCostSettingsDeletePartial" };
                settings.SettingsEditing.Mode = GridViewEditingMode.Inline;
                settings.SettingsBehavior.ConfirmDelete = true;

                //========== Grid View Resizing Column Header of Grid View ===========
                settings.SettingsBehavior.ColumnResizeMode = ColumnResizeMode.Control;
                //==================== Changing Grid Loading Icons ===================
                settings.Images.LoadingPanel.Url = Url.Content("~/Images/icons/LoadingLogo.gif");
                settings.SettingsLoadingPanel.Text = " ";
                settings.Images.LoadingPanel.Width = 76;
                settings.Images.LoadingPanel.Height = 100; 
                
                //Columns section
                settings.Columns.Add(columns =>
                {
                    columns.Caption = "Exchange Partners";
                    columns.FieldName = "ProviderId";
                    columns.ColumnType = MVCxGridViewColumnType.ComboBox;
                    var comboBoxProperties = columns.PropertiesEdit as ComboBoxProperties;
                    comboBoxProperties.NullText = "-- Select --";
                    comboBoxProperties.DataSource = (IEnumerable<RISARC.Setup.Model.ProviderInNetwork>)Session["ProviderMembers"];
                    comboBoxProperties.TextField = "ProviderName";
                    comboBoxProperties.ValueField = "ProviderId";
                    comboBoxProperties.ValueType = typeof(short);

                });
                
                //To disable Member name dropdown while editing a record.
                settings.CellEditorInitialize = (s, e) =>
                {
                    MVCxGridView mvcxgrid = s as MVCxGridView;
                    if (e.Column.FieldName.Equals("ProviderId") && !mvcxgrid.IsNewRowEditing)
                    {
                        e.Editor.ClientEnabled = false;
                    }
                };
                
                settings.Columns.Add("PricePerDocumentPage");
                settings.Columns.Add("PricePerDocumentMegabyte");
                settings.Columns.Add("MinimumDocumentPrice");

                //Command column seciton
                settings.CommandColumn.Visible = true;
                settings.CommandColumn.VisibleIndex = 4;
                settings.CommandColumn.Caption = "Action";
                settings.CommandColumn.NewButton.Visible = true;
                settings.CommandColumn.DeleteButton.Visible = true;
                settings.CommandColumn.EditButton.Visible = true;
                
                ////Formatting of validation messages
                //foreach (MVCxGridViewColumn c in settings.Columns)
                //{
                //    var prop = (c.PropertiesEdit as EditProperties);
                //    if (prop != null)
                //    {
                //        prop.ValidationSettings.ErrorDisplayMode = ErrorDisplayMode.Text;
                //        prop.ValidationSettings.ErrorTextPosition = ErrorTextPosition.Bottom;
                //    }
                //}
            });
    if (ViewData["EditError"] != null)
    {
        grid.SetEditErrorText((string)ViewData["EditError"]);
    }
    grid.Bind(Model).GetHtml();
%>