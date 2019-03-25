using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Ajax;
using SpiegelDg.Security.Implementation.Repository;
using SpiegelDg.Security.Service;
using Microsoft.Practices.EnterpriseLibrary.Security;

namespace RISARC.Web.EBubble.Controllers
{
    public class UserController : Controller
    {
        private ITokenGrabbingService _TokenGrabbingService;
        private ITokenRepository _TokenRepository;
        //
        // GET: /User/

        public UserController(ITokenGrabbingService tokenGrabbingService,
            ITokenRepository tokenRepository)
        {
            this._TokenGrabbingService = tokenGrabbingService;
            this._TokenRepository = tokenRepository;
        }
        // add by Michael Bert
        [HttpPost]
        public JsonResult KeepSessionAlive()
        {
            return new JsonResult { Data = "Success" };
        }

        /// <summary>
        /// Check whether the token is valid using session variables.
        /// </summary>
        /// <returns>Ture/False (JsonResult)</returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 01/06/2014 | Gurudatta   | Modified
        /// </RevisionHistory>
        public JsonResult CheckSessionIsActive()
        {
            bool sessionIsActive;
            //Guru: check whether the token is valid using session variables.
            sessionIsActive = (_TokenRepository.IsValidToken);
            return new JsonResult
            {
                Data = new { sessionIsActive = sessionIsActive }
            };            
        }

        /// <summary>
        /// Get the token expiration time.
        /// </summary>
        /// <returns>Ture/False (JsonResult)</returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 01/06/2014 | Gurudatta   | Modified
        /// </RevisionHistory>
        [AcceptVerbs("GET")]
        public JsonResult GetTokenExpirationTime()
        {
            int tokenExpirationTime = _TokenRepository.TokenExpirationTime;
            return new JsonResult
            {
                Data = new
                {

                    expirationTime = tokenExpirationTime
                },
                JsonRequestBehavior = JsonRequestBehavior.AllowGet
            };
        }

        private string GetUserNameFromToken()
        {
            string userName;
            IToken token;

            if (!Request.IsAuthenticated)
                userName = null;
            else
            {
                token = _TokenGrabbingService.GetToken();
                userName = _TokenRepository.GetUserFromToken(token, false); // second argument is false to prevent token from being refreshed.
            }

            return userName;
        }

    }
}
