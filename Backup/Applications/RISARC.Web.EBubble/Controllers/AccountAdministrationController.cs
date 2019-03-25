using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Ajax;
using SpiegelDg.Security.Model;
using RISARC.Emr.Web.DataTypes;
using RISARC.Membership.Model;
using RISARC.Membership.Service;
using RISARC.Web.EBubble.Models.Binders;
using RISARC.Documents.Service;
using RISARC.Documents.Model;
using RISARC.Logging.Service;
using RISARC.Logging.Model;
using System.Web.Security;
using SpiegelDg.Common.Validation;
using SpiegelDg.Common.Web.Extensions;
using RISARC.Setup.Implementation.Repository;
using RISARC.Setup.Model;
using RISARC.Membership.Implementation.Repository.SqlServer;
using System.Data;
using RISARC.Membership.Implementation.Service;
using RISARC.Common.Extensions;
using RISARC.Common;
using System.Text.RegularExpressions;
using RISARC.Files.Model;
using RISARC.Documents.Implementation.Service;
using RISARC.Emr.Web.Extensions;

namespace RISARC.Web.EBubble.Controllers
{
    public class AccountAdministrationController : Controller 
    {
        private IRMSeBubbleMempershipService _MembershipService;
        private IMembershipAdministrationService _MembershipAdministrationService;
        private ILoggingService _LoggingService;
        private IDocumentTypesRepository _DocumentTypesRepository;
        private IProviderRepository _ProviderRepository;
        //private IRMSeBubbleRoleService _RoleProviderService;
        public AccountAdministrationController(IRMSeBubbleMempershipService membershipService,
            IMembershipAdministrationService membershipAdministrationService,
            ILoggingService loggingService,
            IDocumentTypesRepository documentTypesRepository,
            IProviderRepository providerRepository//,IRMSeBubbleRoleService roleProviderService
            )
        {
            this._MembershipService = membershipService;
            this._MembershipAdministrationService = membershipAdministrationService;
            this._LoggingService = loggingService;
            this._DocumentTypesRepository = documentTypesRepository;
            this._ProviderRepository = providerRepository;
            //this._RoleProviderService = roleProviderService;
        }


        [AuditingAuthorizeAttribute("AllUsers", Roles = "SuperAdmin")]
        [AcceptVerbs(HttpVerbs.Get)]
        public ViewResult AllUsers()
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.AllUsers);

