<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.eTAR.Model.AccountDetailsMain>" %>
<% Html.DevExpress().CallbackPanel(callSettings =>
   {
       callSettings.Name = "eNoteCallbackPanel";
       callSettings.CallbackRouteValues = new { Controller = "AccountDetails", Action = "eNoteCallbackPanel" };
       callSettings.Width = Unit.Percentage(100);
       callSettings.SetContent(() =>
       {
           ViewContext.Writer.Write("<div class='enoteTbl dxc-padding12Left'>");
           ViewContext.Writer.Write("<div class='enoteCont'>");
           if (ViewData["enoteID"] != null)
           {
               Model.enote.eNoteID = SpiegelDg.Common.Utilities.ConvertExtras.ToNullableInt64(ViewData["enoteID"]);
           }
           ViewContext.Writer.Write("<div>");
           ViewContext.Writer.Write(System.Web.Mvc.Html.InputExtensions.HiddenFor(Html, model => model.enote.eNoteID));
           ViewContext.Writer.Write(System.Web.Mvc.Html.InputExtensions.HiddenFor(Html, model => model.enote.ReplyToeNoteID));
           ViewContext.Writer.Write(System.Web.Mvc.Html.InputExtensions.HiddenFor(Html, model => model.DocumentID));
           ViewContext.Writer.Write("</div>");
           ViewContext.Writer.Write("<div class='recipentDays enote_recipient'>");
           ViewContext.Writer.Write("<div>");
           ViewContext.Writer.Write("<div class='floatLeft margin'>");
           ViewContext.Writer.Write("<span class='lightGeyText'>Organization Members</span>");
           ViewContext.Writer.Write("<div id='firstdropdown' class='enote_reply'>");
           ViewContext.Writer.Write(Html.DevExpress().DropDownEdit(
                DropDownSettings =>
                {
                    DropDownSettings.Name = "eNoteRecipients";
                    DropDownSettings.Width = Unit.Pixel(245);
                    DropDownSettings.ControlStyle.CssClass = "OrgNameSeachboxCls";

                    DropDownSettings.Properties.DropDownButton.Image.Url = @Url.Content("~/Images/icons/dropdown_button.png");
                    DropDownSettings.Properties.ButtonStyle.Border.BorderWidth = 0;
                    DropDownSettings.Properties.ButtonStyle.Paddings.Padding = 0;
                    DropDownSettings.Properties.ButtonStyle.CssClass = "dropdownButton";
                    
                    //To disable inpute entring.
                    DropDownSettings.Properties.ClientSideEvents.Init = "function(s, e) {s.GetInputElement().disabled = true; }";
                    
                    
                    DropDownSettings.SetDropDownWindowTemplateContent(c =>
                        {
                            Html.DevExpress().ListBox(listBoxSettings =>
                                {
                                    listBoxSettings.Name = "selectRecipients";
                                    listBoxSettings.Width = Unit.Percentage(95);
                                    
                                    listBoxSettings.ControlStyle.Border.BorderWidth = 0;
                                    listBoxSettings.ControlStyle.BorderBottom.BorderColor = System.Drawing.Color.FromArgb(0xDCDCDC);
                                    
                                    listBoxSettings.Properties.SelectionMode = ListEditSelectionMode.CheckColumn;
                                    
                                    listBoxSettings.Properties.ItemStyle.Border.BorderWidth = 1;
                                    listBoxSettings.Properties.ItemStyle.Border.BorderStyle = System.Web.UI.WebControls.BorderStyle.Solid;
                                    listBoxSettings.Properties.ItemStyle.Border.BorderColor = System.Drawing.Color.LightGray;
                                  
                                    listBoxSettings.Properties.ValueField = "Value";
                                    listBoxSettings.Properties.ValueType = typeof(int);
                                    listBoxSettings.Properties.TextField = "Text";
                                    listBoxSettings.Properties.ClientSideEvents.SelectedIndexChanged = "OnRecipientsSelectionChanged";
                                    listBoxSettings.ControlStyle.CssClass = "OrgNameSeachboxCls";

                                  
                                }).BindList(ViewData["SenderUserList"]).Render();
                        });
                    DropDownSettings.Properties.ClientSideEvents.TextChanged = "SynchronizeListBoxValues";
                    DropDownSettings.Properties.ClientSideEvents.DropDown = "SynchronizeListBoxValues";
                }).GetHtml());
           ViewContext.Writer.Write("</div>");
           ViewContext.Writer.Write("</div>");
           if (Model.IsProviderEtar_LoggedInUser)
           {
               ViewContext.Writer.Write("<div class='floatLeft margin'>");
               ViewContext.Writer.Write("<span class='lightGeyText'>Reviewer & Senders Org.Members</span>");
               ViewContext.Writer.Write("<div id='secondDropdown' class='enote_reply'>");
               ViewContext.Writer.Write(Html.DevExpress().DropDownEdit(
                    DropDownSettings =>
                    {
                        DropDownSettings.Name = "eNoteReviewer";
                        DropDownSettings.Width = Unit.Pixel(245);
                        DropDownSettings.ControlStyle.CssClass = "OrgNameSeachboxCls";

                        DropDownSettings.Properties.DropDownButton.Image.Url = Url.Content("~/Images/icons/dropdown_button.png");
                        DropDownSettings.Properties.ButtonStyle.Border.BorderWidth = 0;
                        DropDownSettings.Properties.ButtonStyle.Paddings.Padding = 0;
                        DropDownSettings.Properties.ButtonStyle.CssClass = "dropdownButton";

                        //To disable inpute entring.
                        DropDownSettings.Properties.ClientSideEvents.Init = "function(s, e) {s.GetInputElement().disabled = true; }";
                    
                        
                        DropDownSettings.SetDropDownWindowTemplateContent(c =>
                            {
                                Html.DevExpress().ListBox(listBoxSettings =>
                                    {
                                        listBoxSettings.Name = "selectReviewers";
                                        listBoxSettings.ControlStyle.Border.BorderWidth = 0;
                                        //listBoxSettings.ControlStyle.BorderBottom.BorderWidth = 1;
                                        listBoxSettings.ControlStyle.BorderBottom.BorderColor = System.Drawing.Color.FromArgb(0xDCDCDC);
                                        listBoxSettings.Properties.SelectionMode = ListEditSelectionMode.CheckColumn;
                                        listBoxSettings.Properties.ItemStyle.Border.BorderWidth = 1;
                                        listBoxSettings.Properties.ItemStyle.Border.BorderStyle = System.Web.UI.WebControls.BorderStyle.Solid;
                                        listBoxSettings.Properties.ItemStyle.Border.BorderColor = System.Drawing.Color.LightGray;
                                        listBoxSettings.Width = Unit.Percentage(100);
                                        listBoxSettings.Properties.ValueField = "Value";
                                        listBoxSettings.Properties.ValueType = typeof(int);
                                        listBoxSettings.Properties.TextField = "Text";
                                        listBoxSettings.Properties.ClientSideEvents.SelectedIndexChanged = "OnReviewerSelectionChanged";
                                        listBoxSettings.ControlStyle.CssClass = "OrgNameSeachboxCls";
                                    }).BindList(ViewData["SenderMemnerAndReviewer"]).Render();
                            });
                        DropDownSettings.Properties.ClientSideEvents.TextChanged = "SynchronizeListBoxValuesReviewer";
                        DropDownSettings.Properties.ClientSideEvents.DropDown = "SynchronizeListBoxValuesReviewer";
                    }).GetHtml());
               // Html.RenderPartial("ENoteResponsibleMemberReviewer", Model);
               ViewContext.Writer.Write("</div>");
               ViewContext.Writer.Write("</div>");
           }
           ViewContext.Writer.Write("<div class='floatLeft'>");
           ViewContext.Writer.Write("<span class='lightGeyText'>Require Response within  </span>");
           ViewContext.Writer.Write("<div class='ResponseDays'>");
           ViewContext.Writer.Write("<div class='floatLeft enote_reply'>");
           ViewContext.Writer.Write(Html.DevExpress().SpinEdit(
               settings =>
               {
                   settings.Name = "responseDays";
                   settings.Properties.MinValue = 1;
                   settings.Properties.MaxValue = 60;
                   settings.Number = 1; //defualt value of control
                   settings.Properties.NumberType = SpinEditNumberType.Integer;
                   settings.Width = Unit.Pixel(130);
                   settings.Properties.ButtonStyle.CssClass = "spinBtn";
                   settings.Properties.ButtonStyle.PressedStyle.BackColor = System.Drawing.ColorTranslator.FromHtml("#FF6600");

                   settings.Properties.SpinButtons.IncrementImage.Url = Url.Content("~/Images/icons/dropdownUp_button.png");
                  // settings.Properties.SpinButtons.IncrementImage
                       
                   settings.Properties.SpinButtons.DecrementImage.Url = Url.Content("~/Images/icons/dropdown_button.png");
                   
               }
           ).GetHtml());
           ViewContext.Writer.Write("</div>");
           ViewContext.Writer.Write("<div class='floatRight adjustPadding enote_reply'>Day(s)</div>");
           ViewContext.Writer.Write("</div>");
           ViewContext.Writer.Write("</div>");
           ViewContext.Writer.Write("</div>");
           ViewContext.Writer.Write("</div>");
           ViewContext.Writer.Write("<div class='clear FixiedHT12'></div>");
           ViewContext.Writer.Write("<div class='enoteTbl'>");
           ViewContext.Writer.Write("<div class='floatLeft interMemo'>");
           ViewContext.Writer.Write(Html.DevExpress().Memo(
                textarea =>
                {
                    textarea.Name = "eNote";
                    textarea.Width = Unit.Percentage(100);
                    textarea.Height = 28;
                }).GetHtml());
           ViewContext.Writer.Write("</div>");
           ViewContext.Writer.Write("<div class='floatRight'>");
           ViewContext.Writer.Write(Html.DevExpress().Button(
                AddButton =>
                {
                    AddButton.Name = "eNoteAddButton";
                    AddButton.ControlStyle.HorizontalAlign = HorizontalAlign.Center;
                    AddButton.Width = Unit.Pixel(70);
                    AddButton.Height = 28;
                    AddButton.Text = "Add";
                    AddButton.ControlStyle.CssClass = "greyBtn";
                    AddButton.ClientSideEvents.Click = "AddeNote";
                }).GetHtml());
           ViewContext.Writer.Write("</div>");
           ViewContext.Writer.Write("</div>");
           ViewContext.Writer.Write("<div class='clear FixiedHT12'></div>");
         
           ViewContext.Writer.Write("</div>");
           ViewContext.Writer.Write("</div>");

           ViewContext.Writer.Write("<div class='activeScroll'>");
           System.Web.Mvc.Html.ChildActionExtensions.RenderAction(Html, "eNotesCallbackMethod", "AccountDetails", new RouteValueDictionary { { "PopUpEnoteFlag", false }, { "enote.eNoteID", Model.enote.eNoteID }, { "enote.DocumentID", Model.DocumentID } });
           ViewContext.Writer.Write("</div>");
       });
   }).Render(); %>