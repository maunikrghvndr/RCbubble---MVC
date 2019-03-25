<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IEnumerable<RISARC.Files.Model.PatientInfo>>" %>

<%  
    var grid = Html.DevExpress().GridView(
     settings =>
     {
         settings.Name = "gvPreformanceDetail";

         settings.CallbackRouteValues = new { Controller = "ChangeFacility", Action = "_gvPerformanceDetailReport" };
         //Alterring color
         settings.Styles.AlternatingRow.BackColor = System.Drawing.ColorTranslator.FromHtml("#f7f7f7");
         settings.Styles.Header.BackColor = System.Drawing.ColorTranslator.FromHtml("#e3f3f4");
         settings.Styles.Header.CssClass = "gvworklistHeader";

         //This for nowmal row.
         settings.Styles.Cell.VerticalAlign = VerticalAlign.Middle;
         settings.Styles.Cell.Paddings.PaddingTop = Unit.Pixel(15);
         settings.Styles.Cell.Paddings.PaddingBottom = Unit.Pixel(15);
         settings.Width = Unit.Percentage(100);

         settings.Settings.HorizontalScrollBarMode = ScrollBarMode.Auto;
         settings.SettingsBehavior.ColumnResizeMode = ColumnResizeMode.Control;

         settings.Columns.Add(column =>
         {
             column.Width = Unit.Percentage(25);
             column.Caption = "Patient";
           
             column.SetDataItemTemplateContent(c =>
              {
                  string FirstName = Convert.ToString(DataBinder.Eval(c.DataItem, "FirstName"));
                  string LastName = Convert.ToString(DataBinder.Eval(c.DataItem, "LastName"));
                   string PatientName = FirstName + " " + LastName;
                   ViewContext.Writer.Write(PatientName);
              });


         });

         settings.Columns.Add(column =>
         {
             column.Width = Unit.Percentage(30);
             column.FieldName = "TreatingPhysician";
             column.Caption = "Treating Physician";
         });


         settings.Columns.Add(column =>
         {
             column.Width = Unit.Percentage(15);
             column.FieldName = "MedicareId";
             column.Caption = "Medicare ID";
             column.CellStyle.HorizontalAlign = System.Web.UI.WebControls.HorizontalAlign.Center;
         });


         settings.Columns.Add(column =>
         {
             column.Width = Unit.Percentage(31);
             column.FieldName = "UploadedDate";
             column.Caption = "Date Uploaded";
         });


     });


    grid.Bind(Model).GetHtml();%>





