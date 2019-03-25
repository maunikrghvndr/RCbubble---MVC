<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Setup.Model.ManageProvider>" %>

 <% 

    Html.DevExpress().CallbackPanel(

        settings =>
        {
            settings.Name = "AddOrgCallbackPanel";
            settings.CallbackRouteValues = new { Controller = "ProviderAdmin", Action = "ManageProviderPartial", Id = Request.Params["Id"] };
            settings.Width = Unit.Percentage(100);
           
            settings.SetContent(() =>
            {
                string CondictionalText = "";
              
                if (string.IsNullOrEmpty(Request.Params["Id"]) == true)
                {
                    CondictionalText = "<h2 class=\"AddOrg\">Add Organization</h2>" +
                         "<span class=\"AddOrgInfo\">Adding an organization will allow them to review, respond, request and/or send documents.</span>";
                    
                }
                else
                {
                    CondictionalText = "<h2 class=\"AddOrg\">Edit Organization</h2>" +
                          "<span class=\"AddOrgInfo\">Edit organization and click save to update</span>"; 
                }
                
                ViewContext.Writer.Write("<table class=\"SuperAdmin_AddOrg\" >" +
                        "<tr>" +
                            "<td>" +
                            CondictionalText +
                     "</td>" +
                 "</tr>" +
                   "<tr>" +
                        "<td>&nbsp;</td>" +
                    "</tr>" +
                    "<tr class=\"OrganizationInfo\">" +
                        "<td>"
                    );
                Html.DevExpress().Label(lbl =>
                {
                    lbl.Name = "OrgInfo_Lable";
                    lbl.Text = "Organization Info";
                    lbl.ControlStyle.CssClass = "OrgInfo_LableClass";
                }).Render();

                ViewContext.Writer.Write("<div class=\"InnerOrganizationInfo\"><table class=\"OrganizationInfoTable\">" +
                     "<tr>" +
                         "<td colspan=\"3\">");
                Html.DevExpress().LabelFor(model => model.Name,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render();
                Html.DevExpress().TextBoxFor(model => model.Name,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                                  Name =>
                                  {
                                      Name.Width = Unit.Percentage(97);
                                  })).Render();
                
                 ViewContext.Writer.Write("</td>"+
                    "</tr>"+
                    "<tr>"+
                        "<td>"); 
                   Html.DevExpress().LabelFor(model => model.ProviderNo,
                                RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render();
                   Html.DevExpress().TextBoxFor(model => model.ProviderNo,
                                     RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                                     ProviderNo =>
                                     {
                                         ProviderNo.Width = Unit.Percentage(91);
                                     })).Render();
                   ViewContext.Writer.Write("</td> <td>");
                   Html.DevExpress().LabelFor(model => model.NPI,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render();
                   Html.DevExpress().TextBoxFor(model => model.NPI,
                                     RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                                     NPI =>
                                     {
                                         NPI.Width = Unit.Percentage(91);
                                     })).Render();
             
               ViewContext.Writer.Write("</td><td>&nbsp;</td>"+
                  "</tr>"+
                    "<tr>"+
                       "<td colspan=\"3\">"); 
                 Html.DevExpress().LabelFor(model => model.StreetAddress,
                                RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render();
                 Html.DevExpress().TextBoxFor(model => model.StreetAddress,
                                   RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                                   StreetAddress =>
                                   {
                                       StreetAddress.Width = Unit.Percentage(97);
                                   })).Render();
                 ViewContext.Writer.Write("</td>" +
                     "</tr>" +
                     "<tr>" +
                         "<td>");

               
                 Html.DevExpress().LabelFor(model => model.Country,
                                 RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render();
                 Html.DevExpress().ComboBox(
                                CountrySettings =>
                                {
                                    CountrySettings.Name = "Countries";
                                    CountrySettings.Width = Unit.Percentage(91);
                                    CountrySettings.SelectedIndex = -1;
                                    CountrySettings.Properties.IncrementalFilteringMode = IncrementalFilteringMode.StartsWith;
                                    CountrySettings.Properties.DropDownStyle = DropDownStyle.DropDown;
                                    CountrySettings.ControlStyle.CssClass = "OrgNameSeachboxCls";
                                }
                            ).BindList(ViewData["Countries"]).GetHtml();
                

                 ViewContext.Writer.Write("</td> <td>");
                
                 Html.DevExpress().LabelFor(model => model.State,
                                 RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render();
                 Html.DevExpress().ComboBox(
                                StateSettings =>
                                {
                                    StateSettings.Name = "State";
                                    StateSettings.Width = Unit.Percentage(91);
                                    StateSettings.SelectedIndex = -1;
                                    StateSettings.Properties.IncrementalFilteringMode = IncrementalFilteringMode.StartsWith;
                                    StateSettings.Properties.DropDownStyle = DropDownStyle.DropDown;
                                    StateSettings.ControlStyle.CssClass = "OrgNameSeachboxCls";
                                }
                            ).BindList(ViewData["States"]).GetHtml();
                
                 ViewContext.Writer.Write("</td> <td>");
                 Html.DevExpress().LabelFor(model => model.City,
                                RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render();
                 Html.DevExpress().ComboBox(
                                CitySettings =>
                                {
                                    CitySettings.Name = "City";
                                    CitySettings.Width = Unit.Percentage(91);
                                    CitySettings.SelectedIndex = -1;
                                    CitySettings.Properties.IncrementalFilteringMode = IncrementalFilteringMode.StartsWith;
                                    CitySettings.Properties.DropDownStyle = DropDownStyle.DropDown;
                                    CitySettings.ControlStyle.CssClass = "OrgNameSeachboxCls";
                                }
                            ).BindList(ViewData["City"]).GetHtml();
                
                 ViewContext.Writer.Write("</td>" +
                                        "</tr>" +
                     "<tr>" +
                         "<td>");
                 Html.DevExpress().LabelFor(model => model.Zip,
                                RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render();
                 Html.DevExpress().TextBoxFor(model => model.Zip,
                                   RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                                   Zip => { Zip.Width = Unit.Percentage(91); })).Render();
                 ViewContext.Writer.Write("</td>"+
                    "</tr>"+
                "</table></div>"+
            "</td>"+
        "</tr>"+
        "<tr>"+
            "<td>&nbsp;</td>"+
        "</tr>"+
        "<tr class=\"ContactInfo\">"+
            "<td>"); 
             Html.DevExpress().Label(lbl =>
                         {
                             lbl.Name = "ContactInfo_Lable";
                             lbl.Text = "Contact Info";
                             lbl.ControlStyle.CssClass = "OrgInfo_LableClass";
                         }).Render();
             ViewContext.Writer.Write("<div class=\"InnerOrganizationInfo\"><table class=\"ContactInfoTable\">" +
                    "<tr>"+
                        "<td colspan=\"3\">");
             Html.DevExpress().LabelFor(model => model.ContactName,
                             RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render();
             Html.DevExpress().TextBoxFor(model => model.ContactName,
                               RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                               ContactName => { ContactName.Width = Unit.Percentage(97); })).Render();

             ViewContext.Writer.Write("</td>" +
                     "</tr>" +
                     "<tr>" +
                         "<td>");
             Html.DevExpress().LabelFor(model => model.ContactPhone,
                            RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render();
             Html.DevExpress().TextBoxFor(model => model.ContactPhone,
                               RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                               ContactPhone =>
                               {
                                   ContactPhone.Width = Unit.Percentage(91);
                               })).Render();
                
             ViewContext.Writer.Write("</td><td>");
             Html.DevExpress().LabelFor(model => model.Fax,
                            RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render();
             Html.DevExpress().TextBoxFor(model => model.Fax,
                               RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                               OrgName =>
                               {
                                   OrgName.Name = "Fax";
                                   OrgName.Width = Unit.Percentage(91);

                               })).Render();
             ViewContext.Writer.Write("</td> <td>");
             Html.DevExpress().LabelFor(model => model.ContactEmail,
                            RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render();
             Html.DevExpress().TextBoxFor(model => model.ContactEmail,
                               RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                               OrgName =>
                               {
                                   OrgName.Width = Unit.Percentage(91);
                               })).Render();
             ViewContext.Writer.Write("</td>" +
                   "</tr>" +
                   "<tr>" +
                       "<td colspan=\"3\">");
             Html.DevExpress().LabelFor(model => model.AlternateContactName,
                            RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render();
             Html.DevExpress().TextBoxFor(model => model.AlternateContactName,
                               RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                               AlternateContactName =>
                               {
                                   AlternateContactName.Width = Unit.Percentage(97);
                               })).Render();

             ViewContext.Writer.Write("</td>" +
                      "</tr>" +
                      "<tr>" +
                          "<td>");
             Html.DevExpress().LabelFor(model => model.AlternateContactPhone,
                            RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render();
             Html.DevExpress().TextBoxFor(model => model.AlternateContactPhone,
                              RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                              AlternateContactPhone =>
                              {
                                  AlternateContactPhone.Width = Unit.Percentage(91);
                              })).Render();
             ViewContext.Writer.Write("</td> <td>");
             Html.DevExpress().LabelFor(model => model.AlternateContactEmail,
                            RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render();
             Html.DevExpress().TextBoxFor(model => model.AlternateContactEmail,
                               RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                               AlternateContactEmail =>
                               {
                                   AlternateContactEmail.Width = Unit.Percentage(91);
                               })).Render();

             ViewContext.Writer.Write("</td>" +
                            "</tr>" +
                        "</table></div>" +
                    "</td>" +
                "</tr>" +
                "<tr>" +
                    "<td>&nbsp;</td>" +
                "</tr>" +
                "<tr class=\"BillingInfo\">" +
                    "<td>");
             Html.DevExpress().Label(lbl =>
             {
                 lbl.Name = "BillingInfo_Lable";
                 lbl.Text = "Billing Info";
                 lbl.ControlStyle.CssClass = "OrgInfo_LableClass";

             }).Render();
             ViewContext.Writer.Write("<div class=\"InnerOrganizationInfo\"><table class=\"BillingInfoTable\">" +
                    "<tr>"+
                        "<td colspan=\"3\">");
            Html.DevExpress().CheckBox(SameContactInfo =>
            {
                SameContactInfo.Name = "SameContactInfo";
                SameContactInfo.Text = "Same as Contact Info";
                SameContactInfo.ClientEnabled = true;
                SameContactInfo.ControlStyle.CssClass = "SameContactInfo";
                SameContactInfo.ControlStyle.Cursor = "pointer";
                SameContactInfo.Properties.ClientSideEvents.CheckedChanged = "CheckSameContactInfo";
            }).Render(); 
                
             ViewContext.Writer.Write("</td>"+
                    "</tr>"+
                    "<tr>"+
                        "<td colspan=\"3\">");
             Html.DevExpress().LabelFor(model => model.BillingContactName,
                            RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render();
             Html.DevExpress().TextBoxFor(model => model.BillingContactName,
                               RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                               OrgName =>
                               {
                                   OrgName.Width = Unit.Percentage(97);
                               })).Render();

             ViewContext.Writer.Write("</td>" +
                   "</tr>" +
                  "<tr>" +
                       "<td>");
             Html.DevExpress().LabelFor(model => model.BillingContactPhone,
                            RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render();
             Html.DevExpress().TextBoxFor(model => model.BillingContactPhone,
                               RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                               BillingContactPhone => { BillingContactPhone.Width = Unit.Percentage(91); })).Render();
             ViewContext.Writer.Write("</td> <td>");
             Html.DevExpress().LabelFor(model => model.BillingContactEmail,
                            RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render();
             Html.DevExpress().TextBoxFor(model => model.BillingContactEmail,
                               RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                               BillingContactEmail =>
                               {
                                   BillingContactEmail.Width = Unit.Percentage(91);
                               })).Render();
             ViewContext.Writer.Write("</td>" +
                        "<td>&nbsp;</td>" +
                    "</tr>" +
                    "<tr>" +
                        "<td colspan=\"3\">" +
                            "<div class=\"grey_line\"></div>" +
                        "</td>" +
                    "</tr>" +
                    "<tr>" +
                        "<td colspan=\"3\">");
             Html.DevExpress().CheckBox(SameOrgInfo =>
             {
                 SameOrgInfo.Name = "SameOrgInfo";
                 SameOrgInfo.Text = "Same as Organization Info";
                 SameOrgInfo.ClientEnabled = true;
                 SameOrgInfo.ControlStyle.CssClass = "SameContactInfo";
                 SameOrgInfo.ControlStyle.Cursor = "pointer";
                 SameOrgInfo.Properties.ClientSideEvents.CheckedChanged = "CheckSameOrgInfo";
             }).Render();
             ViewContext.Writer.Write("</td>" +
                      "</tr>" +
                      "<tr>" +
                          "<td colspan=\"3\">");
             Html.DevExpress().LabelFor(model => model.BillingContactStreetAddress,
                            RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render();
             Html.DevExpress().TextBoxFor(model => model.BillingContactStreetAddress,
                               RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                               BillingContactStreetAddress => { BillingContactStreetAddress.Width = Unit.Percentage(97); })).Render();
             ViewContext.Writer.Write("</td>" +
                      "</tr>" +
                      "<tr>" +
                          "<td>");
                
          
             Html.DevExpress().LabelFor(model => model.BillingContactCountry,
                                RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render();
             Html.DevExpress().ComboBox(
                            CountrySettings =>
                            {
                                CountrySettings.Name = "BillingContactCountry";
                                CountrySettings.Width = Unit.Percentage(91);
                                CountrySettings.SelectedIndex = -1;
                                CountrySettings.Properties.IncrementalFilteringMode = IncrementalFilteringMode.StartsWith;
                                CountrySettings.Properties.DropDownStyle = DropDownStyle.DropDown;
                                CountrySettings.ControlStyle.CssClass = "OrgNameSeachboxCls";
                            }
                        ).BindList(ViewData["Countries"]).GetHtml();
                   
                
             ViewContext.Writer.Write("</td> <td>");

             Html.DevExpress().LabelFor(model => model.BillingContactState,
                                RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render();
             Html.DevExpress().ComboBox(
                            BillingStateSettings =>
                            {
                                BillingStateSettings.Name = "BillingContactState";
                                BillingStateSettings.Width = Unit.Percentage(91);
                                BillingStateSettings.SelectedIndex = -1;
                                BillingStateSettings.Properties.IncrementalFilteringMode = IncrementalFilteringMode.StartsWith;
                                BillingStateSettings.Properties.DropDownStyle = DropDownStyle.DropDown;
                                BillingStateSettings.ControlStyle.CssClass = "OrgNameSeachboxCls";
                            }
                        ).BindList(ViewData["States"]).GetHtml();
            
             ViewContext.Writer.Write("</td> <td>");

             Html.DevExpress().LabelFor(model => model.BillingContactCity,
                            RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render();
             Html.DevExpress().ComboBox(
                            BillingCitySettings =>
                            {
                                BillingCitySettings.Name = "BillingContactCity";
                                BillingCitySettings.Width = Unit.Percentage(91);
                                BillingCitySettings.SelectedIndex = -1;
                                BillingCitySettings.Properties.IncrementalFilteringMode = IncrementalFilteringMode.StartsWith;
                                BillingCitySettings.Properties.DropDownStyle = DropDownStyle.DropDown;
                                BillingCitySettings.ControlStyle.CssClass = "OrgNameSeachboxCls";
                            }
                        ).BindList(ViewData["City"]).GetHtml();
                
             ViewContext.Writer.Write("</td>" +
                       "</tr>" +
                       "<tr>" +
                           "<td>");
             Html.DevExpress().LabelFor(model => model.BillingContactZip,
                            RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render();
             Html.DevExpress().TextBoxFor(model => model.BillingContactZip,
                               RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                               BillingContactZip => { BillingContactZip.Width = Unit.Percentage(91); })).Render();

             ViewContext.Writer.Write("</td>" +
                       "</tr>" +
                   "</table></div>" +
               "</td>" +
           "</tr>" +
           "<tr>" +
               "<td>&nbsp;</td>" +
           "</tr>" +
           "<tr class=\"AdditionalInfo\">" +
               "<td>");
             Html.DevExpress().Label(lbl =>
             {
                 lbl.Name = "AdditionalInfo_Lable";
                 lbl.Text = "Additional Info";
                 lbl.ControlStyle.CssClass = "OrgInfo_LableClass";
             }).Render();

             ViewContext.Writer.Write("<div class=\"InnerOrganizationInfo\"><table class=\"AdditionalInfoTable\">" +
                   "<tr>" +
                       "<td>");
                
             Html.DevExpress().LabelFor(model => model.ContractDateSigned,
                            RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render();
             Html.DevExpress().DateEditFor(model => model.ContractDateSigned,
                               RISARC.Web.EBubble.Models.DevxControlSettings.DateEditSetting.DateEditSettingsMethodAdditional(
                               ContractDateSigned =>
                               {
                                   ContractDateSigned.Properties.DropDownButton.Image.Url = Url.Content("~/Images/icons/InfoIcon.png");
                                   ContractDateSigned.Width = Unit.Percentage(88);
                                   ContractDateSigned.ControlStyle.CssClass = "OrgNameSeachboxCls";
                               })).Render();
            
                
                
             ViewContext.Writer.Write("</td> <td>");
             Html.DevExpress().LabelFor(model => model.OID,
                            RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render();
             Html.DevExpress().TextBoxFor(model => model.OID,
                               RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                               OID => { OID.Width = Unit.Percentage(91); })).Render();
             ViewContext.Writer.Write("</td>" +
                      "<td>&nbsp;</td>" +
                  "</tr>" +
                  "<tr>" +
                      "<td>");
             Html.DevExpress().LabelFor(model => model.ACN.IsAutoGenerate,
                            RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render();
             Html.DevExpress().ComboBoxFor(model => model.ACN.IsAutoGenerate,
                               RISARC.Web.EBubble.Models.DevxControlSettings.ComboBoxSetting.ComboBoxSettingsMethodAdditional(
                               cboSettings => {
                                   cboSettings.Properties.ValueType = typeof(Boolean);
                                   cboSettings.Width = Unit.Percentage(88);
                                   cboSettings.ControlStyle.CssClass = "OrgNameSeachboxCls";
                               })).BindList(ViewData["YesNo"]).Render();
             ViewContext.Writer.Write("</td> <td>");
             Html.DevExpress().LabelFor(model => model.ACN.ACNFrom,
                            RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render();
             Html.DevExpress().TextBoxFor(model => model.ACN.ACNFrom,
                               RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                               OrgName =>
                               {
                                   OrgName.Width = Unit.Percentage(91);
                               })).Render();
             ViewContext.Writer.Write("</td> <td>");
             Html.DevExpress().LabelFor(model => model.ACN.ACNTo,
                            RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render();
             Html.DevExpress().TextBoxFor(model => model.ACN.ACNTo,
                               RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                               OrgName =>
                               {
                                   OrgName.Width = Unit.Percentage(91);
                               })).Render();
             ViewContext.Writer.Write("</td>" +
                         "</tr>" +
                     "</table></div>" +
                 "</td>" +
             "</tr>" +
             "<tr>" +
                 "<td>&nbsp;</td>" +
             "</tr>" +
             "<tr class=\"Invoicing\">" +
                 "<td>");
             Html.DevExpress().Label(lbl =>
             {
                 lbl.Name = "Invoicing_Lable";
                 lbl.Text = "Invoicing";
                 lbl.ControlStyle.CssClass = "OrgInfo_LableClass";
             }).Render();

             ViewContext.Writer.Write("<div class=\"InnerOrganizationInfo\"><table class=\"InvoicingTable\">" +
                    "<tr>" +
                        "<td>");
                
             Html.DevExpress().LabelFor(model => model.MinimumDocumentPrice,
                            RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render();
             Html.DevExpress().TextBoxFor(model => model.MinimumDocumentPrice,
                               RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                               OrgName =>
                               {
                                   OrgName.Width = Unit.Percentage(91);
                               })).Render();
             ViewContext.Writer.Write("</td> <td>");
                
             Html.DevExpress().LabelFor(model => model.PricePerDocumentPage,
                            RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render();
             Html.DevExpress().TextBoxFor(model => model.PricePerDocumentPage,
                               RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                               OrgName =>
                               {
                                   OrgName.Width = Unit.Percentage(91);
                               })).Render();
             ViewContext.Writer.Write("</td> <td>");
                
             Html.DevExpress().LabelFor(model => model.PricePerDocumentMegabyte,
                            RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render();
             Html.DevExpress().TextBoxFor(model => model.PricePerDocumentMegabyte,
                               RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                               OrgName =>
                               {
                                   OrgName.Width = Unit.Percentage(91);
                               })).Render();
             ViewContext.Writer.Write("</td>" +
                 "</tr>" +
                 "<tr>" +
                     "<td>");
             Html.DevExpress().LabelFor(model => model.ROIMinimumDocumentPrice,
                            RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render();
             Html.DevExpress().TextBoxFor(model => model.ROIMinimumDocumentPrice,
                               RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                               OrgName =>
                               {
                                   OrgName.Width = Unit.Percentage(91);
                               })).Render();
             ViewContext.Writer.Write("</td> <td>");
             Html.DevExpress().LabelFor(model => model.ROIPricePerDocumentPage,
                            RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render();
             Html.DevExpress().TextBoxFor(model => model.ROIPricePerDocumentPage,
                               RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                               OrgName =>
                               {
                                   OrgName.Width = Unit.Percentage(91);
                               })).Render();
             ViewContext.Writer.Write("</td> <td>");
             Html.DevExpress().LabelFor(model => model.ROIPricePerDocumentMegabyte,
                            RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render();
             Html.DevExpress().TextBoxFor(model => model.ROIPricePerDocumentMegabyte,
                               RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                               OrgName =>
                               {
                                   OrgName.Width = Unit.Percentage(91);
                               })).Render();
             ViewContext.Writer.Write("</td>" +
                  "</tr>" +
                  "<tr>" +
                      "<td>");
             Html.DevExpress().LabelFor(model => model.PaymentReceivedEnabled,
                            RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render();
             Html.DevExpress().ComboBoxFor(model => model.PaymentReceivedEnabled,
                               RISARC.Web.EBubble.Models.DevxControlSettings.ComboBoxSetting.ComboBoxSettingsMethodAdditional(
                               cboSettings =>
                               {
                                   cboSettings.Properties.ValueType = typeof(Boolean);
                                   cboSettings.ControlStyle.CssClass = "OrgNameSeachboxCls";
                               })).BindList(ViewData["YesNo"]).Render();
             ViewContext.Writer.Write("</td> <td>");
             Html.DevExpress().LabelFor(model => model.CanSendFreeDocuments,
                            RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render();
             Html.DevExpress().ComboBoxFor(model => model.CanSendFreeDocuments,
                               RISARC.Web.EBubble.Models.DevxControlSettings.ComboBoxSetting.ComboBoxSettingsMethodAdditional(
                               cboSettings =>
                               {
                                   cboSettings.Properties.ValueType = typeof(Boolean);
                                   cboSettings.ControlStyle.CssClass = "OrgNameSeachboxCls";
                               })).BindList(ViewData["YesNo"]).Render();
             ViewContext.Writer.Write("</td> <td>");
             Html.DevExpress().LabelFor(model => model.CanBeInvoiced,
                            RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render();
             Html.DevExpress().ComboBoxFor(model => model.CanBeInvoiced,
                               RISARC.Web.EBubble.Models.DevxControlSettings.ComboBoxSetting.ComboBoxSettingsMethodAdditional(
                               cboSettings =>
                               {
                                   cboSettings.Properties.ValueType = typeof(Boolean);
                                   cboSettings.ControlStyle.CssClass = "OrgNameSeachboxCls";
                               })).BindList(ViewData["YesNo"]).Render();
             ViewContext.Writer.Write("</td>" +
                    "</tr>" +
                "</table></div>" +
            "</td>" +
        "</tr>");

             ViewContext.Writer.Write("<tr>" +
                  "<td>&nbsp;</td>" +
              "</tr>" +
              "<tr>" +
                  "<td>" +
                      "<div style=\"clear: both; width: 190px;\">" +
                          "<div style=\"float: left;\">");
             Html.DevExpress().Button(
                buttonSet =>
                {
                    buttonSet.Name = "SaveButton";
                    buttonSet.ControlStyle.CssClass = "AddOrgaveButton";
                    buttonSet.Width = Unit.Pixel(90);
                    buttonSet.Height = 25;
                   // buttonSet.Styles.EnableDefaultAppearance = false; //made defult apperance false for applying own styles
                    buttonSet.ControlStyle.Cursor = "pointer";
                    buttonSet.ControlStyle.BackColor = System.Drawing.ColorTranslator.FromHtml("#8CC700");
                    buttonSet.Text = "Save";
                    buttonSet.UseSubmitBehavior = true;
                    buttonSet.ClientSideEvents.Click = "AddOrgSaveBtn";
                    //buttonSet.RouteValues = new { Controller = "ProviderAdmin", Action = "ManageProvider" };
                }).GetHtml();
             ViewContext.Writer.Write("</div>" +
                         "<div style=\"float: right;\">");
             Html.DevExpress().Button(
                CancleBtn =>
                {
                    CancleBtn.Name = "CancelButton";
                    CancleBtn.ControlStyle.CssClass = "CancelButton";
                    CancleBtn.Width = Unit.Pixel(90);
                    CancleBtn.Text = "Cancel";
                    CancleBtn.Height = 25;
                    //CancleBtn.Styles.EnableDefaultAppearance = false; //made defult apperance false for applying own styles
                    CancleBtn.ControlStyle.Cursor = "pointer";
                    CancleBtn.ControlStyle.BackColor = System.Drawing.ColorTranslator.FromHtml("#ACACAC");
                    CancleBtn.UseSubmitBehavior = false;
                    CancleBtn.ClientSideEvents.Click = "CancleCloseFunc";
                    
                }).GetHtml();
             ViewContext.Writer.Write(" </div>" +
                "</div>" +
            "</td>" +
        "</tr>" +
    "</table>");
                

            });//Set Content Ends 


            settings.ClientSideEvents.BeginCallback = "OnBeginCallbackFunc";
            //settings.ClientSideEvents.EndCallback = "OnEndCallback";
        }
        
  ).GetHtml();  %>

