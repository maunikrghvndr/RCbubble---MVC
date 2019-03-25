<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<%=  Html.DevExpress().GridView(
                    settings =>
                      {
                        settings.Name = "RolesList";
                        settings.CallbackRouteValues = new { Controller = "AccountAdministration", Action = "RoleRights" };
                        settings.ControlStyle.CssClass = "ClickClass";
                        settings.Width = 240;
                       
                        
                        if (Request.Url.AbsolutePath.Equals("/AccountAdministration/ManageRolesItsRights"))
                        {
                           // settings.Caption = "Roles  <a onclick='addClick();'>Add<a> <a onclick='editClick();'>Edit<a> <a onclick='deleteClick();'>Delete<a>" + Html.Action("RoleRights","AccountAdministration");
                            settings.CommandColumn.Visible = false;
                            settings.Settings.ShowColumnHeaders = true; // for hiding column headers
                            settings.Columns.Add(col =>
                            {
                                //setting.Caption = "test"; // don;t set column header 
                                col.FieldName = "RoleName";
                                settings.Styles.Row.Cursor = "pointer";
                                
                                col.SetHeaderCaptionTemplateContent(
                                   
                                    ht => {
                                         ViewContext.Writer.Write(
                                          "Role &nbsp; &nbsp; &nbsp; &nbsp;" +
                                         Html.ActionLink("Add", "ManageRoles")
                                         + " &nbsp; &nbsp; &nbsp; &nbsp; <a onclick='editClick();'>Edit<a> &nbsp; &nbsp; &nbsp; &nbsp; " +
                                          Html.ActionLink("Delete", "Delete")
                                          
                                         );}
                                         
                                    );
                                

                            });
                            
                            
                        }
                        else {
                            settings.Caption = "Roles";
                            settings.CommandColumn.Visible = true;
                            settings.Settings.ShowColumnHeaders = false; // for hiding column headers
                            settings.Columns.Add(col =>
                            {
                                //setting.Caption = "test"; // don;t set column header 
                                col.FieldName = "RoleName";
                                settings.Styles.Row.Cursor = "pointer";

                            });

                        }
                        
                          
                        settings.KeyFieldName = "RoleId";
                        //settings.CommandColumn.Visible = true;
                        settings.CommandColumn.ShowSelectCheckbox = true;
                       // settings.Styles.Row.Cursor = "pointer";
                        //settings.CommandColumn.Caption = "test1"; // don;t set column header 
                          
                        settings.ClientSideEvents.SelectionChanged = "SelectionChanged";
                        settings.ClientSideEvents.RowClick = "RowClick";
                      }).Bind(Model.RolesList).GetHtml()
 %>


