using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Ajax;
using RISARC.Documents.Service;
using RISARC.Common.Model;
using RISARC.Web.EBubble.Models.Binders;
using RISARC.Payment.Service;
using RISARC.Payment.Model;
using RISARC.Documents.Model.Payment;
using RISARC.Emr.Web.DataTypes;
using RISARC.Encryption.Service;
using SpiegelDg.Security.Model;
using SpiegelDg.Common.Validation;
using SpiegelDg.Common.Web.Extensions;
using Castle.DynamicProxy.Generators.Emitters.SimpleAST;
using System.Linq.Expressions;

namespace RISARC.Web.EBubble.Controllers
{
    public class DocumentPaymentController : Controller
    {
        private IUserDocumentsService _UserDocumentsService;
        //private ICreditCardPaymentService _CreditCardPaymentService;
        //
        // GET: /DocumentPayment/

        public DocumentPaymentController(IUserDocumentsService userDocumentsService/*, ICreditCardPaymentService creditCardPaymentService*/)
        {
            this._UserDocumentsService = userDocumentsService;
            //this._CreditCardPaymentService = creditCardPaymentService;
        }

        

        

        

    }
}
