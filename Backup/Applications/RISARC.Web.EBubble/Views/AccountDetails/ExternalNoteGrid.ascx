<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.eTAR.Model.ExternalNote>" %>


<%   
  var grid = Html.DevExpress().GridView(settings =>
      {

          if ((bool)ViewData["controlFlag"] == true)
          {
              settings.Name = "ExternalNoteGridPopup";
              settings.CallbackRouteValues = new { Controller = "AccountDetails", Action = "ExternalNoteGridCallback", AccountNo = Model.AccountNo, SenderProviderID = Model.SenderProviderID, TCNNo = Model.TCNNo, controlFlag = true, TCNIdentificationID = Model.TCNIdentificationID };
               settings.Settings.VerticalScrollBarMode = ScrollBarMode.Auto;
               //settings.Height = Unit.Pixel(130);
               settings.Settings.VerticalScrollableHeight = 130;
          }
          else
          {
              settings.Name = "ExternalNoteGrid";
              settings.CallbackRouteValues = new { Controller = "AccountDetails", Action = "ExternalNoteGridCallback", AccountNo = Model.AccountNo, SenderProviderID = Model.SenderProviderID, TCNNo = Model.TCNNo, TCNIdentificationID = Model.TCNIdentificationID };

              // Surekahs 15/09/2014
              //To hiding Empty Row data as well remove border width also.
              settings.DataBound = (sender, e) =>
              {
                  MVCxGridView gv = sender as MVCxGridView;
                  if (gv.VisibleRowCount <= 0)
                  {
                      gv.SettingsText.EmptyDataRow = " ";
                      gv.ControlStyle.BorderWidth = 0;
                  }
                  else
                  {
                      gv.ControlStyle.CssClass = "dxc-borderVisible";
                  }
              };
          
          } // else end s 
          
        settings.KeyFieldName = "ID";
        settings.Width = Unit.Percentage(100);
       // settings.Height = Unit.Percentage(100);  
          
        //settings.Width = Unit.Pixel(715); 
       
        //  settings.Settings.VerticalScrollableHeight = 400;



          //settings.DataBound += new EventHandler(
          //   delegate(object sender, EventArgs e)
          //   {

          //       ASPxGridView gridview = (ASPxGridView)sender;
          //       if (gridview.VisibleRowCount <= 4)
          //           gridview.Settings.VerticalScrollBarMode = ScrollBarMode.Hidden;
          //       else
          //       {
          //           gridview.Settings.VerticalScrollBarMode = ScrollBarMode.Visible;
          //           if ((gridview.VisibleRowCount * 30) < 250 )
          //              gridview.Settings.VerticalScrollableHeight = (gridview.VisibleRowCount * 30);
          //       }
          //   });

      
       
          
          
          
        settings.SettingsPager.Mode = GridViewPagerMode.ShowAllRecords;
        settings.Settings.ShowColumnHeaders = false;

        //========== Grid View Resizing Column Header of Grid View ===========
        settings.SettingsBehavior.ColumnResizeMode = ColumnResizeMode.Control;
        //==================== Changing Grid Loading Icons ===================
        //settings.Images.LoadingPanel.Url = Url.Content("~/Images/icons/LoadingLogo.gif");
        settings.SettingsLoadingPanel.Text = " "; 
          
        //  settings.SettingsLoadingPanel.
          
          
          
        //Changing whole table color 
        settings.ControlStyle.ForeColor = System.Drawing.ColorTranslator.FromHtml("#333333");
        settings.Styles.Table.BackColor = System.Drawing.ColorTranslator.FromHtml("#ececec");

          
       
       settings.Columns.Add(column =>
        {
            column.Width = Unit.Percentage(100);

            column.CellStyle.CssClass = "cdv-lineHeight";
            
            column.SetDataItemTemplateContent(c =>
            {
                ViewContext.Writer.Write(
                               "<div><b>" + Convert.ToString(DataBinder.Eval(c.DataItem, "Note")).Replace("\n", "<br/>") + "</b></div>" +
                                    "<span class=\"greyColor\">Created by " + DataBinder.Eval(c.DataItem, "CreatedByName") + " on " + "</span>");
                string createdUTCDate = Convert.ToString(DataBinder.Eval(c.DataItem, "CreatedOn"));
                if (!string.IsNullOrEmpty(createdUTCDate))
                {
                    Html.DevExpress().Label(lblSettings =>
                    {


                        if ((bool)ViewData["controlFlag"] == true)
                        {
                            lblSettings.Name = "lblCreatedOnExternalPopup_" + Convert.ToString(DataBinder.Eval(c.DataItem, "ID"));
                        }
                        else
                            lblSettings.Name = "lblCreatedOnExternal_" + Convert.ToString(DataBinder.Eval(c.DataItem, "ID"));
                       
                        lblSettings.Text = string.Format("{0} {1}", createdUTCDate, TimeZoneInfo.Utc.StandardName);
                        lblSettings.Properties.ClientSideEvents.Init = "function(s,e){SetLocalDateNote(s,e,'" + createdUTCDate + "')}";
                        lblSettings.ControlStyle.ForeColor = System.Drawing.Color.Gray;
                        lblSettings.EncodeHtml = false;
                    }).GetHtml();
                }
            });
        });  
    });
    
   grid.Bind(Model.PresentNotes).GetHtml();
%>

