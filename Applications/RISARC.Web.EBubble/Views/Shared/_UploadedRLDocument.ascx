<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IEnumerable<RISARC.Common.Model.UploadedFiles>>" %>
<%
    string displayData = null;
    if (Model != null)
    {
        displayData = displayData + "<ul class='outerAttchLink'>";
        foreach (var item in Model)
        {
            displayData = displayData + "<li><ul class='setAttchement'> <li class='attachment'></li><li>" + item.PreViewLink + "</li><li>" + item.DeleteLink + "</li></ul></li>";
        }
        displayData = displayData + "</ul>";
    }
    
    List<string> gridModel = new List<string>();
    if (!String.IsNullOrEmpty(displayData))
    {
        gridModel.Add(displayData);
    }
 %>

<%= Html.DevExpress().GridView(settings =>
    {
        
        settings.Name = "fileUploadGrid_RL";
        settings.CallbackRouteValues = new { Controller = "File", Action = "UploadedRLDocument" };
        settings.KeyFieldName = "FileID";
       
        settings.SettingsBehavior.ColumnResizeMode = ColumnResizeMode.Control;
        settings.Images.LoadingPanel.Url = Url.Content("~/Images/icons/LoadingLogo.gif");
        settings.SettingsLoadingPanel.Text = " ";
        settings.Images.LoadingPanel.Width = 76;
        settings.Images.LoadingPanel.Height = 100; 
        
        settings.Width = Unit.Percentage(100);

        settings.Styles.Table.BackColor = System.Drawing.ColorTranslator.FromHtml("#FFFFFF");
        
        settings.Settings.VerticalScrollBarMode = ScrollBarMode.Auto;
        settings.Settings.VerticalScrollableHeight = 55;

        settings.SettingsPager.Mode = GridViewPagerMode.ShowAllRecords;
       // settings.SettingsText.EmptyDataRow = "No files uploaded";

          // Surekahs 15/09/2014
            //To hiding Empty Row data as well remove border width also.
            //settings.DataBound = (sender, e) =>
            //{
            //    MVCxGridView gv = sender as MVCxGridView;
            //    if (gv.VisibleRowCount <= 0)
            //    {
            //        gv.SettingsText.EmptyDataRow = " ";
            //        gv.ControlStyle.BorderWidth = 0;
            //    }
            //    else
            //    {
            //        gv.ControlStyle.CssClass = "dxc-allborderVisible";
            //    }
            //};

        
        settings.Columns.Add(column =>
        {
            settings.Settings.ShowColumnHeaders = false;
       
            column.SetDataItemTemplateContent(c =>
            {
                ViewContext.Writer.Write(displayData);
             
            });
            column.Width = Unit.Percentage(30);
            
          
        });


      
        
    }).Bind(gridModel).GetHtml() %>