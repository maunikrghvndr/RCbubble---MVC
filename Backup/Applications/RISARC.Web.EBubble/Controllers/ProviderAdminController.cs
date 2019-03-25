using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Ajax;
using SpiegelDg.Security.Model;
using RISARC.Membership.Service;
using RISARC.Setup.Implementation.Repository;
using RISARC.Emr.Web.DataTypes;
using RISARC.Membership.Model;
using System.Collections.ObjectModel;
using SpiegelDg.Common.Validation;
using SpiegelDg.Common.Web.Extensions;
using RISARC.Setup.Model;
using RISARC.Files.Model;
using RISARC.Files.Service;
using RISARC.Common.ValidationUtilities;
using System.Configuration;
using Microsoft.Practices.EnterpriseLibrary.ExceptionHandling;
using RISARC.Membership.Implementation.Repository;
using System.Text;
using RISARC.Common;
using RISARC.Encryption.Model;
using RISARC.Documents.Model;

namespace RISARC.Web.EBubble.Controllers
{
    public class ProviderAdminController : Controller
    {
        private IProviderRepository _ProviderRepository;
        private IRMSeBubbleMempershipService _MembershipService;
        private IMembershipAdministrationService _MembershipAdministrationService;
        private IFilesService _FilesService;
        private IDocumentTypesRepository _DocumentTypeRepository;
        private const string _FileHeaderKey = "content-disposition";
        private const string _FileHeaderFormat = "attachment; filename={0}";
        private static double _LowestMinimumDocumentPrice;
        // private IMembershipInvitationService _MembershipInvitationService;
        //
        // GET: /ProviderAdmin/

        static ProviderAdminController()
        {
            string lowestMinimumDocumentPriceValue = ConfigurationManager.AppSettings["LowestMinimumDocumentPrice"];
            if (String.IsNullOrEmpty(lowestMinimumDocumentPriceValue))
                throw new ConfigurationErrorsException("LowestMinimumDocumentPrice not configured");

            _LowestMinimumDocumentPrice = Convert.ToDouble(lowestMinimumDocumentPriceValue);
        }

        public ProviderAdminController(IProviderRepository providerRepository,
            IRMSeBubbleMempershipService membershipService,
            IMembershipAdministrationService membershipAdministrationService,
            IFilesService filesService,
            IDocumentTypesRepository documentTypeRepository)
        {
            this._ProviderRepository = providerRepository;
            this._MembershipService = membershipService;
            this._MembershipAdministrationService = membershipAdministrationService;
            this._FilesService = filesService;
            this._DocumentTypeRepository = documentTypeRepository;
        }

        [AuditingAuthorize("Index", Roles = "SuperAdmin")]
        public ViewResult Index()
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.AdministrateMyProvider);

            IEnumerable<Provider> allProviders;

            allProviders = _ProviderRepository.GetAllProviders();

