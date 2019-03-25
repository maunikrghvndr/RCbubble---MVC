<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<%= Html.DevExpress().PopupControl(
                      settings =>
                       {
                            settings.Name = "ApproveRejectPopup";
                           // settings.CallbackRouteValues = new { Controller = "AccountAdministration", Action = "ShowRightSnapshot" };
                            settings.Width = 300;
                            settings.Height = 150;
                            settings.AllowDragging = false;
                            //settings.CloseAction = CloseAction.None;
                            settings.ShowCloseButton = true;
                            settings.PopupAnimationType = AnimationType.Fade;

                            settings.Styles.Header.BackColor = System.Drawing.ColorTranslator.FromHtml("#595959");
                            settings.Styles.Header.ForeColor = System.Drawing.ColorTranslator.FromHtml("#FFFFFF");
                            settings.Styles.Header.Paddings.Padding = 5;
            
                         
                            settings.ShowHeader = true;
                       //     settings.HeaderText = "Update Review Status";
                            settings.Modal = true;

                            settings.PopupHorizontalAlign = PopupHorizontalAlign.WindowCenter;
                            settings.PopupVerticalAlign = PopupVerticalAlign.WindowCenter;

                            settings.SetHeaderTemplateContent(c =>
                            {

                                ViewContext.Writer.Write("<div class=\"cutomeHeaderPopup\">Update Review Status");
                                ViewContext.Writer.Write("<span class=\"moveRight dxc-close-position\">");
                                Html.DevExpress().Image(image =>
                                {
                                    image.Name = "TCNCloseImage";
                                    image.ImageUrl = Url.Content("~/Images/icons/closePopup.jpg");
                                    image.ControlStyle.Cursor = "pointer";

                                    image.Properties.EnableClientSideAPI = true;
                                    image.Properties.ClientSideEvents.Click = "function(s,e){  ApproveRejectPopup.Hide();  }";
                                }).Render();
                                ViewContext.Writer.Write("</span></div>");

                            });                    
                           
                           
                           
                           settings.SetContent(() =>
                            {
                                ViewContext.Writer.Write("<div class='viewerActionBtn  buttonDown'  >" +
                                     "<div class='floatLeft'>");

                                Html.DevExpress().Button( RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                                               settingsApprove =>
                                               {
                                                   settingsApprove.Name = "ApproveButton";
                                                   settingsApprove.Height = 32;
                                                   settingsApprove.Width = 83;
                                                   settingsApprove.ControlStyle.CssClass = "orangeBtn";
                                                   settingsApprove.UseSubmitBehavior = false;
                                                   settingsApprove.ClientSideEvents.Click = "function(s,e){  UpdateReviewStatus('1','1'); } ";
                                                   settingsApprove.Text = "Approve";
                                               })).GetHtml(); 
                                
                             ViewContext.Writer.Write("</div><div class='floatRight'>");
        
                               Html.DevExpress().Button(
                                   RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                                   settingsReject =>
                                   {
                                       settingsReject.Name = "RejectButton";
                                       settingsReject.Height = 32;
                                       settingsReject.Width = 83;
                                       settingsReject.ControlStyle.CssClass = "greyBtn";
                                       settingsReject.UseSubmitBehavior = false;
                                       //ViewData["sourceFlag"] == 1 Means its came from document pending for TSN screen
                                       settingsReject.ClientSideEvents.Click = "function(s,e){  UpdateReviewStatus('2','1');   } ";
                                       settingsReject.Text = "Reject";

                                   })).GetHtml();
                             ViewContext.Writer.Write("</div></div>");
                            
                            }); //Contents Ends 

                           
     }).GetHtml() %>