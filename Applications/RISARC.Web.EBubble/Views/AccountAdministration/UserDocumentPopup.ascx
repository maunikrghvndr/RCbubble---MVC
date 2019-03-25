<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<%= Html.DevExpress().PopupControl(
                      settings =>
                       {
                            settings.Name = "popupControl";
                            settings.CallbackRouteValues = new { Controller = "AccountAdministration", Action = "ShowRightSnapshot" };
                            settings.Width = 900;
                            settings.Height = 700;
                            settings.AllowDragging = true;
                            settings.CloseAction = CloseAction.CloseButton;
                            settings.PopupAnimationType = AnimationType.None;
                            settings.HeaderText = "Document Image";
                            settings.Modal = true;
                            settings.SetContent(() =>
                            {
                                   ViewContext.Writer.Write("<img id='docImages' src='' alt='Some Text'  >");
                               
                            });

                            settings.PopupHorizontalAlign = PopupHorizontalAlign.WindowCenter;
                            settings.PopupVerticalAlign = PopupVerticalAlign.WindowCenter;
                           //settings.PopupHorizontalOffset = 200;
                          // settings.PopupVerticalOffset = 200;
                           // settings.AllowResize = true;
                            settings.ScrollBars = ScrollBars.Both;
                                                                
                           
     }).GetHtml() %>