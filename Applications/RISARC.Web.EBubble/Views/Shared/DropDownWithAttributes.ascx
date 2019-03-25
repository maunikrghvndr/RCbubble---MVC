<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IEnumerable<SelectListItem>>" %>
<% IDictionary<string, object> htmlAttributes = new Dictionary<string, object>();
   string className = ViewData.GetValue(GlobalViewDataKey.ClassName) as string;
   if (!String.IsNullOrEmpty(className))
   {
       htmlAttributes.Add("class", className);
   }
   htmlAttributes.Add("onchange", "ProcessOnChange(this)");

    bool? isDiabled = ViewData.GetValue(GlobalViewDataKey.Disabled) as bool?;
    if(isDiabled.HasValue)
        if(isDiabled.Value)
            htmlAttributes.Add("disabled", "disabled");
    %>
<%= Html.DropDownList(ViewData.GetValue(GlobalViewDataKey.FieldName).ToString(),
    Model,
    ViewData.GetValue(GlobalViewDataKey.OptionText) as string,
    htmlAttributes) %>
