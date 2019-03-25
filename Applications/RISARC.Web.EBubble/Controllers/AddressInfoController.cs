using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Ajax;
using RISARC.Emr.Web.DataTypes;
using RISARC.Common.Model;
using RISARC.Setup.Implementation.Repository;
using System.Web.UI;

namespace RISARC.Web.EBubble.Controllers
{
    public class AddressInfoController : Controller
    {
        //private ISetupDataRepository _SetupDataRepository;

        //public AddressInfoController(ISetupDataRepository setupDataRepository)
        //{
        //    this._SetupDataRepository = setupDataRepository;
        //}
        //
        // GET: /AddressInfo/

        [OutputCache(VaryByParam="bindingPrefix",Location=OutputCacheLocation.Any,Duration=60)]
        public ViewResult UsAddressInfo(string bindingPrefix)
        {
            AddressInfo addressInfo;

            addressInfo = new AddressInfo();
            ViewData.SetValue(GlobalViewDataKey.BindingPrefix, bindingPrefix);

            return View(addressInfo);
        }

        [OutputCache(VaryByParam = "bindingPrefix", Location = OutputCacheLocation.Any, Duration = 60)]
        public ViewResult CanadaAddressInfo(string bindingPrefix)
        {
            AddressInfo addressInfo;

            addressInfo = new AddressInfo();
            ViewData.SetValue(GlobalViewDataKey.BindingPrefix, bindingPrefix);

            return View(addressInfo);
        }

        [OutputCache(VaryByParam = "bindingPrefix", Location = OutputCacheLocation.Any, Duration = 60)]
        public ViewResult InternationalAddressInfo(string bindingPrefix)
        {
            AddressInfo addressInfo;

            addressInfo = new AddressInfo();
            ViewData.SetValue(GlobalViewDataKey.BindingPrefix, bindingPrefix);

            return View(addressInfo);
        }

    }
}
