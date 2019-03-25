<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<%  
    var grid = Html.DevExpress().GridView(
     settings =>
     {
         settings.Name = "gvdirectives";
         settings.Width = Unit.Percentage(100);
         settings.CallbackRouteValues = new { Controller = "ChangeFacility", Action = "_gvPatientDirective" };

         //Alterring color
         settings.Styles.AlternatingRow.BackColor = System.Drawing.ColorTranslator.FromHtml("#f7f7f7");
        // settings.Styles.Header.BackColor = System.Drawing.ColorTranslator.FromHtml("#e3f3f4");
         settings.Styles.Header.CssClass = "gvworklistHeader";


         //This for nowmal row.
         settings.Styles.Cell.VerticalAlign = VerticalAlign.Middle;
         settings.Styles.Cell.Paddings.PaddingTop = Unit.Pixel(15);
         settings.Styles.Cell.Paddings.PaddingBottom = Unit.Pixel(15);
         settings.Width = Unit.Percentage(100);

         settings.SettingsBehavior.ColumnResizeMode = ColumnResizeMode.Control;
         // settings.Styles.Header.BackColor = System.Drawing.ColorTranslator.FromHtml("#e3f3f4");
         settings.Settings.HorizontalScrollBarMode = ScrollBarMode.Auto;
         settings.Settings.VerticalScrollableHeight = 240;
         settings.Settings.VerticalScrollBarMode = ScrollBarMode.Auto;
         settings.SettingsPager.Mode = GridViewPagerMode.ShowAllRecords;
         
         settings.Columns.Add(column =>
         {
             column.Width = 497;
             column.FieldName = "Directive";

         });

         settings.Columns.Add(column =>
         {
              column.Width = 245;
              column.FieldName = "StartDate";
             // column.CellStyle.HorizontalAlign = System.Web.UI.WebControls.HorizontalAlign.Center;
         });

         settings.Columns.Add(column =>
        {
            column.Width = 245;
            column.FieldName = "EndDate";
            // column.CellStyle.HorizontalAlign = System.Web.UI.WebControls.HorizontalAlign.Center;
        });

     });

    grid.Bind(Model).GetHtml();%>





