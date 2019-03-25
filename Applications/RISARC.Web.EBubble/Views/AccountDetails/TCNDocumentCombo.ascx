<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<%
    
    Html.DevExpress().ComboBox(
    settings =>
    {
        settings.Name = "DocumentType";
        settings.ControlStyle.CssClass = "AllScanedDoc";
        settings.Width = System.Web.UI.WebControls.Unit.Percentage(96);
        if (ViewData["Defaultselection"] != null && Convert.ToInt32(ViewData["Defaultselection"]) == 1)
        {
            settings.SelectedIndex = 0;
        }
 
       // settings.Properties.DropDownWidth = 550;
        settings.Properties.DropDownStyle = DropDownStyle.DropDownList;
        settings.CallbackRouteValues = new { Controller = "AccountDetails", Action = "TCNDocumentCombo", AccountSubmissionDetailsID = Model.AccountSubmissionDetailsID, SenderProviderID = Model.SenderProviderID, TCNNo = Model.TCNNo};
        settings.Properties.CallbackPageSize = 30;
        settings.Properties.IncrementalFilteringMode = IncrementalFilteringMode.StartsWith;
        settings.Properties.TextFormatString = "{0}";
        settings.Properties.ValueField = "DocumentID";
        settings.Properties.ValueType = typeof(string);

        settings.Properties.Columns.Add("DocumentTypeName", "Doc Type Name", 20);
        //settings.Properties.Columns.Add("DocumentFileID", "DocumentFileID", 20).Visible = true;
        settings.Properties.Columns.Add("ExternalFileName", "Ext File Name", 20);
        settings.Properties.Columns.Add("TCNNumber", "TCN #", 15);
        settings.Properties.EnableClientSideAPI = true;
        settings.Properties.NullText = "Please Select a value";

        settings.Properties.DropDownButton.Image.Url = @Url.Content("~/Images/icons/dropdown_button.png");
        settings.Properties.ButtonStyle.Border.BorderWidth = 0;
        settings.Properties.ButtonStyle.Paddings.Padding = 0;
        settings.Properties.ButtonStyle.CssClass = "dropdownButton";
        
        //settings.Properties.ClientSideEvents.EndCallback = "DocumentComboBoxInit";
        //settings.Properties.ClientSideEvents.Init = "DocumentComboBoxInit";
        settings.Properties.ClientSideEvents.SelectedIndexChanged = "function(s, e){ SelectPageComboBox(s, e)}";
        
    }
).BindList(Model.tcnDocumentType).GetHtml();
 
%>