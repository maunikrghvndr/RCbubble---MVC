<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.eTAR.Model.InternalNote>" %>


<%   
    var grid = Html.DevExpress().GridView(settings =>
        {
            settings.Name = "InternalNoteGrid";
            settings.CallbackRouteValues = new { Controller = "AccountDetails", Action = "InternalNoteGridCallback", AccountNo = Model.AccountNo, SenderProviderID = Model.SenderProviderID, TCNNo = Model.TCNNo };

            settings.KeyFieldName = "ID";


            settings.Width = Unit.Percentage(100);
            settings.Height = Unit.Percentage(100);

            settings.SettingsPager.Mode = GridViewPagerMode.ShowAllRecords;
            settings.Settings.ShowColumnHeaders = false;
            settings.SettingsBehavior.ColumnResizeMode = ColumnResizeMode.Control;
            settings.Images.LoadingPanel.Url = Url.Content("~/Images/icons/LoadingLogo.gif");
            settings.SettingsLoadingPanel.Text = " ";
            settings.Images.LoadingPanel.Width = 76;
            settings.Images.LoadingPanel.Height = 100; 
            
            settings.ControlStyle.ForeColor = System.Drawing.ColorTranslator.FromHtml("#333333");
            settings.Styles.Table.BackColor = System.Drawing.ColorTranslator.FromHtml("#ececec");

            
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
          

            settings.Columns.Add(column =>
            {
                column.Width = Unit.Percentage(100);
                column.CellStyle.CssClass = "cdv-lineHeight";
                column.SetDataItemTemplateContent(c =>
                {
                    ViewContext.Writer.Write(
                                   "<div class='noteTitle'><b>" + Convert.ToString(DataBinder.Eval(c.DataItem, "Note")).Replace("\n", "<br/>") + "</b></div>" +
                                        "<span class=\"greyColor\">Created by " + DataBinder.Eval(c.DataItem, "CreatedByName") + " on " + "</span>");
                    string createdUTCDate = Convert.ToString(DataBinder.Eval(c.DataItem, "CreatedOn"));
                    if (!string.IsNullOrEmpty(createdUTCDate))
                    {
                        Html.DevExpress().Label(lblSettings =>
                        {
                            lblSettings.Name = "lblCreatedOn_" + Convert.ToString(DataBinder.Eval(c.DataItem, "ID"));
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




