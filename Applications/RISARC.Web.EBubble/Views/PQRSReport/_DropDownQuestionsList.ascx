<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>



<div class="questionblock">
    <span class="redText">*</span> <span class="user-generated "><%= Model.QDescription %></span>
    <input type="hidden" name="questionID" id="questionID" value="<%= Model.QId %>" />
   
</div>

<%
    int i = 0;
    int selectedIndex=0;
    foreach (var option in Model.Options)
    {
        if (option.IsSelected) {
            selectedIndex = i;
        }
        i++;
    }
   
     %>

 <%= Html.DevExpress().ComboBox(RISARC.Web.EBubble.Models.DevxControlSettings.ComboBoxSetting.ComboBoxSettingsMethodAdditional(
    settings => {
        settings.Name = "cmbSelectValue";
        settings.Properties.TextField = "Description";
        settings.Properties.ValueField = "OId";
        settings.Properties.ValueType = typeof(Int64);
        settings.ControlStyle.CssClass = "AllScanedDoc";
        settings.Width = Unit.Percentage(45);
        settings.Properties.ClientSideEvents.SelectedIndexChanged = "cmbGetSelectedOptionValue";
      //  if (selectedIndex != 0)
       // {
            settings.SelectedIndex = selectedIndex;
        //}
    }
)).BindList(Model.Options).GetHtml() %>

<input type="hidden" name="cmbSelectValue" id="cmbSelectValue" value=" " />
  <input type="hidden" class="NextQuestionFlag" name="NextQuestionFlag" value="<%= Model.Options[0].HasNext %>" > 