using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace RISARC.Web.EBubble.Models.Binders
{
    public class IntegerBinder : IModelBinder
    {
        public object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext)
        {
            int value;
            string key = bindingContext.ModelName;
            ValueProviderResult val = bindingContext.ValueProvider.GetValue(key);
            if ((val != null) && !string.IsNullOrEmpty(val.AttemptedValue))
            {
                // try parsing value.  if cannot, add error message
                if (!Int32.TryParse(val.AttemptedValue, out value))
                    bindingContext.ModelState.AddModelError(key, "*Invalid integer");
            }
            else
                // No value was found in the request
                value = default(int);

            return value;
        }
    }
}