            return View(allProviders);
        }

        [AcceptVerbs(HttpVerbs.Get)]
        [AuditingAuthorize("AdministrateMyProvider", Roles = "ProviderAdmin")]
        public ViewResult AdministrateMyProvider()
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.AdministrateMyProvider);
            short? usersProviderId;
            Provider usersProvider;

            usersProviderId = _MembershipService.GetUsersProviderId(User.Identity.Name, true);
            ViewData["ProviderId"] = usersProviderId;

            usersProvider = _ProviderRepository.GetProvider(usersProviderId.Value);

            return View(usersProvider);

        }

        #region Provider Info

        [AcceptVerbs(HttpVerbs.Get)]
        [AuditingAuthorize("EditProviderInfo", Roles = "ProviderAdmin")]
        public ViewResult EditProviderInfo()
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.AdministrateMyProvider);
            short usersProviderId;
            ProviderInfo providerInfo;

            usersProviderId = GetLoggedInUsersProviderId();

            providerInfo = _ProviderRepository.GetProviderInfo(usersProviderId);

            return View(providerInfo);
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [AuditingAuthorize("EditProviderInfoPost", Roles = "ProviderAdmin")]
        public ViewResult EditProviderInfo(ProviderInfo providerInfo)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.AdministrateMyProvider);
            short usersProviderId;

            usersProviderId = GetLoggedInUsersProviderId();
            ICollection<ErrorInfo> errors;

            try
            {
                errors = new Collection<ErrorInfo>();
                ValidateProviderInfo(providerInfo, ref errors);
                if (errors.Count() > 0)
                    throw new RuleException(errors);

                _ProviderRepository.UpdateProviderInfo(usersProviderId, providerInfo);
                ViewData.SetValue(GlobalViewDataKey.StatusMessage, "Provider's Information Successfully Updated.");
            }
            catch (RuleException ex)
            {
                ex.CopyToModelState(ModelState);
            }

            return View(providerInfo);
        }

        #endregion

        #region Provider Configuration

        [AuditingAuthorize("ProviderConfigurationDetails", Roles = "ProviderAdmin")]
        public ViewResult ProviderConfigurationDetails()
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.AdministrateMyProvider);
            ProviderConfiguration providerConfiguration;
            short usersProviderId;

            usersProviderId = GetLoggedInUsersProviderId();
            ViewData["ProviderId"] = usersProviderId;

            providerConfiguration = _ProviderRepository.GetProviderConfiguration(usersProviderId);

            return View(providerConfiguration);
        }

        [AcceptVerbs(HttpVerbs.Get)]
        [AuditingAuthorize("EditProviderConfiguration", Roles = "ProviderAdmin")]
        public ViewResult EditProviderConfiguration()
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.AdministrateMyProvider);
            ProviderConfiguration providerConfiguration;
            short usersProviderId;

            usersProviderId = GetLoggedInUsersProviderId();
            ViewData["ProviderId"] = usersProviderId;
            ViewData["LowestMinimumDocumentPrice"] = _LowestMinimumDocumentPrice;

            //Get assymetric keys for logged in user and RISARC super admin.
            _MembershipService.GetRSAKeysForUserAndSuperAdmin(User.Identity.Name, DocumentFileProcessor.EnableFileEncryption);

            providerConfiguration = _ProviderRepository.GetProviderConfiguration(usersProviderId);
            return View(providerConfiguration);
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [AuditingAuthorize("EditProviderConfiguration", Roles = "ProviderAdmin")]
        public ViewResult EditProviderConfiguration(ProviderConfiguration providerConfiguration)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.AdministrateMyProvider);
            short usersProviderId;
            ICollection<ErrorInfo> errors;

            usersProviderId = GetLoggedInUsersProviderId();
            ViewData["ProviderId"] = usersProviderId;
            ViewData["LowestMinimumDocumentPrice"] = _LowestMinimumDocumentPrice;

            try
            {
                errors = new Collection<ErrorInfo>();

                // following vlaues get set to default of 0 if cannot be bound, so add errors that define both required and invalid
                if (providerConfiguration.PricePerDocumentMegabyte == (double)0)
                    errors.Add("PricePerDocumentMegabyteRequiredInvalid", (string)null);
                if (providerConfiguration.PricePerDocumentPage == (double)0)
                    errors.Add("PricePerDocumentPageRequiredInvalid", (string)null);
                if (providerConfiguration.MinimumDocumentPrice == (double)0)
                    errors.Add("MinimumDocumentPriceRequiredInvalid", (string)null);
                else if (providerConfiguration.MinimumDocumentPrice < _LowestMinimumDocumentPrice)
                    errors.Add("MinimumDocumentPriceBelowMinimum", (string)null);

                //if (providerConfiguration.AcceptsComplianceFormsByFax)
                //{
                //    AddressValidator.ValidatePhoneInfo("ComplianceFormsFaxNumber", "US", providerConfiguration.ComplianceFormsFaxNumber, true, ref errors);
                //}
                //else
                //{
                //    // clear fax phone if not accepting compliance by fax
                //    providerConfiguration.ComplianceFormsFaxNumber = null;
                // }

                if (errors.Count() > 0)
                    throw new RuleException(errors);
            }
            catch (RuleException ex)
            {
                ex.CopyToModelState(ModelState);
            }


            if (ModelState.IsValid)
            {
                _ProviderRepository.UpdateProviderConfiguration(usersProviderId,
                    providerConfiguration.PricePerDocumentPage,
                    providerConfiguration.PricePerDocumentMegabyte,
                    providerConfiguration.MinimumDocumentPrice/*,
                    providerConfiguration.AcceptsComplianceFormsByFax,
                    providerConfiguration.ComplianceFormsFaxNumber*/);

                ViewData.SetValue(GlobalViewDataKey.StatusMessage, "Provider Configuration Successfully Updated.");
            }

            return View(providerConfiguration);
        }

        [AcceptVerbs(HttpVerbs.Get)]
        [AuditingAuthorize("EditPoviderComplianceForm", Roles = "ProviderAdmin")]
        public ViewResult EditPoviderComplianceForm()
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.AdministrateMyProvider);
            return View();
        }

        #endregion

        #region Provider Document Types

        [AcceptVerbs(HttpVerbs.Get)]
        [AuditingAuthorize("EditProvidersDocumentTypes", Roles = "ProviderAdmin")]
        public ViewResult EditProvidersDocumentTypes()
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.AdministrateMyProvider);
            return View();
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [AuditingAuthorize("AddProviderDocumentType", Roles = "ProviderAdmin")]
        [ValidateAntiForgeryToken]
        public ViewResult AddProviderDocumentType(short? documentTypeId)
        {

            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.AdministrateMyProvider);
            if (!documentTypeId.HasValue)
                ModelState.AddModelError("DocumentTypeRequired", "Required");
            else
            {
                _DocumentTypeRepository.InsertProviderDocumentType(GetLoggedInUsersProviderId(), documentTypeId.Value);
                ViewData.SetValue(GlobalViewDataKey.StatusMessage, "Document Type Successfully Added");
            }

            return View("EditProvidersDocumentTypes");
        }

        #endregion

        #region Provider Network

        [AcceptVerbs(HttpVerbs.Get)]
        [AuditingAuthorize("EditProvidersInNetwork", Roles = "ProviderAdmin")]
        public ViewResult EditProvidersInNetwork()
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.AdministrateMyProvider);
            return View();
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [AuditingAuthorize("AddProviderDocumentType", Roles = "ProviderAdmin")]
        [ValidateAntiForgeryToken]
        public ViewResult AddProviderToNetwork(string providerState, string providerCity, short? ProviderId, bool? BAAExists)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.AdministrateMyProvider);
            bool providerExistsInNetwork;
            short loggedInUsersProviderId;

            // two parameters only used for passing back to page to filter providers list
            ViewData["SelectedProviderCity"] = providerCity;
            ViewData["SelectedProviderState"] = providerState;

            if (String.IsNullOrEmpty(providerCity))
                ModelState.AddModelError("ProviderCityRequired", "Required");
            if (String.IsNullOrEmpty(providerState))
                ModelState.AddModelError("ProviderStateRequired", "Required");

            loggedInUsersProviderId = GetLoggedInUsersProviderId();
            if (!ProviderId.HasValue)
            {
                ModelState.AddModelError("ProviderIdRequired", "Required");
            }
            else
            {
                // see if provider already exists in network in network alreay
                providerExistsInNetwork = _ProviderRepository.GetProvidersInNetwork(loggedInUsersProviderId, true).ContainsKey(ProviderId.Value);
                if (providerExistsInNetwork)
                    ModelState.AddModelError("ProviderAlreadyExists", "Provider already exists");
            }

            if (!BAAExists.HasValue)
            {
                ModelState.AddModelError("BAAExistsRequired", "Required");
            }

            if (ModelState.IsValid)
            {
                _ProviderRepository.AddProviderToNetwork(GetLoggedInUsersProviderId(), ProviderId.Value, BAAExists.Value);
                ViewData.SetValue(GlobalViewDataKey.StatusMessage, "Provider successfully added to network.");
            }
            else
            {
                ViewData["ProviderId"] = ProviderId;
                ViewData["BAAExists"] = BAAExists;
            }

            return View("EditProvidersInNetwork");
        }


        [AcceptVerbs(HttpVerbs.Post)]
        [AuditingAuthorize("RemoveProviderFromNetwork", Roles = "ProviderAdmin")]
        public ViewResult RemoveProviderFromNetwork(short ProviderInNetworkId)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.AdministrateMyProvider);
            _ProviderRepository.RemoveProviderFromNetwork(GetLoggedInUsersProviderId(), ProviderInNetworkId);

            ViewData.SetValue(GlobalViewDataKey.StatusMessage, "Provider successfully removed from network.");

            return View("EditProvidersInNetwork");
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [AuditingAuthorize("RemoveProviderFromNetwork", Roles = "ProviderAdmin")]
        public ViewResult UpdateBAASetting(short ProviderInNetworkId, bool BAAExists)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.AdministrateMyProvider);
            _ProviderRepository.UpdateBAASetting(GetLoggedInUsersProviderId(), ProviderInNetworkId, BAAExists);

            if (BAAExists)
                ViewData.SetValue(GlobalViewDataKey.StatusMessage, "BAA Agreement successfully enabled.");
            else
                ViewData.SetValue(GlobalViewDataKey.StatusMessage, "BAA Agreement successfully disabled.");

            return View("EditProvidersInNetwork");
        }

        #endregion

        #region partial views

        /// <summary>
        /// Previews a provider's compliance file.  If provider has not uploaded their own compliance file, renders the link for
        /// the default releast form.
        /// </summary>
        /// <param name="providerId">Id of provider to get compliance file for</param>
        /// <returns></returns>
        [AuditingAuthorizeAttribute("PreviewComplianceFileLink", Roles = "ProviderAdmin")]
        public ActionResult PreviewComplianceFileLink()
        {
            DocumentFile documentFile;
            documentFile = GetComplianceDocument(false);
            return View(documentFile);
        }

        [AuditingAuthorizeAttribute("GetPreviewComplianceFile", Roles = "ProviderAdmin")]
        [AcceptVerbs(HttpVerbs.Get)]
        public FileStreamResult GetPreviewComplianceFile()
        {
            FileStreamResult result;
            DocumentFile documentFile;

            //ROI Should be decrypted using Provider's Private key
            //Check if File encryption is enabled
            documentFile = GetComplianceDocument();

            // make sure so that they download it rather then it takes them to new url
            HttpContext.Response.AddHeader(_FileHeaderKey,
                String.Format(_FileHeaderFormat, documentFile.FileName));

            result = new FileStreamResult(documentFile.Stream, documentFile.ContentType);

            return result;
        }

        private DocumentFile GetComplianceDocument(bool LoadFileStream = true)
        {
            bool IsEncryptionError = false;
            ProviderConfiguration providerConfiguration;
            DocumentFile documentFile;
            short providerId;

            providerId = GetLoggedInUsersProviderId();

            // this method takes provider id rather than the file id directly for security purposes.  If took the file id directly,
            // someone could manually enter any file id and get access to that file

            providerConfiguration = _ProviderRepository.GetProviderConfiguration(providerId);
            try
            {
                if (DocumentFileProcessor.EnableFileEncryption)
                {
                    RSAKeyPair senderRSAKeys = null;
                    RSAKeyPair providerRsaKeys = null;
                    string providerPrivateKeyXml;

                    // to decrypt ROI file using provider's private key 
                    providerRsaKeys = _MembershipService.GetAsymmetricKeysForProvider(providerId);
                    providerPrivateKeyXml = providerRsaKeys.PrivateKey;

                    // to verify digital signature using sender's public key.
                    senderRSAKeys = _MembershipService.GetPublicKeyForUser(providerConfiguration.UploadedByUserName);

                    documentFile = _FilesService.GetFile(providerConfiguration.ComplianceDocumentFileId, LoadFileStream, providerConfiguration.SendersEncryptedSymmetricKey, providerConfiguration.EncryptedVector, providerPrivateKeyXml, senderRSAKeys);
                    IsEncryptionError = true;
                }
                else
                    documentFile = _FilesService.GetFile(providerConfiguration.ComplianceDocumentFileId, LoadFileStream);

                return documentFile;
            }
            catch (Exception ex)
            {
                if (IsEncryptionError && providerConfiguration.ComplianceDocumentFileId != 0)
                {
                    documentFile = _FilesService.GetFile(providerConfiguration.ComplianceDocumentFileId, LoadFileStream);
                    return documentFile;
                }
            }
            return null;
        }

        #region Provider Document Type Related

        [AuditingAuthorizeAttribute("ProvidersDocumentTypesList", Roles = "ProviderAdmin")]
        public ActionResult ProvidersDocumentTypesList(bool showDeleteButton)
        {
            short providerId;

            IDictionary<short, string> providersDocumentTypes;

            ViewData["ShowDeleteButton"] = showDeleteButton;

            providerId = GetLoggedInUsersProviderId();

            providersDocumentTypes = _DocumentTypeRepository.GetProvidersDocumentTypes(providerId);

            return View(providersDocumentTypes);


        }

        /// <summary>
        /// Renders drop down with document types to add to provider, which don't already exist for a provider
        /// </summary>
        /// <returns></returns>
        [AuditingAuthorizeAttribute("AddDocumentTypeToProviderDropDown", Roles = "ProviderAdmin")]
        public ActionResult AddDocumentTypeToProviderDropDown(string fieldName, string emptyOptionText)
        {
            IEnumerable<SelectListItem> selectListItems;

            short providerId;

            IDictionary<short, string> existingProviderDocumentTypes;
            IEnumerable<KeyValuePair<short, string>> allDocumentTypes;

            providerId = GetLoggedInUsersProviderId();
            existingProviderDocumentTypes = _DocumentTypeRepository.GetProvidersDocumentTypes(providerId);

            allDocumentTypes = _DocumentTypeRepository.GetAllDocumentTypes();
            var remainingDocumentTypes = allDocumentTypes.Where(kvp => !existingProviderDocumentTypes.ContainsKey(kvp.Key));

            ViewData.SetValue(GlobalViewDataKey.FieldName, fieldName);
            if (remainingDocumentTypes.Count() > 0)
            {
                selectListItems = from documentType in remainingDocumentTypes
                                  orderby documentType.Value
                                  select new SelectListItem
                                  {
                                      Text = documentType.Value,
                                      Value = documentType.Key.ToString()
                                  };

                ViewData.SetValue(GlobalViewDataKey.OptionText, emptyOptionText);
            }
            else
            {
                selectListItems = new Collection<SelectListItem>();
                ViewData.SetValue(GlobalViewDataKey.OptionText, "-No Document Types Remaining-");
            }


            return View("DropDown", selectListItems);
        }

        #endregion

        #region Provider Network Related

        [AuditingAuthorizeAttribute("ProvidersInNetworkList", Roles = "ProviderAdmin")]
        public ViewResult ProvidersInNetworkList(bool showFormActions)
        {
            IDictionary<short, ProviderInNetwork> providersInNetwork;
            ViewData["ShowFormActions"] = showFormActions;

            providersInNetwork = _ProviderRepository.GetProvidersInNetwork(GetLoggedInUsersProviderId(), true);

            return View(providersInNetwork);

        }

        #endregion

        public ActionResult ProvidersDepartmentsDropDown(string fieldName, short providerId, short? selectedValue)
        {
            IEnumerable<SelectListItem> selectListItems;

            selectListItems = (from department in _ProviderRepository.GetProvidersDepartments(providerId)
                               orderby department.Value
                               select new SelectListItem
                               {
                                   Text = department.Value,
                                   Value = department.Key.ToString(),
                                   Selected = department.Key == selectedValue
                               }).ToList();

            ViewData.SetValue(GlobalViewDataKey.FieldName, fieldName);

            if (selectListItems.Count() > 0)
                ViewData.SetValue(GlobalViewDataKey.OptionText, "-Department-");
            else
                ViewData.SetValue(GlobalViewDataKey.OptionText, "-No Departments Exist for Provider-");

            return View("DropDown", selectListItems);
        }

        #endregion

        private short GetLoggedInUsersProviderId()
        {
            short? usersProviderId;

            usersProviderId = _MembershipService.GetUsersProviderId(User.Identity.Name, true);
            if (!usersProviderId.HasValue)
                throw new InvalidOperationException("Logged in user has no provider.");

            return usersProviderId.Value;
        }

        private void ValidateProviderInfo(ProviderInfo providerInfo, ref ICollection<ErrorInfo> errors)
        {
            if (String.IsNullOrEmpty(providerInfo.Name))
                errors.Add("NameRequired", "Reuquired");
            //if (String.IsNullOrEmpty(providerInfo.ProviderNo))
            //    errors.Add("ProviderNoRequired", "Required");
            AddressValidator.ValidateAddressInfo("Address", providerInfo.Address, true, ref errors);
            AddressValidator.ValidateContactInfo("MainContact", providerInfo.Address.CountryCode, providerInfo.MainContact, true, ref errors);
            AddressValidator.ValidatePhoneInfo("FaxNumber", providerInfo.Address.CountryCode, providerInfo.FaxNumber, true, ref errors);
            AddressValidator.ValidateContactInfo("AlternateContact", providerInfo.Address.CountryCode, providerInfo.AlternateContact, true, ref errors);
            AddressValidator.ValidateAddressInfo("BillingAddress", providerInfo.BillingAddress, true, ref errors);
            AddressValidator.ValidateContactInfo("BillingContact", providerInfo.BillingAddress.CountryCode, providerInfo.BillingContact, true, ref errors);
        }

        #region DevxMVCGridView Call back routes.
        [ValidateInput(false)]
        public ActionResult GridViewUserCostSettingsPartial()
        {
            Session["ProviderMembers"] = GetProviderInNetworkForCostSetup(Enumerators.Actions.Edit);
            return PartialView("pvUserDocumentCostSettingsGrid", GetUserCostSettings());
        }

        private List<ProvidersDocumentCostSettings> GetUserCostSettings()
        {
            short usersProviderId;
            usersProviderId = GetLoggedInUsersProviderId();
            var model = _ProviderRepository.GetMembersDocumentCostSettings(usersProviderId);
            return model;
        }

        /// <summary>
        /// Callbackroute for add action of DevExpress GridView
        /// </summary>
        /// <param name="item">Model of ProvidersDocumentCostSettings</param>
        /// <returns>PartialView of cost settings grid.</returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 12/30/2013 | Gurudatta   | Created
        /// </RevisionHistory>
        [HttpPost, ValidateInput(false)]
        public ActionResult GridViewUserCostSettingsAddNewPartial([Bind(Exclude = "FullName")]ProvidersDocumentCostSettings item)
        {
            int result = 0;
            short usersProviderId;
            if (ModelState.IsValid)
            {
                try
                {
                    // Insert here a code to insert the new item in your model
                    usersProviderId = GetLoggedInUsersProviderId();
                    item.UserProviderId = usersProviderId;
                    result = _ProviderRepository.InsertUpdateMemberDocumentCostSettings(item);
                    if (result.Equals(0))
                    {
                        ViewData["EditError"] = "Cost settings are already exists for the selected member.";
                    }
                }
                catch (Exception e)
                {
                    ViewData["EditError"] = e.Message;
                }
            }
            else
                ShowModelErrors();

            return PartialView("pvUserDocumentCostSettingsGrid", GetUserCostSettings());
        }

        /// <summary>
        /// Callbackroute for edit action of DevExpress GridView
        /// </summary>
        /// <param name="item">Model of ProvidersDocumentCostSettings</param>
        /// <returns>PartialView of cost settings grid.</returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 12/30/2013 | Gurudatta   | Created
        /// </RevisionHistory>
        [HttpPost, ValidateInput(false)]
        public ActionResult GridViewUserCostSettingsUpdatePartial([Bind(Exclude = "FullName")]ProvidersDocumentCostSettings item)
        {
            int result = 0;
            if (ModelState.IsValid)
            {
                try
                {
                    // Insert here a code to update the item in your model
                    result = _ProviderRepository.InsertUpdateMemberDocumentCostSettings(item);
                }
                catch (Exception e)
                {
                    ViewData["EditError"] = e.Message;
                }
            }
            else
                ShowModelErrors();

            return PartialView("pvUserDocumentCostSettingsGrid", GetUserCostSettings());
        }

        /// <summary>
        /// Callbackroute for delete action of DevExpress GridView
        /// </summary>
        /// <param name="item">Model of ProvidersDocumentCostSettings</param>
        /// <returns>PartialView of cost settings grid.</returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 12/30/2013 | Gurudatta   | Created
        /// </RevisionHistory>
        [HttpPost, ValidateInput(false)]
        public ActionResult GridViewUserCostSettingsDeletePartial(System.Int32 id)
        {
            int result = 0;
            try
            {
                // Insert here a code to delete the item from your model
                result = _ProviderRepository.DeleteMemberDocumentCostSettings(id);
                if (result.Equals(2))
                {
                    ViewData["EditError"] = "Error occured while deleting the record.";
                }
            }
            catch (Exception e)
            {
                ViewData["EditError"] = e.Message;
            }

            return PartialView("pvUserDocumentCostSettingsGrid", GetUserCostSettings());
        }
        #endregion

        #region Helper Methods

        ///// <summary>
        ///// Get Provider users
        ///// </summary>
        ///// <returns>List of RMSeBubbleMembershipUser.</returns>
        ///// <RevisionHistory>
        ///// Date       | Owner       | Particulars
        ///// ----------------------------------------------------------------------------------------
        ///// 12/24/2013 | Gurudatta   | Created
        ///// </RevisionHistory>
        //public IEnumerable<RMSeBubbleMembershipUser> GetProviderUsers()
        //{
        //    short usersProviderId;
        //    IEnumerable<RMSeBubbleMembershipUser> providersUsers;
        //    usersProviderId = GetLoggedInUsersProviderId();
        //    providersUsers = _MembershipAdministrationService.GetProvidersUsersWithUserRole(usersProviderId);

        //    return (from users in providersUsers
        //            where !users.UserName.Equals(User.Identity.Name)
        //            select users);
        //}

        /// <summary>
        /// Get list of providers in network for document cost setup.
        /// </summary>
        /// <returns>IEnumerable<ProviderInNetwork></returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 01/02/2014 | Gurudatta   | Created
        /// </RevisionHistory>
        public IEnumerable<ProviderInNetwork> GetProviderInNetworkForCostSetup(Enumerators.Actions action)
        {
            short providerId;
            IEnumerable<ProviderInNetwork> providersinNetwork;
            providerId = GetLoggedInUsersProviderId();
            providersinNetwork = _ProviderRepository.GetProvidersInNetworkForCostSettings(providerId, action);
            return providersinNetwork;
        }

        /// <summary>
        /// Show model erros in DevExpress gridview.
        /// </summary>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 01/02/2014 | Gurudatta   | Created
        /// </RevisionHistory>
        private void ShowModelErrors()
        {
            StringBuilder modelErrors = new StringBuilder();
            foreach (ModelState modelState in ModelState.Values)
            {
                foreach (ModelError error in modelState.Errors)
                {
                    // error.ErrorMessage contains the error message
                    modelErrors.AppendFormat("{0}<br/>", error.ErrorMessage);
                }
            }
            //ViewData["EditError"] = "Please, correct all errors.";
            ViewData["EditError"] = modelErrors.ToString();
        }
        #endregion

        #region Manage Provider

        [AuditingAuthorize("ManageProvider", Roles = "SuperAdmin")]
        public ActionResult ManageProvider(Nullable<int> Id)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.ManageProvider);
            FillDropDownsForManageProvider(Id);
            ManageProvider manageProvider = _ProviderRepository.GetManageProvider(Id);
            return View(manageProvider);
        }

        //public ActionResult ManageProviderPartial(Nullable<int> Id)
        //{
        //    FillDropDownsForManageProvider();
        //    ManageProvider manageProvider = _ProviderRepository.GetManageProvider(Id);
        //    return PartialView(manageProvider);
        //}

        [HttpPost]
        [AuditingAuthorize("ManageProvider", Roles = "SuperAdmin")]
        public ActionResult ManageProvider(ManageProvider manageProvider)
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.ManageProvider);

            int RowsAffected = -1;
            if (!ModelState.IsValid)
            {
                ViewData["ErrorFlag"] = "1";
                FillDropDownsForManageProvider(manageProvider.Id);
                return View("ManageProvider", manageProvider);
            }
            if ((manageProvider.Id == null || manageProvider.Id == 0) && _ProviderRepository.IsProviderExist(manageProvider.Name))
            {
                ModelState.AddModelError("Name", "Organization name already present.");
                FillDropDownsForManageProvider(manageProvider.Id);
                return View("ManageProvider", manageProvider);
            }

            RowsAffected = _ProviderRepository.ManageProvider(manageProvider);

            if (RowsAffected > 0)
            {
                ViewData["Message"] = "Organization Saved Successfully";

                //ViewData.SetValue(GlobalViewDataKey.StatusMessage, "Organization Saved Successfully");
                FillDropDownsForManageProvider(manageProvider.Id);
                manageProvider.Id = null;
            }
            else
                ViewData["EMessage"] = "Unable to Save Organization";

            return View(manageProvider);
        }

        /// <summary>
        /// Fills drop down list for Manage Provider.
        /// </summary>
        /// <returns>Dropdown list.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 02/25/2014 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        private void FillDropDownsForManageProvider(Nullable<int> Id)
        {
            // Provider Drop Down
            List<SelectListItem> ProviderList = new List<SelectListItem>();
            IEnumerable<Provider> providers = _ProviderRepository.GetAllProviders();
            foreach (Provider provider in providers)
            {
                ProviderList.Add(new SelectListItem() { Text = provider.ProviderInfo.Name, Value = Convert.ToString(provider.Id) });
            }
            ViewData.Add("ProviderList", ProviderList);
            //Yes - No Valued Drop Downs
            List<SelectListItem> YesNo = new List<SelectListItem>();
            YesNo.Add(new SelectListItem() { Text = "Yes", Value = "True" });
            YesNo.Add(new SelectListItem() { Text = "No", Value = "False" });
            ViewData["YesNo"] = YesNo;
            //ViewData["OrganizationType"] = Enum.GetValues(typeof(Enumerators.OrganizationType)).Cast<Enumerators.OrganizationType>().ToList();
            ViewData["OrganizationType"] = _ProviderRepository.GetOrganizationType();
            ViewData["Countries"] = _ProviderRepository.GetAllCountriesForProvider();
            ViewData["States"] = _ProviderRepository.GetAllSatesForProvider();
            ViewData["City"] = _ProviderRepository.GetAllCityForProvider();
            ViewData["ReviewersForDHS"] = _ProviderRepository.GetReviewersForDHS(Id);
        }
        #endregion
    }
}