            return View("AllUsers");
        }

        [AuditingAuthorizeAttribute("CopyofSelectProvidersAdministrators", Roles = "SuperAdmin")]
        [AcceptVerbs(HttpVerbs.Get)]
        public ViewResult CopyofSelectProvidersAdministrators()
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.AddNewProvider);

            return View("CopyofSelectProvidersAdministrators");
        }

        /// <summary>
        /// Finds a user by name and displays all users view, with user in view data
        /// </summary>
        /// <param name="userName"></param>
        /// <returns></returns>
        [AuditingAuthorizeAttribute("FindUserByUserName", Roles = "SuperAdmin")]
        [AcceptVerbs(HttpVerbs.Post)]
        public ViewResult FindUserByUserName(string userName)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.AllUsers);

            ViewData["UserName"] = userName;
            IEnumerable<RMSeBubbleMembershipUser> user = _MembershipService.GetUsers(userName);

            ViewData["User"] = user;

            return AllUsers();
        }
        //
        // GET: /AccountAdministration/

        [AuditingAuthorizeAttribute("ProvidersUsers", Roles = "ProviderAdmin")]
        public ViewResult ProvidersUsers()
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.ProvidersUsers);

            short usersProviderId;
            IEnumerable<RMSeBubbleMembershipUser> providersUsers;

            usersProviderId = GetLoggedInUsersProviderId();

            providersUsers = _MembershipAdministrationService.GetProvidersUsers(usersProviderId);

            return View(providersUsers);
        }

        public ViewResult UserAdminTableGrid()
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.ProvidersUsers);

            short usersProviderId;
            IEnumerable<RMSeBubbleMembershipUser> providersUsers;

            usersProviderId = GetLoggedInUsersProviderId();

            providersUsers = _MembershipAdministrationService.GetProvidersUsers(usersProviderId);

            return View("_gvUsersAccounts", providersUsers);
        }

        [AuditingAuthorizeAttribute("RegisterProviderUserGet", Roles = "ProviderAdmin")]
        [AcceptVerbs(HttpVerbs.Get)]
        public ViewResult RegisterProviderUser()
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.ProvidersUsers);
            short providerId = GetLoggedInUsersProviderId();
            RMSeBubbleMembershipUser membershipUser = new RMSeBubbleMembershipUser
            {
                ProviderMembership = new ProviderMembership
                {
                    ProviderId = providerId
                }
            };

            return View(membershipUser); //loaded partial view in this by surekha
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [AuditingAuthorizeAttribute("RegisterProviderUser", Roles = "ProviderAdmin")]
        [ValidateAntiForgeryToken]
        public ActionResult RegisterProviderUser(RMSeBubbleMembershipUser newUser/*, string emailAddress*/)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.ProvidersUsers);
            MembershipCreateStatus createStatus;
            bool successfullyCreated;
            RMSeBubbleMembershipUser createdUser;
            string generatedPassword;

            newUser.ProviderMembership.ProviderId = GetLoggedInUsersProviderId();

            createdUser = null;
            generatedPassword = null;
            if (ValidateAdministrativeRegistration(newUser))
            {
                //get selected role in array of strings
                string[] selectedRoles = null;
                if (!string.IsNullOrEmpty(Request.Form["all_checkbox_value"]))
                {
                    selectedRoles = Request.Form["all_checkbox_value"].Split(',');
                }

                //if (!string.IsNullOrEmpty(Request.Form["UserRoleNames"]))
                //{
                //    selectedRoles = Request.Form["UserRoleNames"].Split(',');
                //}

                generatedPassword = _MembershipService.GeneratePassword();

                createdUser = _MembershipAdministrationService.CreateProviderUser(newUser.Email, newUser.Email, generatedPassword,
                    null,
                    newUser.ProviderMembership,
                    newUser.PersonalInformation, selectedRoles, GetLoggedInUsersProviderId(), out createStatus);

                if (createStatus != MembershipCreateStatus.Success)
                {
                    AccountController.AddErrorForCreateStatus(createStatus, ModelState);
                    successfullyCreated = false;
                }
                else
                {
                    successfullyCreated = true;
                    // if successfully created, add defualt document types for user
                    _DocumentTypesRepository.InsertDefaultDocumentTypesForUser(_MembershipService.GetUserIndex(newUser.Email), newUser.ProviderMembership.ProviderId);
                }
            }
            else
                successfullyCreated = false;

            if (successfullyCreated && createdUser != null)
            {
                return RegisterProviderUserSuccessful(
                    newUser.Email,
                    generatedPassword);
            }
            else
            {
                return View(newUser);
            }
        }

        /// <summary>
        /// Map Users with role 'User' with provider.
        /// </summary>
        /// <returns>ManageUserProviderMapping View</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 01/31/2014 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        [AuditingAuthorizeAttribute("ManageUserProviderMapping", Roles = "SuperAdmin")]
        public ActionResult ManageUserProviderMapping(short? ProviderId = null)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.ManageUserProviderMapping);
            UserProviderMapping userProviderMapping = new UserProviderMapping();
            userProviderMapping.ProviderId = ProviderId;
            ProviderDropDown();
            return View("ManageUserProviderMapping", userProviderMapping);
        }

        /// <summary>
        /// Map Users with role 'User' with provider. Post Method.
        /// </summary>
        /// <returns>ManageUserProviderMapping View</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 01/31/2014 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult ManageUserProviderMapping(UserProviderMapping userProviderMapping)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.ManageUserProviderMapping);
            ProviderDropDown();
            if (!userProviderMapping.ProviderId.HasValue)
                return View(userProviderMapping);

            if (!ModelState.IsValid)
                return View(userProviderMapping);

            if (String.IsNullOrEmpty(Request.Params["NonOrganizationSelectedRowValues"].ToString()))
            {
                ViewData["ErrorMsg"] = "Please select at least one non organization member to map with organization.";
                return View(userProviderMapping);
            }

            List<string> MapUserNames = Request.Params["NonOrganizationSelectedRowValues"].ToString().Split(',').ToList();

            bool IsSuccess = _MembershipAdministrationService.MapUsersWithProvider(MapUserNames, new ProviderMembership() { ProviderId = userProviderMapping.ProviderId.Value }, GetLoggedInUserIndex());

            if (IsSuccess)
                ViewData["Message"] = "Success";
            else
                ViewData["Message"] = "Error";

            return View(userProviderMapping);
        }

        /// <summary>
        /// Un -Map User which are mapped by super admin
        /// </summary>
        /// <param name="userProviderMapping">UserProviderMapping Model / dataentity</param>
        /// <returns>ManageUserProviderMapping view</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 02/06/2014 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult ManageUserProviderUnMapping(UserProviderMapping userProviderMapping)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.ManageUserProviderMapping);
            ProviderDropDown();
            if (!ModelState.IsValid)
                return View("ManageUserProviderMapping", userProviderMapping);

            if (String.IsNullOrEmpty(Request.Params["OrganizationSelectedRowValues"].ToString()))
            {
                ViewData["ErrorMsg"] = "Please select at least one organization member to Un-map from organization.";
                return View("ManageUserProviderMapping", userProviderMapping);
            }

            List<string> MapUserNames = Request.Params["OrganizationSelectedRowValues"].ToString().Split(',').ToList();

            bool IsSuccess = _MembershipAdministrationService.UnMapUsersFromProvider(MapUserNames, userProviderMapping.ProviderId.Value, GetLoggedInUserIndex());

            if (IsSuccess)
                ViewData["Message"] = "Success";
            else
                ViewData["Message"] = "Error";

            //return RedirectToAction("ManageUserProviderMapping", new { ProviderId = userProviderMapping.ProviderId });
            return View("ManageUserProviderMapping", userProviderMapping);
        }

        /// <summary>
        /// Fills Users grid listing all the users with role 'User' For mapping
        /// </summary>
        /// <param name="SearchText">Serach on Username / Lastname / FirstName. (This is handled in Grid so so not required.)</param>
        /// <returns>Grid for Viewing Users</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 01/31/2014 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        [AuditingAuthorizeAttribute("ManageUserProviderMapping", Roles = "SuperAdmin")]
        public ViewResult UserGridParialCallback(string SearchText)
        {
            UserProviderMapping userProviderMapping = new UserProviderMapping();
            userProviderMapping.MembersWithRoleUser = _MembershipAdministrationService.GetAllUsersWithFilters(null);

            return View("_GridUserProviderMapping", userProviderMapping);
        }

        /// <summary>
        /// Fills provider drop down list.
        /// </summary>
        /// <returns>Dropdown list.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 01/31/2014 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        private void ProviderDropDown()
        {
            List<SelectListItem> ProviderList = new List<SelectListItem>();

            IEnumerable<Provider> providers = _ProviderRepository.GetAllProviders();
            foreach (Provider provider in providers)
            {
                ProviderList.Add(new SelectListItem() { Text = provider.ProviderInfo.Name, Value = Convert.ToString(provider.Id) });
            }
            ViewData.Add("ProviderList", ProviderList);
        }

        /// <summary>
        /// Returns Users of the provider Selected in drop down.
        /// </summary>
        /// <param name="ProviderID">Provider Id</param>
        /// <returns>List view containing Users</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 01/31/2014 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        [AuditingAuthorizeAttribute("ManageUserProviderMapping", Roles = "SuperAdmin")]
        public ActionResult GetUsersForSelectedProvider(short? ProviderID = null)
        {
            UserProviderMapping userProviderMapping = new UserProviderMapping();
            if (ProviderID.HasValue)
                userProviderMapping.MappedUserToProvider = _MembershipAdministrationService.GetSuperAdminMappedUsers(ProviderID.Value);
            else
                userProviderMapping.MappedUserToProvider = new List<MapUserProvider>();
            userProviderMapping.ProviderId = ProviderID;

            return PartialView("OrganizationMembersPartial", userProviderMapping); //by surekha
        }

        private ViewResult RegisterProviderUserSuccessful(string emailAddress, string password)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.ProvidersUsers);
            ViewData.SetValue(GlobalViewDataKey.Email, emailAddress);
            ViewData["Password"] = password;

            return View("RegisterProviderUserSuccessful");
        }

        /// <summary>
        /// Renders view where can select which provider to edit administrators for
        /// </summary>
        /// <returns></returns>
        [AuditingAuthorizeAttribute("SelectProvidersAdministrators", Roles = "SuperAdmin")]
        [AcceptVerbs(HttpVerbs.Get)]
        public ViewResult SelectProvidersAdministrators()
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.SelectProvidersAdministrators);

            return View();
        }



        /// <summary>
        /// For post when selecting which provider administrator to edit        
        /// </summary>
        /// <returns></returns>
        [AuditingAuthorizeAttribute("SelectProvidersAdministrators", Roles = "SuperAdmin")]
        [AcceptVerbs(HttpVerbs.Post)]
        [ValidateAntiForgeryToken]
        public ViewResult SelectProvidersAdministrators(string providerState, string providerCity, short? ProviderIdToAdministrate)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.SelectProvidersAdministrators);


            if (String.IsNullOrEmpty(providerCity))
                ModelState.AddModelError("ProviderCityRequired", "Required");
            if (String.IsNullOrEmpty(providerState))
                ModelState.AddModelError("ProviderStateRequired", "Required");
            if (!ProviderIdToAdministrate.HasValue)
                ModelState.AddModelError("ProviderIdRequired", "Required");

            if (!ModelState.IsValid)
            {
                ViewData["SelectedProviderState"] = providerState;
                ViewData["SelectedProviderCity"] = providerCity;
                ViewData["SelectedProviderId"] = ProviderIdToAdministrate;
                return View("SelectProvidersAdministrators");
            }
            else
                return ProvidersAdministrators(ProviderIdToAdministrate.Value);
        }


        // BELOW METHODS ARE ALMOST EXACT less names and 
        [AuditingAuthorizeAttribute("ProvidersAdministrators", Roles = "SuperAdmin")]
        public ViewResult ProvidersAdministrators(short providerIdToAdministrate)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.ProvidersAdministrators);
            ViewData["ProviderIdToAdministrate"] = providerIdToAdministrate;

            IEnumerable<RMSeBubbleMembershipUser> providersUsers;

            providersUsers = _MembershipAdministrationService.GetProvidersAdministrators(providerIdToAdministrate);

            return View("ProvidersAdministrators", providersUsers);
        }

        [AcceptVerbs(HttpVerbs.Get)]
        [AuditingAuthorizeAttribute("RegisterProviderAdminGet", Roles = "SuperAdmin")]
        public ViewResult RegisterProviderAdmin(short providerIdToAdministrate)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.ProvidersAdministrators);
            ViewData["ProviderId"] = providerIdToAdministrate;
            ViewData["RoleList"] = GetRoleList(providerIdToAdministrate);
            RMSeBubbleMembershipUser membershipUser = new RMSeBubbleMembershipUser
            {
                ProviderMembership = new ProviderMembership
                {
                    ProviderId = providerIdToAdministrate
                }
            };

            return View(membershipUser);
        }

        private List<SelectListItem> GetRoleList(short providerIdToAdministrate)
        {
            List<SelectListItem> roleList = new List<SelectListItem>();
            List<MemberRole> memberRole = _MembershipAdministrationService.GetProviderAdminRoles(providerIdToAdministrate);
            foreach (var item in memberRole)
            {
                roleList.Add(new SelectListItem() { Text = item.RoleName, Value = item.RoleName });
            }

            return roleList;
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [AuditingAuthorizeAttribute("RegisterProviderAdmin", Roles = "SuperAdmin")]
        [ValidateAntiForgeryToken]
        public ActionResult RegisterProviderAdmin(RMSeBubbleMembershipUser newUser/*, string emailAddress*/)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.ProvidersAdministrators);
            MembershipCreateStatus createStatus;
            bool successfullyCreated;
            RMSeBubbleMembershipUser createdUser;
            string generatedPassword;
            ViewData["ProviderId"] = newUser.ProviderMembership.ProviderId;
            ViewData["RoleList"] = GetRoleList(newUser.ProviderMembership.ProviderId);
            //newUser.ProviderMembership.ProviderId = GetLoggedInUsersProviderId(); // now is taken from 

            createdUser = null;
            generatedPassword = null;
            if (ValidateAdministrativeRegistration(newUser))
            {
                generatedPassword = _MembershipService.GeneratePassword();
                // CreateProviderAdministrator different than in other method
                createdUser = _MembershipAdministrationService.CreateProviderAdministrator(newUser.Email, newUser.Email, newUser.UserRolesList, generatedPassword,
                    null,
                    newUser.ProviderMembership,
                    newUser.PersonalInformation, out createStatus);

                if (createStatus != MembershipCreateStatus.Success)
                {
                    AccountController.AddErrorForCreateStatus(createStatus, ModelState);
                    successfullyCreated = false;
                }
                else
                {
                    successfullyCreated = true;
                    // if successfully created, add defualt document types for user
                    _DocumentTypesRepository.InsertDefaultDocumentTypesForUser(_MembershipService.GetUserIndex(newUser.Email), newUser.ProviderMembership.ProviderId);
                }
            }
            else
                successfullyCreated = false;

            if (successfullyCreated && createdUser != null)
            {
                return RegisterProviderAdminSuccessful(
                    newUser.Email,
                    generatedPassword);
            }
            else
            {
                return View(newUser);
            }
        }

        private ViewResult RegisterProviderAdminSuccessful(string emailAddress, string password)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.ProvidersAdministrators);
            ViewData.SetValue(GlobalViewDataKey.Email, emailAddress);
            ViewData["Password"] = password;

            return View("RegisterProviderAdminSuccessful");
        }




        /// <summary>
        /// 
        /// </summary>
        /// <param name="emailAddress"></param>
        /// <param name="ReturnUrl"></param>
        /// <returns></returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 12/09/2013 | Viresh   | Created
        /// 12/09/2013 | Viresh   | Commented the unused variable providerMembership.
        /// </RevisionHistory>
        [AuditingAuthorizeAttribute("AdministerUser", Roles = "SuperAdmin,ProviderAdmin")]
        public ViewResult AdministerUser([ModelBinder(typeof(EncryptedStringBinder))] string emailAddress, string ReturnUrl)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.ProvidersUsers);
            ViewData.SetValue(GlobalViewDataKey.ReturnUrl, ReturnUrl);
            IEnumerable<string> userRoles;
            //ProviderMembership providerMembership;
            //ProviderInfo provider;
            short? providerId = null;
            ViewData["SetProviderAdmin"] = false;

            RMSeBubbleMembershipUser memberhipUser;
           
            memberhipUser = _MembershipService.GetUser(emailAddress, false);
            if (memberhipUser.ProviderMembership != null && memberhipUser.ProviderMembership.ProviderId != null)
            {
                providerId = memberhipUser.ProviderMembership.ProviderId;
                if (_MembershipService.IsUserInRoles(HttpContext.User.Identity.Name, new string[] { ConstantManager.StoredProcedureConstants.SuperAdminRoleAcess }, GetLoggedInUsersProviderId()))
                {
                    ViewData["SetProviderAdmin"] = true;
                }
          
            }

            userRoles = _MembershipService.GetUserRoles(emailAddress, providerId);
            ViewData["UserRoles"] = userRoles;

            return View("AdministerUser", memberhipUser);
        }

        [AuditingAuthorizeAttribute("UserHistory", Roles = "SuperAdmin,ProviderAdmin")]
        public ViewResult UserHistory([ModelBinder(typeof(EncryptedStringBinder))] string emailAddress)
        {
            ICollection<ActionLogEntry> history;

            ViewData.SetValue(GlobalViewDataKey.Email, emailAddress);
            int userIndex;

            userIndex = _MembershipService.GetUserIndex(emailAddress);
            history = _LoggingService.GetActionHistoryForUser(userIndex);

            return View(history);
        }

        [AuditingAuthorizeAttribute("ResetPassword", Roles = "SuperAdmin,ProviderAdmin")]
        [ValidateAntiForgeryToken]
        [AcceptVerbs(HttpVerbs.Post)]
        public ViewResult ResetPassword([ModelBinder(typeof(EncryptedStringBinder))] string emailAddress, string ReturnUrl)
        {
            string newPassword;

            newPassword = _MembershipAdministrationService.ResetPassword(emailAddress);

            ViewData["Password"] = newPassword;
            ViewData.SetValue(GlobalViewDataKey.Email, emailAddress);
            ViewData.SetValue(GlobalViewDataKey.ReturnUrl, ReturnUrl);

            // return new view with new password
            return View("ResetPasswordSuccess");
        }

        [AuditingAuthorizeAttribute("UnlockAccount", Roles = "SuperAdmin,ProviderAdmin")]
        [ValidateAntiForgeryToken]
        [AcceptVerbs(HttpVerbs.Post)]
        public ViewResult UnlockAccount([ModelBinder(typeof(EncryptedStringBinder))] string emailAddress, string ReturnUrl)
        {
            bool unlockSuccess;

            unlockSuccess = _MembershipAdministrationService.UnlockAccount(emailAddress);

            if (unlockSuccess)
                ViewData.SetValue(GlobalViewDataKey.StatusMessage, "User Successfully Unlocked.");
            else
                ViewData.SetValue(GlobalViewDataKey.StatusMessage, "Unexpected Error Occured.");

            // return same view
            return AdministerUser(emailAddress, ReturnUrl);
        }

        [AuditingAuthorizeAttribute("SetUserApproval", Roles = "SuperAdmin,ProviderAdmin")]
        [ValidateAntiForgeryToken]
        [AcceptVerbs(HttpVerbs.Post)]
        public ViewResult SetUserEnabled([ModelBinder(typeof(EncryptedStringBinder))] string emailAddress, bool setEnabled, string ReturnUrl)
        {
            bool userApprovalSuccess;

            userApprovalSuccess = _MembershipAdministrationService.SetUserApproval(emailAddress, setEnabled);

            if (userApprovalSuccess)
            {
                if (setEnabled)
                    ViewData.SetValue(GlobalViewDataKey.StatusMessage, "User Successfully Enabled.");
                else
                    ViewData.SetValue(GlobalViewDataKey.StatusMessage, "User Successfully Disabled.");
            }
            else
                ViewData.SetValue(GlobalViewDataKey.StatusMessage, "Unexpected Error Occured.");

            // return same view
            return AdministerUser(emailAddress, ReturnUrl);
        }
        /// <summary>
        /// To Set The USer as Resposible Member of an organisation
        /// </summary>
        /// <param name="emailAddress"></param>
        /// <param name="setResponsible"></param>
        /// <param name="ReturnUrl"></param>
        /// <returns>viewresult</returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 05/23/2014 | Abdul   | Created
        /// </RevisionHistory>
        [ValidateAntiForgeryToken]
        [AcceptVerbs(HttpVerbs.Post)]
        public ViewResult SetUserResponsible([ModelBinder(typeof(EncryptedStringBinder))] string emailAddress, bool setResponsible, string ReturnUrl)
        {
            bool userResposibleSuccess;

            userResposibleSuccess = _MembershipAdministrationService.SetUserResponsible(emailAddress, setResponsible);

            if (userResposibleSuccess)
            {
                if (setResponsible)
                    ViewData.SetValue(GlobalViewDataKey.StatusMessage, ConstantManager.StatusConstants.MarkResponsible);
                else
                    ViewData.SetValue(GlobalViewDataKey.StatusMessage, ConstantManager.StatusConstants.UnMarkResponsible);
            }
            else
                ViewData.SetValue(GlobalViewDataKey.StatusMessage, ConstantManager.StatusConstants.UnexpectedError);

            // return same view
            return AdministerUser(emailAddress, ReturnUrl);
        }

        public ViewResult MakeProviderAdmin([ModelBinder(typeof(EncryptedStringBinder))] string emailAddress, string setProviderAdmin, string ReturnUrl)
        {
            short providerId  = GetLoggedInUsersProviderId();
            if (!string.IsNullOrEmpty(setProviderAdmin)&& Convert.ToBoolean(setProviderAdmin))
            {
              _MembershipAdministrationService.AddUserToRole(emailAddress, new string[] { ConstantManager.StoredProcedureConstants.ProviderAdminRoleAccess }, GetLoggedInUsersProviderId(), _MembershipService.GetUsersProviderId(emailAddress, false));
              ViewData.SetValue(GlobalViewDataKey.StatusMessage, ConstantManager.StatusConstants.SetProviderAdmin);
            }
            else
            {
                _MembershipAdministrationService.RemoveUserFromRole(emailAddress, new string[] { ConstantManager.StoredProcedureConstants.ProviderAdminRoleAccess }, GetLoggedInUsersProviderId(), _MembershipService.GetUsersProviderId(emailAddress, false));
                ViewData.SetValue(GlobalViewDataKey.StatusMessage, ConstantManager.StatusConstants.RemoveProviderAdmin);
            }
            return AdministerUser(emailAddress, ReturnUrl);
        }

        public JsonResult UserAccountSettings(string emailAddresses, string accessUserIndexes, string deniedUserIndexes)
        {
            SetMultipleResonsible(emailAddresses);
            SetAccessToExternalNote(accessUserIndexes,deniedUserIndexes);
           return Json("Success", JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// Setting Up Responsible Members From User Accounts Grid
        /// </summary>
        /// <param name="emailAddresses">comma Seperated Email addresses</param>
        /// <returns>Json Success</returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 06/3/2014 | Abdul   | Created
        /// </RevisionHistory>
        private JsonResult SetMultipleResonsible(string emailAddresses)
        {

            string[] emailaddress = emailAddresses.Split(',');
            // unselecting each responsible User for a current Provider
            IEnumerable<RMSeBubbleMembershipUser> providersUsers;
            providersUsers = _MembershipAdministrationService.GetProvidersUsers(GetLoggedInUsersProviderId());
            var previouslyresponsible = providersUsers.Where(a => a.IsResponsible == true);
            foreach (var member in previouslyresponsible)
            {
                _MembershipAdministrationService.SetUserResponsible(member.UserName, false);
            }
            //selecting checked Users as Responsible
            foreach (string item in emailaddress)
            {
                _MembershipAdministrationService.SetUserResponsible(item, true);
            }
            return Json("Success", JsonRequestBehavior.AllowGet);
        }
        /// <summary>
        /// assign access to the external Notes 
        /// </summary>
        /// <param name="AccessUserIndexes">User that are given Access to external note</param>
        /// <param name="DeniedUserIndexes">User that are denied Access to external note</param>
        /// <returns>JsonResult</returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 06/26/2014 | Abdul   | Created
        /// </RevisionHistory>
        private JsonResult SetAccessToExternalNote(string accessUserIndexes, string deniedUserIndexes)
        {
             _MembershipAdministrationService.SetAccessToExternalNote(accessUserIndexes,deniedUserIndexes);
            return Json("Success", JsonRequestBehavior.AllowGet);
        }


        [AuditingAuthorizeAttribute("SetProviderReportsAccess", Roles = "SuperAdmin,ProviderAdmin")]
        [ValidateAntiForgeryToken]
        [AcceptVerbs(HttpVerbs.Post)]
        public ViewResult SetProviderReportsAccess([ModelBinder(typeof(EncryptedStringBinder))] string emailAddress, bool setEnabled)
        {
            bool userRoleChangeSuccess;

            _MembershipAdministrationService.AddUserToRole(emailAddress, new string[] { ConstantManager.StoredProcedureConstants.ProviderReportsViewer }, GetLoggedInUsersProviderId(), _MembershipService.GetUsersProviderId(emailAddress, false));

            ViewData.SetValue(GlobalViewDataKey.StatusMessage, "User access to provider reports successfully changed.");

            return AdministerUser(emailAddress, null);
        }

        #region PartialViews

        [AuditingAuthorizeAttribute("UserAdministrativeLink", Roles = "SuperAdmin,ProviderAdmin")]
        [AcceptVerbs(HttpVerbs.Get)]
        public ViewResult UserAdministrativeLink(int userIndex)
        {
            RMSeBubbleMembershipUser user;

            user = GetUserFromIndex(userIndex);

            return View(user);
        }

        //[AuditingAuthorize("UserDocumentTypesList", Roles = "SuperAdmin,ProviderAdmin,DocumentAdmin")]
        public ViewResult UserDocumentTypesList([ModelBinder(typeof(EncryptedStringBinder))] string userName, bool showFormActions)
        {
            IDictionary<short, string> userDocumentTypes;
            int userIndex;
            int UserProviderID;
            ViewData["ShowFormActions"] = showFormActions;
            ViewData["UserName"] = userName;

            userIndex = _MembershipService.GetUserIndex(userName);
            UserProviderID = Convert.ToInt16(_MembershipService.GetUsersProviderId(userName, false));
            userDocumentTypes = _DocumentTypesRepository.GetUsersDocumentTypes(userIndex, UserProviderID);

            return View(userDocumentTypes);
        }

        [AuditingAuthorize("EditUserDocumentTypes", Roles = "SuperAdmin,ProviderAdmin")]
        public ViewResult EditUserDocumentTypes([ModelBinder(typeof(EncryptedStringBinder))] string UserName)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.ProvidersUsers);
            ViewData["UserName"] = UserName;
            ViewData["ProviderId"] = _MembershipService.GetUsersProviderId(UserName, false);

            return View("EditUserDocumentTypes");
        }

        [AuditingAuthorize("AddDocumentTypeToUser", Roles = "SuperAdmin,ProviderAdmin")]
        [AcceptVerbs(HttpVerbs.Post)]
        [ValidateAntiForgeryToken]
        public ViewResult AddUserDocumentType([ModelBinder(typeof(EncryptedStringBinder))] string UserName, short? DocumentTypeId)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.ProvidersUsers);
            IDictionary<short, string> userDocumentTypes;
            int userIndex;
            int UserProviderID;
            //ViewData["UserName"] = userName;
            userIndex = _MembershipService.GetUserIndex(UserName);
            UserProviderID = Convert.ToInt16(_MembershipService.GetUsersProviderId(UserName, false));
            if (!DocumentTypeId.HasValue)
                ModelState.AddModelError("DocumentTypeRequired", "Required");
            else
            {
                userDocumentTypes = _DocumentTypesRepository.GetUsersDocumentTypes(userIndex, UserProviderID);
                if (userDocumentTypes.ContainsKey(DocumentTypeId.Value))
                    ModelState.AddModelError("DocumentTypeExists", "Exists");
            }

            if (ModelState.IsValid)
            {
                _DocumentTypesRepository.InsertUserDocumentType(userIndex, _MembershipService.GetUsersProviderId(UserName, false).Value, DocumentTypeId.Value);
                ViewData.SetValue(GlobalViewDataKey.StatusMessage, "Document type successfully added to user.");
            }

            return EditUserDocumentTypes(UserName);
        }

        //[AuditingAuthorize("ShowUserDocumentPatientAlpha", Roles = "SuperAdmin,User")]
        public ViewResult ShowUserDocumentPatientAlpha([ModelBinder(typeof(EncryptedStringBinder))] string userName)
        {
            KeyValuePair<char?, char?> documentPatientAlpha;
            int userIndex;
            userIndex = _MembershipService.GetUserIndex(userName);
            documentPatientAlpha = _DocumentTypesRepository.GetUserDocumentPatientAlpha(userIndex, null);
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

            return View();
        }

        /// <summary>
        /// Edits user document patient alpha for logged in user
        /// </summary>
        /// <returns></returns>
        [AuditingAuthorize("EditUserDocumentPatientAlpha", Roles = "SuperAdmin,ProviderAdmin")]
        [AcceptVerbs(HttpVerbs.Get)]

        public ViewResult EditUserDocumentPatientAlpha(string userName)
        {
            UserAlphaSettings userAlphaSettings = new UserAlphaSettings();
            userAlphaSettings.UserName = userName;
            userAlphaSettings.UserIndex = _MembershipService.GetUserIndex(userName);
            userAlphaSettings.ReturnUrl = (Request.UrlReferrer.AbsoluteUri.ToString());
            return View("EditUserDocumentPatientAlpha", userAlphaSettings);
        }


        [AuditingAuthorize("EditUserDocumentPatientAlpha", Roles = "User,SuperAdmin")]
        [AcceptVerbs(HttpVerbs.Post)]
        [ValidateAntiForgeryToken]
        public ActionResult EditUserDocumentPatientAlpha(UserAlphaSettings userAlphaSettings)
        {
            if (!ModelState.IsValid)
                return View("EditUserDocumentPatientAlpha", userAlphaSettings);

            short? userProviderId1;
            short userProviderId;

            userProviderId1 = _MembershipService.GetUsersProviderId(userAlphaSettings.UserName, false);

            userProviderId = (short)userProviderId1;
            _DocumentTypesRepository.UpdateUserDocumentPatientAlpha(userAlphaSettings.UserIndex.Value, userProviderId, userAlphaSettings.patientFirstAlpha.Value, userAlphaSettings.patientLastAlpha.Value);
            ViewData.SetValue(GlobalViewDataKey.StatusMessage, "Settings successfully updated.");
            return View("EditUserDocumentPatientAlpha", userAlphaSettings);
        }

        public ActionResult AlphaSettingsDropDown(UserAlphaSettings userAlphaSettings)
        {
            KeyValuePair<char?, char?> documentPatientAlpha;

            userAlphaSettings.AlfaSettingsList = _DocumentTypesRepository.MemberAlphaSettingsList(userAlphaSettings.UserIndex.Value);
            documentPatientAlpha = _DocumentTypesRepository.GetUserDocumentPatientAlpha(userAlphaSettings.UserIndex.Value, 1);

            if (documentPatientAlpha.Key == null && documentPatientAlpha.Value == null)
                userAlphaSettings.patientFirstAlpha = !userAlphaSettings.patientFirstAlpha.HasValue ? documentPatientAlpha.Key : userAlphaSettings.patientFirstAlpha;
            else
                userAlphaSettings.patientFirstAlpha = !userAlphaSettings.patientFirstAlpha.HasValue ? documentPatientAlpha.Key : userAlphaSettings.patientFirstAlpha;

            return PartialView("AlphaSettingsDropDown", userAlphaSettings);
        }

        public ActionResult AlphaSettingsLastDropDown(UserAlphaSettings userAlphaSettings, char? FirstDropDownSelection)
        {
            KeyValuePair<char?, char?> documentPatientAlpha;

            userAlphaSettings.AlfaSettingsList = _DocumentTypesRepository.MemberAlphaSettingsList(userAlphaSettings.UserIndex.Value);
            documentPatientAlpha = _DocumentTypesRepository.GetUserDocumentPatientAlpha(userAlphaSettings.UserIndex.Value, 1);

            if (documentPatientAlpha.Key == null && documentPatientAlpha.Value == null)
            {
                if (!userAlphaSettings.patientFirstAlpha.HasValue)
                    userAlphaSettings.patientFirstAlpha = null;
                else
                    FirstDropDownSelection = userAlphaSettings.patientFirstAlpha;
                userAlphaSettings.patientLastAlpha = null;
            }
            else
            {
                userAlphaSettings.patientFirstAlpha = documentPatientAlpha.Key;
                userAlphaSettings.patientLastAlpha = documentPatientAlpha.Value;
                FirstDropDownSelection = !FirstDropDownSelection.HasValue ? documentPatientAlpha.Key : FirstDropDownSelection;
            }

            if (FirstDropDownSelection.HasValue)
            {
                ViewData["FirstDropDownSelection"] = FirstDropDownSelection;
                List<MemberAlphaSettings> memberLastAlphaSettingsList;
                memberLastAlphaSettingsList = userAlphaSettings.AlfaSettingsList.Where(m => m.PatientAlpha == FirstDropDownSelection).ToList();
                short RowNum = memberLastAlphaSettingsList[0].RowNum;
                foreach (var item in userAlphaSettings.AlfaSettingsList.Where(m => m.RowNum > RowNum).ToList())
                {
                    if (!item.UserIndex.HasValue || item.UserIndex == userAlphaSettings.UserIndex.Value)
                        memberLastAlphaSettingsList.Add(item);
                    else
                        break;
                }

                if (userAlphaSettings.patientFirstAlpha != FirstDropDownSelection)
                    userAlphaSettings.patientLastAlpha = null;

                userAlphaSettings.AlfaSettingsList = memberLastAlphaSettingsList;
                return PartialView("AlphaSettingsLastDropDown", userAlphaSettings);
            }
            ViewData["FirstDropDownSelection"] = null;

            return PartialView("AlphaSettingsLastDropDown", userAlphaSettings);
        }

        /// <summary>
        /// Reset the Alpha Setting For the user
        /// </summary>
        /// <param name="userAlphaSettings">Model foe alpha settings</param>
        /// <returns>View</returns>
        public ViewResult ClearAlphaSettings(UserAlphaSettings userAlphaSettings)
        {
            userAlphaSettings.ShowValidationForAlpha = true;
            KeyValuePair<char?, char?> documentPatientAlpha;
            documentPatientAlpha = _DocumentTypesRepository.GetUserDocumentPatientAlpha(userAlphaSettings.UserIndex.Value, 1);

            if (documentPatientAlpha.Key == null && documentPatientAlpha.Value == null)
                ViewData.SetValue(GlobalViewDataKey.StatusMessage, "No alpha Settings Exist for the User");

            else
            {
                _DocumentTypesRepository.ClearAlphaSettings(userAlphaSettings.UserName);
                ViewData.SetValue(GlobalViewDataKey.StatusMessage, "Settings successfully removed.");
            }
            userAlphaSettings.patientFirstAlpha = null;
            userAlphaSettings.patientLastAlpha = null;

            return View("EditUserDocumentPatientAlpha", userAlphaSettings);
        }

        //[AuditingAuthorize("EditUserDocumentPatientAlphaPost", Roles = "SuperAdmin,ProviderAdmin")]
        //[AcceptVerbs(HttpVerbs.Post)]
        //[ValidateAntiForgeryToken]
        //public ActionResult EditUserDocumentPatientAlpha(char patientFirstAlpha, char patientLastAlpha)
        //{
        //    int userIndex;
        //    short userProviderId;
        //    userIndex = GetLoggedInUserIndex();
        //    userProviderId = GetLoggedInUsersProviderId();

        //    _DocumentTypesRepository.UpdateUserDocumentPatientAlpha(userIndex, userProviderId, patientFirstAlpha, patientLastAlpha);

        //    ViewData.SetValue(GlobalViewDataKey.StatusMessage, "Settings successfully updated.");

        //    // hack, return member index view
        //    return View();
        //}






        [AuditingAuthorize("RemoveDocumentTypeFromUser", Roles = "SuperAdmin,ProviderAdmin")]
        [AcceptVerbs(HttpVerbs.Post)]
        public ViewResult RemoveDocumentTypeFromUser([ModelBinder(typeof(EncryptedStringBinder))] string UserName, short? DocumentTypeId)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.ProvidersUsers);
            int userIndex;
            userIndex = _MembershipService.GetUserIndex(UserName);

            _DocumentTypesRepository.DeleteUserDocumentType(userIndex, DocumentTypeId.Value);
            ViewData.SetValue(GlobalViewDataKey.StatusMessage, "Document type successfully removed from user.");

            return EditUserDocumentTypes(UserName);
        }

        [AuditingAuthorizeAttribute("UserAdministrativeLink", Roles = "SuperAdmin,ProviderAdmin")]
        [AcceptVerbs(HttpVerbs.Get)]
        public ViewResult DisplayNameAndEmailAddress(int userIndex)
        {
            RMSeBubbleMembershipUser user;

            user = GetUserFromIndex(userIndex);

            return View(user);
        }

        #endregion

        private RMSeBubbleMembershipUser GetUserFromIndex(int userIndex)
        {
            RMSeBubbleMembershipUser user;
            string emailAddress;

            emailAddress = _MembershipService.GetUserNameFromIndex(userIndex);
            if (String.IsNullOrEmpty(emailAddress))
                throw new ArgumentException("No user exists with index " + userIndex + ".", "userIndex");

            user = _MembershipService.GetUser(emailAddress, false);

            return user;
        }

        private int GetLoggedInUserIndex()
        {
            return _MembershipService.GetUserIndex(base.User.Identity.Name);
        }

        private short GetLoggedInUsersProviderId()
        {
            short providerId;

            providerId = _MembershipService.GetUsersProviderId(base.User.Identity.Name, true).Value;

            return providerId;
        }

        private bool ValidateAdministrativeRegistration(RMSeBubbleMembershipUser newUser)
        {
            IEnumerable<ErrorInfo> errors = null;

            if (String.IsNullOrEmpty(newUser.Email))
                ModelState.AddModelError("EmailRequired", "You must specify an Email Address.");
            if (String.IsNullOrEmpty(newUser.PersonalInformation.FirstName))
                ModelState.AddModelError("PersonalInformation.FirstNameRequired", "Required");
            if (String.IsNullOrEmpty(newUser.PersonalInformation.LastName))
                ModelState.AddModelError("PersonalInformation.LastNameRequired", "Required");
            if (!String.IsNullOrEmpty(newUser.Email))
                errors = _MembershipService.ValidateAdministrativeRegistrationData(MemberRoleType.User,
                    newUser);

            if (errors != null && errors.Count() > 0)
                errors.CopyToModelState(ModelState, null);

            return ModelState.IsValid;
        }


        /// </RevisionHistory>
        /// <summary>
        /// Display Roles list in partialView
        /// </summary>
        /// <returns>Actionresult for partial view</returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 02/13/2014 | Abdul   | Created
        /// </RevisionHistory>
        [ValidateInput(false)]
        public ActionResult Roles(int Id = 0) //used by surekha
        {
            ViewData["IsSuperAdmin"] = false;
            if (HttpContext.User.IsInRole(ConstantManager.StoredProcedureConstants.SuperAdminRoleAcess))
            {
                ViewData["IsSuperAdmin"] = true;
            }
            DisplayRoleRights roles;
            if (Id == 0)
            {
                RMSeBubbleRoleService roleService = new RMSeBubbleRoleService();
                roles = roleService.GetRoleRights();
                return PartialView(roles);
            }
            else
            {
                return PartialView(GetRolesListByUserIndex(Id));
            }
        }

        //created by surekha
        [AuditingAuthorizeAttribute("ManageRoles", Roles = "SuperAdmin")]
        public ActionResult ManageRoles(string successStatus = null)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.ManageRoles);
            ViewData["IsSuperAdmin"] = false;
            if (HttpContext.User.IsInRole(ConstantManager.StoredProcedureConstants.SuperAdminRoleAcess))
            {
                ViewData["IsSuperAdmin"] = true;
            }
            if (!string.IsNullOrEmpty(successStatus) && successStatus.Contains("False"))
                //ViewData["DeleteRole"] = status;
                ModelState.AddModelError("DeleteRole", "Cannot delete an Assigned role");
            else
            {
                ViewData["Status"] = successStatus;
            }

            return View();
        }

        public ActionResult Rights(string selectedID)
        {
            string selectedRoleId = !String.IsNullOrEmpty(Request.Params["roleid"]) ? Request.Params["roleid"] : selectedID;

            DisplayRoleRights displayRoleRights = new DisplayRoleRights();
            RMSeBubbleRoleService roleService = new RMSeBubbleRoleService();
            displayRoleRights = roleService.GetRoleSpecificRights(selectedRoleId);
            return PartialView("Rights", displayRoleRights.RoleRightsList);
        }

        //created by surekha: for loading user rights document 
        public ActionResult ShowRightSnapshot()
        {
            return PartialView("RightSnapshotPopup");
        }

        /// <summary>
        /// For Rights List based on Role Id
        /// </summary>
        /// <param name="roleId">Role Id of role whose rights list is to be displayed</param>
        /// <returns>ActionResult for partial View</returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 02/14/2014 | Abdul   | Created
        /// </RevisionHistory>
        public ActionResult RoleSpecificRights(string roleId)
        {
            RMSeBubbleRoleService _RoleProviderService = new RMSeBubbleRoleService();
            DisplayRoleRights Rights;
            Rights = _RoleProviderService.GetRoleRights();

            return PartialView(Rights);
        }

        /// <summary>
        /// Display view for add and Edit roles Respectively
        /// </summary>
        /// <returns>AddEditRole View</returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 02/12/2014 | Abdul   | Created
        /// </RevisionHistory>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult AddEditRole(string roleId)
        {
            if (HttpContext.User.IsInRole(ConstantManager.StoredProcedureConstants.SuperAdminRoleAcess))
            //if (HttpContext.User.IsInRole("ProviderAdmin"))
            {
                ViewData["ComboBoxDisplay"] = true;
                ViewData["ComboBoxList"] = Enum.GetValues(typeof(Enumerators.RoleAcessTypes)).Cast<Enumerators.RoleAcessTypes>().ToList();
            }
            ManageRoleRights AllRoleRights = GetRightsByRoleId(roleId);
            return View("AddEditRole", AllRoleRights);
        }

        public ActionResult GetEditRolesGridPartial(string roleId) //Grid Partial for roles by guru
        {
            ManageRoleRights AllRoleRights = GetRightsByRoleId(roleId);
            return PartialView("AddEditRolesGrid", AllRoleRights);
        }


        private ManageRoleRights GetRightsByRoleId(string roleId)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.ManageRoles);
            RMSeBubbleMembershipProvider membershipProvider = (RMSeBubbleMembershipProvider)System.Web.Security.Membership.Providers["RMSeBubbleMembershipProvider"];
            ManageRoleRights manageAllRoleRights = new ManageRoleRights();
            List<MembershipRights> alreadyAssignedRights = new List<MembershipRights>();

            if (HttpContext.User.IsInRole(ConstantManager.StoredProcedureConstants.SuperAdminRoleAcess))
                manageAllRoleRights.RoleRightsList = membershipProvider.GetAllRights(true).ToList();

            else
                manageAllRoleRights.RoleRightsList = membershipProvider.GetAllRights().ToList();

            //if role id is null show all rights
            if (roleId == null)
            {
                manageAllRoleRights.RoleId = null;
                return manageAllRoleRights;
                // return View("AddEditRole", AllRoleRights);
            }

            manageAllRoleRights.RoleId = roleId;
            alreadyAssignedRights = membershipProvider.GetRoleRights(roleId).ToList();
            List<string> temp = new List<string>();
            //temp = null;
            foreach (var item in alreadyAssignedRights)
            {
                temp.Add(item.MenuName);
            }
            foreach (var item in manageAllRoleRights.RoleRightsList)
            {

                if (temp.Contains(item.MenuName))
                    item.IsAssigned = true;
            }
            if (alreadyAssignedRights.Count != 0)
            {
                manageAllRoleRights.RoleName = alreadyAssignedRights[0].RoleName;
                manageAllRoleRights.AccessType = alreadyAssignedRights[0].AccessType;
            }
            if (!HttpContext.User.IsInRole(ConstantManager.StoredProcedureConstants.SuperAdminRoleAcess) &&( manageAllRoleRights.AccessType ==Enumerators.RoleAcessTypes.Protected|| manageAllRoleRights.AccessType ==Enumerators.RoleAcessTypes.Public))
            {
                throw new Exception("Permissions denied!!!");
            }
            return manageAllRoleRights;
        }


        /// <summary>
        /// Save button action method on EditRole Screen
        /// to change the existing Role's Rights
        /// </summary>
        /// <param name="roleId">role to be Modified</param>
        /// <param name="selectedRights">string of comma seperated rights</param>
        /// <returns></returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 02/11/2014 | Abdul   | Created
        /// </RevisionHistory>   

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult AddEditRole(ManageRoleRights AllRoleRights)
        {
            String successStatus = null;
            string AssignedRights = null;
            string RemovedRights = null;
            string roleId = !String.IsNullOrEmpty(Request.Params["selected_roleId"]) ? Request.Params["selected_roleId"] : null;
            string roleName = null;
            string selectedRights = null;
            selectedRights = !String.IsNullOrEmpty(Request.Form["all_checkbox_value"]) ? Request.Form["all_checkbox_value"] : null;
            if (!String.IsNullOrEmpty(Request.Form["AccessType"]))
            {
                Enumerators.RoleAcessTypes Roleaccess;
                Enum.TryParse(Request.Form["AccessType"], out Roleaccess);
                AllRoleRights.AccessType = Roleaccess;
            }
          
            Enumerators.RoleAcessTypes accesstype = AllRoleRights.AccessType;
            if (string.IsNullOrEmpty(selectedRights))
            {
                ModelState.AddModelError("selectedRights", "No Rights Selected Atleast 1 Right needed");
                AllRoleRights = GetRightsByRoleId(roleId);
                return View(AllRoleRights);
            }

            if (roleId != null && AllRoleRights.AccessType==0 && !String.IsNullOrEmpty(Request.Form["AccessType"]))
            {
                throw new Exception("tried to access a unauthorized role");
            }
            RMSeBubbleRoleService roleService = new RMSeBubbleRoleService();
            if (AllRoleRights.AccessType==0)
                AllRoleRights.AccessType = Enumerators.RoleAcessTypes.Private;

            if (roleId != null)
            {
                DataSet ds = roleService.ModifyRoleRights(roleId, selectedRights, AllRoleRights.AccessType);
                if ((ds.Tables.Count > 0) && (ds.Tables[0].Rows.Count > 0))//dataset is not emopty
                {
                    AssignedRights = ds.Tables[0].Rows[0].ItemArray[0].ToString();
                    RemovedRights = ds.Tables[0].Rows[0].ItemArray[1].ToString();
                }
                _MembershipAdministrationService.RoleLogEvent("role modified", roleId, selectedRights, AssignedRights, RemovedRights);
                successStatus = "Role Modified Successfully";
            }
            else
            {
                roleName = Request.Params["rolename"];
                if (HttpContext.User.IsInRole(ConstantManager.StoredProcedureConstants.SuperAdminRoleAcess))
                {
                    ViewData["ComboBoxDisplay"] = true;
                    ViewData["ComboBoxList"] = Enum.GetValues(typeof(Enumerators.RoleAcessTypes)).Cast<Enumerators.RoleAcessTypes>().ToList();
                    if (!Regex.IsMatch(roleName, @"^(SA_).*[a-zA-Z1-9]"))
                    {
                       
                        ModelState.AddModelError("roleName", "SuperAdmin Created Role Name must start with SA_");
                        AllRoleRights = GetRightsByRoleId(roleId);
                        AllRoleRights.RoleName = roleName;
                        AllRoleRights.AccessType = accesstype;
                        return View(AllRoleRights);
                    }
                }
                else
                {
                    if (Regex.IsMatch(roleName, @"^(SA_).*[a-zA-Z1-9] | ^(SA_)") || Regex.IsMatch(roleName, @"^(SA_)") || Regex.IsMatch(roleName, @"^(sa_).*[a-zA-Z1-9] | ^(SA_)") || Regex.IsMatch(roleName, @"^(sa_)"))
                    {
                        ModelState.AddModelError("roleName", "Can't create a Role Name Starting with SA_ ");
                        AllRoleRights = GetRightsByRoleId(roleId);
                        AllRoleRights.RoleName = roleName;
                        return View(AllRoleRights);
                    }
                }

                if (String.IsNullOrEmpty(roleName))
                {
                    ModelState.AddModelError("roleName", "Role Name Cannot be null");
                    AllRoleRights = GetRightsByRoleId(roleId);

                    return View(AllRoleRights);
                }
                String status = roleService.CreateRole(roleName, selectedRights, AllRoleRights.AccessType);
                //String status = roleService.CreateRole(roleName, selectedRights);
                if (!String.IsNullOrEmpty(status))
                {
                    ModelState.AddModelError("roleName", status);
                    AllRoleRights = GetRightsByRoleId(roleId);

                    return View(AllRoleRights);
                }
                _MembershipAdministrationService.RoleLogEvent("role created", roleId, selectedRights, null, null, roleName);
                successStatus = "New Role Created Successfully";
            }
            return RedirectToAction("ManageRoles", "AccountAdministration", new { successStatus });
            //return View("ManageRoles");
        }


        public ActionResult DeleteRole(string rolename)
        {
            string status = null;
            short providerId = GetLoggedInUsersProviderId();
            RMSeBubbleRoleService roleService = new RMSeBubbleRoleService();
            if (roleService.GetUsersInRole(rolename,providerId).Count() == 0)
            {
                roleService.DeleteRole(rolename, false);
                status = "Role Deleted Successfully";
            }
            else
                status = "False";
            return RedirectToAction("ManageRoles", new { successStatus = status });
        }


        /// <summary>
        ///Display All provider Users and their corresponding Roles
        /// </summary>
        /// <returns></returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 01/28/2014 | Abdul   | Created
        /// </RevisionHistory>
         [AuditingAuthorizeAttribute("DisplayUserRoles", Roles = "SuperAdmin")]
        public ActionResult DisplayUserRoles(string status = null)
        {
            IEnumerable<RMSeBubbleMembershipUser> providersUsers;
            short usersProviderId;

            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.DisplayUserRoles);
            usersProviderId = GetLoggedInUsersProviderId();
            providersUsers = _MembershipAdministrationService.GetProvidersUsers(usersProviderId);
            ViewData["Status"] = status;
            return View("UserRoles", providersUsers);
        }

        public ActionResult UserRolesPatial()
        { //used by surekha

            IEnumerable<RMSeBubbleMembershipUser> providersUsers;
            short usersProviderId;

            usersProviderId = GetLoggedInUsersProviderId();
            providersUsers = _MembershipAdministrationService.GetProvidersUsers(usersProviderId);

            return PartialView("UserRolesPatial", providersUsers);

        }


        /// <summary>
        /// Diplay Edit user roles Screen
        /// </summary>
        /// <param name="id">User Id whose roles are to be modified</param>
        /// <returns>Action result</returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 01/14/2014 | Abdul   | Created
        /// </RevisionHistory>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult EditUserRoles([ModelBinder(typeof(EncryptedIntegerBinder))] int id, bool isPost = false)
        {
            ViewData["UserName"] = _MembershipService.GetUserNameFromIndex(id);
            ViewData["id"] = id;
            if (isPost == true)
                ViewData["selectedRoles"] = "No Roles Selected";
            return View("EditUserRoles");
        }

        /// <summary>
        /// gets the roles list by user Index
        /// </summary>
        /// <param name="id">User Index</param>
        /// <returns>DiplayRoleRights Model holding roles details of user</returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 01/14/2014 | Abdul   | Created
        /// </RevisionHistory>
        private DisplayRoleRights GetRolesListByUserIndex(int id)
        {
            //Commented by surekha 
            int index = 0;
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.DisplayUserRoles);
            RMSeBubbleMembershipProvider MembershipProvider = (RMSeBubbleMembershipProvider)System.Web.Security.Membership.Providers["RMSeBubbleMembershipProvider"];
            DisplayRoleRights allRolesRights = new DisplayRoleRights();

            allRolesRights.RolesList = MembershipProvider.GetAllRoles(base.User.Identity.Name, id);

            //if role id is null show all rights
            if (id == null)
            {
                return allRolesRights;
                // return View(AllRolesRights);
            }
            String UserName = _MembershipService.GetUserNameFromIndex(id);
            ViewData["UserName"] = allRolesRights.RolesList[0].UserName;

            string[] UserRoleList = _MembershipService.GetUserRoles(UserName,_MembershipService.GetUsersProviderId(UserName,false));
            UserName.Contains(allRolesRights.RolesList[index].RoleName);

            //Commented by Guru
            //now setting Up IsAssigned flag True if Role is already assigned to user
            foreach (var item in allRolesRights.RolesList)
            {
                if (UserRoleList.Contains(allRolesRights.RolesList[index].RoleName))
                    allRolesRights.RolesList[index].IsAssigned = true;
                else
                    allRolesRights.RolesList[index].IsAssigned = false;
                index++;
            }

            return allRolesRights;
        }

        /// <summary>
        /// Modify the user role the User Roles(post Method)
        /// </summary>
        /// <param name="userName">Name of the user </param>
        /// <param name="selectedRoles">selected Roles to be assigned</param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult EditUserRoles()
        {
            int userIndex;
            int.TryParse(Request.Params["editUserIndex"], out userIndex);
            string[] selectedRoles = Request.Params["all_checkbox_value"].Split(',');
            short? providerId;
            if (String.IsNullOrEmpty(selectedRoles[0]))
            {
                HtmlHelper htmlHelper = RISARC.Common.Extensions.HtmlHelperExtensions.GetHtmlHelper(this);

                string encrypteduserIndex = EncryptionExtensions.Encrypt(htmlHelper, userIndex);
                return RedirectToAction("EditUserRoles", "AccountAdministration", new { id = encrypteduserIndex, isPost = true });
            }
            string UserName = _MembershipService.GetUserNameFromIndex(userIndex);
            providerId = _MembershipService.GetUsersProviderId(UserName, false);
            string[] UserCurrentRoles = _MembershipService.GetUserRoles(UserName,providerId);
            _MembershipAdministrationService.EditUserRole(UserName, selectedRoles, UserCurrentRoles, GetLoggedInUsersProviderId(),providerId);

            return RedirectToAction("DisplayUserRoles", "AccountAdministration", new { status = "Edit Successful" });
        }


        private static IList<DocumentFormatType> AllAvailableFormatTypes()
        {
            IList<DocumentFormatType> lstDocumentFormatTypes;
            lstDocumentFormatTypes = DocumentsAdminService.GetAllProviderDocumentFormat().ToList();

            return lstDocumentFormatTypes;
        }

        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 01/26/2014 | Abdul   | Created
        /// </RevisionHistory>
        public ActionResult AvailableFormatTypes()
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.AvailableFormatTypes);
            return View(AllAvailableFormatTypes());
        }

        //Surekha
        public ActionResult AvailableFormatTypesPartial()
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.AvailableFormatTypes);
            return PartialView("AvailableFormatTypesPartial", AllAvailableFormatTypes());
        }
        // ends

        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 01/26/2014 | Abdul   | Created
        /// </RevisionHistory>
        public ActionResult OrganizationDocumentFormat(short? ProviderIdToAdministrate)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.SelectProvidersAdministrators);
            IList<DocumentFormatType> lstDocumentFormatTypes;
            lstDocumentFormatTypes = DocumentsAdminService.GetAllProviderDocumentFormat(ProviderIdToAdministrate).ToList();
            string path = Request.UrlReferrer.AbsolutePath.ToString();
            if (!path.Contains("SelectProvidersAdministrators"))
            {
                ViewData["ProviderAdmin"] = 1;
            }
            return PartialView("OrganizationDocumentFormat", lstDocumentFormatTypes);
        }

        public ActionResult AddDocumentFormatType(DocumentFormatType documentFormatType)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.AvailableFormatTypes);
            if (!Regex.IsMatch(documentFormatType.DocumentFormat, @"^[a-zA-Z]{3,5}$"))
            {
                ViewData["EditError"] = "format type must only contain alphabets length between 3-5";
                return PartialView("AvailableFormatTypesPartial", AllAvailableFormatTypes());
            }
            bool errorstatus = DocumentsAdminService.InsertDocumentFormat(documentFormatType.DocumentFormat, documentFormatType.Description, GetLoggedInUserIndex());
            if (documentFormatType.Description == null)
            {
                ViewData["EditError"] = "Please Enter Proper Description";
                return PartialView("AvailableFormatTypesPartial", AllAvailableFormatTypes());
            }
            if (errorstatus == false)
            {
                ViewData["EditError"] = "Please, correct all errors.";
                return PartialView("AvailableFormatTypesPartial", AllAvailableFormatTypes());
            }
            return PartialView("AvailableFormatTypesPartial", AllAvailableFormatTypes());

        }

        public ActionResult EditDocumentFormatType(DocumentFormatType documentFormatType)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.AvailableFormatTypes);
            short Id = (Int16)documentFormatType.Id;
            if (!Regex.IsMatch(documentFormatType.DocumentFormat, @"^[a-zA-Z]{3,5}$"))
            {
                ViewData["EditError"] = "format type must only contain alphabets length between 3-5";
                return PartialView("AvailableFormatTypesPartial", AllAvailableFormatTypes());
            }
            if (documentFormatType.Description == null)
            {
                ViewData["EditError"] = "Please Enter Proper Description";
                return PartialView("AvailableFormatTypesPartial", AllAvailableFormatTypes());
            }
            DocumentsAdminService.EditDocumentFormats(Id, documentFormatType.DocumentFormat, documentFormatType.Description, GetLoggedInUserIndex());

            return PartialView("AvailableFormatTypesPartial", AllAvailableFormatTypes());

        }

        public ActionResult DeleteDocumentFormatType(DocumentFormatType documentFormatType)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.AvailableFormatTypes);
            short Id = (Int16)documentFormatType.Id;
            DocumentsAdminService.SoftDeleteDocumentFormat(Id, GetLoggedInUserIndex());
            return PartialView("AvailableFormatTypesPartial", AllAvailableFormatTypes());

        }


        public void EditProviderDocumentFormatType(short? providerId, string DocumentFormatTypesId)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.SelectProvidersAdministrators);
            //All Checked Ids 
            //  string[] AllCheckbox = DevExpress.Web.Mvc.ListBoxExtension.GetSelectedValues<string>("OrgDocumentFormatList");
            //string.Join(",", AllCheckbox);
            // DocumentsAdminService.EditProviderDocumentFormat(providerId, string.Join(",", AllCheckbox));

            DocumentsAdminService.EditProviderDocumentFormat(providerId, DocumentFormatTypesId);

        }
    }
}

