<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Web.EBubble.Models.DevxCommonModels.DevExpressComboModel>" %>
<% if(Model != null) {
       string SelectedVal = null;
       if (Model.Items != null && Model.Items.Count() > 0)
       {
           var SelectedItem = Model.Items.Where(x => x.Selected == true).ToList();
           foreach (var item in SelectedItem)
           {
               SelectedVal = item.Text;
           }
       }
       %>
    <%= Html.DevExpress().ComboBox(Model.cmbSettings).BindList(Model.Items).Bind(SelectedVal).GetHtml() %>
<%} %>