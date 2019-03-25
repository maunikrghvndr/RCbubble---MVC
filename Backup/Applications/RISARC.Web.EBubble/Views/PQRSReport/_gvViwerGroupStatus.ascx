<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IEnumerable<RISARC.ACO.Model.GroupStatus>>" %>

<%  
    var grid = Html.DevExpress().GridView(
     settings =>
     {
         settings.Name = "gvViewerGroupStatus";
        
         settings.Width = Unit.Percentage(100);
         settings.CallbackRouteValues = new { Controller = "PQRSReport", Action = "_gvGroupStatus"};

         //Alterring color
         settings.Styles.AlternatingRow.BackColor = System.Drawing.ColorTranslator.FromHtml("#f7f7f7");
         settings.Styles.Header.BackColor = System.Drawing.ColorTranslator.FromHtml("#e3f3f4");
         settings.Styles.Header.CssClass = "gvworklistHeader";

         settings.Styles.Header.Wrap = DefaultBoolean.True;
         
         settings.SettingsEditing.Mode = GridViewEditingMode.Inline;
         settings.SettingsPopup.EditForm.Width = 600;
         settings.SettingsBehavior.AllowSort = false;

         //This for nowmal row.
         settings.Styles.Cell.VerticalAlign = VerticalAlign.Middle;
         settings.Styles.Cell.Paddings.PaddingTop = Unit.Pixel(15);
         settings.Styles.Cell.Paddings.PaddingBottom = Unit.Pixel(15);
         settings.Width = Unit.Percentage(100);



         settings.Settings.HorizontalScrollBarMode = ScrollBarMode.Auto;
         settings.SettingsBehavior.ColumnResizeMode = ColumnResizeMode.Control;
        

         settings.Columns.Add(column =>
         {
             column.Caption = "";
             column.FieldName = "Status";
           
         });


         settings.HtmlDataCellPrepared = (sender, e) =>
         {
             switch (e.DataColumn.FieldName)
             {
               
                case "carefallscount":
                     if (((string)e.GetValue("Status") == "Analysis") && e.GetValue("carefallscount") != null && (int)e.GetValue("carefallscount") != 0)
                         e.Cell.BackColor = System.Drawing.ColorTranslator.FromHtml("#d5dfeb");
                     break;
                case "cadcount":
                     if (((string)e.GetValue("Status") == "Analysis") && e.GetValue("cadcount") != null && (int)e.GetValue("cadcount") != 0)
                         e.Cell.BackColor = System.Drawing.ColorTranslator.FromHtml("#d5dfeb");
                     break;
                case "dmcount":
                     if (((string)e.GetValue("Status") == "Analysis") && e.GetValue("dmcount") != null && (int)e.GetValue("dmcount") != 0)
                         e.Cell.BackColor = System.Drawing.ColorTranslator.FromHtml("#d5dfeb");
                     break;
                case "hfcount":
                     if (((string)e.GetValue("Status") == "Analysis") && e.GetValue("hfcount") != null && (int)e.GetValue("hfcount") != 0)
                         e.Cell.BackColor = System.Drawing.ColorTranslator.FromHtml("#d5dfeb");
                     break;
                case "htncount":
                     if (((string)e.GetValue("Status") == "Analysis") && e.GetValue("htncount") != null && (int)e.GetValue("htncount") != 0)
                         e.Cell.BackColor = System.Drawing.ColorTranslator.FromHtml("#d5dfeb");
                     break;
                case "ivdcount":
                     if (((string)e.GetValue("Status") == "Analysis") && e.GetValue("ivdcount") != null && (int)e.GetValue("ivdcount") != 0)
                         e.Cell.BackColor = System.Drawing.ColorTranslator.FromHtml("#d5dfeb");
                     break;
                case "pcmammogramcount":
                     if (((string)e.GetValue("Status") == "Analysis") && e.GetValue("pcmammogramcount") != null && (int)e.GetValue("pcmammogramcount") != 0)
                         e.Cell.BackColor = System.Drawing.ColorTranslator.FromHtml("#d5dfeb");
                     break;
                case "pccolorectalcount":
                     if (((string)e.GetValue("Status") == "Analysis") && e.GetValue("pccolorectalcount") != null && (int)e.GetValue("pccolorectalcount") != 0)
                         e.Cell.BackColor = System.Drawing.ColorTranslator.FromHtml("#d5dfeb");
                     break;
                case "pcflushotcount":
                     if (((string)e.GetValue("Status") == "Analysis") && e.GetValue("pcflushotcount") != null && (int)e.GetValue("pcflushotcount") != 0)
                         e.Cell.BackColor = System.Drawing.ColorTranslator.FromHtml("#d5dfeb");
                     break;
                case "pcpneumoshotcount":
                     if (((string)e.GetValue("Status") == "Analysis") && e.GetValue("pcpneumoshotcount") != null && (int)e.GetValue("pcpneumoshotcount") != 0)
                         e.Cell.BackColor = System.Drawing.ColorTranslator.FromHtml("#d5dfeb");
                     break;
                case "pcbmiscreencount":
                     if (((string)e.GetValue("Status") == "Analysis") && e.GetValue("pcbmiscreencount") != null && (int)e.GetValue("pcbmiscreencount") != 0)
                         e.Cell.BackColor = System.Drawing.ColorTranslator.FromHtml("#d5dfeb");
                     break;
                case "pctobaccousecount":
                     if (((string)e.GetValue("Status") == "Analysis") && e.GetValue("pctobaccousecount") != null && (int)e.GetValue("pctobaccousecount") != 0)
                         e.Cell.BackColor = System.Drawing.ColorTranslator.FromHtml("#d5dfeb");
                     break;
                case "pcbloodpressurecount":
                     if (((string)e.GetValue("Status") == "Analysis") && e.GetValue("pcbloodpressurecount") != null && (int)e.GetValue("pcbloodpressurecount") != 0)
                         e.Cell.BackColor = System.Drawing.ColorTranslator.FromHtml("#d5dfeb");
                     break; 
                case "pcdepressioncount":
                     if (((string)e.GetValue("Status") == "Analysis") && e.GetValue("pcdepressioncount") != null && (int)e.GetValue("pcdepressioncount") != 0)
                         e.Cell.BackColor = System.Drawing.ColorTranslator.FromHtml("#d5dfeb");
                     break; 
                case "care1count":
                     if (((string)e.GetValue("Status") == "Analysis") && e.GetValue("care1count") != null && (int)e.GetValue("care1count") != 0)
                         e.Cell.BackColor = System.Drawing.ColorTranslator.FromHtml("#d5dfeb");
                     break; 
             
             }
             
             
         };
         
         
         settings.Columns.Add(column =>
         {
             // column.Width = 150;
             column.Caption = "CAD Count";
             column.FieldName = "cadcount";
             
             
             column.SetDataItemTemplateContent(c =>
             {
                 int measureCount = Convert.ToInt32(DataBinder.Eval(c.DataItem, "cadcount"));
                 string Status = Convert.ToString(DataBinder.Eval(c.DataItem, "Status"));

                 if ((measureCount != 0 && Status.Equals("Analysis")) || (measureCount != 0 && Request["bk"] == "closed"))
                 {
                     ViewContext.Writer.Write("<a href='#' onclick='ShowQuestionAnswers(\"cadcount\");'>" + measureCount + "</a>");
                 }
                 else
                 {
                     ViewContext.Writer.Write(measureCount);
                 }
             });
             
         });

         settings.Columns.Add(column =>
         {

             column.Caption = "DM Count";
             column.FieldName = "dmcount";
             column.SetDataItemTemplateContent(c =>
             {
                 int measureCount = Convert.ToInt32(DataBinder.Eval(c.DataItem, "dmcount"));
                 string Status = Convert.ToString(DataBinder.Eval(c.DataItem, "Status"));
                 if ((measureCount != 0 && Status.Equals("Analysis")) || (measureCount != 0 && Request["bk"] == "closed"))
                 {
                     ViewContext.Writer.Write("<a href='#' onclick='ShowQuestionAnswers(\"dmcount\");'>" + measureCount + "</a>");
                 }
                 else
                 {
                     ViewContext.Writer.Write(measureCount);
                 }
             });
             
             
         });

         settings.Columns.Add(column =>
         {
             column.Caption = "HF Count";
             column.FieldName = "hfcount";

             column.SetDataItemTemplateContent(c =>
             {
                 int measureCount = Convert.ToInt32(DataBinder.Eval(c.DataItem, "hfcount"));
                 string Status = Convert.ToString(DataBinder.Eval(c.DataItem, "Status"));
                 if ((measureCount != 0 && Status.Equals("Analysis")) || (measureCount != 0 &&  Request["bk"] == "closed"))
                 {
                     ViewContext.Writer.Write("<a href='#' onclick='ShowQuestionAnswers(\"hfcount\");'>" + measureCount + "</a>");
                 }else {
                     ViewContext.Writer.Write(measureCount);
                 }
             });
             
         });



         settings.Columns.Add(column =>
         {
             column.Caption = "HTN Count";
             column.FieldName = "htncount";
             column.SetDataItemTemplateContent(c =>
             {
                 int measureCount = Convert.ToInt32(DataBinder.Eval(c.DataItem, "htncount"));
                 string Status = Convert.ToString(DataBinder.Eval(c.DataItem, "Status"));
                 if ((measureCount != 0 && Status.Equals("Analysis")) || (measureCount != 0 && Request["bk"] == "closed"))
                 {
                     ViewContext.Writer.Write("<a href='#' onclick='ShowQuestionAnswers(\"htncount\");'>" + measureCount + "</a>");
                 }
                 else
                 {
                     ViewContext.Writer.Write(measureCount);
                 }
             });
             
         });


         settings.Columns.Add(column =>
         {
             column.Caption = "IVD Count";
             column.FieldName = "ivdcount";
             column.SetDataItemTemplateContent(c =>
             {
                 int measureCount = Convert.ToInt32(DataBinder.Eval(c.DataItem, "ivdcount"));
                 string Status = Convert.ToString(DataBinder.Eval(c.DataItem, "Status"));
                 if ((measureCount != 0 && Status.Equals("Analysis")) || (measureCount != 0 && Request["bk"] == "closed"))
                 {
                     ViewContext.Writer.Write("<a href='#' onclick='ShowQuestionAnswers(\"ivdcount\");'>" + measureCount + "</a>");
                 }
                 else
                 {
                     ViewContext.Writer.Write(measureCount);
                 }
             });
             
             
         });

         settings.Columns.Add(column =>
         {
             column.Caption = "BP Count";
             column.FieldName = "pcbloodpressurecount";
             column.SetDataItemTemplateContent(c =>
             {
                 int measureCount = Convert.ToInt32(DataBinder.Eval(c.DataItem, "pcbloodpressurecount"));
                 string Status = Convert.ToString(DataBinder.Eval(c.DataItem, "Status"));
                 if ((measureCount != 0 && Status.Equals("Analysis")) || (measureCount != 0 && Request["bk"] == "closed"))
                 {
                     ViewContext.Writer.Write("<a href='#' onclick='ShowQuestionAnswers(\"pcbloodpressurecount\");'>" + measureCount + "</a>");
                 }
                 else
                 {
                     ViewContext.Writer.Write(measureCount);
                 }
             });
             
         });



         settings.Columns.Add(column =>
         {
             column.Caption = "DEPRESSION Count";
             column.FieldName = "pcdepressioncount";
             column.SetDataItemTemplateContent(c =>
             {
                 int measureCount = Convert.ToInt32(DataBinder.Eval(c.DataItem, "pcdepressioncount"));
                 string Status = Convert.ToString(DataBinder.Eval(c.DataItem, "Status"));
                 if ((measureCount != 0 && Status.Equals("Analysis")) || (measureCount != 0 && Request["bk"] == "closed"))
                 {
                     ViewContext.Writer.Write("<a href='#' onclick='ShowQuestionAnswers(\"pcdepressioncount\");'>" + measureCount + "</a>");
                 }
                 else
                 {
                     ViewContext.Writer.Write(measureCount);
                 }
             });
             
             
         });
         
        
           settings.Columns.Add(column =>
         {

             column.FieldName = "pcflushotcount";
             column.Caption = "FLUSHOT Count";

             column.SetDataItemTemplateContent(c =>
             {
                 int measureCount = Convert.ToInt32(DataBinder.Eval(c.DataItem, "pcflushotcount"));
                 string Status = Convert.ToString(DataBinder.Eval(c.DataItem, "Status"));
                 if ((measureCount != 0 && Status.Equals("Analysis")) || (measureCount != 0 && Request["bk"] == "closed"))
                 {
                     ViewContext.Writer.Write("<a href='#' onclick='ShowQuestionAnswers(\"pcflushotcount\");'>" + measureCount + "</a>");
                 }
                 else
                 {
                     ViewContext.Writer.Write(measureCount);
                 }
             });
             
         });
       
         
       settings.Columns.Add(column =>
         {

             column.FieldName = "pcmammogramcount";
             column.Caption = "MAMMOGRAM Count";

             column.SetDataItemTemplateContent(c =>
             {
                 int measureCount = Convert.ToInt32(DataBinder.Eval(c.DataItem, "pcmammogramcount"));
                 string Status = Convert.ToString(DataBinder.Eval(c.DataItem, "Status"));
                 if ((measureCount != 0 && Status.Equals("Analysis")) || (measureCount != 0 && Request["bk"] == "closed"))
                 {
                     ViewContext.Writer.Write("<a href='#' onclick='ShowQuestionAnswers(\"pcmammogramcount\");'>" + measureCount + "</a>");
                 }
                 else
                 {
                     ViewContext.Writer.Write(measureCount);
                 }
             });
             
             
         });
        
              settings.Columns.Add(column =>
              {

             column.FieldName = "pcpneumoshotcount";
             column.Caption = "NEUMOSHOT Count";

             column.SetDataItemTemplateContent(c =>
             {
                 int measureCount = Convert.ToInt32(DataBinder.Eval(c.DataItem, "pcpneumoshotcount"));
                 string Status = Convert.ToString(DataBinder.Eval(c.DataItem, "Status"));
                 if ((measureCount != 0 && Status.Equals("Analysis")) || (measureCount != 0 && Request["bk"] == "closed"))
                 {
                     ViewContext.Writer.Write("<a href='#' onclick='ShowQuestionAnswers(\"pcpneumoshotcount\");'>" + measureCount + "</a>");
                 }
                 else
                 {
                     ViewContext.Writer.Write(measureCount);
                 }
             });
             
         });
     
        settings.Columns.Add(column =>
         {

             column.FieldName = "pctobaccousecount";
             column.Caption = "BACCOUSER Count";

             column.SetDataItemTemplateContent(c =>
             {
                 int measureCount = Convert.ToInt32(DataBinder.Eval(c.DataItem, "pctobaccousecount"));
                 string Status = Convert.ToString(DataBinder.Eval(c.DataItem, "Status"));
                 if ((measureCount != 0 && Status.Equals("Analysis")) || (measureCount != 0 && Request["bk"] == "closed"))
                 {
                     ViewContext.Writer.Write("<a href='#' onclick='ShowQuestionAnswers(\"pctobaccousecount\");'>" + measureCount + "</a>");
                 }
                 else
                 {
                     ViewContext.Writer.Write(measureCount);
                 }
             });
             
             
         });
                 
         settings.Columns.Add(column =>
         {

             column.FieldName = "carefallscount";
             column.Caption = "CAREFALLS Count";

             column.SetDataItemTemplateContent(c =>
             {
                 int measureCount = Convert.ToInt32(DataBinder.Eval(c.DataItem, "carefallscount"));
                 string Status = Convert.ToString(DataBinder.Eval(c.DataItem, "Status"));
                 if ((measureCount != 0 && Status.Equals("Analysis")) || (measureCount != 0 && Request["bk"] == "closed"))
                 {
                     ViewContext.Writer.Write("<a href='#' onclick='ShowQuestionAnswers(\"carefallscount\");'>" + measureCount + "</a>");
                 }
                 else
                 {
                     ViewContext.Writer.Write(measureCount);
                 }
             });
             
         });
       
       settings.Columns.Add(column =>
         {

             column.FieldName = "care1count";
             column.Caption = "CARE-1 Count";

             column.SetDataItemTemplateContent(c =>
             {
                 int measureCount = Convert.ToInt32(DataBinder.Eval(c.DataItem, "care1count"));
                 string Status = Convert.ToString(DataBinder.Eval(c.DataItem, "Status"));
                 if ((measureCount != 0 && Status.Equals("Analysis")) || (measureCount != 0 && Request["bk"] == "closed"))
                 {
                     ViewContext.Writer.Write("<a href='#' onclick='ShowQuestionAnswers(\"care1count\");'>" + measureCount + "</a>");
                 }
                 else
                 {
                     ViewContext.Writer.Write(measureCount);
                 }
             });
             
             
         });

       
         
        settings.Columns.Add(column =>
         {

             column.FieldName = "pcbmiscreencount";
             column.Caption = "MIS SCREEN Count";
             column.SetDataItemTemplateContent(c =>
             {
                 int measureCount = Convert.ToInt32(DataBinder.Eval(c.DataItem, "pcbmiscreencount"));
                 string Status = Convert.ToString(DataBinder.Eval(c.DataItem, "Status"));
                 if ((measureCount != 0 && Status.Equals("Analysis")) || (measureCount != 0 && Request["bk"] == "closed"))
                 {
                     ViewContext.Writer.Write("<a href='#' onclick='ShowQuestionAnswers(\"pcbmiscreencount\");'>" + measureCount + "</a>");
                 }
                 else
                 {
                     ViewContext.Writer.Write(measureCount);
                 }
             });
             
         });
         
         settings.Columns.Add(column =>
         {

             column.FieldName = "pccolorectalcount";
             column.Caption = "COLORECTAL Count";
             column.SetDataItemTemplateContent(c =>
             {
                 int measureCount = Convert.ToInt32(DataBinder.Eval(c.DataItem, "pccolorectalcount"));
                 string Status = Convert.ToString(DataBinder.Eval(c.DataItem, "Status"));
                 if ((measureCount != 0 && Status.Equals("Analysis")) || (measureCount != 0 && Request["bk"] == "closed"))
                 {
                     ViewContext.Writer.Write("<a href='#' onclick='ShowQuestionAnswers(\"pccolorectalcount\");'>" + measureCount + "</a>");
                 }
                 else
                 {
                     ViewContext.Writer.Write(measureCount);
                 }
             });
             
             
             
         });
         
     });
     
    grid.Bind(Model).GetHtml();%>