<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Membership.Model.UserProviderMapping>" %>
    
<%= Html.DevExpress().GridView(settings => {
    settings.Name = "OrgMemberMaping";
    settings.KeyFieldName = "Email";
    settings.CallbackRouteValues = new { Controller = "AccountAdministration", Action = "GetUsersForSelectedProvider" , ProviderID = Model.ProviderId};

    settings.Styles.Header.BackColor = System.Drawing.ColorTranslator.FromHtml("#e3f3f4");
    settings.Styles.Header.CssClass = "gvworklistHeader";
    
    //settings.Settings.GridLines = System.Web.UI.WebControls.GridLines.


    settings.ClientSideEvents.BeginCallback = "sendSelectedProviderId";
   
    
    //Grid View Resizing Column Header of Grid View
    settings.SettingsBehavior.ColumnResizeMode = ColumnResizeMode.Control;
    //==================== Changing Grid Loading Icons ===================
    settings.Images.LoadingPanel.Url = Url.Content("~/Images/icons/LoadingLogo.gif");
    settings.SettingsLoadingPanel.Text = " ";
    settings.Images.LoadingPanel.Width = 76;
    settings.Images.LoadingPanel.Height = 100;  
    
    settings.Styles.FilterCell.CssClass = "fillterCell";
    settings.Settings.ShowFilterRow = true;
    settings.ImagesEditors.DropDownEditDropDown.Url = Url.Content("~/Images/icons/calenderIcon.png"); 
    
    settings.Styles.SelectedRow.CssClass = "changebackgroud"; //by surekha written style for it
    settings.Width = Unit.Pixel(460);

    settings.Settings.VerticalScrollBarMode = ScrollBarMode.Visible;
    settings.Settings.VerticalScrollableHeight = 350;

    
    settings.CommandColumn.Visible = true;
    settings.CommandColumn.ShowSelectCheckbox = true;
    settings.CommandColumn.Width = 40;
    settings.CommandColumn.Name = "selectAllCheckbox";

    settings.SettingsPager.Mode = GridViewPagerMode.ShowAllRecords;


    settings.Styles.SelectedRow.BackColor = System.Drawing.ColorTranslator.FromHtml("#f1f1f1");
    settings.ControlStyle.Border.BorderColor = System.Drawing.ColorTranslator.FromHtml("#d5d5d5"); 


    

    settings.AutoFilterCellEditorInitialize = (sender, e) =>
    {
        ASPxTextBox filterTextBox = (e.Editor as ASPxTextBox);

        if (filterTextBox != null)
        {
            filterTextBox.NullText = "Search Member By Name";
        }

    };

    
    settings.Settings.GridLines = System.Web.UI.WebControls.GridLines.Horizontal;

    settings.CommandColumn.SetHeaderTemplateContent(c =>
    {
        Html.DevExpress().CheckBox(settingsCheckBox =>
        {
            settingsCheckBox.Name = "cbOrgSelectAll";
        
            settingsCheckBox.Properties.ClientSideEvents.CheckedChanged =
                string.Format("function(s, e) {{ if(s.GetChecked()) {0}.SelectRows(); else {0}.UnselectRows(); }}", settings.Name);
            settingsCheckBox.Checked = c.Grid.VisibleRowCount == c.Grid.Selection.Count;
            settingsCheckBox.ClientVisible = c.Grid.VisibleRowCount > 0; // <- Add this line

            
        }).Render();
    });


    settings.Styles.FilterCell.CssClass = "fillterCell";
    settings.Settings.ShowFilterRow = true;


    settings.Columns.Add(column =>
    {
        column.FieldName = "UserIndex";
        column.Visible = false;
    });

    settings.Columns.Add(column =>
    {
        column.HeaderStyle.Wrap = DefaultBoolean.True;
        column.Caption = "Member Name & Details ";
        column.Width = 70;
        column.FieldName = "MemberFullName";
        
        column.SetDataItemTemplateContent(c =>
        {
            string MembFullName = Convert.ToString(DataBinder.Eval(c.DataItem, "MemberFullName"));
            string Email = Convert.ToString(DataBinder.Eval(c.DataItem, "Email"));
            string CreatedBy = Convert.ToString(DataBinder.Eval(c.DataItem, "CreatedBy"));

            ViewContext.Writer.Write("<div class='mapUserName'>" + MembFullName + "</div><div class='contactAddr'><span>" + Email + "</span> <span>&nbsp; | &nbsp;</span> <span>" + CreatedBy + "</span></div>");


        });

    });//column ends 
    
    
 
    settings.ClientSideEvents.SelectionChanged = "OrganizationSelectionChanged";
    
}).Bind(Model.MappedUserToProvider).GetHtml() %>