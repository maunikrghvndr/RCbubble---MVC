using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RISARC.Documents.Model.PatientIdentification;
using System.Reflection;

namespace RISARC.Web.EBubble.Models.Binders
{
    public class APatientIdentificationMethodBinder : DefaultModelBinder
    {
        #region IModelBinder Members

        public override object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext)
        {
            string typeKey = bindingContext.ModelName + ".Type";
            string identificationTypeName = GetValue<string>(bindingContext, typeKey);

            APatientIdentification tempPatientIdentification =
                Activator.CreateInstance(Assembly.GetAssembly(typeof(APatientIdentification)).GetName().FullName, 
                identificationTypeName).Unwrap() as APatientIdentification;

            

            return (tempPatientIdentification);
        }

        private T GetValue<T>(ModelBindingContext bindingContext, string key)
        {
            ValueProviderResult valueResult;
            bindingContext.ValueProvider.GetValue(key);
            // bindingContext.ModelState.TryGetValue(key,out valueResult );
            valueResult = bindingContext.ValueProvider.GetValue(key);
            return (T)valueResult.ConvertTo(typeof(T));
        }
        #endregion
    }
}
