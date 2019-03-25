<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>


<div class="questionblock">
    <span class="redText">*</span> <span class="user-generated "><%= Model.QDescription %></span>
    <input type="hidden" name="questionID" id="questionID" value="<%= Model.QId %>" />
</div>


<%if (!string.IsNullOrEmpty(Model.PopulatedDate.ToString()))
  {

       Html.DevExpress().DateEdit( 
 RISARC.Web.EBubble.Models.DevxControlSettings.DateEditSetting.DateEditSettingsMethodAdditional(settings => {
     settings.Name = "SelectDateValue";
     settings.Width = Unit.Percentage(15);
 })).Bind(Model.PopulatedDate).GetHtml();
      
  }else { 

   Html.DevExpress().DateEdit( 
     RISARC.Web.EBubble.Models.DevxControlSettings.DateEditSetting.DateEditSettingsMethodAdditional(settings => {
     settings.Name = "SelectDateValue";
     settings.Width = Unit.Percentage(15);

     if (!string.IsNullOrEmpty(Model.MinVal) && !string.IsNullOrEmpty(Model.MaxVal)) {
         settings.Properties.MaxDate = DateTime.ParseExact(Model.MinVal, "MM-dd-yyyy", System.Globalization.CultureInfo.InvariantCulture);
         settings.Properties.MaxDate = DateTime.ParseExact(Model.MaxVal, "MM-dd-yyyy", System.Globalization.CultureInfo.InvariantCulture);
     }
         
    })).GetHtml(); 
  } %>
<input type="hidden" class="NextQuestionFlag" name="NextQuestionFlag" value="<%=  Model.Options[0].HasNext%>" >