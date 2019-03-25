using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Collections.Specialized;

namespace RISARC.Web.EBubble.Models.Binders
{
    /// <summary>
    /// For binding date time
    /// </summary>
    public class DateTimeModelBinder : IModelBinder
    {
        public object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext)
        {
            DateTime value;
            string key = bindingContext.ModelName;
            //ValueProviderResult val = bindingContext.ValueProvider[key];
            ValueProviderResult val = bindingContext.ValueProvider.GetValue(key);
            if ((val != null) && !string.IsNullOrEmpty(val.AttemptedValue))
            {
                // try parsing value.  if cannot, add error message
                if (!DateTime.TryParse(val.AttemptedValue, out value))
                    bindingContext.ModelState.AddModelError(key, "Invalid format for date");
            }
            else
                // No value was found in the request
                value = default(DateTime);

            return value;
        }
    }
}
