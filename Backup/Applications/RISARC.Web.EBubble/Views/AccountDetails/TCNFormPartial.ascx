<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<%
    
    Html.DevExpress().CallbackPanel(
    settings =>
    {
        settings.Name = "TCNFormDisplayCP";
        settings.CallbackRouteValues = new { Controller = "AccountDetails", Action = "TCNFormPartial" };
        settings.Width = Unit.Percentage(100);

        settings.ControlStyle.ForeColor = System.Drawing.ColorTranslator.FromHtml("#ff6600");
       
        settings.SetContent(() =>
        {
            //Here Html Editor Set
            Html.DevExpress().HtmlEditor(
                  settingsEditor =>
                  {
                      settingsEditor.Name = "TCNFormDisplay";
                      settingsEditor.ControlStyle.CssClass = "TCNViewerArea";
                     
                      settingsEditor.Width = Unit.Percentage(100);
                      settingsEditor.Height = Unit.Pixel(719);
                 
                      System.IO.Stream fileStream;
                      //get HTML content using stream reader
                      if (ViewData["HtmlFileStream"] != null)
                      {
                          //if TCN file is decrypted
                          if (ViewData["HtmlFileStream"] is System.IO.MemoryStream)
                          {
                              fileStream = ViewData["HtmlFileStream"] as System.IO.MemoryStream;
                          }
                          else
                          {
                              fileStream = ViewData["HtmlFileStream"] as System.IO.FileStream;
                          }

                          using (System.IO.StreamReader streamReader = new System.IO.StreamReader(fileStream))
                          {
                              settingsEditor.Html = streamReader.ReadToEnd();
                          }
                      }

                      //Disabling all button of Html editor.
                      //Current files is viewed in preview mode because all other mode are disabled 
                      settingsEditor.Settings.AllowPreview = true;
                      settingsEditor.Settings.AllowHtmlView = false;
                      settingsEditor.Settings.AllowDesignView = false;

                  }).GetHtml();
        });
    }
).GetHtml();
%>