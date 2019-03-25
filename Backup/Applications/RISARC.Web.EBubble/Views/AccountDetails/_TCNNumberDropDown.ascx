<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.eTAR.Model.TCNDropDown>" %>
<%= Html.DevExpress().ComboBox(RISARC.Web.EBubble.Models.DevxControlSettings.ComboBoxSetting.ComboBoxSettingsMethodAdditional(
    settings => {
        settings.Name = "TCNId";
        settings.CallbackRouteValues = new { Controller = "AccountDetails", Action = "TCNNumberDropDown" };
        settings.Properties.TextField = "TCNNumber";
        settings.Properties.ValueField = "TCNIdentificationID";
        settings.Properties.ValueType = typeof(Int64);
        settings.ClientEnabled = true;
        settings.Properties.ClientSideEvents.SelectedIndexChanged = "TCNId_SelectedIndexChange";
        settings.Properties.ClientSideEvents.EndCallback = "TCNID_EndCallback";
        settings.ControlStyle.CssClass = "AllScanedDoc";
        settings.Width = Unit.Percentage(45);
    }
)).BindList(Model.TCNDropDownItems).Bind(Model.TCNIdentificationID).GetHtml() %>