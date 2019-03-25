using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RISARC.Documents.Model;
using System.Collections.Specialized;
using RISARC.Documents.Model.PatientIdentification;
using System.Reflection;
using RISARC.Encryption.Service;

namespace RISARC.Web.EBubble.Models.Binders
{
    public class PatientIdentificationMethodsBinder : DefaultModelBinder
    {
        public override object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext)
        {
            PatientIdentificationMethods patientIdentificationMethods;
            NameValueCollection form;
            string typeName;
            string baseModelName;

            // bind base as patient identification methods
            patientIdentificationMethods = base.BindModel(controllerContext, bindingContext) as PatientIdentificationMethods;
            form = controllerContext.HttpContext.Request.Form;
            baseModelName = bindingContext.ModelName;
            
            // problem with normal binding, is that it binds all identification methods, even if checkbox for patient identification 
            // wasnt checked and no values were entered for that identification method.
            // find all identification methods that didn't have a check box checked, and set those to null.
            foreach (Type identificationType in PatientIdentificationFactory.GetAllPatientIdentificationTypes())
            {
                typeName = identificationType.Name;
                if (form[typeName] == null)
                {
                    patientIdentificationMethods.RemoveIdentificationOfType(identificationType);
                }
                else
                {
                    //set optional check for DOB verification
                    if (typeName.Equals(typeof(DateOfBirthIdentification).Name))
                    {
                        patientIdentificationMethods.DateOfBirthIdentification.IsDOBVerificationRequired = (form["DateOfBirthIdentificationOption"] != null);
                    }
                }
            }

            return patientIdentificationMethods;
        }
    }
}
