using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RISARC.Encryption.Service;

namespace RISARC.Web.EBubble.Models.Binders
{
    public class EncryptedLongBinder: IModelBinder
    {
        private IEncryptionService _EncryptionService;

        public EncryptedLongBinder()
            : this(new FrontEndEnrypter())
        {
        }

        public EncryptedLongBinder(IEncryptionService encryptionService)
        {
            this._EncryptionService = encryptionService;
        }

        #region IModelBinder Members

        public virtual object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext)
        {
            object value;
            string decryptedValue;
            string key = bindingContext.ModelName;
            string incomingString;
            string[] incomingStringArray;
            ValueProviderResult val = bindingContext.ValueProvider.GetValue(key);
            if ((val != null) && !string.IsNullOrEmpty(val.AttemptedValue))
            {
                // Follow convention by stashing attempted value in ModelState
                //bindingContext.ModelState.SetModelValue(key, val);
                // Try to parse incoming data
                incomingStringArray = val.RawValue as string[];
                if (incomingStringArray != null)
                    incomingString = incomingStringArray[0];
                else
                    incomingString = val.RawValue as string;

                if (String.IsNullOrEmpty(incomingString))
                    value = null;
                else
                {
                    decryptedValue = _EncryptionService.Decrypt(incomingString);

                    value = Convert.ToInt64(decryptedValue);
                }
            }
            else
                value = null;
            // No value was found in the request
            return value;
        }

        #endregion
    }
}