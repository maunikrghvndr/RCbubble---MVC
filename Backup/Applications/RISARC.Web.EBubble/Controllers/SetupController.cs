using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Ajax;
using SpiegelDg.Security.Model;
using RISARC.Emr.Web.DataTypes;
using RISARC.Membership.Service;
using RISARC.Setup.Implementation.Repository;
using RISARC.Setup.Model;
using System.Collections.ObjectModel;
using System.Collections;
using RISARC.Web.EBubble.Models.Binders;

namespace RISARC.Web.EBubble.Controllers
{
    public class SetupController : Controller
    {
        private IProviderRepository _ProviderRepository;
        private IRMSeBubbleMempershipService _MembershipService;
        private IDocumentTypesRepository _DocumentTypesRepository;

        public SetupController(IProviderRepository providerRepository,
            IRMSeBubbleMempershipService membershipService,
            IDocumentTypesRepository documentTypesRepository)
        {
            this._ProviderRepository = providerRepository;
            this._MembershipService = membershipService;
            this._DocumentTypesRepository = documentTypesRepository;
        }

        /// <summary>
        /// Renders view where provider state, then provider city, then provider can be selected
        /// </summary>
        /// <param name="providerIdFieldName"></param>
        /// <param name="selectedProviderState"></param>
        /// <param name="selectedProviderCity"></param>
        /// <param name="selectedProviderId"></param>
        /// <returns></returns>
        public ViewResult CascadingProviderFilters(string providerIdFieldName, string selectedProviderState, string selectedProviderCity, short? selectedProviderId)
        {
            ViewData["ProviderIdFieldName"] = providerIdFieldName;
            ViewData["SelectedProviderState"] = selectedProviderState;
            ViewData["SelectedProviderCity"] = selectedProviderCity;
            ViewData["SelectedProviderId"] = selectedProviderId;

            return View();
        }

        /// <summary>
        /// Renders possible sities 
        /// </summary>
        /// <param name="fieldName"></param>
        /// <param name="providerState"></param>
        /// <param name="selectedValue"></param>
        /// <returns></returns>
        [OutputCacheAttribute(VaryByParam = "*", Duration = 0, NoStore = true)]
        public ViewResult ProviderCitiesDropDown(string fieldName, string providerState, string selectedValue)
        {
            IEnumerable<SelectListItem> selectListItems;
            IEnumerable<string> cities;
            string actualOptionText;

            ViewData.SetValue(GlobalViewDataKey.FieldName, fieldName);

            if (!String.IsNullOrEmpty(providerState))
            {

                cities = _ProviderRepository.GetProviderCities(providerState);
                if (cities.Count() == 0)
                {
                    actualOptionText = "-No Providers Exist in State.  Please Select Another State-";
                    selectListItems = new Collection<SelectListItem>();
                    ViewData.SetValue(GlobalViewDataKey.Disabled, true);
                }
                else
                {
                    actualOptionText = "-Provider City-";
                    selectListItems = from city in cities
                                      select new SelectListItem
                                      {
                                          Text = city,
                                          Value = city,
                                          Selected = city == selectedValue
                                      };
                }
            }
            else
            {
                actualOptionText = "-Select Provider's State-";
                ViewData.SetValue(GlobalViewDataKey.Disabled, true);
                selectListItems = new Collection<SelectListItem>();
            }

            ViewData.SetValue(GlobalViewDataKey.OptionText, actualOptionText);
            ViewData.SetValue(GlobalViewDataKey.ClassName, fieldName);

            return View("DropDown", selectListItems);
        }

        /// <summary>
        /// Renders drop down of providers in the city and state
        /// </summary>
        /// <param name="fieldName"></param>
        /// <param name="providerCity"></param>
        /// <param name="providerState"></param>
        /// <param name="selectedValue"></param>
        /// <returns></returns>
        [OutputCacheAttribute(VaryByParam = "*", Duration = 0, NoStore = true)]
        public ViewResult ProvidersDropDown(string fieldName, string providerCity, string providerState, short? selectedValue)
        {
            IEnumerable<SelectListItem> selectListItems;
            IEnumerable<Provider> providers;
            string emptyOptionText;

            ViewData.SetValue(GlobalViewDataKey.FieldName, fieldName);

            if (!String.IsNullOrEmpty(providerCity) && !String.IsNullOrEmpty(providerState))
            {
                providers = _ProviderRepository.GetProvidersOfCityAndState(providerState, providerCity);

                emptyOptionText = "-Provider-";
                selectListItems = from provider in providers
                                  select new SelectListItem
                                  {
                                      Text = provider.ProviderInfo.Name,
                                      Value = provider.Id.ToString(),
                                      Selected = provider.Id == selectedValue
                                  };
            }
            else
            {
                emptyOptionText = "-Select Provider's State and City-";
                ViewData.SetValue(GlobalViewDataKey.Disabled, true);
                selectListItems = new Collection<SelectListItem>();
            }

            ViewData.SetValue(GlobalViewDataKey.OptionText, emptyOptionText);
            ViewData.SetValue(GlobalViewDataKey.ClassName, fieldName);

            return View("DropDown", selectListItems);
        }

