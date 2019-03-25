<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<RISARC.Setup.Model.ManageProvider>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    ManageProvider
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <% using (Html.BeginForm())
       { %>
    <%: Html.ValidationSummary(true) %>
  <input type="hidden" name="SelectedOrgName" id="SelectedOrgName" value="" />
    <input type="hidden" name="EditFlag" id="EditFlag" value="<%= ViewData["ErrorFlag"] %>" />


    <% if (ViewData["Message"] != null)
       { %>
    <div class="statusMessage">
          <% Response.Write(ViewData["Message"]);  %>
        <% Response.Write(ViewData["EMessage"]);  %>
    </div>
 <% } %>
   
 

      <table style="width:100%">
          <tr>

              <td>
                   <h2>Search Organization</h2>
            <div class="totalAccount">Search organization by name, click edit organization to view and update its information. </div>


              </td>
              <td>
                   <div class="floatRight clsLineHeight50">
                    <%  Html.DevExpress().Button(
                                   settings =>
                                   {
                                       settings.Name = "AddNewOrganization";
                                     
                                       settings.Width = Unit.Percentage(80);
                                       settings.Height = 35;
                                       settings.Text = "Add New Organization";
                                       settings.UseSubmitBehavior = false;
                                       settings.ClientSideEvents.Click = "AddNewOrgClick";
                                       settings.ControlStyle.CssClass = "orangeBtn";
                                       
                                   }).GetHtml();  %>
                       </div>
                   <div class="error"></div>

              </td>
          </tr>

      </table>


    <table class="SearchOrgTable">

        <tr>
            <td colspan="3">
                <div class="SearchOuter">
                    <table class="topTableTr reducePaddingtopTableTr">
                        <tr>
                            <td>


                                <%
                    Html.DevExpress().Label(
                        Labelsettings =>
                        {
                            Labelsettings.Text = "Search By Organization Name";
                            Labelsettings.Name = "SearchByOrgName";
                            Labelsettings.ControlStyle.CssClass = "CommanLableCls";
                        }
                        ).GetHtml();
                    Html.DevExpress().ComboBox(
                                  RISARC.Web.EBubble.Models.DevxControlSettings.ComboBoxSetting.ComboBoxSettingsMethodAdditional(settings =>
                                  {
                                      settings.Name = "OrganizationSelector";
                                      settings.Properties.ValueType = typeof(short);
                                      settings.Width = Unit.Percentage(90);
                                      settings.SelectedIndex = -1;
                                      settings.Properties.IncrementalFilteringMode = IncrementalFilteringMode.StartsWith;
                                      settings.ControlStyle.CssClass = "OrgNameSeachboxCls";
                                      settings.Properties.ClientSideEvents.SelectedIndexChanged = "OrgNameChanged";
                                  })
                              ).BindList(ViewData["ProviderList"]).Bind(Model.Name).GetHtml();
                                %> 
                                <%= System.Web.Mvc.Html.InputExtensions.HiddenFor(Html, model => model.Id) %>
                            </td>
                            <td colspan="2">

                                <%  Html.DevExpress().Button(
                                       settings =>
                                       {
                                           settings.Name = "EditOrg";
                                           settings.ControlStyle.CssClass = "orangeBtn disableOrangeBtn";
                                           settings.Width = Unit.Percentage(25);
                                           settings.Height = 35;
                                           settings.Text = "Edit Organization";
                                           settings.UseSubmitBehavior = false;
                                           settings.ClientSideEvents.Click = "EditOrgClick";

                                           settings.ClientEnabled = false;
                                         //  settings.RouteValues = new { Controller = "ProviderAdmin", Action = "ManageProvider", id = Model.Id  };

                                       }).GetHtml();  %>
                            </td>
                         
                        </tr>
                    </table>
                </div>
            </td>
        </tr>

       <%-- <tr>
            <td colspan="3">&nbsp;</td>
        </tr>--%>
    </table>


    <div class="AddOrgContainer">
        <table class="SuperAdmin_AddOrg" style="display: none;">
             <tr class="">
                <td class="FixiedHT30">&nbsp;</td>
            </tr>
             <tr>
            <td>
                
                    <%    if (Model.Id.HasValue)
                          {%>
               <h2 class="AddOrg">Edit Organization</h2>
                    <span class="AddOrgInfo lightGery">Edit organization and click save to update</span>
                    <%}
                          else
                   {%>
               
                  <h2 class="AddOrg">Add Organization</h2>
                    <span class="AddOrgInfo lightGery">Adding an organization will allow them to review, respond, request and/or send documents.</span>
                <%  } %>                




            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
        </tr>
        <tr class="OrganizationInfo">
            <td>
                <% Html.DevExpress().Label(lbl =>
                        {
                            lbl.Name = "OrgInfo_Lable";
                            lbl.Text = "Organization Info";
                            lbl.ControlStyle.CssClass = "OrgInfo_LableClass";
                        }).Render(); %>
                <table class="OrganizationInfoTable ">
                        
                        <tr> 
                               <td class="blockTblTd">
                                <% Html.DevExpress().LabelFor(model => model.OrganizationType,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>

                                <% RISARC.Common.Enumerators.OrganizationType? val = Model.OrganizationType == 0 ? (RISARC.Common.Enumerators.OrganizationType?)null : Model.OrganizationType;
                                   Html.DevExpress().ComboBoxFor(model => model.OrganizationType,
                                     RISARC.Web.EBubble.Models.DevxControlSettings.ComboBoxSetting.ComboBoxSettingsMethodAdditional(settings =>
                                     {
                                        
                                         settings.Properties.ValueType = typeof(RISARC.Common.Enumerators.OrganizationType);
                                         //settings.Properties.Items.AddRange(Enum.GetNames(typeof(RISARC.Common.Enumerators.OrganizationType)));
                                         settings.Properties.ClientSideEvents.SelectedIndexChanged = "OrgTypeChanged";
                                         settings.Properties.IncrementalFilteringMode = IncrementalFilteringMode.StartsWith;
                                         settings.Properties.NullDisplayText = "--Select--";
                                         settings.Properties.NullText = "--Select--";
                                         //settings.Width = 310;
                                     })).BindList(ViewData["OrganizationType"]).Bind(val).Render();
                                %>
                            </td>

                            
                            <td class="blockTblTd">

                                 <% Html.DevExpress().LabelFor(model => model.OID,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                                <% Html.DevExpress().TextBoxFor(model => model.OID,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                                  OrgName =>{
                                      
                                  })).Render();
                                %>

                            </td>
                            


                        </tr>
                        
                    <tr>
                          <%--  <td colspan="3">
                            <% Html.DevExpress().LabelFor(model => model.Name,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                            <% Html.DevExpress().TextBoxFor(model => model.Name,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                                  OrgName =>
                                  {
                                      OrgName.Width = Unit.Percentage(97);
                                  })).Render();
                            %>
                            </td>--%>
                    </tr>
                    <tr>
                        <%--removed as requested by tamaara--%>
                        <%--<td>
                            <% Html.DevExpress().LabelFor(model => model.ProviderNo,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                            <% Html.DevExpress().TextBoxFor(model => model.ProviderNo,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                                  OrgName =>
                                  {
                                      OrgName.Width = Unit.Percentage(91);
                                  })).Render();
                            %>
                        </td>--%>
                         <td class="blockTblTd"  colspan="2">
                                <% Html.DevExpress().LabelFor(model => model.Name,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                                <% Html.DevExpress().TextBoxFor(model => model.Name,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                                  OrgName =>
                                  {
                                        OrgName.Width = Unit.Percentage(98);
                                    // OrgName.Width = 650;
                                  })).Render();
                                %>
                            </td>
                        <td class="blockTblTd">
                            <% Html.DevExpress().LabelFor(model => model.NPI,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                            <% Html.DevExpress().TextBoxFor(model => model.NPI,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                                  NPI =>
                                  {
                                     // NPI.Width = Unit.Percentage(91);
                                  })).Render();
                            %>
                        </td>
                    </tr>
                    <tr>
                        <td class="blockTblTd" colspan="2">
                            <% Html.DevExpress().LabelFor(model => model.StreetAddress,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                            <% Html.DevExpress().TextBoxFor(model => model.StreetAddress,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                                  OrgName =>
                                  {
                                      OrgName.Width = Unit.Percentage(98);
                                     // OrgName.Width = 650;
                                  })).Render();
                            %>
                        </td>
                         <td class="blockTblTd">
                            <% Html.DevExpress().LabelFor(model => model.City,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                            <% Html.DevExpress().ComboBoxFor(model => model.City,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.ComboBoxSetting.ComboBoxSettingsMethodAdditional(settings =>
                                  {
                                      settings.Properties.ValueType = typeof(string);
                                      settings.Properties.IncrementalFilteringMode = IncrementalFilteringMode.StartsWith;
                                      settings.Properties.DropDownStyle = DropDownStyle.DropDown;
                                      
                                  })).BindList(ViewData["City"]).Render();%>
                        </td>
                    </tr>
                    <tr>
                        <td class="blockTblTd">
                            <% Html.DevExpress().LabelFor(model => model.Country,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                            <% Html.DevExpress().ComboBoxFor(model => model.Country,
                                RISARC.Web.EBubble.Models.DevxControlSettings.ComboBoxSetting.ComboBoxSettingsMethodAdditional(settings =>
                                {
                                    settings.Properties.ValueType = typeof(string);

                                    settings.Properties.IncrementalFilteringMode = IncrementalFilteringMode.StartsWith;
                                    settings.Properties.DropDownStyle = DropDownStyle.DropDown;
                                    
                                    
                                })).BindList(ViewData["Countries"]).Render();
                            %>

                        </td>
                        <td class="blockTblTd">
                            <% Html.DevExpress().LabelFor(model => model.State,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                            <%  Html.DevExpress().ComboBoxFor(model => model.State,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.ComboBoxSetting.ComboBoxSettingsMethodAdditional(settings =>
                                  {
                                      settings.Properties.ValueType = typeof(string);
                                      settings.Properties.IncrementalFilteringMode = IncrementalFilteringMode.StartsWith;
                                      settings.Properties.DropDownStyle = DropDownStyle.DropDown;
                                      
                                  })).BindList(ViewData["States"]).Render();%>
                        </td>

                        <td class="blockTblTd">
                            <% Html.DevExpress().LabelFor(model => model.Zip,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                            <% Html.DevExpress().TextBoxFor(model => model.Zip,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                                  Zip =>
                                  {
                                     // Zip.Width = Unit.Percentage(91);
                                  })).Render();%>
                        </td>
                       
                    </tr>
                   
                </table>
            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
        </tr>
        <tr class="ContactInfo">
            <td>
                <% Html.DevExpress().Label(lbl =>
                        {
                            lbl.Name = "ContactInfo_Lable";
                            lbl.Text = "Contact Info";
                            lbl.ControlStyle.CssClass = "OrgInfo_LableClass";
                        }).Render(); %>
                <table class="ContactInfoTable ">
                    <tr>
                        <td class="blockTblTd" colspan="2">
                            <% Html.DevExpress().LabelFor(model => model.ContactName,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                            <% Html.DevExpress().TextBoxFor(model => model.ContactName,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                                  OrgName =>
                                  {
                                      OrgName.Width = Unit.Percentage(98);
                                  })).Render();%>
                        </td>
                         <td class="blockTblTd">
                            <% Html.DevExpress().LabelFor(model => model.ContactPhone,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                            <% Html.DevExpress().TextBoxFor(model => model.ContactPhone,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                                  OrgName =>
                                  {
                                     // OrgName.Width = Unit.Percentage(91);
                                  })).Render();%>
                        </td>
                    </tr>

                    <tr>
                        <td class="blockTblTd"><% Html.DevExpress().LabelFor(model => model.ContactEmail,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                            <% Html.DevExpress().TextBoxFor(model => model.ContactEmail,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                                  OrgName =>
                                  {
                                     // OrgName.Width = Unit.Percentage(91);
                                  })).Render();
                            %></td>
                         <td class="blockTblTd">
                            <% Html.DevExpress().LabelFor(model => model.Fax,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                            <% Html.DevExpress().TextBoxFor(model => model.Fax,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                                  OrgName =>
                                  {
                                      //OrgName.Width = Unit.Percentage(91);
                                  })).Render();%>
                        </td>
                    </tr>
                    <tr>
                        <td class="blockTblTd" colspan="2">
                            <% Html.DevExpress().LabelFor(model => model.AlternateContactName,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                            <% Html.DevExpress().TextBoxFor(model => model.AlternateContactName,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                                  OrgName =>
                                  {
                                      OrgName.Width = Unit.Percentage(98);
                                  })).Render();
                            %>
                        </td>
                         <td class="blockTblTd">
                            <% Html.DevExpress().LabelFor(model => model.AlternateContactPhone,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                            <% Html.DevExpress().TextBoxFor(model => model.AlternateContactPhone,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                                  OrgName =>
                                  {
                                      //OrgName.Width = Unit.Percentage(91);
                                  })).Render();
                            %>
                        </td>
                    </tr>
                    <tr>
                        <td class="blockTblTd" colspan="2">
                            <% Html.DevExpress().LabelFor(model => model.AlternateContactEmail,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                            <% Html.DevExpress().TextBoxFor(model => model.AlternateContactEmail,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                                  OrgName =>
                                  {
                                      OrgName.Width = Unit.Percentage(98);
                                  })).Render();
                            %>
                        </td>
                    </tr>

                </table>
            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
        </tr>
        <tr class="BillingInfo">
            <td>
                <% Html.DevExpress().Label(lbl =>
                        {
                            lbl.Name = "BillingInfo_Lable";
                            lbl.Text = "Billing Info";
                            lbl.ControlStyle.CssClass = "OrgInfo_LableClass";
                        }).Render(); %>
                <table class="BillingInfoTable">
                    <tr>
                        <td class="blockTblTd" colspan="3">
                            <% Html.DevExpress().CheckBox(SameContactInfo =>
                               {
                                   SameContactInfo.Name = "SameContactInfo";
                                   SameContactInfo.Text = "Same as Contact Info";
                                   SameContactInfo.ClientEnabled = true;
                                   SameContactInfo.ControlStyle.CssClass = "SameContactInfo";
                                   SameContactInfo.ControlStyle.Cursor = "pointer";
                                   SameContactInfo.Properties.ClientSideEvents.CheckedChanged = "CheckSameContactInfo";
                               }).Render(); %>
                        </td>
                    </tr>
                    <tr>
                        <td class="blockTblTd" colspan="2">
                            <% Html.DevExpress().LabelFor(model => model.BillingContactName,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                            <% Html.DevExpress().TextBoxFor(model => model.BillingContactName,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                                  OrgName =>
                                  {
                                      OrgName.Width = Unit.Percentage(98);
                                  })).Render();
                            %>
                        </td>
                           <td class="blockTblTd">
                            <% Html.DevExpress().LabelFor(model => model.BillingContactPhone,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                            <% Html.DevExpress().TextBoxFor(model => model.BillingContactPhone,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                                  OrgName =>
                                  {
                                     // OrgName.Width = Unit.Percentage(91);
                                  })).Render();
                            %>
                        </td>
                    </tr>
                    <tr>
                     
                        <td class="blockTblTd"><% Html.DevExpress().LabelFor(model => model.BillingContactEmail,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                            <% Html.DevExpress().TextBoxFor(model => model.BillingContactEmail,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                                  OrgName =>
                                  {
                                     // OrgName.Width = Unit.Percentage(91);
                                  })).Render();
                            %></td>
                        <td>&nbsp;</td>
                    </tr>
                    
                    <tr>
                        <td colspan="3" class="blockTblTd">
                            <% Html.DevExpress().CheckBox(SameOrgInfo =>
                             {
                                 SameOrgInfo.Name = "SameOrgInfo";
                                 SameOrgInfo.Text = "Same as Organization Info";
                                 SameOrgInfo.ClientEnabled = true;
                                 SameOrgInfo.ControlStyle.CssClass = "SameContactInfo";
                                 SameOrgInfo.ControlStyle.Cursor = "pointer";
                                 SameOrgInfo.Properties.ClientSideEvents.CheckedChanged = "CheckSameOrgInfo";
                             }).Render(); %>
                        </td>
                    </tr>
                    <tr>
                        <td class="blockTblTd" colspan="2">
                            <% Html.DevExpress().LabelFor(model => model.BillingContactStreetAddress,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                            <% Html.DevExpress().TextBoxFor(model => model.BillingContactStreetAddress,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(settings => {

                                      settings.Width = Unit.Percentage(98);
                                      
                                  })).Render();
                            %>

                        </td>
                         <td class="blockTblTd">
                            <% Html.DevExpress().LabelFor(model => model.BillingContactCity,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                            <% Html.DevExpress().ComboBoxFor(model => model.BillingContactCity,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.ComboBoxSetting.ComboBoxSettingsMethodAdditional(settings =>
                                  {
                                      settings.Properties.ValueType = typeof(string);
                                      settings.Properties.IncrementalFilteringMode = IncrementalFilteringMode.StartsWith;
                                      settings.Properties.DropDownStyle = DropDownStyle.DropDown;
                                      
                                  })).BindList(ViewData["City"]).Render();
                            %></td>
                    </tr>
                    <tr>
                        <td class="blockTblTd">
                            <% Html.DevExpress().LabelFor(model => model.BillingContactCountry,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                            <% Html.DevExpress().ComboBoxFor(model => model.BillingContactCountry,
                                RISARC.Web.EBubble.Models.DevxControlSettings.ComboBoxSetting.ComboBoxSettingsMethodAdditional(settings =>
                                {
                                    settings.Properties.ValueType = typeof(string);
                                    settings.Properties.IncrementalFilteringMode = IncrementalFilteringMode.StartsWith;
                                    settings.Properties.DropDownStyle = DropDownStyle.DropDown;
                                    
                                })).BindList(ViewData["Countries"]).Render();
                            %>

                        </td>
                        <td class="blockTblTd">
                            <% Html.DevExpress().LabelFor(model => model.BillingContactState,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                            <%  Html.DevExpress().ComboBoxFor(model => model.BillingContactState,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.ComboBoxSetting.ComboBoxSettingsMethodAdditional(settings =>
                                  {
                                      settings.Properties.ValueType = typeof(string);
                                      settings.Properties.IncrementalFilteringMode = IncrementalFilteringMode.StartsWith;
                                      settings.Properties.DropDownStyle = DropDownStyle.DropDown;
                                      
                                  })).BindList(ViewData["States"]).Render();
                            %></td>
                         <td class="blockTblTd">
                            <% Html.DevExpress().LabelFor(model => model.BillingContactZip,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                            <% Html.DevExpress().TextBoxFor(model => model.BillingContactZip,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                                  OrgName =>
                                  {
                                      //OrgName.Width = Unit.Percentage(91);
                                  })).Render();
                            %>
                        </td>
                       
                    </tr>
                  
                </table>
            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
        </tr>
        <tr class="AdditionalInfo">
            <td>
                <% Html.DevExpress().Label(lbl =>
                        {
                            lbl.Name = "AdditionalInfo_Lable";
                            lbl.Text = "Additional Info";
                            lbl.ControlStyle.CssClass = "OrgInfo_LableClass";
                        }).Render(); %>
                <table class="AdditionalInfoTable">
                    <tr>
                        <td class="blockTblTd">
                            <% Html.DevExpress().LabelFor(model => model.ContractDateSigned,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>

                            <% Html.DevExpress().DateEditFor(model => model.ContractDateSigned,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.DateEditSetting.DateEditSettingsMethodAdditional(
                                  ContractDate =>
                                  {
                                      ContractDate.Properties.DropDownButton.Image.Url = Url.Content("~/Images/icons/calenderIcon.png");
                                      ContractDate.Properties.ButtonStyle.Paddings.Padding = 0;
                                      ContractDate.Properties.ButtonStyle.CssClass = "calenderIcon";
                                      //ContractDate.Properties.ButtonStyle.Border.BorderWidth = 0;
                                      //ContractDate.Properties.ButtonStyle.BackColor = System.Drawing.ColorTranslator.FromHtml("#fff");

                                     // ContractDate.Width = Unit.Percentage(88);
                                      ContractDate.ControlStyle.CssClass = "OrgNameSeachboxCls";
                                  })).Render();
                            %>
                        </td>
                            <%--<td>
                            <% Html.DevExpress().LabelFor(model => model.OID,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                            <% Html.DevExpress().TextBoxFor(model => model.OID,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                                  OrgName =>
                                  {
                                      //OrgName.ClientEnabled = false;
                                      OrgName.Width = Unit.Percentage(91);
                                  })).Render();
                            %>
                            </td>--%>
                        
                        <td class="blockTblTd">
                            <% Html.DevExpress().LabelFor(model => model.IsETAR,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                            <%  Html.DevExpress().ComboBoxFor(model => model.IsETAR,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.ComboBoxSetting.ComboBoxSettingsMethodAdditional(
                                  OrgName =>
                                  {
                                      //OrgName.Width = Unit.Percentage(60);
                                      OrgName.Properties.ValueType = typeof(Boolean);
                                  })).BindList(ViewData["YesNo"]).Render();
                            %>
                        </td>
                         <td class="blockTblTd">
                            <% Html.DevExpress().LabelFor(model => model.ACN.IsAutoGenerate,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                            <%  Html.DevExpress().ComboBoxFor(model => model.ACN.IsAutoGenerate,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.ComboBoxSetting.ComboBoxSettingsMethodAdditional(
                                  OrgName =>
                                  {
                                      //OrgName.Width = Unit.Percentage(60);
                                      OrgName.Properties.ValueType = typeof(Boolean);
                                      OrgName.Properties.ClientSideEvents.TextChanged = "enableDisableACN";
                                  })).BindList(ViewData["YesNo"]).Render();
                            %>
                        </td>
                    </tr>
                    <tr>
                       
                        <td class="blockTblTd"><% Html.DevExpress().LabelFor(model => model.ACN.ACNFrom,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                                  <% Html.DevExpress().TextBoxFor(model => model.ACN.ACNFrom,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                                  OrgName =>
                                  {
                                      //OrgName.Name = "test";
                                      OrgName.Properties.ClientSideEvents.KeyPress = "KeyPress";
                                      OrgName.ControlStyle.CssClass = "ACNFROM";
                                     // OrgName.Width = Unit.Percentage(91);
                                  })).Render();
                                %>



                            <%--    <%       Html.DevExpress().DateEditFor(model => model.ACN.ACNFrom,
                               RISARC.Web.EBubble.Models.DevxControlSettings.DateEditSetting.DateEditSettingsMethodAdditional(
                               ContractDateSigned =>
                               {
                                   ContractDateSigned.Properties.DropDownButton.Image.Url = Url.Content("~/Images/icons/calenderIcon.png");
                                   ContractDateSigned.Properties.ButtonStyle.Paddings.Padding = 0;
                                   ContractDateSigned.Properties.ButtonStyle.Border.BorderWidth = 0;
                                   ContractDateSigned.Properties.ButtonStyle.BackColor = System.Drawing.ColorTranslator.FromHtml("#fff");
                                  // ContractDateSigned.Width = Unit.Percentage(88);
                                   ContractDateSigned.ControlStyle.CssClass = "OrgNameSeachboxCls";
                               })).Render();
                                %>--%>

                            </td>
                        <td class="blockTblTd"><% Html.DevExpress().LabelFor(model => model.ACN.ACNTo,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>

                                 <% Html.DevExpress().TextBoxFor(model => model.ACN.ACNTo,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                                  OrgName =>
                                  {
                                      OrgName.Properties.ClientSideEvents.KeyPress = "KeyPress";
                                      OrgName.ControlStyle.CssClass = "ACNTO";
                                     // OrgName.Width = Unit.Percentage(91);
                                  })).Render();
                            %>

                                <%--<%   Html.DevExpress().DateEditFor(model => model.ACN.ACNTo,
                               RISARC.Web.EBubble.Models.DevxControlSettings.DateEditSetting.DateEditSettingsMethodAdditional(
                               ContractDateSigned =>
                               {
                                   ContractDateSigned.Properties.DropDownButton.Image.Url = Url.Content("~/Images/icons/calenderIcon.png");
                                   ContractDateSigned.Properties.ButtonStyle.Paddings.Padding = 0;
                                   ContractDateSigned.Properties.ButtonStyle.Border.BorderWidth = 0;
                                   ContractDateSigned.Properties.ButtonStyle.BackColor = System.Drawing.ColorTranslator.FromHtml("#fff");
                                   
                                  // ContractDateSigned.Width = Unit.Percentage(88);
                                   ContractDateSigned.ControlStyle.CssClass = "OrgNameSeachboxCls";
                               })).Render();

                                %>--%>
                        </td>

                         <td class="blockTblTd"><% Html.DevExpress().LabelFor(model => model.SFTP,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                            <% Html.DevExpress().TextBoxFor(model => model.SFTP,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                                  OrgName =>
                                  {
                                     // OrgName.Width = Unit.Percentage(91);
                                  })).Render();
                            %></td>
                    </tr>
                 
                       <tr>
                         <td>
                             <% Html.DevExpress().LabelFor(model => model.IsReviewerForDHS,
                                   RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                             <%  Html.DevExpress().ComboBoxFor(model => model.IsReviewerForDHS,
                                      RISARC.Web.EBubble.Models.DevxControlSettings.ComboBoxSetting.ComboBoxSettingsMethodAdditional(
                                      settings =>
                                      {
                                          settings.Properties.ValueType = typeof(Boolean);
                                      })).BindList(ViewData["YesNo"]).Render();
                             %>
                         </td>
                         <td>
                             <% Html.DevExpress().LabelFor(model => model.DefaultReviewerProviderID,
                                   RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                             <%  Html.DevExpress().ComboBoxFor(model => model.DefaultReviewerProviderID,
                                      RISARC.Web.EBubble.Models.DevxControlSettings.ComboBoxSetting.ComboBoxSettingsMethodAdditional(
                                      settings =>
                                      {
                                          settings.Properties.ValueType = typeof(short);
                                      })).BindList(ViewData["ReviewersForDHS"]).Render();
                             %>
                         </td>
                            <td>&nbsp;&nbsp;</td>
                 </tr>


               

                </table>
            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
        </tr>
        <tr class="Invoicing">
            <td>
                <% Html.DevExpress().Label(lbl =>
                        {
                            lbl.Name = "Invoicing_Lable";
                            lbl.Text = "Invoicing";
                            lbl.ControlStyle.CssClass = "OrgInfo_LableClass";
                        }).Render(); %>

                <table class="InvoicingTable">
                    <tr>
                        <td class="blockTblTd">
                            <% Html.DevExpress().LabelFor(model => model.MinimumDocumentPrice,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                            <% Html.DevExpress().TextBoxFor(model => model.MinimumDocumentPrice,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                                  OrgName =>
                                  {
                                     // OrgName.Width = Unit.Percentage(91);
                                  })).Render();
                            %>
                        </td>
                        <td class="blockTblTd"><% Html.DevExpress().LabelFor(model => model.PricePerDocumentPage,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                            <% Html.DevExpress().TextBoxFor(model => model.PricePerDocumentPage,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                                  OrgName =>
                                  {
                                    //  OrgName.Width = Unit.Percentage(91);
                                  })).Render();
                            %></td>

                        <td class="blockTblTd"><% Html.DevExpress().LabelFor(model => model.PricePerDocumentMegabyte,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                            <% Html.DevExpress().TextBoxFor(model => model.PricePerDocumentMegabyte,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                                  OrgName =>
                                  {
                                     // OrgName.Width = Unit.Percentage(91);
                                  })).Render(); %></td>
                    </tr>

                    <tr>
                        <td class="blockTblTd">
                            <% Html.DevExpress().LabelFor(model => model.ROIMinimumDocumentPrice,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>

                            <% Html.DevExpress().TextBoxFor(model => model.ROIMinimumDocumentPrice,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                                  OrgName =>
                                  {
                                     // OrgName.Width = Unit.Percentage(91);
                                  })).Render(); %>
                        </td>
                        <td class="blockTblTd"><% Html.DevExpress().LabelFor(model => model.ROIPricePerDocumentPage,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                            <% Html.DevExpress().TextBoxFor(model => model.ROIPricePerDocumentPage,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                                  OrgName =>
                                  {
                                    //  OrgName.Width = Unit.Percentage(91);
                                  })).Render(); %></td>
                        <td class="blockTblTd"><% Html.DevExpress().LabelFor(model => model.ROIPricePerDocumentMegabyte,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                            <% Html.DevExpress().TextBoxFor(model => model.ROIPricePerDocumentMegabyte,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.TextBoxSetting.TextBoxSettingsMethodAdditional(
                                  OrgName =>
                                  {
                                   //   OrgName.Width = Unit.Percentage(91);
                                  })).Render();
                            %></td>
                    </tr>
                    <tr>
                        <td class="blockTblTd">
                            <% Html.DevExpress().LabelFor(model => model.PaymentReceivedEnabled,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                            <% Html.DevExpress().ComboBoxFor(model => model.PaymentReceivedEnabled,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.ComboBoxSetting.ComboBoxSettingsMethodAdditional(settings =>
                                  {
                                      settings.Properties.ValueType = typeof(Boolean);
                                  })).BindList(ViewData["YesNo"]).Render();
                            %>
                        </td>
                        <td class="blockTblTd">
                            <% Html.DevExpress().LabelFor(model => model.CanSendFreeDocuments,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                            <%  Html.DevExpress().ComboBoxFor(model => model.CanSendFreeDocuments,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.ComboBoxSetting.ComboBoxSettingsMethodAdditional(settings =>
                                  {
                                      settings.Properties.ValueType = typeof(Boolean);
                                  })).BindList(ViewData["YesNo"]).Render();
                            %></td>
                        <td class="blockTblTd">
                            <% Html.DevExpress().LabelFor(model => model.CanBeInvoiced,
                               RISARC.Web.EBubble.Models.DevxControlSettings.LabelSetting.LabelSettingsMethod).Render(); %>
                            <% Html.DevExpress().ComboBoxFor(model => model.CanBeInvoiced,
                                  RISARC.Web.EBubble.Models.DevxControlSettings.ComboBoxSetting.ComboBoxSettingsMethodAdditional(settings =>
                                  {
                                      settings.Properties.ValueType = typeof(Boolean);
                                  })).BindList(ViewData["YesNo"]).Render();
                            %></td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>

                 <div class="viewerActionBtnADetails">
                                <div class="floatLeft">
                                    <% Html.DevExpress().Button(
                                   RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                                   settings =>
                                   {
                                       settings.Name = "SaveButton";
                                       settings.Height = 32;
                                       settings.Width = 83;
                                       settings.ControlStyle.CssClass = "orangeBtn";
                                     //  settings.ClientSideEvents.Click = "AddOrgSaveButtonClick";
                                       settings.Text = "Save";

                                   })).GetHtml(); %>
                                </div>

                                <div class="floatRight">
                                    <% Html.DevExpress().Button(
                                   RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                                   settings =>
                                   {
                                       settings.Name = "CancelButton";
                                       settings.Height = 32;
                                       settings.Width = 83;
                                       settings.ControlStyle.CssClass = "greyBtn";
                                       settings.UseSubmitBehavior = false;
                                       settings.Text = "Cancel";
                                       settings.RouteValues = new { Controller = "ProviderAdmin", Action = "ManageProvider" };
                                       
                                   })).GetHtml(); %>

                                </div>
                            </div>

            </td>
        </tr>
    </table>
     </div>

    <% } %>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">

 <script type="text/javascript">

     $(document).ready(function () {



         if ((location.search != "") || ($("#EditFlag").val() != "")) {
             $(".SuperAdmin_AddOrg").show();

         }

         EnableOidTxtBox($("#OrganizationType_I").val());
     });

     function OrgNameChanged(s, e) {
         var OrgNameValue = s.GetValue();

         //enable button now 
         $("#EditOrg").removeClass("disableOrangeBtn").addClass("orangeBtn");
         EditOrg.SetEnabled(true);

         $("#SelectedOrgName").val(OrgNameValue);


     }
     function OrgTypeChanged(s, e) {
         var orgType = s.GetValue();

         EnableOidTxtBox(orgType);
     }

     function EnableOidTxtBox(orgType) {

         if (orgType.toLowerCase() == "esmd") {

             OID.SetEnabled(true);
             $("#OID").addClass("enableTextBox").removeClass("disabledTextBox");
             $("#OID_I").addClass("enableTextBox").removeClass("disabledTextBox");
             
         }
         else {
             OID.SetEnabled(false);
             $("#OID").addClass("disabledTextBox").removeClass("enableTextBox");
             $("#OID_I").addClass("disabledTextBox").removeClass("enableTextBox");
         }
     }
     function AddNewOrgClick() {
         $(".SuperAdmin_AddOrg").show();

         if ((location.search != "")) {

             window.location.assign(window.location.pathname + "?fe=1");
             $(".SuperAdmin_AddOrg").show();
         }


     }

     function EditOrgClick() {
         if ($("#SelectedOrgName").val() != "") {
             $(".error").hide();
             //  loadingPanelEditOrg.Show();
             window.location.assign(window.location.pathname + "?Id=" + $("#SelectedOrgName").val());
         }// If Ends 

         $(".error").html("* Please select at least one orgnization name to edit.");
         return false;

     }//fnction ends 

     function enableDisableACN(s,e){
         debugger;
         if (s.GetValue()) {
             OID.SetEnabled(true);
            ACN.ACNFrom.SetEnabled(true);
             $("#ACN.ACNFrom").addClass("clsdexTextBox").removeClass("disabledTextBox");
             $("#ACN.ACNFrom_I").addClass("clsdexTextBox").removeClass("disabledTextBox");

         } else {
             //ACN.ACNFrom.SetEnabled(false);
             $("#ACN.ACNFrom").addClass("clsdexTextBox").removeClass("enableTextBox");
             $("#ACN.ACNFrom_I").addClass("clsdexTextBox").removeClass("enableTextBox");
            
        }
        
       
         

     
     }

     function KeyPress(s, e) {
         var theEvent = e.htmlEvent || window.event;
         var key = theEvent.keyCode || theEvent.which;
         key = String.fromCharCode(key);
         var regex = /[0-9]|\./;

         if (!regex.test(key)) {
             alert("Please enter Numeric Value.");
             theEvent.returnValue = false;
             if (theEvent.preventDefault)
                 theEvent.preventDefault();
         }
     }
     //function AddOrgSaveButtonClick() {

     //}

     function CheckSameContactInfo(s, e) {

         if (SameContactInfo.GetValue()) {
             BillingContactName.SetValue(ContactName.GetValue()); //Sets the text
             BillingContactPhone.SetValue(ContactPhone.GetValue()); //Sets the text
             BillingContactEmail.SetValue(ContactEmail.GetValue()); //Sets the text

         } else {
             BillingContactName.SetValue(""); //Sets the text
             BillingContactPhone.SetValue(""); //Sets the text
             BillingContactEmail.SetValue(""); //Sets the text
         }

     }


     function CheckSameOrgInfo(s, e) {


         if (SameOrgInfo.GetValue()) {
             BillingContactStreetAddress.SetValue(StreetAddress.GetValue()); //Sets the text
             BillingContactCountry.SetValue(Country.GetValue()); //Sets the text
             BillingContactState.SetValue(State.GetValue()); //Sets the text
             BillingContactCity.SetValue(City.GetValue()); //Sets the text
             BillingContactZip.SetValue(Zip.GetValue()); //Sets the text

         } else {
             BillingContactStreetAddress.SetValue(""); //Sets the text
             BillingContactCountry.SetValue(""); //Sets the text
             BillingContactState.SetValue(""); //Sets the text
             BillingContactCity.SetValue(""); //Sets the text
             BillingContactZip.SetValue(""); //Sets the text
         }

     }




    </script>
</asp:Content>
