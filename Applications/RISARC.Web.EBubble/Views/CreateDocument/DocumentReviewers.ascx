<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IEnumerable<RISARC.Setup.Model.ProviderInNetwork>>" %>

<% 
    Html.DevExpress().GridView(
        settings => {
            settings.Name = "documentReviewerGrid";
            settings.CallbackRouteValues = new { Controller = "CreateDocument", Action = "DocumentReviewers" };
            //settings.Settings.HorizontalScrollBarMode = ScrollBarMode.Auto;
            //settings.Settings.VerticalScrollBarMode = ScrollBarMode.Auto;
            //settings.Settings.VerticalScrollableHeight = 80;
            settings.KeyFieldName = "ProviderId";
            settings.Height = Unit.Pixel(200);
            settings.Width = Unit.Percentage(100);
            settings.Columns.Add(column => {
                column.FieldName = "ProviderId";
                column.Caption = "";
                column.Visible = false;
            });

            settings.Columns.Add("ProviderName", "Organization Name");

            settings.CommandColumn.Visible = true;
            settings.CommandColumn.ShowSelectCheckbox = true;
            settings.CommandColumn.Width = Unit.Pixel(20);

            //select all checkbox in gridview
            settings.CommandColumn.SetHeaderTemplateContent(c =>
                   {
                       Html.DevExpress().CheckBox(settingsCheckBox =>
                       {
                           settingsCheckBox.Name = "cbSelectAll";
                           settingsCheckBox.Properties.ClientSideEvents.CheckedChanged = string.Format("function(s, e) {{ if(s.GetChecked()) {0}.SelectRows(); else {0}.UnselectRows(); }}", settings.Name);
                           settingsCheckBox.Checked = c.Grid.VisibleRowCount == c.Grid.Selection.Count;
                       }).Render();
                     });    
            
            settings.ClientSideEvents.SelectionChanged = "OnReviewerGridSelectionChanged";
            settings.ClientSideEvents.BeginCallback = "OnReviewerGridBeginCallback";
            
            settings.Settings.ShowFilterRow = true;
            settings.ImagesEditors.DropDownEditDropDown.Url = Url.Content("~/Images/icons/calenderIcon.png"); 
            
            settings.Styles.SelectedRow.BackColor = System.Drawing.ColorTranslator.FromHtml("#f7f7f7");
            settings.Styles.SelectedRow.ForeColor = System.Drawing.Color.Black;
            
        }).Bind(Model).Render();
%>