using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Ajax;
using RISARC.Membership.Service;
using RISARC.Membership.Implementation.Service;
using RISARC.Membership.Model;
using SpiegelDg.Common.Validation;
using SpiegelDg.Common.Web.Extensions;
using RISARC.Web.EBubble.Models.Binders;
using System.Web.Security;
using System.Security.Principal;
using RISARC.Emr.Web.DataTypes;
using SpiegelDg.Security.Model;
using RISARC.Setup.Implementation.Repository;
using RISARC.Setup.Implementation.Repository.SqlServer;
using SpiegelDg.Security.Service;
using SpiegelDg.Common.Service;
using RISARC.Setup.Model;
using System.Web.Routing;
using Telerik.Web.Mvc.Examples;
using Telerik.Web.Mvc;
using Telerik.Web.Mvc.Extensions;
using SpiegelDg.Common.Utilities;
using RISARC.Documents.Service;
using RISARC.Files.Service;
using RISARC.Membership.Implementation.Repository.SqlServer;
using RISARC.Encryption.Model;
using RISARC.Common;
using System.Configuration;
using RISARC.Common.Extensions;
using System.Text.RegularExpressions;
using System.Transactions;

namespace RISARC.Web.EBubble.Controllers
{
    public class AccountController : Controller
    {
        private IRMSeBubbleMempershipService _MembershipService;
        private IMembershipAdministrationService _MembershipAdministrationService;
        private IFormsAuthenticationService _FormsAuthentication;
        private IProviderRepository _ProviderRepository;
        private IDocumentTypesRepository _DocumentTypesRepository;
        private IDocumentsAdminService _DocumentsAdminService;
        private IFilesService _FileService;
        private const string _RegisteringUserKey = "RegisteringUser";
        SecureStringExtensions _secureStringExtensions;

        //public AccountController()
        //    : this(new RMSeBubbleMempershipService(),
        //    new ProviderRepository(),
        //    new FormsAuthenticationService())
        //{
        //}

        public AccountController(IRMSeBubbleMempershipService membershipService,
            IMembershipAdministrationService membershipAdministrationService,
            IProviderRepository providerRepository,
            IFormsAuthenticationService formsAuthentication,
            IDocumentTypesRepository documentTypesRepository,
            IDocumentsAdminService adminService,
            IFilesService fileService)
        {
            this._MembershipService = membershipService;
            this._FormsAuthentication = formsAuthentication;
            this._ProviderRepository = providerRepository;
            this._MembershipAdministrationService = membershipAdministrationService;
            this._DocumentTypesRepository = documentTypesRepository;
            this._DocumentsAdminService = adminService;
            this._FileService = fileService;
            _secureStringExtensions = new SecureStringExtensions();
        }

        /// <summary>
        /// Displays page where user can edit their account information
        /// </summary>
        /// <param name="user"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        //[AuditingAuthorizeAttribute("AccountIndex")]
        public ActionResult Index()
        {
            RMSeBubbleMembershipUser currentUser;
            currentUser = _MembershipService.GetUser(User.Identity.Name, true);

            return Index(currentUser);
        }

        private ActionResult Index(RMSeBubbleMembershipUser currentUser)
        {
            KeyValuePair<char?, char?> documentPatientAlpha;

            if (currentUser == null)
                throw new InvalidOperationException("No user is logged in");
            //not used commneted by abdul
            //ViewData["UserRoles"] = GetUserRoles(currentUser.Email);
            if (currentUser.ProviderMembership != null)
            {
                documentPatientAlpha = _DocumentTypesRepository.GetUserDocumentPatientAlpha(GetLoggedInUserIndex(),null);

                if (documentPatientAlpha.Key == null && documentPatientAlpha.Value == null)
                {
                    ViewData["PatientFirstAlpha"] = "Not Assigned";
                    ViewData["PatientLastAlpha"] = "Not Assigned";
                }
                else
                {
                    ViewData["PatientFirstAlpha"] = documentPatientAlpha.Key;
                    ViewData["PatientLastAlpha"] = documentPatientAlpha.Value;
                }
            }

            ViewData["UserName"] = User.Identity.Name;

            return View("Index", currentUser);
        }

        /// <summary>
        /// Edits user document patient alpha for logged in user
        /// </summary>
        /// <returns></returns>
        [AuditingAuthorize("EditUserDocumentPatientAlphaPost", Roles = "User")]
        [AcceptVerbs(HttpVerbs.Post)]
        [ValidateAntiForgeryToken]
        public ActionResult EditUserDocumentPatientAlpha(char patientFirstAlpha, char patientLastAlpha)
        {
            int userIndex;
            short userProviderId;
            userIndex = GetLoggedInUserIndex();
            userProviderId = GetLoggedInUsersProviderId();

            _DocumentTypesRepository.UpdateUserDocumentPatientAlpha(userIndex, userProviderId, patientFirstAlpha, patientLastAlpha);

            ViewData.SetValue(GlobalViewDataKey.StatusMessage, "Settings successfully updated.");

            // hack, return member index view
            return Index();
        }

