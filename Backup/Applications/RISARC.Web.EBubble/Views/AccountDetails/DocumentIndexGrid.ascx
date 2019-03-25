<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<List<RISARC.eTAR.Model.DocumentIndexInfo>>" %>


<% 
    var grid = Html.DevExpress().GridView(settings =>
    {
        settings.Name = "DocumentIndexGrid";
       
        //Scroll Settings 
        settings.KeyFieldName = "Category";
        settings.CallbackRouteValues = new { Controller = "AccountDetails", Action = "DocumentIndexGrid"};
        settings.SettingsEditing.UpdateRowRouteValues = new { Controller = "AccountDetails", Action = "DocumentIndexGridUpdatePartial" };
        
        settings.ControlStyle.Cursor = "pointer";
        settings.Width = System.Web.UI.WebControls.Unit.Percentage(100);

        //========== Grid View Resizing Column Header of Grid View ===========
        settings.SettingsBehavior.ColumnResizeMode = ColumnResizeMode.Control;
        //==================== Changing Grid Loading Icons ===================
       
        settings.ControlStyle.BorderRight.BorderStyle = BorderStyle.None;
    
        
        
        settings.Settings.HorizontalScrollBarMode = ScrollBarMode.Auto;
        settings.Settings.VerticalScrollBarMode = ScrollBarMode.Auto;
        settings.Settings.VerticalScrollableHeight = 290;
        settings.SettingsPager.Mode = GridViewPagerMode.ShowAllRecords;
        
        settings.SettingsText.EmptyDataRow = "Document indexes are not present for selected document.";
        settings.ControlStyle.CssClass = "PopupEditForm";
        
        settings.Caption = "Document Index";

        settings.Styles.Header.BackColor = System.Drawing.ColorTranslator.FromHtml("#ececec");
        // settings.Styles.Header.CssClass = "gvworklistHeader";
        settings.ControlStyle.CssClass = "docIndexGrid";
        settings.Styles.AlternatingRow.BackColor = System.Drawing.ColorTranslator.FromHtml("#f7f7f7");

        //=================== Incresing Row Height =============================
        settings.Styles.Cell.VerticalAlign = VerticalAlign.Middle;
        settings.Styles.Cell.Paddings.PaddingTop = Unit.Pixel(14);
        settings.Styles.Cell.Paddings.PaddingBottom = Unit.Pixel(14);  
        //+ ends 
        
      
        
        // Added By Dnyaneshwar
        settings.CustomJSProperties = (sender, e) =>
        {
            MVCxGridView gridIndex = (MVCxGridView)sender;
            e.Properties["cpVisibleRowCount"] = gridIndex.VisibleRowCount;
        };
        // End Added

     
        //Hide or Show command column based on who is revieing the document. (index modification is not allowed once the document is submitted to field officer.)
        if (ViewData["IsDocumentSubmitted"] != null)
        {

            //columns settings
            settings.Columns.Add(col =>
            {
                col.FieldName = "Category";
                col.ReadOnly = true;
            });

            settings.Columns.Add(column =>
            {
                column.FieldName = "Page";
                column.SetDataItemTemplateContent(content =>
                {
                    ViewContext.Writer.Write("" + DataBinder.Eval(content.DataItem, "Page") + "");
                    //Added By Dnyaneshwar
                    ViewContext.Writer.Write(Html.Hidden("documentIndex_" + content.VisibleIndex, DataBinder.Eval(content.DataItem, "FirstIndexForSection")));
                    //End Added
                });
            });
            
            bool isDocumentSubmitted = (bool)ViewData["IsDocumentSubmitted"];
            settings.CommandColumn.Visible = isDocumentSubmitted;
            settings.CommandColumn.ShowEditButton = isDocumentSubmitted;
            settings.CommandColumn.Width = Unit.Percentage(15);

        }  else { //thiss is the case when document viewer is loaded 


            string path = Request.UrlReferrer.AbsolutePath.ToString();

            if (path == "/ViewDocuments/MyDocumentsPendingForTCN" || path == "/AccountDetails/AccountDetailsMaster")
            {

                //columns settings
                settings.Columns.Add(col =>
                {
                    col.Width = Unit.Percentage(20);
                    col.Caption = "#";
                    col.ReadOnly = true;
                });

                //columns settings
                settings.Columns.Add(col =>
                {
                    col.Width = Unit.Percentage(40);
                    col.Caption = "Category";
                    col.ReadOnly = true;
                });
                //columns settings
                settings.Columns.Add(col =>
                {
                    col.Width = Unit.Percentage(41);
                    col.Caption = "Page";
                    col.ReadOnly = true;
                });


            }
            else
            {

                //columns settings
                settings.Columns.Add(col =>
                {
                    col.Width = Unit.Percentage(50);
                    col.Caption = "Category";
                    col.ReadOnly = true;
                });
                //columns settings
                settings.Columns.Add(col =>
                {
                    col.Width = Unit.Percentage(50);
                    col.Caption = "Page";
                    col.ReadOnly = true;
                });

            }

            
       }



        //edit mode settings
        settings.SettingsText.PopupEditFormCaption = "Modify Document Index";
        settings.SettingsEditing.UpdateRowRouteValues = new { Controller = "AccountDetails", Action = "DocumentIndexGridUpdatePartial" };
        settings.SettingsEditing.Mode = GridViewEditingMode.PopupEditForm;

        settings.SettingsPopup.EditForm.HorizontalAlign = PopupHorizontalAlign.WindowCenter;
        settings.SettingsPopup.EditForm.VerticalAlign = PopupVerticalAlign.WindowCenter;
        settings.SettingsPopup.EditForm.Modal = true;
        settings.SettingsPopup.EditForm.Width = Unit.Pixel(700);
        settings.SettingsPopup.EditForm.Height = Unit.Pixel(150);
        settings.SettingsEditing.EditFormColumnCount = 1;

        //client side events
        settings.ClientSideEvents.BeginCallback = "OnDocumentIndexBeginCallback";
        // Added by Dnyaneshwar
        settings.ClientSideEvents.EndCallback = "function(s,e){ if($('#IndexRowCount') != null){ $('#IndexRowCount').val(s.cpVisibleRowCount);  var indxLen = $('#documentIndex_0').length;  }else{  disableNextPrevIndex();} }";
        settings.ClientSideEvents.RowClick = "GoToIndex";
        // End Added

        //Formatting of validation messages
        foreach (MVCxGridViewColumn c in settings.Columns)
        {
            var prop = (c.PropertiesEdit as EditProperties);
            if (prop != null)
            {
                prop.ValidationSettings.ErrorDisplayMode = ErrorDisplayMode.Text;
                prop.ValidationSettings.ErrorTextPosition = ErrorTextPosition.Bottom;
            }
        }
    });
    if (ViewData["EditError"] != null)
    {
        grid.SetEditErrorText((string)ViewData["EditError"]);
    }
    grid.Bind(Model).GetHtml();
    %>



 
   