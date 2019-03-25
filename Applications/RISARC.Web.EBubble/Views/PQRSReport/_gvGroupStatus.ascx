<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IEnumerable<RISARC.ACO.Model.GroupStatus>>" %>

<%  
    var grid = Html.DevExpress().GridView(
     settings =>
     {
         settings.Name = "gvGroupStatus";
         //  settings.KeyFieldName = "SrNo";
         settings.Width = Unit.Percentage(100);

         settings.CallbackRouteValues = new { Controller = "PQRSReport", Action = "_gvGroupStatus" };

         // settings.Styles.Header.CssClass = "gvworklistHeader";
         //Alterring color
         settings.Styles.AlternatingRow.BackColor = System.Drawing.ColorTranslator.FromHtml("#f7f7f7");
         settings.Styles.Header.BackColor = System.Drawing.ColorTranslator.FromHtml("#e3f3f4");
         settings.Styles.Header.CssClass = "gvworklistHeader";

         settings.Styles.Header.Wrap = DefaultBoolean.True;
         
         settings.SettingsEditing.Mode = GridViewEditingMode.Inline;
         settings.SettingsPopup.EditForm.Width = 600;

         //This for nowmal row.
         settings.Styles.Cell.VerticalAlign = VerticalAlign.Middle;
         settings.Styles.Cell.Paddings.PaddingTop = Unit.Pixel(15);
         settings.Styles.Cell.Paddings.PaddingBottom = Unit.Pixel(15);
         settings.Width = Unit.Percentage(100);

         

         settings.Settings.HorizontalScrollBarMode = ScrollBarMode.Auto;
         settings.SettingsBehavior.ColumnResizeMode = ColumnResizeMode.Control;
         
         settings.Columns.Add(column =>
         {
             // column.Width = 150;
             column.Caption = "";
             column.FieldName = "Status";

         });
         

         settings.Columns.Add(column =>
         {
             // column.Width = 150;
             column.Caption = "CAD Count";
             column.FieldName = "cadcount";
             
         });

         settings.Columns.Add(column =>
         {

             column.Caption = "DM Count";
             column.FieldName = "dmcount";
         });

         settings.Columns.Add(column =>
         {
             column.Caption = "HF Count";
             column.FieldName = "hfcount";
         });



         settings.Columns.Add(column =>
         {
             column.Caption = "HTN Count";
             column.FieldName = "htncount";
         });


         settings.Columns.Add(column =>
         {
             column.Caption = "IVD Count";
             column.FieldName = "ivdcount";
         });

         settings.Columns.Add(column =>
         {
             column.Caption = "BP Count";
             column.FieldName = "pcbloodpressurecount";
         });



         settings.Columns.Add(column =>
         {
             column.Caption = "DEPRESSION Count";
             column.FieldName = "pcdepressioncount";
         });
         
        
           settings.Columns.Add(column =>
         {

             column.FieldName = "pcflushotcount";
             column.Caption = "FLUSHOT Count";
         });
       
         
             settings.Columns.Add(column =>
         {

             column.FieldName = "pcmammogramcount";
             column.Caption = "MAMMOGRAM Count";
         });
        
              settings.Columns.Add(column =>
         {

             column.FieldName = "pcpneumoshotcount";
             column.Caption = "NEUMOSHOT Count";
         });
     
        settings.Columns.Add(column =>
         {

             column.FieldName = "pctobaccousecount";
             column.Caption = "BACCOUSER Count";
         });
                 
         settings.Columns.Add(column =>
         {

             column.FieldName = "carefallscount";
             column.Caption = "CAREFALLS Count";
         });
       
            settings.Columns.Add(column =>
         {

             column.FieldName = "care1count";
             column.Caption = "CARE-1 Count";
         });

       
         
              settings.Columns.Add(column =>
         {

             column.FieldName = "pcbmiscreencount";
             column.Caption = "MIS SCREEN Count";
         });
         
                  settings.Columns.Add(column =>
         {

             column.FieldName = "pccolorectalcount";
             column.Caption = "COLORECTAL Count";
         });
         
     });


    grid.Bind(Model).GetHtml();%>





