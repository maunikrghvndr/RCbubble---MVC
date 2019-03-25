<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IEnumerable<RISARC.Membership.Model.RMSeBubbleMembershipUser>>" %>


<%= Html.DevExpress().GridView(settings =>
   {
       settings.Name = "UserAdminTableGrid";
       settings.KeyFieldName = "UserName";
       settings.CallbackRouteValues = new { Controller = "AccountAdministration", Action = "UserAdminTableGrid" };
      
    //========== Grid View Resizing Column Header of Grid View ===========
    settings.SettingsBehavior.ColumnResizeMode = ColumnResizeMode.Control;
    //==================== Changing Grid Loading Icons ===================
    settings.Images.LoadingPanel.Url = Url.Content("~/Images/icons/LoadingLogo.gif");
    settings.Images.LoadingPanel.Width = 76;
    settings.Images.LoadingPanel.Height = 100;   
    settings.SettingsLoadingPanel.Text = " ";
    settings.Styles.FilterCell.CssClass = "fillterCell"; 
    settings.Width = Unit.Percentage(100);
       
    //Alterring color
    settings.Styles.AlternatingRow.BackColor = System.Drawing.ColorTranslator.FromHtml("#f7f7f7");
    settings.Styles.Header.BackColor = System.Drawing.ColorTranslator.FromHtml("#e3f3f4");
    settings.Styles.Header.CssClass = "gvworklistHeader";

    settings.Styles.HeaderFilterItem.Height = 50;
       
        
    //=================== Incresing Row Height =============================
    settings.Styles.Cell.VerticalAlign = VerticalAlign.Middle;
    settings.Styles.Cell.Paddings.PaddingTop = Unit.Pixel(14);
    settings.Styles.Cell.Paddings.PaddingBottom = Unit.Pixel(14);                              
   //+ ends     

    settings.Settings.ShowFilterRow = true;
   
    settings.Settings.HorizontalScrollBarMode = ScrollBarMode.Visible;
     settings.Settings.VerticalScrollBarMode = ScrollBarMode.Visible;
     settings.Settings.VerticalScrollableHeight = 580;

     settings.Styles.Table.ForeColor = System.Drawing.ColorTranslator.FromHtml("#707070");
    // settings.SettingsPager.PageSize = 2;

     settings.SettingsPager.Mode = GridViewPagerMode.ShowAllRecords;

     settings.Styles.SelectedRow.BackColor = System.Drawing.ColorTranslator.FromHtml("#ffffff");
      settings.Styles.SelectedRow.ForeColor = System.Drawing.ColorTranslator.FromHtml("#707070");



          settings.Columns.Add(commandCol2 =>
          {


              if (Request.Url.AbsolutePath.Contains("/AccountAdministration/FindUserByUserName"))
              {
                  commandCol2.Visible = false; } else { 
                  commandCol2.Visible = true; }
                  
              
              commandCol2.Width = 120;
              commandCol2.Settings.AllowAutoFilter = DefaultBoolean.False;
              commandCol2.Name = "RespMembers";
              commandCol2.FieldName = "IsResponsible";
             // commandCol2.Caption = "Responsible Members";
              commandCol2.HeaderStyle.Cursor = "pointer";
              commandCol2.CellStyle.HorizontalAlign = System.Web.UI.WebControls.HorizontalAlign.Center;
              commandCol2.HeaderStyle.Wrap = DefaultBoolean.True;
              commandCol2.ToolTip = " Responsible Members have the right to  \r\n view and respond to transactions sent \r\n by reviewers";
         
              commandCol2.HeaderStyle.CssClass = "setTooltipIcon";

            
              
              commandCol2.SetDataItemTemplateContent(c =>
              {
                  Html.DevExpress().CheckBox(settingsCom =>
                  {
                      settingsCom.Name = "RespMemCheckbox" + c.VisibleIndex;
                      settingsCom.Properties.ClientSideEvents.CheckedChanged = "ResponsibleMemberCheck";
                      

                      bool IsLockedOut = Convert.ToBoolean(DataBinder.Eval(c.DataItem, "IsLockedOut"));
                      bool IsOnline = Convert.ToBoolean(DataBinder.Eval(c.DataItem, "IsOnline"));
                      bool IsApproved = Convert.ToBoolean(DataBinder.Eval(c.DataItem, "IsApproved"));
                      bool isPasswordIsExpired = Convert.ToBoolean(DataBinder.Eval(c.DataItem, "MemberRegistrationStatus.PasswordIsExpired"));
                      bool isRequiresEmailConfirmation = Convert.ToBoolean(DataBinder.Eval(c.DataItem, "MemberRegistrationStatus.RequiresEmailConfirmation"));
                      bool isRequiresFullRegistration = Convert.ToBoolean(DataBinder.Eval(c.DataItem, "MemberRegistrationStatus.RequiresFullRegistration"));

                      String UserName = Convert.ToString(DataBinder.Eval(c.DataItem, "UserName"));
                      
                      if (IsLockedOut || !IsApproved || isPasswordIsExpired || isRequiresEmailConfirmation || isRequiresFullRegistration)
                      {
                          settingsCom.ClientEnabled = false;
                      }

                      settingsCom.CustomJSProperties = (s, e) =>
                      {
                         // e.Properties["cpRowIndex"] = c.VisibleIndex;
                          e.Properties["cpRowIndex"] = UserName;
                          
                      };

                      
                      bool IsResponsible = Convert.ToBoolean(DataBinder.Eval(c.DataItem, "IsResponsible"));
                    
                      if (IsResponsible)
                      {
                          settingsCom.Checked = true;
                      }
                      
                      settingsCom.Properties.ClientSideEvents.Init = "CollectAllRespMember";
                      
                      
                  }).Render();
              });

          });


          settings.Columns.Add(column =>
          {

              if (Request.Url.AbsolutePath.Contains("/AccountAdministration/FindUserByUserName")) { 
                  column.Visible = false; } else {
                  column.Visible = true; }
              column.Settings.AllowAutoFilter = DefaultBoolean.False;
              column.CellStyle.HorizontalAlign = System.Web.UI.WebControls.HorizontalAlign.Center;
              column.Width = 135;
           //   column.Visible = true;
              column.Name = "AccessExtNote";
              column.FieldName = "HasExternalNoteAccess";
           //   column.Caption = "Access External Notes";
              column.HeaderStyle.CssClass = "setTooltipIcon";
              column.ToolTip = "Enable respective user as to grant acess for\r\n External notes facility.";
              column.HeaderStyle.Wrap = DefaultBoolean.True;

              
              column.SetDataItemTemplateContent(c =>
              {
                  Html.DevExpress().CheckBox(settingsCom =>
                  {
                      settingsCom.Name = "AccessExtNote" + c.VisibleIndex;
                      settingsCom.Properties.ClientSideEvents.CheckedChanged = "GiveExternalNoteAcess";
                      //bool IsLockedOut = Convert.ToBoolean(DataBinder.Eval(c.DataItem, "IsLockedOut"));
                      bool IsOnline = Convert.ToBoolean(DataBinder.Eval(c.DataItem, "IsOnline"));
                      bool IsApproved = Convert.ToBoolean(DataBinder.Eval(c.DataItem, "IsApproved"));
                      bool isPasswordIsExpired = Convert.ToBoolean(DataBinder.Eval(c.DataItem, "MemberRegistrationStatus.PasswordIsExpired"));
                      bool isRequiresEmailConfirmation = Convert.ToBoolean(DataBinder.Eval(c.DataItem, "MemberRegistrationStatus.RequiresEmailConfirmation"));
                      bool isRequiresFullRegistration = Convert.ToBoolean(DataBinder.Eval(c.DataItem, "MemberRegistrationStatus.RequiresFullRegistration"));

                      if (!IsApproved || isPasswordIsExpired || isRequiresEmailConfirmation || isRequiresFullRegistration)
                      {
                          settingsCom.ClientEnabled = false;
                      }
                      settingsCom.CustomJSProperties = (s, e) =>
                      {
                          e.Properties["cpRowIndex"] = c.VisibleIndex;
                      };

                      bool HasExternalNoteAccess = Convert.ToBoolean(DataBinder.Eval(c.DataItem, "HasExternalNoteAccess"));
                      if (HasExternalNoteAccess)
                      {
                          settingsCom.Checked = true;
                      }

                  }).Render();
              });
          });

     
    
       settings.Columns.Add(column =>
       {           
           column.Caption = "Name"; 
                    
           column.Width = 200;
           column.FieldName = "PersonalInformation.FirstName";
           column.SetDataItemTemplateContent(c =>
          {
          string FirstName = Convert.ToString(DataBinder.Eval(c.DataItem, "PersonalInformation.FirstName"));
          string LastName = Convert.ToString(DataBinder.Eval(c.DataItem, "PersonalInformation.LastName"));
          Html.DevExpress().Label(lblSettings =>
          {
              lblSettings.Text = FirstName + " " + LastName;
              
          }).GetHtml();
         
           });
       });

       
       
       
       settings.Columns.Add(column =>
       {
           column.FieldName = "UserName";
           column.Caption = "Account Email Address";
           column.Width = 200; //Unit.Percentage(30);
          // column.Width = Unit.Percentage(40);
           column.SetDataItemTemplateContent(c =>
           {
               string UserName = Convert.ToString(DataBinder.Eval(c.DataItem, "UserName"));
               ViewContext.Writer.Write("<div id=\"adminHyperLink\" class=\"adminHyperLink\">");
               ViewContext.Writer.Write(Html.Mailto(UserName, UserName));
               ViewContext.Writer.Write("</div>");

           });

          
       });
       
       settings.Columns.Add(column =>
       {
           column.Settings.AllowAutoFilter = DefaultBoolean.False;
           column.FieldName = "LastActivityDate";
           column.Caption = "Last Activity Date";
           
           column.SetDataItemTemplateContent(c =>
           {
               DateTime dt = Convert.ToDateTime(DataBinder.Eval(c.DataItem, "LastActivityDate"));
               //ViewContext.Writer.Write(Html.SplitLineDate(dt));             
               ViewContext.Writer.Write(dt);    
           });
           
         


           if (Request.Url.AbsolutePath.Contains("/AccountAdministration/FindUserByUserName")) //superadmin view
           {
               column.Width = Unit.Percentage(30);
           }
           else // provider admin View
           {
               column.Width = 150;
           }
           
           
           
       });

       settings.Columns.Add(column =>
           {               
               column.Caption = "Status Flags";

               column.Width = 250;
               column.SetDataItemTemplateContent(c =>
               {
                   bool IsLockedOut = Convert.ToBoolean(DataBinder.Eval(c.DataItem, "IsLockedOut"));
                   bool IsOnline = Convert.ToBoolean(DataBinder.Eval(c.DataItem, "IsOnline"));
                   bool IsApproved = Convert.ToBoolean(DataBinder.Eval(c.DataItem, "IsApproved"));
                   bool isPasswordIsExpired = Convert.ToBoolean(DataBinder.Eval(c.DataItem, "MemberRegistrationStatus.PasswordIsExpired"));
                   bool isRequiresEmailConfirmation = Convert.ToBoolean(DataBinder.Eval(c.DataItem, "MemberRegistrationStatus.RequiresEmailConfirmation"));
                   bool isRequiresFullRegistration = Convert.ToBoolean(DataBinder.Eval(c.DataItem, "MemberRegistrationStatus.RequiresFullRegistration"));
                   
                   Html.DevExpress().Label(lblSettings =>
                   {
                       var statusMessage = "";
                       
                       if (IsLockedOut)
                       {                           
                           statusMessage = "<span style=\"color : Red\">" + "Locked Out</br>";
                       }
                       if (IsOnline)
                       {                           
                           statusMessage = "<span style=\"color: Green\">" + statusMessage + "Online</br>";
                       }
                       if (!IsApproved)
                       {
                          
                           statusMessage = "<span style=\"color : Red\">"+ statusMessage + "Disabled</br>";
                       }
                       if (isPasswordIsExpired)
                       {
                         
                            statusMessage = "<span style=\"color : Red\">" + statusMessage +"New Password Required</br>";
                       }
                       if (isRequiresEmailConfirmation)
                       {
                          
                            statusMessage = "<span style=\"color : Red\">" + statusMessage +"Email Confirmation Required</br>";
                       }
                       if (isRequiresFullRegistration)
                       {
                           
                           statusMessage = "<span style=\"color : Red\">" + statusMessage + "Awaiting Registration Completion";
                       }
                       
                       var cellText = statusMessage;
                       ViewContext.Writer.Write(string.Format("{0}", cellText));
                   }).GetHtml();


               });
             
           });

       settings.Columns.Add(column =>
           {               
               column.Caption = "Administrate";

               column.Width = 150;
               column.SetDataItemTemplateContent(c =>
               {
                  
                   string UserName = Convert.ToString(DataBinder.Eval(c.DataItem, "UserName"));

                   ViewContext.Writer.Write(Html.ActionLink("Administrate",
                   "AdministerUser",   // <-- ActionMethod
                       "AccountAdministration",  // <-- Controller Name.

                    new
                    {
                        emailAddress = Html.Encrypt(UserName),
                        returnUrl = HttpContext.Current.Request.Url.AbsoluteUri
                    }, // <-- Route arguments.
                   new { 
                   
                    @class="clsLoader"
                   }  // <-- htmlArguments .. which are none. You need this value
                       //     otherwise you call the WRONG method ...
                       //     (refer to comments, below).
                       )//action link ends 
                      );
                   
                   
                  // ViewContext.Writer.Write("</div>");              
                   
               });
               
           });
  
      
       
   }).Bind(Model).GetHtml() %> 
    