        /// <summary>
        /// For when a session is timed out; user will be directed here.
        /// </summary>
        /// <returns></returns>
        public ActionResult TimedOut()
        {
            //Empty trash folder
            _FileService.EmptyTrashFolderForCurrentSession();
            _FormsAuthentication.SignOut();
            return View();
        }

        public ActionResult LogOn(string emailAddress, string ReturnUrl)
        {
            ViewData.SetValue(GlobalViewDataKey.Email, emailAddress);
            ViewData.SetValue(GlobalViewDataKey.ReturnUrl, ReturnUrl);

            // pass is get to page, because when logging in, don't redirect to page if was post. just
            // redirect to page if was get.  This is because getting a lot of those post urls would not work.
            //bool returnUrlIsGet;
            //returnUrlIsGet = Request.HttpMethod.ToLower() == "get";

            //ViewData["ReturnUrlIsGet"] = returnUrlIsGet;

            return View("LogOn");
        }

        public ActionResult LogOff()
        {
            //Delete All uploded files from Collection
            _DocumentsAdminService.DeleteUploadedButNotSentDocuments();
            //Empty trash folder
            _FileService.EmptyTrashFolderForCurrentSession();
            _FormsAuthentication.SignOut();
            ViewData["LoggingOff"] = "true";
            return View("LogOffSuccess");
        }



        //public ActionResult ChangePassword()
        //{
        //    //enter email
        //    // display secreat question
        //    // Enter special secret answer

        //    // 
            
        //    // Change Password
        //    Membership.GetUser().ChangePassword(Membership.GetUser().ResetPassword(), "new password");

        //}

