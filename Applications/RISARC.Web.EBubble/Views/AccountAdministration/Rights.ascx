<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<%     
    var grid = Html.DevExpress().GridView(settings =>
     {
         settings.Name = "UserRights";
         settings.Width = Unit.Percentage(100);
         settings.Height = Unit.Pixel(580);
         settings.KeyFieldName = "MenuId";
         settings.CallbackRouteValues = new { Controller = "AccountAdministration", Action = "Rights" };

         //========== Grid View Resizing Column Header of Grid View ===========
         settings.SettingsBehavior.ColumnResizeMode = ColumnResizeMode.Control;
         //==================== Changing Grid Loading Icons ===================
         settings.Images.LoadingPanel.Url = Url.Content("~/Images/icons/LoadingLogo.gif");
         settings.SettingsLoadingPanel.Text = " ";
         settings.Images.LoadingPanel.Width = 76;
         settings.Images.LoadingPanel.Height = 100;  
         
        // e3f3f4
         settings.Styles.Header.BackColor = System.Drawing.ColorTranslator.FromHtml("#e3f3f4");
         settings.Styles.Header.CssClass = "gvworklistHeader";
         settings.Styles.Table.ForeColor = System.Drawing.ColorTranslator.FromHtml("#717171");  
         
      //   settings.Caption = "Rights";

       //  settings.Styles.Header.CssClass = "RightsColumnTitleBack";//Columns Title Background Color Changes
         //pagination disabled
         settings.SettingsPager.Mode = GridViewPagerMode.ShowAllRecords;
         settings.Settings.VerticalScrollBarMode = ScrollBarMode.Visible;
         settings.Settings.VerticalScrollableHeight = 555;
         
         settings.Columns.Add(column =>
            {
                //column.CellStyle.BorderLeft.BorderWidth = 5;
                column.FieldName = "MenuName";
                //column.Width = 250;
                column.Caption = "<b>Right Name</b>";
                //column.CellStyle.CssClass = "CellTextAlign";
                //column.CellStyle.HorizontalAlign = System.Web.UI.WebControls.HorizontalAlign.Left;
           });

         settings.Columns.Add(column =>
         {
             column.FieldName = "Description";
             //column.Width = 380;
           //  column.CellStyle.CssClass = "CellTextAlign";
             column.Caption = "<b>Description</b>";
         });

         ////Below Image path is set invisible 
         //settings.Columns.Add(column =>
         //{
         //    column.FieldName = "ImageUrl";
         //    column.Caption = "ImagePath";
         //    column.Visible = true; //invisiblity settings
         //    //column.Width = 50;
             
         //});


         //Below Image path is set invisible 
         settings.Columns.Add(column =>
         {
             column.FieldName = "ImageUrl";
             column.Caption = "<b>Info</b>";
             column.Width = Unit.Percentage(10);

             column.CellStyle.Cursor = "pointer";
             column.SetDataItemTemplateContent(c =>
             {
                 string imageUrl = Url.Content("~/Images/"+Convert.ToString(DataBinder.Eval(c.DataItem, "ImageUrl")));
                 imageUrl = "\"" + imageUrl + "\"";

                  ViewContext.Writer.Write("<img src='" + Url.Content("~/Images/icons/InfoIcon.png") + "'  onClick=ShowDocumentsPopup(" + imageUrl + ") />");

             });
             
         });

         

       //  settings.CommandColumn.VisibleIndex = 3; //here button postion set
       //  settings.CommandColumn.Visible = true;
       //  GridViewCommandColumnCustomButton editBtn = new GridViewCommandColumnCustomButton();
       //  settings.CommandColumn.Caption = "<b>Info</b>";
       //  settings.CommandColumn.Width = Unit.Percentage(10);
       ////  settings.CommandColumn.CellStyle.CssClass = "CellTextAlign";

       //  editBtn.ID = "Rights Documents Snap"; //it show tooltip
       //  editBtn.Visibility = GridViewCustomButtonVisibility.AllDataRows;
       //  editBtn.Image.Url = Url.Content("~/Images/icons/InfoIcon.png");
       //  editBtn.Image.IsResourcePng = true;

       //  settings.CommandColumn.CustomButtons.Add(editBtn);
       //  //settings.CommandColumn.ButtonType = ButtonType.Image;
       //  //settings.CommandColumn.ButtonType = (DevExpress.Web.ASPxGridView.GridViewCommandButtonType) ButtonType.Image;
       //  settings.CommandColumn.ButtonType = GridViewCommandButtonType.Image;

       //  settings.CommandColumn.va
         
         //Changing Background Color Of All Row 
         //settings.Styles.Row.CssClass = "RightsRowBackColor";
         //=================== Incresing Row Height =============================
         settings.Styles.Cell.VerticalAlign = VerticalAlign.Middle;
         settings.Styles.Cell.Paddings.PaddingTop = Unit.Pixel(14);
         settings.Styles.Cell.Paddings.PaddingBottom = Unit.Pixel(14);  
         //+ ends  



         //settings.DataBound += new EventHandler(
         //   delegate(object sender, EventArgs e)
         //   {

         //       ASPxGridView gridview = (ASPxGridView)sender;
         //       if (gridview.VisibleRowCount <= 10)
         //           gridview.Settings.VerticalScrollBarMode = ScrollBarMode.Hidden;
         //       else
         //       {
         //           gridview.Settings.VerticalScrollBarMode = ScrollBarMode.Auto;
         //           gridview.Settings.VerticalScrollableHeight = 555;
         //       }
         //   });
         
       //  settings.ClientSideEvents.CustomButtonClick = "function(s,e){ OnButtonClick(s,e); }";
         
         settings.ClientSideEvents.BeginCallback = "OnBeginCallback";
         

     });
    grid.Bind(Model).GetHtml();
%>

 