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
                        //    settings.HeaderText = "Rights Documents snapshot";
                            settings.Modal = true;


                            settings.Styles.Header.BackColor = System.Drawing.ColorTranslator.FromHtml("#595959");
                            settings.Styles.Header.ForeColor = System.Drawing.ColorTranslator.FromHtml("#FFFFFF");
                            settings.Styles.Header.Paddings.Padding = 5;

                            settings.SetHeaderTemplateContent(c =>
                            {

                                ViewContext.Writer.Write("<div class=\"cutomeHeaderPopup\">Rights Documents snapshot");
                                ViewContext.Writer.Write("<span class=\"moveRight dxc-close-position\">");
                                Html.DevExpress().Image(image =>
                                {
                                    image.Name = "TCNCloseImage";
                                    image.ImageUrl = Url.Content("~/Images/icons/closePopup.jpg");
                                    image.ControlStyle.Cursor = "pointer";
                                    image.Width = 29;
                                    image.Height = 29;
                                    image.Properties.EnableClientSideAPI = true;
                                    image.Properties.ClientSideEvents.Click = "function(s,e){  popupControl.Hide();  }";
                                }).Render();
                                ViewContext.Writer.Write("</span></div>");

                            });
                           
                            settings.SetContent(() =>
                            {
                                   ViewContext.Writer.Write("<img id='docImages' src='' alt='Image not Found'  >");
                            });

                            settings.PopupHorizontalAlign = PopupHorizontalAlign.WindowCenter;
                            settings.PopupVerticalAlign = PopupVerticalAlign.WindowCenter;
                            settings.ScrollBars = ScrollBars.Both;
                           
     }).GetHtml() %>