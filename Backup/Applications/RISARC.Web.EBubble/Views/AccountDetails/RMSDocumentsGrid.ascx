<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.eTAR.Model.AccountDetailsMain>" %>
<%   
  var grid = Html.DevExpress().GridView(settings =>
      {
        settings.Name = "RMSDocumentsGrid";
        settings.KeyFieldName = "DocumentFileID";
        settings.ControlStyle.Cursor = "pointer";
        //Scroll Settings 

        settings.SettingsLoadingPanel.Text = "Loading...";

        settings.CallbackRouteValues = new { Controller = "AccountDetails", Action = "RMSDocumentsGrid", DocumentFileID = Model.DocumentFileID, DocumentTypeID = Model.DocumentTypeID, TCNNo = Model.TCNNo, AccountSubmissionDetailsID = Model.AccountSubmissionDetailsID, SenderProviderID = Model.SenderProviderID, PatientId = Model.PatientId };
        settings.ClientSideEvents.BeginCallback = "OnDocumentGridBeginCallback";
    
        settings.Width = System.Web.UI.WebControls.Unit.Percentage(100);
         
        settings.Settings.HorizontalScrollBarMode = ScrollBarMode.Auto;
        settings.Settings.VerticalScrollBarMode = ScrollBarMode.Auto;
        settings.Settings.VerticalScrollableHeight = 300;

        // Altrnet Row color changes
        settings.Styles.AlternatingRow.BackColor = System.Drawing.ColorTranslator.FromHtml("#f7f7f7");
           
        settings.SettingsPager.Mode = GridViewPagerMode.ShowAllRecords;
       
          
        settings.SettingsBehavior.AllowSelectSingleRowOnly = true;
        settings.SettingsBehavior.AllowSelectByRowClick = true;

      
           
          //This is code for response letter. surekha : 22.09.2014
          //Delete column should be shown to field officer dynamically  
        if (Session["IsFieldOffierLogin"] != null && (bool)Session["IsFieldOffierLogin"] == true)
        {
            GridViewCommandColumnCustomButton delBtn = new GridViewCommandColumnCustomButton();
            delBtn.ID = "Remove Response Letter";
            delBtn.Image.Url = Url.Content("~/images/remove.jpg");
            delBtn.Image.IsResourcePng = true;
            
            settings.CommandColumn.CustomButtons.Add(delBtn);
            settings.CommandColumn.Caption = "<b></b>";
            settings.CommandColumn.Width = Unit.Percentage(10);
           // settings.SettingsBehavior.ConfirmDelete = true;
          //  settings.SettingsText.ConfirmDelete = "Are you sure you want to delete this record?";

            settings.CommandColumn.ButtonType = GridViewCommandButtonType.Image;
            settings.CommandColumn.Visible = true;
            settings.CommandColumn.VisibleIndex = 1;
            settings.CommandColumn.CellStyle.Paddings.Padding = 0;
            settings.CommandColumn.MinWidth = 40;
            settings.ClientSideEvents.CustomButtonClick = "removeRLFileWithDocid";
          
            settings.CustomButtonInitialize = (sender, e) =>
                {
                    if (e.CellType == GridViewTableCommandCellType.Filter) return;

                    MVCxGridView gr = sender as MVCxGridView;
                    string DocumentTypeName = Convert.ToString(gr.GetRowValues(e.VisibleIndex, "DocumentRemoveLink")); // get necessary row values
                    if (string.IsNullOrEmpty(DocumentTypeName)) //check the value
                    { e.Visible = DefaultBoolean.False; }
                    else
                    {
                        e.Visible = DefaultBoolean.True;

                    }
                };
            settings.ClientSideEvents.EndCallback = "OnDocumentGridEndCallback";

            /*This code is written becuase when response letter is uploaded and user said "Attch & preveiew"
          then last file from grid is opening and need to set fouse on that file.
          Row count - 1  RMSDocumentsGrid.SetFocusedRowIndex(count - 1  ); when user do attche and preview */

            settings.CustomJSProperties = (sender, e) =>
            {
                MVCxGridView gridIndex = (MVCxGridView)sender;
                e.Properties["cpVisibleRowCount"] = gridIndex.VisibleRowCount;
            };
            
        }//  If ends ...
          
          
          
        settings.Styles.Header.BackColor = System.Drawing.ColorTranslator.FromHtml("#ececec");
        settings.ControlStyle.CssClass = "docIndexGrid";
  
       
        //Removing Right and bottom border.
        settings.ControlStyle.BorderRight.BorderStyle = BorderStyle.None;
        settings.ControlStyle.BorderBottom.BorderStyle = BorderStyle.None; 
        
             
        //========== Grid View Resizing Column Header of Grid View ===========
        settings.SettingsBehavior.ColumnResizeMode = ColumnResizeMode.Control;
         
        settings.Styles.SelectedRow.BackColor = System.Drawing.ColorTranslator.FromHtml("#fffedf");
        settings.Styles.SelectedRow.ForeColor = System.Drawing.ColorTranslator.FromHtml("#333333");

     
           
        //============== Enable Text Wraping in grid =============
        settings.Styles.Cell.Wrap = DefaultBoolean.True;

      
          
        //=================== Incresing Row Height =============================
        settings.Styles.Cell.VerticalAlign = VerticalAlign.Middle;
        settings.Styles.Cell.Paddings.PaddingTop = Unit.Pixel(14);
        settings.Styles.Cell.Paddings.PaddingBottom = Unit.Pixel(14);  
      
        //+ ends 
        
      
       
       settings.Caption = "List of RMS Documents";
       
        settings.Columns.Add(column =>
        {
            column.FieldName = "DocumentFileID";
            column.Width = System.Web.UI.WebControls.Unit.Pixel(15);
            column.Visible = false;
        });
          
        settings.Columns.Add(column =>
        { 
            column.Caption = "Doc. Name";
            column.FieldName = "DocumentName";
           // column.Width = System.Web.UI.WebControls.Unit.Percentage(38);
            column.ReadOnly = true;
            column.Width = System.Web.UI.WebControls.Unit.Percentage(35);
            
            
           // column.MinWidth = 100;
            //Meage columns when response letter are avilable 
            if (ViewData["ResponseLetterFound"] != null && Convert.ToBoolean(ViewData["ResponseLetterFound"]) == true)
            {
                column.CellStyle.BorderRight.BorderWidth = 0;
                column.HeaderStyle.CssClass = "RMSRemoveRightBorder";
              //  column.MinWidth = 85;
            } else  if (Session["IsFieldOffierLogin"] != null && (bool)Session["IsFieldOffierLogin"] == true) //Mege columns when Response letter not found 
                {                                                                                             //Logged in user if field offincer       
                   column.CellStyle.BorderRight.BorderWidth = 0;
                    column.HeaderStyle.CssClass = "RMSRemoveRightBorder";
                  //  column.MinWidth = 85;
                }
        });



        settings.Columns.Add(column =>
            {
                column.Caption = "Doc. Type Name";
                column.FieldName = "DocumentTypeName";
                column.Width = System.Web.UI.WebControls.Unit.Percentage(41);
                // column.MinWidth = 100;
            });

        settings.Columns.Add(column =>
        {
            column.Width = Unit.Percentage(30);
         
            column.FieldName = "TCNNumber";
            column.Caption = "TCN#";
           // column.MinWidth = 48; 
            column.CellStyle.Wrap = DefaultBoolean.True;
            
        });

        settings.Columns.Add(column => {
            column.FieldName = "DocumentID";
            column.Visible = false;
        });

        settings.Columns.Add(column =>
        {
            column.FieldName = "DocumentRemoveLink";
            column.Visible = false;
            
        });
          
        settings.ClientSideEvents.RowClick = "RMSDocumentRowClicked";
    });
    
   grid.Bind(Model.DocumentTypeList).GetHtml();
%>


