<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IEnumerable<RISARC.Files.Model.Measures>>" %>

<% Html.DevExpress().DropDownEdit(
    settings => {
        
        settings.Name = "checkComboBox1";
        settings.Width = Unit.Pixel(320);
        settings.ControlStyle.CssClass = "OrgNameSeachboxCls";
        settings.Properties.DropDownButton.Image.Url = @Url.Content("~/Images/icons/dropdown_button.png");
        settings.Properties.ButtonStyle.Border.BorderWidth = 0;
        settings.Properties.ButtonStyle.Paddings.Padding = 0;
        settings.Properties.ButtonStyle.CssClass = "dropdownButton";
      //  settings.Text = Convert.ToString(CoommaSeperatedRoles);
       //  settings.Text = "--Select Provider--";

        settings.Properties.AnimationType = AnimationType.None;
        settings.Properties.ClientSideEvents.TextChanged = "SynchronizeListBoxValues";
        settings.Properties.ClientSideEvents.DropDown = "SynchronizeListBoxValues";
        settings.Properties.ClientSideEvents.CloseUp = "DropDownClose";
        settings.ControlStyle.Wrap = DefaultBoolean.True; 
        settings.SetDropDownWindowTemplateContent(c =>
        {
            Html.DevExpress().ListBox(
                listBoxSettings => {
                    listBoxSettings.Name = "checkListBox1";
                    listBoxSettings.Width = Unit.Percentage(95);
                    listBoxSettings.ControlStyle.Border.BorderWidth = 0;
                    listBoxSettings.ControlStyle.BorderBottom.BorderColor = System.Drawing.Color.FromArgb(0xDCDCDC);
                    listBoxSettings.Properties.ItemStyle.Border.BorderWidth = 1;
                    listBoxSettings.Properties.ItemStyle.Border.BorderStyle = System.Web.UI.WebControls.BorderStyle.Solid;
                    listBoxSettings.Properties.ItemStyle.Border.BorderColor = System.Drawing.Color.LightGray;
                    listBoxSettings.Properties.SelectionMode = ListEditSelectionMode.CheckColumn;
                    listBoxSettings.Properties.ValueField = "MeasureId";
                    listBoxSettings.Properties.ValueType = typeof(int);
                    listBoxSettings.Properties.TextField = "MeasureName";
                    listBoxSettings.Properties.ClientSideEvents.SelectedIndexChanged = "OnListBoxSelectionChanged";
                    listBoxSettings.ControlStyle.CssClass = "OrgNameSeachboxCls";
                    string Temp = listBoxSettings.Properties.ValueField;
            
                }).BindList(Model).Render();
            
            
        });
        
    }
).GetHtml();
%>