<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>


<%= Html.DevExpress().PopupControl(settings =>
                       {
                            settings.Name = "releaseFile";
                            
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
                          //  settings.PopupElementID = "btnSave";
                          //  settings.HeaderText = "Confirm to Add Responsible Members";

                          //settings.ControlStyle
                           settings.Styles.Header.BackColor = System.Drawing.ColorTranslator.FromHtml("#595959");
                           settings.Styles.Header.ForeColor = System.Drawing.ColorTranslator.FromHtml("#fff");
                           settings.Modal = true;

                           settings.SetHeaderTemplateContent(c =>
                           {

                               ViewContext.Writer.Write("<div class=\"cutomeHeaderPopup\">Release File Required");
                               ViewContext.Writer.Write("<span class=\"moveRight dxc-close-position\">");
                               Html.DevExpress().Image(image =>
                               {
                                   image.Name = "TCNCloseImage";
                                   image.ImageUrl = Url.Content("~/Images/icons/closePopup.png");
                                   image.ControlStyle.Cursor = "pointer";

                                   image.Properties.EnableClientSideAPI = true;
                                   image.Properties.ClientSideEvents.Click = "function(s,e){  releaseFile.Hide();  }";
                               }).Render();
                               ViewContext.Writer.Write("</span></div>");

                           });                    
                           
                           
                            settings.SetContent(() =>
                            {

                                 ViewContext.Writer.Write("<div class='responsibleMemb gery_text'> <span>  You have selected \"No\", a release form is required to have on file before releasing information.");
                                 ViewContext.Writer.Write(" Please verify a copy on file through your organization to proceed.</span>");
                                 ViewContext.Writer.Write("<ul id=\"lstResponsibleMembers\"> </ul>");
                                 ViewContext.Writer.Write("<div>");
                                ViewContext.Writer.Write("<span>");
                                Html.DevExpress().Button(
                                          RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                                  settingsb =>
                                  {
                                      settingsb.Width = 40;
                                      settingsb.Name = "goBackUploadReleaseFile";
                                      settingsb.UseSubmitBehavior = true;
                                      settingsb.ControlStyle.CssClass = "orangeBtn margin";
                                      settingsb.Text = "Go Back to Upload Release File";
                                      settingsb.RouteValues = new { Controller = "ProviderAdmin", Action = "EditProviderConfiguration" };
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
                                                settingsb.Text = "Close";
                                                settingsb.ClientSideEvents.Click = "function(s, e) { releaseFile.Hide();}";

                                            })).GetHtml();
                                ViewContext.Writer.Write("</span></div></div>");
                               
                            });
                               
                           
     }).GetHtml() %>
