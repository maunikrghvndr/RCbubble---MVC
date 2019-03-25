<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<%= Html.DevExpress().PopupControl(settings =>
                       {
                            settings.Name = "adminSavePopup";
                            
                            settings.Width = 500;
                            settings.MinHeight = 100;
                            
                           settings.AllowDragging = true;

                           settings.ShowCloseButton = true;
                           
                            settings.PopupHorizontalAlign = PopupHorizontalAlign.WindowCenter;
                            settings.PopupVerticalAlign = PopupVerticalAlign.WindowCenter;

                            settings.Styles.Header.BackColor = System.Drawing.ColorTranslator.FromHtml("#595959");
                            settings.Styles.Header.ForeColor = System.Drawing.ColorTranslator.FromHtml("#FFFFFF");
                            settings.Styles.Header.Paddings.Padding = 5;
            
                           
                           settings.CloseAction = CloseAction.CloseButton;
                            settings.PopupAnimationType = AnimationType.Fade;
                            settings.ShowCloseButton = true;
                         
                          //settings.ControlStyle
                           settings.Styles.Header.BackColor = System.Drawing.ColorTranslator.FromHtml("#595959");
                           settings.Styles.Header.ForeColor = System.Drawing.ColorTranslator.FromHtml("#fff");
                           settings.Modal = true;

                           settings.SetHeaderTemplateContent(c =>
                           {

                               ViewContext.Writer.Write("<div class=\"cutomeHeaderPopup\">Confirm to Add Responsible Members");
                               ViewContext.Writer.Write("<span class=\"moveRight dxc-close-position\">");
                               Html.DevExpress().Image(image =>
                               {
                                   image.Name = "TCNCloseImage";
                                   image.ImageUrl = Url.Content("~/Images/icons/closePopup.jpg");
                                   image.ControlStyle.Cursor = "pointer";
                                   image.Width = 29;
                                   image.Height = 29;
                                   image.Properties.EnableClientSideAPI = true;
                                   image.Properties.ClientSideEvents.Click = "function(s,e){  adminSavePopup.Hide();  }";
                               }).Render();
                               ViewContext.Writer.Write("</span></div>");

                           });                    
                           
                           
                            settings.SetContent(() =>
                            {

                                ViewContext.Writer.Write("<div class='responsibleMemb gery_text'> <span> Please confirm if the selected members should be marked as responsible to view and response to the mail send from receivers.</span>");
                                ViewContext.Writer.Write("<ul id=\"lstResponsibleMembers\"> </ul>");
                                ViewContext.Writer.Write("<div>");
                                ViewContext.Writer.Write("<span>");
                                Html.DevExpress().Button(
                                          RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                                  settingsb =>
                                  {
                                      settingsb.Width = 40;
                                      settingsb.Name = "btnSavePopUp";
                                      settingsb.UseSubmitBehavior = true;
                                      settingsb.ControlStyle.CssClass = "orangeBtn margin";
                                      settingsb.Text = "Confirm";
                                      settingsb.ClientSideEvents.Click = "function(s, e) {Confirm();}";

                                  })).GetHtml();
                                ViewContext.Writer.Write("</span><span>");
                                
                                Html.DevExpress().Button(
                                            RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                                            settingsb =>
                                            {
                                                settingsb.Width = 40;
                                                settingsb.Name = "btnCancelPopUp";
                                                settingsb.ControlStyle.CssClass = "greyBtn";
                                                settingsb.UseSubmitBehavior = false;
                                                settingsb.Text = "Cancel";
                                                settingsb.ClientSideEvents.Click = "function(s, e) {popUpCancel();}";

                                            })).GetHtml();
                                ViewContext.Writer.Write("</span></div></div>");
                               
                            });
                               
                           
     }).GetHtml() %>
