using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Ajax;
using RISARC.Documents.Model;
using RISARC.Documents.Service;
using RISARC.Documents.Model.PatientIdentification;
using System.Collections.ObjectModel;
using RISARC.Web.EBubble.Models.Binders;
using SpiegelDg.Security.Model;

namespace RISARC.Web.EBubble.Controllers
{
    public class PatientIdentificationController : Controller
    {
        private IUserDocumentsService _UserDocumentsService;

        public PatientIdentificationController(IUserDocumentsService userDocumentsService)
        {
            this._UserDocumentsService = userDocumentsService;
        }

        ///// <summary>
        ///// Gets next identification option.  If for existing document, then uses the possible options for the document.
        ///// Otherwise, uses all possible options
        ///// </summary>
        ///// <param name="currentOptionTypeName"></param>
        ///// <param name="identificationShouldBeKnown">If identification should be known by whoever is filling out identification</param>
        ///// <param name="documentId"></param>
        ///// <returns></returns>
        //public ActionResult NextPatientIdentificationOption(string currentOptionTypeName, bool identificationShouldBeKnown, int? documentId)
        //{
        //    string nextOptionName;
        //    APatientIdentification emptyIdentification;
            
        //    nextOptionName = GetNextPatientIdentificationTypeName(currentOptionTypeName, documentId);

        //    // will be null if no options left
        //    if (string.IsNullOrEmpty(nextOptionName))
        //    {
        //        ViewData["LastOptionReached"] = true;
        //        emptyIdentification = null;
        //    }
        //    else
        //    {
        //        ViewData["LastOptionReached"] = false;
        //        emptyIdentification = GenerateIdentificationForTypeName(nextOptionName);
        //    }

        //    return PatientIdentificationOption(emptyIdentification, identificationShouldBeKnown);
            
        //}

        //public ActionResult PatientIdentificationOption(APatientIdentification patientIdentification, bool identificationShouldBeKnown)
        //{
        //    ViewData["IdentificationShouldBeKnown"] = identificationShouldBeKnown;
        //    return View("PatientIdentificationOption", patientIdentification);
        //}


         

        ///// <summary>

        [AuditingAuthorizeAttribute("ShowPatientIdentification", Roles = "DocumentAdmin")]
        public ViewResult ShowPatientIdentification(APatientIdentification identificationToShow)
        {
            return View(identificationToShow);
        }

        ///// <summary>
        ///// 
        ///// </summary>
        ///// <param name="currentOptionTypeName"></param>
        ///// <param name="documentId"></param>
        ///// <returns>Next option; returns null if this is last option</returns>
        //private string GetNextPatientIdentificationTypeName(string currentOptionTypeName, int? documentId)
        //{
        //    IList<string> identificationOptionNames;
        //    string nextOptionName;
        //    int currentOptionIndex;
        //    int nextOptionIndex;

        //    // get all identification options, if for document or not.
        //    // if no current option, then use first option.
        //    // if there is one, 
        //    // if it's last option, then set to null.
        //    // otherwise, use next option

        //    identificationOptionNames = _UserDocumentsService.GetPossibleIdentificationMethods(documentId);

        //    if (identificationOptionNames.Count == 0)
        //        throw new InvalidOperationException("No identification options exist for document.");

        //    if (String.IsNullOrEmpty(currentOptionTypeName))
        //        nextOptionName = identificationOptionNames[0];
        //    else
        //    {
        //        currentOptionIndex = identificationOptionNames.IndexOf(currentOptionTypeName);

        //        if (currentOptionIndex == identificationOptionNames.Count - 1)
        //            nextOptionName = null;
        //        else
        //        {
        //            nextOptionIndex = currentOptionIndex + 1;
        //            nextOptionName = identificationOptionNames[nextOptionIndex];
        //        }
        //    }

        //    return nextOptionName;
        //}


        private APatientIdentification GenerateIdentificationForTypeName(string typeName)
        {
            APatientIdentification patientIdentification;

            patientIdentification = PatientIdentificationFactory.GenerateEmptyPatientIdentification(typeName);

            //switch (typeName)
            //{
            //    case "AccountNumberIdentification":
            //        patientIdentification = new AccountNumberIdentification();
            //        break;
            //    case "SSNIdentification":
            //        patientIdentification = new SSNIdentification();
            //        break;
            //    case "MedicalRecordNoIdentification":
            //        patientIdentification = new MedicalRecordNoIdentification();
            //        break;
            //    default:
            //        throw new ArgumentException("Unknown type name of " + typeName + ".", "typeName");

            //}

            return patientIdentification;
        }

        //[AcceptVerbs(HttpVerbs.Get)]
        //public ViewResult TestPatientIdentificationMethods()
        //{
        //    IList<APatientIdentification> patientIdentifications;

        //    patientIdentifications = new Collection<APatientIdentification>()
        //    {
        //        { new SSNIdentification { SSN = "1111"}},
        //        { new AccountNumberIdentification ()},
        //    };

        //    return View(patientIdentifications);
        //}




    }
}
