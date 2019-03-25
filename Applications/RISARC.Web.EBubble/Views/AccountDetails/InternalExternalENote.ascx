<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.eTAR.Model.AccountDetailsMain>" %>

<%  Html.DevExpress().PageControl(
        NoteTabs =>
        {
            NoteTabs.Name = "NoteTabs";
            NoteTabs.ControlStyle.CssClass = "dvc-PaneBgcolor";
            NoteTabs.Width = Unit.Percentage(100);
            NoteTabs.CallbackRouteValues = new { Controller = "AccountDetails", Action = "InternalExternalENote", TCNIdentificationID = Model.TCNIdentificationID, SenderProviderID = Model.SenderProviderID, AccountSubmissionDetailsID = Model.AccountSubmissionDetailsID, DocumentID = Model.DocumentID, HasExternalNoteAccess = Model.HasExternalNoteAccess, IsProviderEtar_LoggedInUser = Model.IsProviderEtar_LoggedInUser, AccountNo = Model.AccountNo, TCNNo = Model.TCNNo, eNoteID = Model.enote.eNoteID };
            NoteTabs.ClientSideEvents.BeginCallback = "NoteTabs_BeginCallback";
            //Tabs control loading panel 
            NoteTabs.LoadingPanelText = " ";
            NoteTabs.Images.LoadingPanel.Url = Url.Content("~/Images/icons/LoadingLogo.gif");
            NoteTabs.Images.LoadingPanel.Width = 76;
            NoteTabs.Images.LoadingPanel.Height = 100;  
            
            //To increse tab height 
            NoteTabs.Styles.Tab.Height = 30;
            NoteTabs.Height = 311;
           
            
            NoteTabs.ControlStyle.Paddings.Padding = 0;

                NoteTabs.Styles.ActiveTab.BackColor = System.Drawing.ColorTranslator.FromHtml("#ececec");
                NoteTabs.Styles.ActiveTab.CssClass = "TabActive";

                NoteTabs.Styles.Tab.VerticalAlign = VerticalAlign.Middle;
            
                NoteTabs.Styles.ActiveTab.BorderTop.BorderColor = System.Drawing.ColorTranslator.FromHtml("#ff6600");
                NoteTabs.Styles.ActiveTab.BorderTop.BorderWidth = 2;   
           
                NoteTabs.Styles.ActiveTab.BorderBottom.BorderWidth = 0;
                NoteTabs.Styles.SpaceAfterTabsTemplate.Paddings.Padding = 0;

                NoteTabs.Styles.Content.BackColor = System.Drawing.ColorTranslator.FromHtml("#ececec");
                NoteTabs.Styles.Content.BorderRight.BorderStyle = BorderStyle.None;
                
            
            if (Model != null && Model.NoteTabs != null)
            {
                foreach (var item in Model.NoteTabs)
                {
                    NoteTabs.TabPages.Add(tabsettings =>
                    {
                        tabsettings.Text = item.TabText;
                        tabsettings.Name = item.TabName;
                      
                        tabsettings.SetContent(() =>
                        {
                            if (item.IsRenderAction)
                            {
                                System.Web.Mvc.Html.ChildActionExtensions.RenderAction(Html, item.ActionMethodName, item.ControllerName, item.RoutDirectoryData);
                            }
                            else if (item.IsPartialView)
                            {
                                System.Web.Mvc.Html.RenderPartialExtensions.RenderPartial(Html, item.PartialViewName, item.PartialViewModel);
                            }
                        });
                        if (item.SelectedPageIndex != null)
                        {
                            NoteTabs.ActiveTabIndex = (int)item.SelectedPageIndex;
                        }
                    });
                }
            }
        }).GetHtml(); %>