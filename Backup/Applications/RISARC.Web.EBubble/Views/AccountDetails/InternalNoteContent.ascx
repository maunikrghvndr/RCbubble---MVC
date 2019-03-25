<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.eTAR.Model.AccountDetailsMain>" %>

<% Html.DevExpress().CallbackPanel(callback =>
   {
       callback.Name = "InternalNoteCallbackPanel";
       callback.CallbackRouteValues = new { Controller = "AccountDetails", Action = "InternalNoteCallbackPanel" };
       callback.Width = Unit.Percentage(100);
       callback.SetContent(() =>
       {
           ViewContext.Writer.Write(System.Web.Mvc.Html.InputExtensions.HiddenFor(Html, model => model.DocumentID));
           ViewContext.Writer.Write("<table class='clsWidth720'><tr><td class='dxc-padding12Left'>");
           ViewContext.Writer.Write("<div id='InternalNoteDiv' class='interMemo'>");
           ViewContext.Writer.Write(Html.DevExpress().Memo(settings =>
           {
               settings.Name = "InternalNoteMemo";
               settings.Width = Unit.Percentage(100);
               settings.Height = 28;

           }).GetHtml());


           ViewContext.Writer.Write("</div><div class='floatRight'>");
           ViewContext.Writer.Write(Html.DevExpress().Button(
                        AddButton =>
                        {
                            AddButton.Name = "InternalAddButton";
                            AddButton.ControlStyle.HorizontalAlign = HorizontalAlign.Center;
                            AddButton.Width = Unit.Pixel(70);
                            AddButton.Height = 28;
                            AddButton.ControlStyle.CssClass = "greyBtn";
                            AddButton.Text = "Add";
                            AddButton.EnableClientSideAPI = true;
                            AddButton.ClientSideEvents.Click = "AddInternalNote";
                        }).GetHtml());
           ViewContext.Writer.Write(@"</div>");
           ViewContext.Writer.Write(@"<tr><td>&nbsp;</td>");
           ViewContext.Writer.Write("</table>");
           System.Web.Mvc.Html.ChildActionExtensions.RenderAction(Html, "InternalNoteGridCallback", "AccountDetails", new { TCNIdentificationID = Model.TCNIdentificationID, SenderProviderID = Model.SenderProviderID });
       });
   }).Render();%>