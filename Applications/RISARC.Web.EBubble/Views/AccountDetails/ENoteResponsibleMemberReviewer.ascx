<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.eTAR.Model.AccountDetailsMain>" %>
 <%  Html.DevExpress().CallbackPanel(
                    settings =>
                    {
                        settings.Name = "cbpENoteReviewer";
                        settings.CallbackRouteValues = new { Controller = "AccountDetails", Action = "EnoteResponsibleMemberReviewer", documentId = Model.DocumentID };
                        settings.Width = Unit.Percentage(100);
                        settings.Height = 400;

                        settings.SetContent(() =>
                        {
                            Html.DevExpress().DropDownEdit(
                                    DropDownSettings =>
                                    {
                                        DropDownSettings.Name = "eNoteReviewer";
                                        DropDownSettings.Width = Unit.Pixel(245);
                                        DropDownSettings.ControlStyle.CssClass = "OrgNameSeachboxCls";
                                        //DropDownSettings.Properties.DropDownStyle = DropDownStyle.DropDownList;
                                        
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
                                    }).GetHtml();
                        });

                        //settings.ClientSideEvents.BeginCallback = "OnBeginCallback";
                        //settings.ClientSideEvents.EndCallback = "OnEndCallback";
                    }
).GetHtml();
                %>