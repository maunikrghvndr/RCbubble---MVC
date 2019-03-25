<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<% 
    Html.DevExpress().GridView(
        settings =>
        {
            settings.Name = "UserRole";
            settings.KeyFieldName = "UserIndex";
            settings.CallbackRouteValues = new { Controller = "AccountAdministration", Action = "UserRolesPatial" };
            settings.ControlStyle.CssClass = "UserRolesClass";

          
            
            settings.Width = Unit.Percentage(100);

            //=================== Incresing Row Height =============================
            settings.Styles.Cell.VerticalAlign = VerticalAlign.Middle;
            settings.Styles.Cell.Paddings.PaddingTop = Unit.Pixel(14);
            settings.Styles.Cell.Paddings.PaddingBottom = Unit.Pixel(14);  
            //+ ends  
         

            settings.Styles.Table.ForeColor = System.Drawing.ColorTranslator.FromHtml("#333333");
            //==

            //Alterring color
            
            settings.Styles.Header.BackColor = System.Drawing.ColorTranslator.FromHtml("#e3f3f4");
          
            settings.Styles.Header.CssClass = "gvworklistHeader";

            settings.Settings.ShowFilterRow = true;
            settings.Styles.FilterCell.CssClass = "fillterCell";
            //========== Grid View Resizing Column Header of Grid View ===========
            settings.SettingsBehavior.ColumnResizeMode = ColumnResizeMode.Control;
            //==================== Changing Grid Loading Icons ===================
            settings.Images.LoadingPanel.Url = Url.Content("~/Images/icons/LoadingLogo.gif");
            settings.SettingsLoadingPanel.Text = " ";
            settings.Images.LoadingPanel.Width = 76;
            settings.Images.LoadingPanel.Height = 100;  
            
            //=
            settings.Styles.Table.ForeColor = System.Drawing.ColorTranslator.FromHtml("#333333");     
            
            settings.Columns.Add(column =>
            {
                column.Caption = "<b>Users</b>";
                column.CellStyle.CssClass = "CellTextAlign";
                column.FieldName = "FullName";
                column.Width = 300;
            });
            //+

            //=
            settings.Columns.Add(column =>
            {
                column.Caption = "<b>Roles</b>";
                column.CellStyle.CssClass = "CellTextAlign";
                column.FieldName = "UserRolesList";
                column.CellStyle.ForeColor = System.Drawing.ColorTranslator.FromHtml("#717171");
                column.Settings.AllowAutoFilter = DefaultBoolean.False;
                //column.Width = 700;
            });
            //+

          
            var commandColumn = settings.Columns.Add("");
            commandColumn.Width = Unit.Percentage(5);
            commandColumn.Caption = "Edit";
            commandColumn.SetDataItemTemplateContent(c =>
            {
                DevExpressHelper.WriteLineToResponse(Html.ActionLink("Edit", "EditUserRoles",
                    new { id = Html.Encrypt(DataBinder.Eval(c.DataItem, "UserIndex")) }, new {  @class = "button clsLoader" }).ToHtmlString());
            });
            //+

        }).Bind(Model).GetHtml();
%>