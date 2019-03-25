<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.eTAR.Model.AccountDetailsMain>" %>
<%  
    RISARC.eTAR.Model.DocumentType Dummy = new RISARC.eTAR.Model.DocumentType();
    //Dt.DocumentID = -1;
    Dummy.DocumentTypeName = "--- Show all Documents ---";
    Dummy.DocumentTypeID = -1;
    Model.DocumentTypeList.Add(Dummy);
  var combo =Html.DevExpress().ComboBox(
            ComboBoxSettings =>
            {
                ComboBoxSettings.Name = "selectDocumentType";
                ComboBoxSettings.ControlStyle.CssClass = "AllScanedDoc";
                ComboBoxSettings.Width = System.Web.UI.WebControls.Unit.Percentage(100);
                //ComboBoxSettings.SelectedIndex = 0;
                ComboBoxSettings.Properties.IncrementalFilteringMode = IncrementalFilteringMode.StartsWith;
                ComboBoxSettings.Properties.DropDownStyle = DropDownStyle.DropDown;
                ComboBoxSettings.Properties.TextField = "DocumentTypeName";
                ComboBoxSettings.Properties.ValueField = "DocumentTypeID";
                ComboBoxSettings.Properties.NullText = "Select Document Type";
                ComboBoxSettings.ToolTip = "Select the document type filter";
                                                   
                ComboBoxSettings.Properties.DropDownButton.Image.Url = @Url.Content("~/Images/icons/dropdown_button.png");
                ComboBoxSettings.Properties.ButtonStyle.Border.BorderWidth = 0;
                ComboBoxSettings.Properties.ButtonStyle.Paddings.Padding = 0;
                ComboBoxSettings.Properties.ButtonStyle.CssClass = "dropdownButton";
                                                    
                //for manipulation of grid on selection of organization
                ComboBoxSettings.Properties.EnableClientSideAPI = true;
                ComboBoxSettings.Properties.ClientSideEvents.SelectedIndexChanged = "OnSelectionGetDocTypeID";
                ComboBoxSettings.CallbackRouteValues = new { Controller = "AccountDetails", Action = "RMSDocumentsCombo", TCNNo = Model.TCNNo, AccountSubmissionDetailsID = Model.AccountSubmissionDetailsID, SenderProviderID = Model.SenderProviderID,Model.DocumentFileID };
            }).BindList(Model.DocumentTypeList).GetHtml();
%>
