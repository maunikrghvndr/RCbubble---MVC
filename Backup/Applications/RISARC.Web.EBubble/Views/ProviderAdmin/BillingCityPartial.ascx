<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Setup.Model.ManageProvider>" %>
<%
 Html.DevExpress().LabelFor(model => model.BillingContactCity,
                            RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render();
             Html.DevExpress().ComboBoxFor(model => model.BillingContactCity,
                               RISARC.Web.EBubble.Models.DevxControlSettings.ComboBoxSetting.ComboBoxSettingsMethod).Render();

 %>