<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<%= Html.DevExpress().PopupControl(
                      settings =>
                       {
                            settings.Name = "TCNStatusConfirmation";
                            //settings.CallbackRouteValues = new { Controller = "AccountDetails", Action = "AccountNotesPopup" };
                          
                            settings.Width = 550;
                            settings.MinHeight = 220;
                            settings.AllowDragging = true;
                            settings.PopupHorizontalAlign = PopupHorizontalAlign.WindowCenter;
                            settings.PopupVerticalAlign = PopupVerticalAlign.WindowCenter;

                            settings.ControlStyle.CssClass = "dxc-AccountNotes";
                           
                            settings.ShowCloseButton = true;
                            settings.CloseAction = CloseAction.CloseButton;

                            settings.Styles.Header.BackColor = System.Drawing.ColorTranslator.FromHtml("#595959");
                            settings.Styles.Header.ForeColor = System.Drawing.ColorTranslator.FromHtml("#FFFFFF");
                            settings.Styles.Header.Paddings.Padding = 5;
            
                           settings.SetHeaderTemplateContent(c =>
                           {
                               ViewContext.Writer.Write("<div class=\"cutomeHeaderPopup\">TCN Status Confirmation");
                               ViewContext.Writer.Write("<span class=\"statusTimerPosition\">");
                               System.Web.Mvc.Html.ChildActionExtensions.RenderAction(Html, "TimeSpent", "AccountDetails", new { popupFlag = true });
                               ViewContext.Writer.Write("</span>");
                               ViewContext.Writer.Write("<span class=\"moveRight dxc-close-position\">");

                               Html.DevExpress().Image(image =>
                               {
                                   image.Name = "CloseImage";
                                   image.ImageUrl = Url.Content("~/Images/icons/closePopup.jpg");
                                   image.ControlStyle.Cursor = "pointer";

                                   image.Properties.EnableClientSideAPI = true;
                                   image.Properties.ClientSideEvents.Click = "function(s,e){  TCNStatusConfirmation.Hide();  }";
                               }).Render();

                               ViewContext.Writer.Write("</span></div>");
                               
                            
                               
                           });

                            //Client-side events
                            if (Session["IsFieldOffierLogin"] != null && (bool)Session["IsFieldOffierLogin"])
                            {
                                settings.ClientSideEvents.Shown = "function(s,e){OnPopupTickerInit(); OnTimeTrackerInit(1);}";
                                settings.ClientSideEvents.Closing = "function(s,e){StopTimeTracker('1');}";
                            }
                           
                            settings.Modal = true;
                            settings.SetContent(() =>
                            {      Html.RenderPartial("StatusConfirmationPopupContent");
                            });
                           
     }).GetHtml() %>

