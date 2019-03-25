<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<%= Html.DevExpress().GridView(settings => {
    settings.Name = "AddEditRolesGrid";
    settings.KeyFieldName = "MenuId";

    settings.Width = Unit.Percentage(100);
    
    settings.CallbackRouteValues = new { Controller = "AccountAdministration", Action = "GetEditRolesGridPartial", roleId = Request.Params["roleId"] };

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

    //for vartical scroll
    settings.Settings.VerticalScrollBarMode = ScrollBarMode.Auto;
    settings.Settings.VerticalScrollableHeight = 380;
                            
 
    
    
    
     //Below settings for removeing effect of selected checkbox row selection 
                            //========================= Check box row selection nulify by settings ==============
    settings.Styles.SelectedRow.BackColor = System.Drawing.ColorTranslator.FromHtml("#eaeaea");
      settings.Styles.SelectedRow.ForeColor = System.Drawing.Color.Black;
                            // ends 
                            
    //Setting All Rowes background color 
    settings.Styles.Table.BackColor = System.Drawing.ColorTranslator.FromHtml("#ffffff");


    settings.Styles.Header.BackColor = System.Drawing.ColorTranslator.FromHtml("#d4ecee");
    settings.Styles.Header.CssClass = "gvworklistHeader";
    
    
    
    
    
    settings.CommandColumn.Visible = true;
    settings.CommandColumn.ShowSelectCheckbox = true;
    settings.CommandColumn.Width = 20;
    settings.CommandColumn.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;    
    settings.CommandColumn.SetHeaderTemplateContent(c =>
    {

        Html.DevExpress().CheckBox(settingsCheckBox =>
        {
            settingsCheckBox.ControlStyle.CssClass = "CellTextAlign";
            settingsCheckBox.Name = "cbSelectAll";
            settingsCheckBox.Properties.ClientSideEvents.CheckedChanged = string.Format("function(s, e) {{ if(s.GetChecked()) {0}.SelectRows(); else {0}.UnselectRows(); }}", settings.Name);
            settingsCheckBox.Checked = c.Grid.VisibleRowCount == c.Grid.Selection.Count;
            settingsCheckBox.ClientVisible = c.Grid.VisibleRowCount > 0; // <- Add this line
        }).Render();
    });

    
    //by defult show Assigned Roles selected. 
    settings.PreRender = (sender, e) =>
    {
        ASPxGridView gridView = (ASPxGridView)sender;
        for (int i = 0; i < gridView.VisibleRowCount; i++)
        {
            Boolean isAssigned = Convert.ToBoolean(gridView.GetRowValues(i, "IsAssigned"));
            if (isAssigned)
                {
                    gridView.Selection.SetSelection(i,true);
                }
            }
    };

    //settings.Styles.Header.CssClass = "RightsColumnTitleBack";//Columns Title Background Color Changes
    
    //settings.SettingsBehavior.AllowSelectByRowClick = true;
    
    settings.Columns.Add(column =>
    {
        column.FieldName = "MenuName";
        column.Caption = "<b>&nbsp;&nbsp;&nbsp;&nbsp;Right Name</b>";
        //column.Width = 350;
        //column.CellStyle.HorizontalAlign = HorizontalAlign.Right;
        column.Width = Unit.Percentage(20);
        column.CellStyle.CssClass = "CellTextAlign";
    });
    
    settings.Columns.Add(column =>
    {
        column.FieldName = "Description";
        column.Caption = "<b>&nbsp;&nbsp;&nbsp;&nbsp; Description</b>";
        //column.Width = 580;
        column.Width = Unit.Percentage(50);
        column.CellStyle.CssClass = "CellTextAlign";
    });
    
    
    
    //column 3
    settings.Columns.Add(column =>
    {
        column.Caption = "<b>&nbsp;&nbsp;Info.</b>";
        column.Width = 40;
        column.CellStyle.CssClass = "CellTextAlign";
        column.SetDataItemTemplateContent(c =>
        {
            Html.DevExpress().Image(settingsImage =>
            {
                settingsImage.ImageUrl = Url.Content("~/Images/icons/InfoIcon.png");
                settingsImage.Name = "image_" + DataBinder.Eval(c.DataItem, "MenuId");
                settingsImage.ControlStyle.Cursor = "pointer";
                settingsImage.Properties.EnableClientSideAPI = true;
                string url ="";
                if(!string.IsNullOrEmpty(DataBinder.Eval(c.DataItem, "ImageUrl").ToString()))
                    url = Url.Content("~/Images/" + DataBinder.Eval(c.DataItem, "ImageUrl").ToString());
                settingsImage.Properties.ClientSideEvents.Click = string.Format("function(s, e) {{ ShowDocumentsPopup(\"{0}\"); }}", url);
            }).Render();

        });
    });
   
    //Client Side Events 
    settings.ClientSideEvents.SelectionChanged = "RolesRightsSelectionChanged";
    //settings.ClientSideEvents.RowClick = "RowClick";
     
}).Bind(Model.RoleRightsList).GetHtml() %>