<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<%=  Html.DevExpress().GridView(
                    settings =>
                      {
                        settings.Name = "RolesList";
                        settings.Width = 350;  
                        settings.KeyFieldName = "RoleId";
                        settings.SettingsPager.Mode = GridViewPagerMode.ShowAllRecords;
                        //for vartical scroll
                        settings.Settings.VerticalScrollBarMode = ScrollBarMode.Auto;
                        settings.Settings.VerticalScrollableHeight = 555;
                          
                        //========== Grid View Resizing Column Header of Grid View ===========
                     //   settings.SettingsBehavior.ColumnResizeMode = ColumnResizeMode.Control; 
                        //==================== Changing Grid Loading Icons ===================
                        settings.Images.LoadingPanel.Url = Url.Content("~/Images/icons/LoadingLogo.gif");
                        settings.SettingsLoadingPanel.Text = " ";       
                        settings.Images.LoadingPanel.Width = 76;
                        settings.Images.LoadingPanel.Height = 100;       
                          
                        //=================== Incresing Row Height =============================
                            settings.Styles.Cell.VerticalAlign = VerticalAlign.Middle;
                            settings.Styles.Cell.Paddings.PaddingTop = Unit.Pixel(14);
                            settings.Styles.Cell.Paddings.PaddingBottom = Unit.Pixel(14);                              
                        //+ ends  

                          
                            //Below settings for removeing effect of selected checkbox row selection 
                            //========================= Check box row selection nulify by settings ==============
                            settings.Styles.SelectedRow.BackColor = System.Drawing.ColorTranslator.FromHtml("#ffffff");
                            settings.Styles.SelectedRow.ForeColor = System.Drawing.Color.Black;
                            // ends 
                            
                            //Setting All Rowes background color 
                            settings.Styles.Table.BackColor = System.Drawing.ColorTranslator.FromHtml("#eaeaea");
                           
                          
                            settings.Styles.Header.BackColor = System.Drawing.ColorTranslator.FromHtml("#d4ecee");
                            settings.Styles.Header.CssClass = "gvworklistHeader";

                          settings.CallbackRouteValues = new { Controller = "AccountAdministration", Action = "Roles", Id = Request.Params["id"] };
                          
                        if (Request.Url.AbsolutePath.Contains("/AccountAdministration/ManageRoles"))
                        {
                            settings.SettingsBehavior.AllowSelectByRowClick = true;
                            settings.Styles.Row.Cursor = "pointer";
                            settings.CommandColumn.Visible = false;
                            settings.Settings.ShowColumnHeaders = true; // for hiding column headers

                            settings.Columns.Add(col =>
                            {
                                col.FieldName = "RoleName";
                                col.HeaderStyle.CssClass = "CustRolesHeader";

            col.CellStyle.BorderRight.BorderWidth = 0;
                                
                                col.Settings.AllowSort = DefaultBoolean.False; //It stops header filltering
                                
                                col.SetHeaderTemplateContent(ht =>
                                {
                                    ViewContext.Writer.Write(
                                     "<div><span class='floatLeft'>Role</span> <span class='floatRight spaceRight'> &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;" +
                Html.ActionLink("Add", "AddEditRole", "", new { @class = "clsLoader" })
                                    + " &nbsp;&nbsp;"
                                    );
                                    
                                    Html.DevExpress().HyperLink(s =>
                                    {
                                        s.Name = "lnkEdit";
                                      
                                        s.NavigateUrl = "#";
                                        s.Properties.Text = "Edit";
                                        s.Properties.ClientSideEvents.Click = "function(s,e){ editClick(s,e);}";
                                    }).GetHtml();

                                    ViewContext.Writer.Write("&nbsp;&nbsp;");

                                    Html.DevExpress().HyperLink(s =>
                                    {
                                        s.Name = "lnkDelete";
                                        s.NavigateUrl = "#";
                                        s.Properties.Text = "Delete";
                                        //s.ControlStyle.CssClass = "clsLoader";
                                        s.Properties.ClientSideEvents.Click = "function(s,e){ deleteClick();}";
                                    }).GetHtml();

                                    ViewContext.Writer.Write("</span></div>");
                                });

                                /// <RevisionHistory>
                                /// Date       | Owner       | Particulars
                                /// ----------------------------------------------------------------------------------------
                                /// 02/17/2014 | Surekha   | Created
                                /// This block code is changed
                                /// </RevisionHistory>

                                col.CellStyle.CssClass = "RightArrow";  //added comman class 
                                
                                settings.HtmlDataCellPrepared = (sender, e) =>
                                {
                                    string cellId = "cell_" + e.VisibleIndex;
                                    //added Id attribute to cell 
                                    e.Cell.Attributes.Add(
                                       "Id",
                                       "cell_" + e.VisibleIndex
                                       );
                                    e.Cell.Attributes.Add(
                                             "onclick",
                                             string.Format("OnCellClick('{0}','{1}');", cellId, e.VisibleIndex)
                                           );
                                };// cell dataprepared Ends

                                /// 02/17/2014 | Surekha   | Created
                                /// This block code is changed
            /// For Setting first Roles always should be selected.

                                //=================== For Setting User Role Selected By defult & its Rights ====================
                                settings.PreRender = (sender, e) =>
                                {
                                    ASPxGridView gridView = (ASPxGridView)sender;
                                     gridView.ClientSideEvents.Init = "function(s,e){ GetDefaultUserRoleId(s.GetRowKey(" + 0 + "));  s.SelectRow(" + 0 + ",true);}";
                                };

                            });
                        //if ends                             
    }
    else
    {
                            
                        // settings.Settings.ShowColumnHeaders = false; // for hiding column headers
                            settings.Styles.Row.Cursor = "pointer";
                            settings.ControlStyle.CssClass = "ClickClass";
                            settings.CommandColumn.Visible = true;
                            settings.CommandColumn.ShowSelectCheckbox = true;
                            settings.CommandColumn.Width = 25;
                            settings.CommandColumn.Caption = " ";

                            //******* IF User Is Addinfg Then Show User Role Selected Else Show its assigned Roles ******
                           // settings.Columns.Add(Model.RolesList.IsAssigned);

                            var EditUserRolesID = Request.Params["Id"];
                            if (EditUserRolesID != null) //Show all Ready Assigned roles
                            {
                                //by defult show Assigned Roles selected. 
                                settings.PreRender = (sender, e) =>
                                {
                                    ASPxGridView gridView = (ASPxGridView)sender;
                                    for (int i = 0; i < gridView.VisibleRowCount; i++)
                                    {
                                        //Show Defult Rights of First Role Selected.
                                        gridView.ClientSideEvents.Init = "function(s,e){ GetDefaultUserRoleId(s.GetRowKey(" + 0 + ")); s.SetFocusedRowIndex(" + 0 + "); }";
                                        //Show Assigned Rows Selected.
                                        Boolean isAssigned = Convert.ToBoolean(gridView.GetRowValues(i, "IsAssigned"));
                                        if (isAssigned)
                                        {
                                            gridView.Selection.SetSelection(i, true);
                                        }
                                        
                                    }
                                };

                            }
                            else
                            { //Use Is adding 
                                //=================== For Setting User Role Selected By defult & its Rights ====================
                                settings.PreRender = (sender, e) =>
                                {
                                    ASPxGridView gridView = (ASPxGridView)sender;
                                    for (int i = 0; i < gridView.VisibleRowCount; i++)
                                    {
                                        //Show Defult Rights of First Role Selected.
                                        gridView.ClientSideEvents.Init = "function(s,e){ GetDefaultUserRoleId(s.GetRowKey(" + 0 + ")); s.SetFocusedRowIndex(" + 0 + "); }";
                                        //gridView.Selection.SetSelection(0, true);
                                        
                                        string roleName = Convert.ToString(gridView.GetRowValues(i, "RoleName"));
                                        if (roleName.Equals(RISARC.Common.ConstantManager.StoredProcedureConstants.User))
                                        {
                                            gridView.Selection.SetSelection(i, true);
                                        }
                                        
                                        
                                    }
                                };

                            }

        settings.Columns.Add(col =>
        {
                                col.FieldName = "RoleName";
                                col.CellStyle.CssClass = "RightArrow";
                                col.Caption = "Roles";
                                //added comman class 
                                settings.HtmlDataCellPrepared = (sender, e) =>
                                {   
                                    string cellId = "cell_" + e.VisibleIndex;
                                    //added Id attribute to cell 
                                     e.Cell.Attributes.Add(
                                        "Id",
                                        "cell_" + e.VisibleIndex
                                        );
                                       e.Cell.Attributes.Add(
                                                "onclick",
                                                string.Format("OnCellClick('{0}','{1}');", cellId, e.VisibleIndex)
                                              );
                                };// cell dataprepared Ends
                            
                            });


                        }//end else
                          
                        settings.ClientSideEvents.SelectionChanged = "SelectionChanged";
                        settings.ClientSideEvents.RowClick = "RowClick";
                        //Disable default role check box
                        settings.CommandButtonInitialize = (s, e) =>
                        {
                            MVCxGridView grid = s as MVCxGridView;
                            if (e.ButtonType.Equals(ColumnCommandButtonType.SelectCheckbox))
                            {
                                var roleName = grid.GetRowValues(e.VisibleIndex, "RoleName");
                                var AccessType = grid.GetRowValues(e.VisibleIndex, "AccessType");

                                e.Enabled = !roleName.Equals(RISARC.Common.ConstantManager.StoredProcedureConstants.User); // User Disable for superadmin
                                //Condiction should not disable for superadmin 
                                if (!Convert.ToBoolean(ViewData["IsSuperAdmin"]))
                                {
                                    //Disable for protected & User
                                 
                                    if (AccessType != null || roleName != null)
                                    {
                                        string accessValue = Enum.GetName(AccessType.GetType(), AccessType);
                                        e.Enabled = ((!accessValue.Equals("Protected")) && (!roleName.Equals(RISARC.Common.ConstantManager.StoredProcedureConstants.User)));
                                    }
                                }
                               
                            }
                        };
                          
                          
                      }).Bind(Model.RolesList).GetHtml()
%>


