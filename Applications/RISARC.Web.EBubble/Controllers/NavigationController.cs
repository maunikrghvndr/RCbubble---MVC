using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Ajax;
using RISARC.Emr.Web.DataTypes;
using SpiegelDg.Common.Web.Model;
using System.Collections.ObjectModel;
using System.Web.Routing;
using RISARC.Membership.Service;
using RISARC.Membership.Model;
using RISARC.Membership.Implementation.Repository.SqlServer;
//functions have been hadded and
//unnecessary used variables,Functions in the controller have been removed (-by abdul)
namespace RISARC.Web.EBubble.Controllers
{
    public class NavigationController : Controller
    {
        private IRMSeBubbleMempershipService _MembershipService;

        public static new HttpContextBase HttpContext
        {
            get
            {
                HttpContextWrapper context =
                    new HttpContextWrapper(System.Web.HttpContext.Current);
                return (HttpContextBase)context;
            }
        }

        public NavigationController(IRMSeBubbleMempershipService membershipService)
        {
            _MembershipService = membershipService;
        }
        
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 01/14/2014 | Abdul   | Created
        /// <summary>
        /// Reltruns the collection of the Navigation Menu based on the role of the 
        /// logged-in user.
        /// </summary>
        /// </RevisionHistory>
        private ICollection<NavNode> NavigationNode()
        {
            String UserName = HttpContext.User.Identity.Name;
            ICollection<NavNode> Menu = new Collection<NavNode>();
            ICollection<MemberNavigationMenu> memberNavigationMenu = RMSeBubbleMembershipProvider.GetUserMenu(UserName);

            var parentMenus = memberNavigationMenu.Where(m => string.IsNullOrEmpty(m.ParentMenuId));

            foreach (var item in parentMenus)
            {
                ICollection<NavNode> subMenu = new Collection<NavNode>();
                var subMenus = memberNavigationMenu.Where(a => a.ParentMenuId == item.Id);
                foreach (var value in subMenus)
                {
                    NavSettings navSettings = new NavSettings(null, value.Text, value.ActionName, value.ControllerName, null, value.AdditionalCssClass);
                    NavNode navNode = new NavNode(navSettings);
                    subMenu.Add(navNode);
                }
                NavSettings setMain = new NavSettings(null, item.Text, item.ActionName, item.ControllerName, null, item.AdditionalCssClass);
                NavNode nodeMain = new NavNode(setMain, subMenu);
                Menu.Add(nodeMain);
            }
            return Menu;
            //NavSettings();
        }


        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 01/15/2014 | Abdul   | Created
        /// <summary>
        /// Method has been modified Appropiately to access the Dynamic Navigation Tree
        /// </summary>
        /// </RevisionHistory>
        public ActionResult NavigationMenu(SelectedLink? selectedLink)
        {
            ICollection<NavLink> navLinks;
            string selectedLinkKey;

            selectedLinkKey = selectedLink.HasValue ? selectedLink.ToString() : (string)null;

            //navLinks = new Collection<NavLink>();
            ICollection<NavNode> _SiteNavigationTree = this.NavigationNode();
            
            navLinks = _SiteNavigationTree.ToNavLinks();
            navLinks.SelectActiveNodes(selectedLink.ToString());
            return View(navLinks);
        }
    }


    public enum SelectedLink
    {
        MyDownloadedDocuments,
        MyReceivedDocuments,
        MySentDocuments,
        MyReleaseForms,
        SendRequest,
        SendDocument,
        ProvidersUsers,
        ProvidersAdministrators,
        RegisterProviderAdmin,
        MyOutstandingRequests,
        AllUsers,
        MySentRequests,
        AddNewProvider,
        DocumentRACMoneyReport,
        Send,
        AdministrateMyProvider,
        SentRequests,
        DocumentRequestTransactionLog,
        DocumentTransactionLog,
        MyRespondedToRequests,
        DocumentRACDecision,
        ChangeFacility,
        // Added by Dnyaneshwar
        ManageUserProviderMapping,
        ManageProvider,
        WorkListSearch,
        // End Added
        //Added by Abdul
        ManageRoles,
        DisplayUserRoles,
        SelectProvidersAdministrators,
        //End Added
        AvailableFormatTypes,
        MyDocumentsPendingForTCN,
        GlobalSearch,
        DocumentsReviewedByDHS,      //added by Guru
        DeadlineConfiguration,
        ENotesSearch,
        MyErroneousRejectedDocuments,
        ManageChangeFacility //added by abdul
    }
}
