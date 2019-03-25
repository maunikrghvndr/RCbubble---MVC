<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IEnumerable<RISARC.Setup.Model.ProviderInNetworkTest>>" %>
 
<%=  Html.DevExpress().ComboBox(
      RISARC.Web.EBubble.Models.DevxControlSettings.ComboBoxSetting.ComboBoxSettingsMethodAdditional(settings =>
                                  {
                                      settings.Name = "OrganizationSelector";
                                  
                                      settings.Properties.NullText = "Select provider from the list";
                                      settings.Properties.TextField = "ProviderName";
                                      settings.Properties.ValueField = "ProviderId";
                                      settings.Properties.ValueType = typeof(short);
                                      settings.Width = Unit.Pixel(320);
                                     //  settings.SelectedIndex = 0;
                                      settings.Properties.IncrementalFilteringMode = IncrementalFilteringMode.StartsWith;
                                      settings.ControlStyle.CssClass = "OrgNameSeachboxCls";
                                      settings.Properties.ClientSideEvents.SelectedIndexChanged = "UpdateReportByProviderId";
                                  }
                              )).BindList(Model).GetHtml() %> 
