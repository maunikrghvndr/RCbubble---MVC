using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RISARC.Documents.Model;
using System.Collections.Specialized;
using System.Reflection;
using RISARC.Encryption.Service;
using RISARC.Documents.Model.PatientIdentification;
using SpiegelDg.Common.Extensions;
using SpiegelDg.Common.Utilities;
using SpiegelDg.Common.DataTypes;

namespace RISARC.Web.EBubble.Models.Binders
{
    /// <summary>
    /// Binds according to hidden field that has identification type name, and returns
    /// correct version of identification, bound to the fields
    /// </summary>
    public class PatientIdentificationBinder : DefaultModelBinder
    {
        public override object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext)
        {
            APatientIdentification identification;
            NameValueCollection form;
            //string encryptedElementTypeName;
            string elementTypeName;
            string fullTypeName;
            Type patientIdentificationType;
            //APatientIdentification tempIdentification;


            form = controllerContext.HttpContext.Request.Form;

            elementTypeName = form["PatientIdentificationTypeName"];
            if (!String.IsNullOrEmpty(elementTypeName))
            {
                fullTypeName = typeof(APatientIdentification).Namespace + "." + elementTypeName;
                patientIdentificationType = Assembly.GetAssembly(typeof(APatientIdentification)).GetType(fullTypeName);

                identification = BindModel(patientIdentificationType, null, form);
            }
            else
                identification = null;

            return identification;
        }

        public static APatientIdentification BindModel(Type patientIdentificationType, string bindingPrefix, NameValueCollection form)
        {
            APatientIdentification patientIdentification = null;
            bool success;
            string prefix;

            if (!String.IsNullOrEmpty(bindingPrefix))
                prefix = bindingPrefix + '.';
            else
                prefix = "";

            //Get selected date time
            string selectedDate = form[prefix + "DateOfBirthIdentification.DateOfBirthCalender"];

            if (patientIdentificationType == typeof(AccountNumberIdentification))
            {
                var AccountNoFrom = form[prefix + "AccountNumberIdentification.AccountDateOfServiceFrom"] == "MM/dd/yyyy" ? (DateTime?)null : Convert.ToDateTime(form[prefix + "AccountNumberIdentification.AccountDateOfServiceFrom"]);
                var AccountNoTo = form[prefix + "AccountNumberIdentification.AccountDateOfServiceTo"] == "MM/dd/yyyy" ? (DateTime?)null : Convert.ToDateTime(form[prefix + "AccountNumberIdentification.AccountDateOfServiceTo"]);

                patientIdentification = new AccountNumberIdentification
                {
                    AccountNumber = form[prefix + "AccountNumberIdentification.AccountNumber"],
                    AccountDateOfServiceFrom = AccountNoFrom,
                    AccountDateOfServiceTo = AccountNoTo
                };
            }
            else if (patientIdentificationType == typeof(SSNIdentification))
            {
                string ssn = form[prefix + "SSNIdentification.SSN"];
                // get last 4 ssn if ssn properly entered
                string ssnLast4 = null;
                if (!String.IsNullOrEmpty(ssn))
                    if (ssn.Length == 9)
                    {
                        ssnLast4 = ssn.Substring(5, 4);
                    }

                patientIdentification = new SSNIdentification
                {
                    SSN = ssn,
                    SSNLast4 = ssnLast4,
                    DateOfServiceFrom = form[prefix + "SSNIdentification.DateOfServiceFrom"].TryParseDateTime(out success),
                    DateOfServiceTo = form[prefix + "SSNIdentification.DateOfServiceTo"].TryParseDateTime(out success),
                };
            }
            else if (patientIdentificationType == typeof(MedicalRecordNoIdentification))
            {
                patientIdentification = new MedicalRecordNoIdentification
                {
                    MedicalRecordNumber = form[prefix + "MedicalRecordNoIdentification.MedicalRecordNumber"],
                    DateOfServiceFrom = form[prefix + "MedicalRecordNoIdentification.DateOfServiceFrom"].TryParseDateTime(out success),
                    DateOfServiceTo = form[prefix + "MedicalRecordNoIdentification.DateOfServiceTo"].TryParseDateTime(out success),
                };
            }
            else if (patientIdentificationType == typeof(DateOfBirthIdentification))
            {
                patientIdentification = new DateOfBirthIdentification()
                {
                    DateOfBirthCalender = !string.IsNullOrEmpty(selectedDate) ? Convert.ToDateTime(selectedDate) : (DateTime?)null
                };
            }
            else throw new ArgumentException("Unknown patient identification type of " + patientIdentificationType.FullName + ".", "patientIdentificationType");
            
            return patientIdentification;
        }

    }
}
