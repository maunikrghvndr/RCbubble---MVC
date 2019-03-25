using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RISARC.Membership.Model;
using System.Collections.Specialized;

namespace RISARC.Web.EBubble.Models.Binders
{
    [Obsolete]
    public class RMSeBubbleMembershipUserBinder : DefaultModelBinder
    {
        public override object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext)
        {
            RMSeBubbleMembershipUser baseBindedUser;
            PersonalInformation personalInformation;
            NameValueCollection form;

            baseBindedUser = (RMSeBubbleMembershipUser)base.BindModel(controllerContext, bindingContext);

            form = controllerContext.HttpContext.Request.Form;

            personalInformation = new PersonalInformation();

            //personalInformation.FirstName = form["FirstName"];
            //personalInformation.LastName = form["LastName"];
            //personalInformation.Title = form["Title"];
            //personalInformation.Address.StreetAddress = form["Address"];
            //personalInformation.Address.City = form["City"];
            //personalInformation.Address.State = form["State"];
            //personalInformation.Address.CountryName = form["Country"];
            //personalInformation.PrimaryPhone.PhoneAreaCode = form["PhoneAreaCode"];
            //personalInformation.PrimaryPhone.PhoneBody = form["PhonePrefix"];
            //personalInformation.PrimaryPhone.PhoneSuffix = form["PhoneSuffix"];
            //personalInformation.Address.ZipCode = form["ZipCode"];

            //baseBindedUser.PersonalInformation = personalInformation;

            return baseBindedUser;
        }
    }
}