        [AuditingAuthorizeAttribute("ProviderDocumentTypesDropDown")]
        public ViewResult ProviderDocumentTypesDropDown(string fieldName, string emptyOptionText, short providerId, [ModelBinder(typeof(EncryptedStringBinder))] string username, short? selectedDocumentType, bool IsRemoveUsersAvailableDocType = false)
        {
            IEnumerable<SelectListItem> selectedListItems;
            IDictionary<short, string> documentTypes;
            IDictionary<short, string> userDocumentTypes;

            ViewData.SetValue(GlobalViewDataKey.FieldName, fieldName);
            ViewData.SetValue(GlobalViewDataKey.OptionText, emptyOptionText);
            ViewData.SetValue(GlobalViewDataKey.ClassName, "ProviderDocumentTypesDropDown");


            documentTypes = _DocumentTypesRepository.GetProvidersDocumentTypes(providerId);

            if (documentTypes.Count == 0)
                ViewData.SetValue(GlobalViewDataKey.OptionText, "Provider cannot accept documents.");

            selectedListItems = from documentType in documentTypes.OrderBy(d => d.Value)
                                select new SelectListItem
                                {
                                    Text = documentType.Value,
                                    Value = documentType.Key.ToString(),
                                    Selected = documentType.Key == selectedDocumentType
                                };
            if (IsRemoveUsersAvailableDocType && !String.IsNullOrEmpty(username))
            {
                int userIndex;
                userIndex = _MembershipService.GetUserIndex(username);
                userDocumentTypes = _DocumentTypesRepository.GetUsersDocumentTypes(userIndex, providerId);
                selectedListItems = selectedListItems.Where(p => !userDocumentTypes.Any(p2 => p2.Key == Convert.ToInt16(p.Value)));
            }

            return View("DropDown", selectedListItems);

        }

        //
        // GET: /Setup/

        [AuditingAuthorizeAttribute("AccessableProvidersDropDown", Roles= "SuperAdmin,User")]
        public ViewResult AccessibleProvidersDropDown(string fieldName, string emptyOptionText, int selectedValue)
        {
            IEnumerable<SelectListItem> selectedListItems;
            IDictionary<short, ProviderInNetwork> providers;
            string userName;
            short? providerId;

            ViewData.SetValue(GlobalViewDataKey.FieldName, fieldName);
            ViewData.SetValue(GlobalViewDataKey.OptionText, emptyOptionText);

            // get users provider id.  if null, then list all providers.  If not null, then list
            userName = User.Identity.Name;
            providerId = _MembershipService.GetUsersProviderId(userName, true);
            // providers that user's provider has access to
            if (!providerId.HasValue)
            {
                var allProvidersInNetworkQuery = from provider in _ProviderRepository.GetAllProviders()
                                                 select new ProviderInNetwork(provider.Id, provider.ProviderInfo.Name, false);

                providers = allProvidersInNetworkQuery.ToDictionary(x => x.ProviderId); 
            }
            else
                providers = _ProviderRepository.GetProvidersInNetwork(providerId.Value);

            selectedListItems = from provider in providers
                                select new SelectListItem
                                {
                                    Text = provider.Value.ProviderName,
                                    Value = provider.Key.ToString(),
                                    Selected = provider.Key == selectedValue
                                };

            return View("DropDown", selectedListItems);
        }

        private static IEnumerable<char> _AlphaChars = new Collection<char>{
            {'A'},{'B'},{'C'},{'D'},{'E'},{'F'},{'G'},{'H'},{'I'},{'J'},{'K'},{'L'},
            {'M'},{'N'},{'O'},{'P'},{'Q'},{'R'},{'S'},{'T'},{'U'},{'V'},{'Q'},{'X'},{'Y'},{'Z'}
        };
        /// <summary>
        /// Renders drop down with all alpha characters
        /// </summary>
        public ViewResult AlphaDropDown(string fieldName, string optionText, char? selectedValue)
        {
            IEnumerable<SelectListItem> selectedListItems;

            ViewData.SetValue(GlobalViewDataKey.FieldName, fieldName);
            ViewData.SetValue(GlobalViewDataKey.OptionText, optionText);
            
            selectedListItems = from alpha in _AlphaChars
                                select new SelectListItem
                                {
                                    Text = alpha.ToString(),
                                    Value = alpha.ToString(),
                                    Selected = alpha == selectedValue
                                };

            return View("DropDown", selectedListItems);
        }

        //public ViewResult AlphaSettingsDropDown(string UserName)
        //{
        //    int userIndex;
        //    short? userProviderId1;
        //    short userProviderId;
        //    userIndex = _MembershipService.GetUserIndex(UserName);
        //    userProviderId1 = _MembershipService.GetUsersProviderId(UserName, false);
        //    return View("DropDown", selectedListItems);
        //}
        /// <summary>
        /// Displays provider name for the provider id
        /// </summary>
        /// <param name="providerId"></param>
        /// <returns></returns>
        public string DisplayProviderName([ModelBinder(typeof(EncryptedShortBinder))] short eProviderId)
        {
            ProviderInfo providerInfo;

            providerInfo = _ProviderRepository.GetProviderInfo(eProviderId);

            if (providerInfo == null)
                throw new ArgumentException("No provider exists with id " + eProviderId.ToString() + ".");

            return providerInfo.Name;

        }

    
}
}
