using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DevExpress.Web.Mvc;
using RISARC.Membership.Model;
using DevExpress.Web.ASPxGridView;
using RISARC.Membership.Service;
using RISARC.Emr.Web.DataTypes;
using SpiegelDg.Security.Model;

namespace RISARC.Web.EBubble.Controllers
{
    public class ChangeFacilityController : Controller
    {
        //
        // GET: /ChangeFacility/
        private IMembershipAdministrationService _MembershipAdministrationService;
        private IRMSeBubbleMempershipService _MembershipService;

        public ChangeFacilityController(
            IMembershipAdministrationService membershipAdministrationService,IRMSeBubbleMempershipService membershipService
            )
        {
           
            this._MembershipAdministrationService = membershipAdministrationService;
            this._MembershipService = membershipService;
        }
        [AuditingAuthorize("ManageChangeFacility", Roles = "Superadmin")]
        public ActionResult ManageChangeFacility()
        {
            ViewData.SetValue(GlobalViewDataKey.SelectedLink, SelectedLink.ManageChangeFacility);
            //List<ChangeFacility> ChangeFacilityList = new List<ChangeFacility>();
           // ChangefacilityList changefacilityList = _MembershipAdministrationService.GetChangeFaciltyUserDetails();
            return View();
        }

        public ActionResult _gvChangeFacility(int? UserIndex, string actioncommand = null)
        {
            ViewData["actioncommand"] = actioncommand;
            return PartialView("_gvChangeFacility", ChangeFacilityUserDetails(UserIndex));
        }

        private List<ProviderList> ChangeFacilityUserDetails(int? UserIndex)
        {
            ChangefacilityList changefacilityList = new ChangefacilityList();
            changefacilityList = _MembershipAdministrationService.GetChangeFaciltyUserDetails(UserIndex);
            List<Role> role = new List<Role>();
            ViewData["roleList"] = _MembershipAdministrationService.GetAllPulicProtectedRole();
            if (changefacilityList.changefacilityitem.Count() > 0)
            {
                if (changefacilityList.changefacilityitem[0].AccessibleProviderList.Count() > 0)
                {
                    return (changefacilityList.changefacilityitem[0].AccessibleProviderList);
                }
            }
            return (new List<ProviderList>());
        }

        //public ActionResult _gvChangeFacilityCallback(ChangefacilityList changefacilityList)
        //{
           
        //    changefacilityList = _MembershipAdministrationService.GetChangeFaciltyUserDetails();
        //    var temp = changefacilityList.changefacilityitem.Select(a => a.UserIndex == changefacilityList.UserIndex);
        //    return PartialView("_gvChangeFacility",temp);
        //}

        public ActionResult AddNewChangeFacility(ProviderList ProviderList)
        {
            
            string Roles = Convert.ToString(Request.Form["RolesComboBox"]);
            int userIndex = Convert.ToInt32(Request.Form["UserIndex"]);
            ProviderList.ProviderId = Convert.ToInt32(ProviderList.ProviderName);
            if (ProviderList.ProviderId != 0 && !String.IsNullOrEmpty(Roles))
            {
            string userName = _MembershipService.GetUserNameFromIndex(userIndex);

            int createdBy = _MembershipService.GetUserIndex(User.Identity.Name);
            int providerId = _MembershipService.GetUsersProviderId(base.User.Identity.Name, true).Value;

            bool isAssigned = _MembershipAdministrationService.AssignProviderToUser(userIndex, ProviderList.ProviderId, createdBy);
             if (isAssigned)
             {
                 _MembershipAdministrationService.AddUserToRole(userName, Roles.Split(';'), providerId, ProviderList.ProviderId);
             }

            }
            else
            {
                if (ProviderList.ProviderId == 0)
                {
                    ViewData["ProviderIdError"] = "* Please select organisation\n";
                }
                if (String.IsNullOrEmpty(Roles))
                {
                    ViewData["ProviderIdError"]  += "* Please select roles";
                }
            }

            return PartialView("_gvChangeFacility", ChangeFacilityUserDetails(userIndex));
        }

        public ActionResult EditChangeFacility(ProviderList ProviderList)
        {
            
            int userIndex = Convert.ToInt32(Request.Form["UserIndex"]);
            string Roles = Convert.ToString(Request.Form["RolesComboBox"]);
            string userName = _MembershipService.GetUserNameFromIndex(userIndex);
            if (ProviderList.ProviderId != 0 && !String.IsNullOrEmpty(Roles))
            {
                string[] UserCurrentRoles = _MembershipService.GetUserRoles(userName, Convert.ToInt16(ProviderList.ProviderId));
            int loggedinUserproviderId = _MembershipService.GetUsersProviderId(base.User.Identity.Name, true).Value;

             _MembershipAdministrationService.EditUserRole(userName, Roles.Split(';'), UserCurrentRoles, loggedinUserproviderId, ProviderList.ProviderId);
            }
            else {

                if (ProviderList.ProviderId == 0)
                {
                    ViewData["ProviderIdError"] = "* Please select Organization\n";
                }
                if (String.IsNullOrEmpty(Roles))
                {
                    ViewData["ProviderIdError"] += "* Please select roles";
                }
            
            }

             return PartialView("_gvChangeFacility", ChangeFacilityUserDetails(userIndex));
        }

        public ActionResult DeleteChangeFacility(int ProviderId )
        {  // correct selecred user 

            int userIndex = Convert.ToInt32(Request.Form["UserIndex"]);
            _MembershipAdministrationService.DeleteUserChangeFacility(userIndex , ProviderId);
            return PartialView("_gvChangeFacility", ChangeFacilityUserDetails(userIndex));
        }
       

        public ActionResult UsersOrgnizationsList()
        {
            int providerId = _MembershipService.GetUsersProviderId(base.User.Identity.Name, true).Value;
            List<ChangeFaciltyCombo> ChangeFaciltyCombolist = _MembershipAdministrationService.GetChangeFaciltyCombo(providerId);
            return PartialView("UsersOrgnizationsList",ChangeFaciltyCombolist);
        }

        public ActionResult callBackOfUsersOrgnizationsList(ChangefacilityList changeFacilityList)
        {
            //List<ChangeFacility> ChangeFacilityList = new List<ChangeFacility>();
            changeFacilityList = _MembershipAdministrationService.GetChangeFaciltyUserDetails();
            return PartialView("UsersOrgnizationsList", changeFacilityList);
        }

    }
}