        [AcceptVerbs(HttpVerbs.Post)]
        [ValidateAntiForgeryToken]
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1054:UriParametersShouldNotBeStrings",
            Justification = "Needs to take same parameter type as Controller.Redirect()")]
        public ActionResult LogOn(string emailAddress, string password, string ReturnUrl/*, bool ReturnUrlIsGet*/)
        {
            MemberLoginSuccess? memberLoginSuccess;
            string realReturnUrl;


            memberLoginSuccess = ValidateLogOn(emailAddress, password);

            // if form method is post, then clear out return url, because some of thoes pages don't have get
            // urls.  This was set when the log on page was loaded, by telling if the a return url was from a get or post request
            //if(ReturnUrlInAcceptableRoutes(ReturnUrl))
            realReturnUrl = ReturnUrl;
            //else
            //    realReturnUrl = null;

            //if (!memberLoginSuccess.HasValue)
            //    return View();
            //else if (memberLoginSuccess == MemberLoginSuccess.InvalidUserNamePassword)
            //    return View();
            //else if (memberLoginSuccess == MemberLoginSuccess.LockedOut)
            //    return View();
            if (memberLoginSuccess == MemberLoginSuccess.ActivateEmailNecessary)
                return ConfirmationRequired(emailAddress, realReturnUrl);
            else if (memberLoginSuccess == MemberLoginSuccess.PasswordResetNecessary)
                return SetNewPassword(emailAddress, realReturnUrl);
            else if (memberLoginSuccess == MemberLoginSuccess.FullRegistrationNecessary)
            {
                return CompleteRegistration(emailAddress);
            }

           //for not allowing the Disabled User to log in(--by Abdul)
            //else if (memberLoginSuccess == MemberLoginSuccess.CurrentlyDisabled)
            //{
            //    return View();
            //}


            else if (memberLoginSuccess == MemberLoginSuccess.Success)
            {
                Session["IsLoggedIn"] = true;
                _FormsAuthentication.SignIn(emailAddress, false);
                // clear name cookie
                ClearNameCookie();

                // Set secured string password if private key encryption is enabled.
                _MembershipService.SetSecuredPasswordForUserAndSuperAdmin(_secureStringExtensions, password);

                //Check whether the logged in user's organization is eTar Organization.
                Session["IsFieldOffierLogin"] = false;
                short? providerId = _MembershipService.GetUsersProviderId(emailAddress, true);
                if (providerId.HasValue)
                    Session["IsFieldOffierLogin"] = _DocumentTypesRepository.IseTAROrganization(providerId.Value);

                //TODO: Tobe commeted out ot check file encryption/ decryption for non-organization flow.
                //Get list of documents recieved by Non org member adn update the symmetric key by private key
                _DocumentsAdminService.UpdateEncryptedSymmetricKeyForNonOrgMember(emailAddress);
                //To Open Redirection Attack
                //  if (!String.IsNullOrEmpty(realReturnUrl))

                if (!_MembershipService.decryptPrivateKeyTemp(emailAddress, password) && RISARC.Encryption.EncryptionConstantManager.CryptoConstants.SuperAdminUserName != emailAddress.ToLower().Trim())
                {
                    using (TransactionScope scope = new TransactionScope())
                    {
                        string newPassword;
                        newPassword = _MembershipAdministrationService.ResetPassword(emailAddress);
                        _MembershipService.ChangePassword(emailAddress, newPassword, password, password);
                        scope.Complete();
                    }
                }


                if (Url.IsLocalUrl(realReturnUrl))
                    return Redirect(realReturnUrl);
                else
                    return RedirectToAction("Members", "Home");
            }
            //not required as per code already checks for null value & Return is necessary
            //else
            //    throw new InvalidOperationException("Unknown memberLoginSuccess value");

            return View();
        }

        

        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult RegisterUser(string ReturnUrl)
        {
            ViewData["AgreeTerms"] = false;
            return View("RegisterUser", new RMSeBubbleMembershipUser());
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [ValidateAntiForgeryToken]
        public ActionResult RegisterUser(/*[ModelBinder(typeof(RMSeBubbleMembershipUserBinder))]*/ RMSeBubbleMembershipUser newUser,/*, string emailAddress,*/ string Password, string ConfirmPassword, string PasswordQuestion, string PasswordAnswer, string ReturnUrl, bool AgreeTerms)
        {
            //ViewData.SetValue(GlobalViewDataKey.emailAddress, newUser.Email);
            MembershipCreateStatus createStatus;
            bool successfullyCreated;
            RMSeBubbleMembershipUser createdUser;

            ViewData["AgreeTerms"] = AgreeTerms;
            createdUser = null;
            if (ValidateRegistration(newUser, newUser.Email, Password, ConfirmPassword, PasswordQuestion, PasswordAnswer, AgreeTerms))
            {
                createdUser = _MembershipService.CreatePublicUser(newUser.Email, Password,
                    newUser.Email, PasswordQuestion, PasswordAnswer, true, null, null, newUser.PersonalInformation, out createStatus);

                if (createStatus != MembershipCreateStatus.Success)
                {
                    AddErrorForCreateStatus(createStatus, ModelState);
                    successfullyCreated = false;
                }
                else
                    successfullyCreated = true;
            }
            else
                successfullyCreated = false;

            if (successfullyCreated && createdUser != null)
            {
                // get secured password
                System.Security.SecureString securePassword = _secureStringExtensions.GetSecuredPasswordString(Password);

                //genrerate keys
                int userIndex = _MembershipService.GetUserIndex(createdUser.UserName);
                RMSeBubbleMembershipProvider.InsertUpdateKeyPairForUser(ProviderID: null, UserIndex: userIndex, securePasswordString: securePassword);
                return RedirectToAction("RegistrationSuccessful",
                    new
                    {
                        emailAddress = newUser.Email,
                        //emailAddress = newUser.Email,
                        ReturnUrl = ReturnUrl
                    });
            }
            else
            {
                return View(newUser);
            }
        }

        public ActionResult RegistrationSuccessful(string emailAddress, string ReturnUrl)
        {
            ViewData.SetValue(GlobalViewDataKey.Email, emailAddress);
            ViewData.SetValue(GlobalViewDataKey.ReturnUrl, ReturnUrl);

            return View("RegistrationSuccessful");
        }

        [AcceptVerbs(HttpVerbs.Get)]
        [AuditingAuthorize("UpdatePersonalInformationGet")]
        public ActionResult UpdatePersonalInformation(IPrincipal user)
        {
            RMSeBubbleMembershipUser membershipUser = _MembershipService.GetCurrentUser(user);

            if(user == null)
                throw new InvalidOperationException("No user logged in.");

            return View(membershipUser.PersonalInformation);
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [AuditingAuthorize("UpdatePersonalInformation")]
        public ActionResult UpdatePersonalInformation(PersonalInformation personalInformation)
        {
            try
            {
                _MembershipService.UpdatePersonalInformation(User.Identity.Name, personalInformation);
            }
            catch(RuleException ex)
            {
                ex.CopyToModelState(ModelState);
            }

            if (ModelState.IsValid)
            {
                ViewData.SetValue(GlobalViewDataKey.StatusMessage, "Personal information successfully updated.");
                return Index();
            }
            else
                return View(personalInformation);
        }

        private ActionResult SetNewPassword(string emailAddress, string returnUrl)
        {
            ViewData.SetValue(GlobalViewDataKey.Email, emailAddress);
            ViewData.SetValue(GlobalViewDataKey.ReturnUrl, returnUrl);

            return View("SetNewPassword");
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [ValidateAntiForgeryToken]
        public ActionResult SetNewPassword(string emailAddress, string CurrentPassword, string NewPassword, string ConfirmPassword, string PasswordQuestion, string PasswordAnswer, string ReturnUrl)
        {
            //string emailAddress;

            //emailAddress = base.User.Identity.Name;
            //emailAddress = emailAddress.Identity.Name;

            ViewData.SetValue(GlobalViewDataKey.Email, emailAddress);
            ViewData.SetValue(GlobalViewDataKey.ReturnUrl, ReturnUrl);


            //if (ModelState.IsValid)
            //{
            try
            {
                _MembershipService.ChangePasswordAndQuestionAndAnswer(emailAddress, CurrentPassword, NewPassword, ConfirmPassword, PasswordQuestion, PasswordAnswer);
            }
            catch (RuleException ex)
            {
                ex.CopyToModelState(ModelState);
            }
            //}

            if (!ModelState.IsValid)
            {
                ViewData["PasswordQuestion"] = PasswordQuestion;
                ViewData["PasswordAnswer"] = PasswordAnswer;
                return View();
            }
            else
            {
                return View("SetNewPasswordSuccess");
            }

        }

        /// <summary>
        /// Will only be called privately.  Can only be posted to, in which case registering user is in the session.
        /// </summary>
        /// <param name="emailAddress"></param>
        /// <returns></returns>
        private ActionResult CompleteRegistration(string emailAddress)
        {
            if (emailAddress == null)
                throw new ArgumentNullException("emailAddress");

            Session[_RegisteringUserKey] = emailAddress;
            RMSeBubbleMembershipUser membershipUser = _MembershipService.GetUser(emailAddress, true);

            if(membershipUser.ProviderMembership != null)
            {
                ViewData["ProviderName"] = _ProviderRepository.GetProviderName(membershipUser.ProviderMembership.ProviderId);
            }

            ViewData["AgreeTerms"] = false;

            return View("CompleteRegistration", membershipUser);
        }

        public ActionResult CompleteRegistration([Bind(Exclude = "emailAddress")] RMSeBubbleMembershipUser newUser, string Password, string ConfirmPassword, string PasswordQuestion, string PasswordAnswer, string ReturnUrl, bool AgreeTerms)
        {
            //ViewData.SetValue(GlobalViewDataKey.emailAddress, emailAddress);
            string emailAddress;            
            MembershipCreateStatus createStatus;
            bool successfullyCreated;
            RMSeBubbleMembershipUser completedUser;

            ViewData["AgreeTerms"] = AgreeTerms;

            emailAddress = Session[_RegisteringUserKey] as string;
            if (String.IsNullOrEmpty(emailAddress))
            {
                throw new InvalidOperationException("Could not grab registering Email Address from session.");
            }
            newUser.Email = emailAddress;

            completedUser = null;
            if (ValidateCompletingRegistration(newUser, AgreeTerms))
            {
                completedUser = _MembershipService.CompleteRegistration(emailAddress,
                    newUser.Email, 
                    newUser.PersonalInformation, out createStatus);

                if (createStatus != MembershipCreateStatus.Success)
                {
                    AddErrorForCreateStatus(createStatus, ModelState);
                    successfullyCreated = false;
                }
                else
                    successfullyCreated = true;
            }
            else
                successfullyCreated = false;

            if (successfullyCreated && completedUser != null)
            {
                return RedirectToAction("RegistrationSuccessful",
                    new
                    {
                        emailAddress = newUser.Email,
                        //emailAddress = newUser.Email,
                        ReturnUrl = ReturnUrl
                    });
            }
            else
            {
                return View(newUser);
            }
        }

        /// <summary>
        /// Link can be called to send a confirmation email
        /// </summary>
        /// <param name="email"></param>
        /// <param name="emailAddress"></param>
        /// <returns></returns>
        public ActionResult SendConfirmation(string emailAddress, string ReturnUrl)
        {
            RMSeBubbleMembershipUser user;

            user = _MembershipService.GetUser(emailAddress, true);

            if (user == null)
                throw new ArgumentException("No user exists with name " + emailAddress + ".");

            _MembershipService.SendConfirmationEmail(emailAddress, user.Email);

            ViewData.SetValue(GlobalViewDataKey.Email, user.Email);
            //ViewData.SetValue(GlobalViewDataKey.emailAddress, emailAddress);

            return View("ConfirmationSent");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="emailAddress"></param>
        /// <returns></returns>
        public ActionResult ConfirmationRequired(string emailAddress, string ReturnUrl)
        {
            RMSeBubbleMembershipUser user = _MembershipService.GetUser(emailAddress, true);

            if (user == null)
                throw new InvalidOperationException("No emailAddress exists with name " + emailAddress + ".");

            ViewData.SetValue(GlobalViewDataKey.Email, user.Email);
            //ViewData.SetValue(GlobalViewDataKey.emailAddress, emailAddress);
            ViewData.SetValue(GlobalViewDataKey.ReturnUrl, ReturnUrl);

            return View("ConfirmationRequired");
        }
        
        /// <summary>
        /// Will display prompt to confirm email address.
        /// </summary>
        /// <param name="emailAddress"></param>
        /// <param name="confirmId"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult ConfirmEmail(string emailAddress, string ReturnUrl)
        {
            ViewData.SetValue(GlobalViewDataKey.ReturnUrl, ReturnUrl);
            ViewData.SetValue(GlobalViewDataKey.Email, emailAddress);

            return View();
        }

        /// <summary>
        /// Will confirm email and display success page.  If could  not confirm email,
        /// throws exception.
        /// </summary>
        /// <param name="emailAddress"></param>
        /// <param name="confirmId"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)] [ValidateAntiForgeryToken]
        public ActionResult ConfirmEmail(string emailAddress, string EmailConfirmationId, string ReturnUrl)
        {
            EmailConfirmationSuccess confirmationSuccess;
            ViewData.SetValue(GlobalViewDataKey.ReturnUrl, ReturnUrl);
            ViewData.SetValue(GlobalViewDataKey.Email, emailAddress);

            //Guid emailConfirmGuid = new Guid(confirmId);

            if (String.IsNullOrEmpty(EmailConfirmationId))
            {
                ModelState.AddModelError("EmailConfirmation", "Required");
            }
            else
            {
                confirmationSuccess = _MembershipService.ConfirmEmail(emailAddress, EmailConfirmationId);

                if (confirmationSuccess == EmailConfirmationSuccess.Success)
                {
                    ViewData.SetValue(GlobalViewDataKey.StatusMessage, "Email address succesfully confirmed.");
                }
                else if (confirmationSuccess == EmailConfirmationSuccess.AlreadyConfirmed)
                {
                    ViewData.SetValue(GlobalViewDataKey.StatusMessage, "Email address has already been confirmed.");
                }
                else
                {
                    ModelState.AddModelError("EmailConfirmation", "Invalid Email Confirmation ID.");
                    //throw new InvalidOperationException("emailAddress " + emailAddress + "' email could not be confirmed with confirmation id " + confirmId + ".");
                }
            }

            if (!ModelState.IsValid)
                return View();
            else
                return View("ConfirmEmailSuccess");
        }

        [AcceptVerbs(HttpVerbs.Get)]
        [AuditingAuthorize("ChangePasswordGet")]
        public ViewResult ChangePassword()
        {
            return View();
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [AuditingAuthorize("ChangePasswordGet")]
        public ActionResult ChangePassword(IPrincipal user, string CurrentPassword, string NewPassword, string ConfirmPassword)
        {
            ChangePasswordStatus changePasswordStatus;
            string emailAddress;

            //if (ConfirmPassword != NewPassword)
            //{
            //    ModelState.AddModelError("ConfirmPassword", "Passwords do not match");
            //}
            //else
            //{
            emailAddress = user.Identity.Name;

            try
            {
                changePasswordStatus = _MembershipService.ChangePassword(emailAddress, CurrentPassword, NewPassword, ConfirmPassword);
            }
            catch(RuleException ex)
            {
                ex.CopyToModelState(ModelState);
            }
                //if (changePasswordStatus == ChangePasswordStatus.Failed)
                //    ModelState.AddModelError("NewPassword", "Password change failed");
                //else if (changePasswordStatus == ChangePasswordStatus.NewPasswordInvalid)
                //    ModelState.AddModelError("NewPassword", "New password invalid.  Must have at least 8 characters and a capital letter and number");
                //else if (changePasswordStatus == ChangePasswordStatus.CurrentPasswordInvalid)
                //    ModelState.AddModelError("CurrentPassword", "Old password does not match the password in our system");

            //}

            if (!ModelState.IsValid)
                return View();
            else
            {
                ViewData.SetValue(GlobalViewDataKey.StatusMessage, "Your password has successfully been changed.");
                return Index();
            }
        }

        /// <summary>
        /// WIll display view where user can enter their user name.  When submitting, will take them to next page where can reset forgotten password
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ViewResult ForgotPassword()
        {
            return View();
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ViewResult ForgotPassword(string emailAddress)
        {
            RMSeBubbleMembershipUser user;

            user = _MembershipService.GetUser(emailAddress, false);

            if (user == null)
            {
                ModelState.AddModelError("NoUserWithEmailAddress", "No user exists with that email address.");
            }

            ViewData.SetValue(GlobalViewDataKey.Email, emailAddress);

            if (!ModelState.IsValid || user == null)
            {
                return View();
            }
            else
            {
                return ResetForgottenPassword(user);
            }

        }

        private ViewResult ResetForgottenPassword(RMSeBubbleMembershipUser user)
        {
            ViewData.SetValue(GlobalViewDataKey.Email, user.Email);
            ViewData["PasswordQuestion"] = user.PasswordQuestion;

            return View("ResetForgottenPassword");

        }
            

        [AcceptVerbs(HttpVerbs.Post)]
        public ViewResult ResetForgottenPassword(string emailAddress, string questionAnswer)
        {
            ForgotPasswordStatus forgotPasswordStatus;
            RMSeBubbleMembershipUser user;
            MembershipProvider forgotPasswordProvider;

            // hack - have to use new provider, which required password question and answer.  otherwise, with original provider, doesn't
            forgotPasswordProvider = System.Web.Security.Membership.Providers["ForgotPasswordProvider"];

            if (String.IsNullOrEmpty(questionAnswer))
            {
                ModelState.AddModelError("QuestionAnswerRequired", "Required");
            }
            else
            {
                forgotPasswordStatus = _MembershipService.ResetForgottenPassword(emailAddress, questionAnswer);


                    if (forgotPasswordStatus == ForgotPasswordStatus.InvalidQuestionAnswer)
                        ModelState.AddModelError("InvalidQuestionAnswer", (string)null);
                    else if (forgotPasswordStatus == ForgotPasswordStatus.AccountLockedOut)
                        ModelState.AddModelError("LockedOut", (string)null);

            }

            if (ModelState.IsValid)
            {
                ViewData.SetValue(GlobalViewDataKey.Email, emailAddress);
                return View("ResetForgottenPasswordSuccess");
            }
            else
            {
                user = _MembershipService.GetUser(emailAddress, false);
                return ResetForgottenPassword(user);
            }

        }

        #region Helpers


        /// <summary>
        /// Validates the logon criteria and then runs it through validation service.
        /// If data was not run through validation service, returns null.
        /// </summary>
        /// <param name="emailAddress"></param>
        /// <param name="password"></param>
        /// <returns></returns>
        private MemberLoginSuccess? ValidateLogOn(string emailAddress, string password)
        {
            MemberLoginSuccess? loginSuccess;

            if (String.IsNullOrEmpty(emailAddress) || String.IsNullOrEmpty(password))
            {
                if (String.IsNullOrEmpty(emailAddress))
                {
                    ModelState.AddModelError("EmailRequired", "You must specify a emailAddress.");
                }
                if (String.IsNullOrEmpty(password))
                {
                    ModelState.AddModelError("PasswordRequired", "You must specify a password.");
                }
              
                loginSuccess = null;
            }
            else
            {
                if (!Regex.IsMatch(password, @"^(?=.*\d)(?=.*[A-Z])(?!.*\s).{8,}$"))
                {
                    ModelState.AddModelError("InvalidEmailPassword", (string)null);
                    loginSuccess = MemberLoginSuccess.InvalidPasswordFormat;
                }
                else
                {
                loginSuccess = _MembershipService.ValidateUser(emailAddress, password);

                // if login error was invalid Email Address or password, then allow to correct if
                if (loginSuccess == MemberLoginSuccess.InvalidUserNamePassword)
                {
                    ModelState.AddModelError("InvalidEmailPassword", (string)null);
                }
                else if (loginSuccess == MemberLoginSuccess.LockedOut)
                {
                    ModelState.AddModelError("LockedOut", (string)null);
                }
                // if login was unconfirmed email, redirect them to page where can confirm it.
                else if (loginSuccess == MemberLoginSuccess.CurrentlyDisabled)
                {
                    ModelState.AddModelError("Approved", (string)null);
                }
            }
            }

            return loginSuccess;
        }

        [AcceptVerbs(HttpVerbs.Get)]
        [AuditingAuthorize("ChangeFacility")]
        public ViewResult ChangeFacility()
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.ChangeFacility);
            return View();
        }

                [AcceptVerbs(HttpVerbs.Post)]

        public ViewResult ProvidersOtherFacilityDropDown(string fieldName, string emptyOptionText, short? selectedValue, bool showNetworkSettings)
        {
            IEnumerable<SelectListItem> selectedListItems;
            IDictionary<short, ProviderInNetwork> providers;
            IDictionary<int, ProviderInNetworkTest> providersTest;
            string userName;
            short? providerId;
            int UserIndex;
            ViewData.SetValue(GlobalViewDataKey.FieldName, fieldName);
            ViewData.SetValue(GlobalViewDataKey.OptionText, emptyOptionText);
            ViewData.SetValue(GlobalViewDataKey.ClassName, "ProvidersOtherFacilityDropDown");

            // get users provider id. 
            userName = User.Identity.Name;
            providerId = _MembershipService.GetUsersProviderId(userName, true);
            UserIndex = _MembershipService.GetUserIndex(userName);
            // providers that user's provider has access to
            if (!providerId.HasValue) // this would be the case of a non-member
            {
                throw new InvalidOperationException("Logged in user must have a provider");
            }
            else
            {
                providersTest = _ProviderRepository.GetProvidersInNetworkTest(UserIndex);
            }

            selectedListItems = from provider in providersTest
                                select new SelectListItem
                                {
                                    /* provider name will include BAA if BAA exists */
                                    Text = GetProviderInNetworkOptionTextTest(provider.Value, showNetworkSettings),
                                    Value = provider.Key.ToString(),
                                    Selected = provider.Key == selectedValue
                                };

            if (selectedListItems.Count() == 0)
            {
                ViewData.SetValue(GlobalViewDataKey.OptionText, "No providers exist in your provider's network.  Please contact your provider's administrator.");

                //providerId = ViewData["RecipientProviderId"];
            }

            return View("DropDown", selectedListItems.ToList());
            //ViewData.SetValue(GlobalViewDataKey.OptionText, ViewData["RecipientProviderId"]);
            // return View("DropDownWithAttributes", selectedListItems);
        }
        private string GetProviderInNetworkOptionTextTest(ProviderInNetworkTest providerInNetworkTest, bool showNetworkSettings)
        {
            string providerInNetworkText;

            if (showNetworkSettings)
            {

                providerInNetworkText = providerInNetworkTest.ProviderName;
            }
            else
                providerInNetworkText = providerInNetworkTest.ProviderName;

            return providerInNetworkText;
        }


        [AcceptVerbs(HttpVerbs.Post)]
        [AuditingAuthorize("ChangeFacilityPost", Roles = "User")]
        public ViewResult ChangeFacility(ProviderInfo providerInfo, int recipientProviderId)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.ChangeFacility);
            if (recipientProviderId == 0)
            {
                ViewData.SetValue(GlobalViewDataKey.OptionText, "No providers exist in your provider's network.  Please contact your provider's administrator.");
                ModelState.AddModelError("EmailRequired", "You must specify a emailAddress.");
            }

            {

                if (!ModelState.IsValid)
                {

                    return View();
                }
                else
                {
                    //   return View("SetNewPasswordSuccess");


                    int userIndex;
                    short userProviderId;
                    userIndex = GetLoggedInUserIndex();
                    userProviderId = GetLoggedInUsersProviderId();

                    //_DocumentTypesRepository.UpdateUserDocumentPatientAlpha(userIndex, userProviderId, patientFirstAlpha, patientLastAlpha);
                    _MembershipService.InsertChangeFacilityLog(recipientProviderId, base.User.Identity.Name);
                    _ProviderRepository.ChangeMemberFacility(recipientProviderId, userIndex);
                    Session["IsFieldOffierLogin"] = _DocumentTypesRepository.IseTAROrganization(Convert.ToInt16(recipientProviderId));
                    ViewData.SetValue(GlobalViewDataKey.StatusMessage, "Settings successfully updated.");

                    // hack, return member index view
                    //Suhas: Set Value to Empty string as it check for value while updating header panel.
                    
                    HttpCookie nameCookie;
                    nameCookie = base.Request.Cookies[_NameCookieKey];
                    nameCookie.Value = "";

                    return View(providerInfo);
                }
            }

        }
        private bool ValidateRegistration(RMSeBubbleMembershipUser user, string emailAddress,/* string email,*/ string password, string ConfirmPassword, string passwordQuestion, string passwordAnswer, bool agreeTerms)
        {
            IEnumerable<ErrorInfo> errors;

            if (String.IsNullOrEmpty(emailAddress))
            {
                ModelState.AddModelError("EmailRequired", "You must specify an email address.");
            }
            if (String.IsNullOrEmpty(passwordQuestion))
            {
                ModelState.AddModelError("PasswordQuestionRequired", "You must specify a secret question.");
            }
            if (String.IsNullOrEmpty(passwordAnswer))
            {
                ModelState.AddModelError("PasswordAnswerRequired", "You must specify the answer to the secret question.");
            }
            if (!String.Equals(password, ConfirmPassword, StringComparison.Ordinal))
            {
                ModelState.AddModelError("ConfirmPassword", "The new password and confirmation password do not match.");
            }
            if (!agreeTerms)
            {
                ModelState.AddModelError("AgreeTermsRequired", "Required");
            }

            errors = _MembershipService.ValidateRegistrationData(MemberRoleType.User,
                user,
                password);            

            if(errors.Count() > 0)
                errors.CopyToModelState(ModelState, null);

            return ModelState.IsValid;
        }

        /// <summary>
        /// For validating a user that wants to complete registration
        /// </summary>
        /// <param name="user"></param>
        /// <param name="emailAddress"></param>
        /// <param name="email"></param>
        /// <returns></returns>
        private bool ValidateCompletingRegistration(RMSeBubbleMembershipUser user, bool agreeTerms)
        {
            IEnumerable<ErrorInfo> errors;

            //if (String.IsNullOrEmpty(email))
            //{
            //    ModelState.AddModelError("Email", "You must specify an email address.");
            //}
            
            errors = _MembershipService.ValidateCompletingRegistrationData(MemberRoleType.DocumentAdmin,
                user);

            if (!agreeTerms)
                ModelState.AddModelError("AgreeTermsRequired", "Required");



            if (errors.Count() > 0)
                errors.CopyToModelState(ModelState, null);

            return ModelState.IsValid;
        }

        private bool ValidateAdministrativeRegistration(RMSeBubbleMembershipUser newUser)
        {
            IEnumerable<ErrorInfo> errors;

            if (String.IsNullOrEmpty(newUser.Email))
                ModelState.AddModelError("EmailRequired", "You must specify an Email Address.");
            if (String.IsNullOrEmpty(newUser.PersonalInformation.FirstName))
                ModelState.AddModelError("PersonalInformation.FirstNameRequired", "Required");
            if (String.IsNullOrEmpty(newUser.PersonalInformation.LastName))
                ModelState.AddModelError("PersonalInformation.LastNameRequired", "Required");

            errors = _MembershipService.ValidateAdministrativeRegistrationData(MemberRoleType.User,
                newUser);

            if (errors.Count() > 0)
                errors.CopyToModelState(ModelState, null);

            return ModelState.IsValid;
        }

        //commneted by abdul( not Used)
        //private string[] GetUserRoles(string emailAddress)
        //{
        //    return _MembershipService.GetUserRoles(emailAddress);
        //}

        /// <summary>
        /// Based on the create status error type, will add an error message to the ModelState
        /// </summary>
        /// <param name="createStatus"></param>
        public static void AddErrorForCreateStatus(MembershipCreateStatus createStatus, ModelStateDictionary modelState)
        {
            //string createStatusString;

            switch (createStatus)
            {
                case MembershipCreateStatus.DuplicateUserName:
                    modelState.AddModelError("EmailDuplicate", "A user with that e-mail address already exists. Please enter a different e-mail address.");
                    break;
                case MembershipCreateStatus.InvalidEmail:
                    modelState.AddModelError("EmailInvalid", "The e-mail address provided is invalid. Please check the value and try again.");
                    break;
                //case MembershipCreateStatus.DuplicateEmail:
                //    ModelState.AddModelError("EmailAddressRequired", "A emailAddress for that e-mail address already exists. Please enter a different e-mail address.");
                //    break;
                case MembershipCreateStatus.InvalidPassword:
                    modelState.AddModelError("Password", "The password provided is invalid. Please enter a valid password value.");
                    break;
                case MembershipCreateStatus.InvalidAnswer:
                    modelState.AddModelError("PasswordAnswer", "The password retrieval answer provided is invalid. Please check the value and try again.");
                    break;
                case MembershipCreateStatus.InvalidQuestion:
                    modelState.AddModelError("PasswordQuestion", "The password retrieval question provided is invalid. Please check the value and try again.");
                    break;
                //case MembershipCreateStatus.InvalidemailAddress:
                //    ModelState.AddModelError("emailAddress", "The Email Address provided is invalid. Please check the value and try again.");
                //    break;
                case MembershipCreateStatus.ProviderError:
                    modelState.AddModelError("_FORM", "The authentication provider returned an error. Please verify your entry and try again. If the problem persists, please contact your system administrator.");
                    break;
                case MembershipCreateStatus.UserRejected:
                    modelState.AddModelError("_FORM", "The user creation request has been canceled. Please verify your entry and try again. If the problem persists, please contact your system administrator.");
                    break;
                default:
                    modelState.AddModelError("_FORM", "An unknown error occurred. Please verify your entry and try again. If the problem persists, please contact your system administrator.");
                    break;
            }
            //ModelState.AddModelError("_FORM", createStatusString);

        }

        private int GetLoggedInUserIndex()
        {
            return _MembershipService.GetUserIndex(User.Identity.Name);
        }

        private short GetLoggedInUsersProviderId()
        {
            short providerId;

            providerId = _MembershipService.GetUsersProviderId(base.User.Identity.Name, true).Value;

            return providerId;
        }

        private const string _NameCookieKey = "nme";
        public string GetLoggedInUsersFullName()
        {
            string name;
            bool loadNameIntoCookie;
            RMSeBubbleMembershipUser membershipUser;

            HttpCookie nameCookie;

            // gry getting name from name cookie.  If cookie doesn't exist, then load from user info,
            // and save in cookie
            nameCookie = base.Request.Cookies[_NameCookieKey];

            if (nameCookie == null)
                loadNameIntoCookie = true;
            else
            {
                if (String.IsNullOrEmpty(nameCookie.Value))
                    loadNameIntoCookie = true;
                else
                    loadNameIntoCookie = false;
            }

            if (loadNameIntoCookie)
            {
                membershipUser = _MembershipService.GetUser(User.Identity.Name, true);
                name = membershipUser.PersonalInformation.FirstName;
                if (membershipUser.ProviderMembership != null)
                    name = membershipUser.PersonalInformation.FirstName + ' ' + '(' + _ProviderRepository.GetProviderName(membershipUser.ProviderMembership.ProviderId) + ')';
                base.Response.Cookies.Add(new HttpCookie(_NameCookieKey, name));
            }
            else
                name = nameCookie.Value;

            return name;
        }

        #endregion

        private const string _ExpireNameCookieKey = "exnm";
        /// <summary>
        /// Clears the name cookie from the request and response cookies collection
        /// </summary>
        private void ClearNameCookie()
        {
            base.Response.Cookies[_NameCookieKey].Value = null;
        }

        

    }
    
    //#region Forms Authentication Helpers

    //    // The FormsAuthentication type is sealed and contains static members, so it is difficult to
    //    // unit test code that calls its members. The interface and helper class below demonstrate
    //    // how to create an abstract wrapper around such a type in order to make the AccountController
    //    // code unit testable.

    //    public interface IFormsAuthentication
    //    {
    //        void SignIn(string emailAddress, bool createPersistentCookie);
    //        void SignOut();
    //    }

    //    public class FormsAuthenticationService : IFormsAuthentication
    //    {
    //        public void SignIn(string emailAddress, bool createPersistentCookie)
    //        {                
    //            FormsAuthentication.SetAuthCookie(emailAddress, createPersistentCookie);
    //        }
    //        public void SignOut()
    //        {
    //            FormsAuthentication.SignOut();
    //        }
    //    }

    //    #endregion
}
