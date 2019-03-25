<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Setup.Model.UserAlphaSettings>" %>
        <% Html.DevExpress().GridLookup(settings =>
           {
               settings.Name = "patientFirstAlpha";
               settings.GridViewProperties.CallbackRouteValues = new { Controller = "AccountAdministration", Action = "AlphaSettingsDropDown", UserName = Model.UserName, UserIndex =Model.UserIndex };
               settings.Width = 75;
               settings.Height = 33;
               settings.KeyFieldName = "PatientAlpha";
               settings.Columns.Add("PatientAlpha");
               settings.Columns.Add("UserIndex");//.Visible = false;
               settings.Columns.Add("FullName");
               settings.Properties.IncrementalFilteringMode = IncrementalFilteringMode.Contains;
               settings.Properties.TextFormatString = "{0}";
              
               settings.GridViewProperties.Settings.ShowColumnHeaders = false;
               settings.GridViewProperties.SettingsPager.Mode = GridViewPagerMode.ShowAllRecords;
               settings.GridViewProperties.SettingsBehavior.EnableRowHotTrack = true;
              
               settings.Properties.EnableClientSideAPI = true;
               settings.Properties.ClientSideEvents.RowClick = "FirstSettingClick";
               

               //============================= Changing arrow of chombobox =====================================
               settings.Properties.DropDownButton.Image.Url = @Url.Content("~/Images/icons/dropdown_button.png");
               settings.Properties.ButtonStyle.Border.BorderWidth = 0;
               settings.Properties.ButtonStyle.Paddings.Padding = 0;
               settings.Properties.ButtonStyle.CssClass = "dropdownButton";

               settings.ControlStyle.CssClass = "AllScanedDoc";
               
               settings.Properties.ClientSideEvents.EndCallback = "patientFirstAlphaEndCallback";
               settings.GridViewProperties.SetDataRowTemplateContent(c =>
               {
                   RISARC.Setup.Model.MemberAlphaSettings memberalpha = new  RISARC.Setup.Model.MemberAlphaSettings(); 
                       memberalpha.RowNum = Convert.ToInt16( DataBinder.Eval(c.DataItem, "RowNum"));
                       memberalpha.PatientAlpha = Convert.ToChar( DataBinder.Eval(c.DataItem, "PatientAlpha"));
                       memberalpha.UserIndex = SpiegelDg.Common.Utilities.ConvertExtras.ToNullableInt32(DataBinder.Eval(c.DataItem, "UserIndex"));
                       memberalpha.FullName = Convert.ToString( DataBinder.Eval(c.DataItem,"FullName"));
                       Html.RenderPartial("AdvancedLookupRowTemplatePartial", memberalpha, new ViewDataDictionary { { "userindex", Model.UserIndex } });
               });

               settings.DataBound = (sender, e) =>
               {
                   var gridLookup = (MVCxGridLookup)sender;
                   gridLookup.GridView.Width = 200;
                  
                   gridLookup.GridView.Settings.VerticalScrollBarMode = ScrollBarMode.Auto;
                   gridLookup.GridView.Settings.VerticalScrollableHeight = 100;
                   
               };

               settings.GridViewProperties.BeforeGetCallbackResult = (sender, e) =>
               {
                   var grid = (ASPxGridView)sender;
                   if (grid.VisibleRowCount <= 2)
                       grid.Settings.VerticalScrollBarMode = ScrollBarMode.Hidden;
               };
               settings.Properties.NullText = "Select";
           }).BindList(Model.AlfaSettingsList).Bind(Model.patientFirstAlpha).GetHtml();
%>