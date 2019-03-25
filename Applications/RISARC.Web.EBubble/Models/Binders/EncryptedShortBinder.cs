using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace RISARC.Web.EBubble.Models.Binders
{
    public class EncryptedShortBinder : EncryptedIntegerBinder
    {
        public override object BindModel(System.Web.Mvc.ControllerContext controllerContext, System.Web.Mvc.ModelBindingContext bindingContext)
        {
            object valueToReturn;

            object modelValue;
            // gets base binded model as int 32, and converts to int 16
            modelValue = base.BindModel(controllerContext, bindingContext);

            if (modelValue == null)
                valueToReturn = null;
            else
            {
                valueToReturn = Convert.ToInt16(modelValue);
            }

            return valueToReturn;
        }
    }
}
