<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IEnumerable<RISARC.Membership.Model.ChangeFaciltyCombo>>" %>

  <% Html.DevExpress().GridLookup(settings =>
           {
               settings.Name = "gvUserOrgnizationsList";
               settings.GridViewProperties.CallbackRouteValues = new { Controller = "ChangeFacility", Action = "UsersOrgnizationsList"};
               settings.Width = 280;
             
               settings.KeyFieldName = "UserIndex";

            
               settings.ControlStyle.CssClass = "AllScanedDoc changeBgColor";
               settings.Columns.Add( column => {
                   
                   
                   column.FieldName = "UserName";
                   column.Width = Unit.Percentage(40);
                   column.CellStyle.Wrap = DefaultBoolean.True;
               });

               settings.Columns.Add(column =>
               {
                   column.FieldName = "Providers";
                   column.Width = Unit.Percentage(60);
                   column.CellStyle.Wrap = DefaultBoolean.True;
               });
               
         
               settings.Properties.IncrementalFilteringMode = IncrementalFilteringMode.Contains;
               settings.Properties.TextFormatString = "{0} | {1}";
              
               settings.GridViewProperties.Settings.ShowColumnHeaders = false;
               settings.GridViewProperties.SettingsPager.Mode = GridViewPagerMode.ShowAllRecords;
               settings.GridViewProperties.SettingsBehavior.EnableRowHotTrack = true;
              
               settings.Properties.EnableClientSideAPI = true;
               settings.Properties.ClientSideEvents.RowClick = "UserListClick";


               //============================= Changing arrow of chombobox =====================================
               settings.Properties.DropDownButton.Image.Url = @Url.Content("~/Images/icons/dropdown_button.png");
               settings.Properties.ButtonStyle.Border.BorderWidth = 0;
               settings.Properties.ButtonStyle.Paddings.Padding = 0;
               settings.Properties.ButtonStyle.CssClass = "dropdownButton";

        

              // settings.Properties.ClientSideEvents.EndCallback = "patientFirstAlphaEndCallback";
               settings.GridViewProperties.SetDataRowTemplateContent(c =>
               {
                   string UserName = DataBinder.Eval(c.DataItem, "UserName").ToString();
                   string Providers = (DataBinder.Eval(c.DataItem, "Providers")).ToString();
                   
                 
                   Html.RenderPartial("_AdvancedLookupUsersOrgsTmpl", new ViewDataDictionary { {"UserName",UserName},{"Providers",Providers}});
               });

               settings.DataBound = (sender, e) =>
               {
                   var gridLookup = (MVCxGridLookup)sender;
                   gridLookup.GridView.Width = 500;

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
               
            
               
           }).BindList(Model).GetHtml();
%>