<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<%Html.DevExpress().ComboBox(
    settings =>
    {
        settings.Name = "BatchYearcomboBox";        
        settings.Width = 180;
        settings.SelectedIndex = 0;
        settings.CallbackRouteValues = new { Controller = "PQRSReport", Action = "BatchYearComboBox" };
        //settings.Properties.CallbackPageSize = 15;        

        settings.Width = Unit.Pixel(320);
        settings.ControlStyle.CssClass = "OrgNameSeachboxCls";
        settings.Properties.DropDownButton.Image.Url = @Url.Content("~/Images/icons/dropdown_button.png");
        settings.Properties.ButtonStyle.Border.BorderWidth = 0;
        settings.Properties.ButtonStyle.Paddings.Padding = 0;
        settings.Properties.ButtonStyle.CssClass = "dropdownButton";                
        settings.Properties.Items.Add(new ListEditItem("Select", 0));
        settings.Properties.Items.Add(new ListEditItem("2014", 1));
           
    }
).BindList(Model).GetHtml();  %>

