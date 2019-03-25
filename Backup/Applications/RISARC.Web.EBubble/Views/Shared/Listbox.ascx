<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IEnumerable<SelectListItem>>" %>
<% IDictionary<string, object> htmlAttributes = new Dictionary<string, object>();
   string className = ViewData.GetValue(GlobalViewDataKey.ClassName) as string;
   if (!String.IsNullOrEmpty(className))
       htmlAttributes.Add("class",  className);
//    bool? isDiabled = ViewData.GetValue(GlobalViewDataKey.Disabled) as bool?;
//    if(isDiabled.HasValue)
//        if(isDiabled.Value)
//            htmlAttributes.Add("disabled", "disabled");
   //         htmlAttributes.Add("onchange", "TestType(this);");
    //       htmlAttributes.Add("onchange", "this.form.submit();"); 
   htmlAttributes.Add("onchange", "return changeHandler();");
   //htmlAttributes.Add("onclick", "return changeHandler();");
   htmlAttributes.Add("onmouseup", "return changeHandler();");
   //htmlAttributes.Add("onafter", "return changeHandler();");
   //htmlAttributes.Add("MULTIPLE SIZE", "5");
    htmlAttributes.Add("SIZE", "6");
    %>

    <%= Html.ListBox(ViewData.GetValue(GlobalViewDataKey.FieldName).ToString(), Model, htmlAttributes) %>

   