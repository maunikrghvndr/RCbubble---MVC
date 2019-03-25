using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RISARC.Encryption.Service;

namespace RISARC.Web.EBubble.Models.Binders
{
    public class EncryptedStringBinder : IModelBinder
    {
        private IEncryptionService _EncryptionService;

        public EncryptedStringBinder()
            : this(new FrontEndEnrypter())
        {
        }

        public EncryptedStringBinder(IEncryptionService encryptionService)
        {
            this._EncryptionService = encryptionService;
        }

        #region IModelBinder Members

        public object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext)
        {
            string decryptedValue;
            string key = bindingContext.ModelName;
            object rawValue;
            ValueProviderResult val = bindingContext.ValueProvider.GetValue(key);
            if ((val != null) && !string.IsNullOrEmpty(val.AttemptedValue))
            {
                // Follow convention by stashing attempted value in ModelState
                //bindingContext.ModelState.SetModelValue(key, val);
                // Try to parse incoming data
                string incomingString;

                rawValue = val.RawValue;

                if (rawValue is string)
                    incomingString = (string)rawValue;
                else
                    incomingString = ((string[])val.RawValue)[0];

                decryptedValue = _EncryptionService.Decrypt(incomingString);

            }
            else
                throw new HttpException("Invalid encrypted paramater.");
            // No value was found in the request
            return decryptedValue;
        }

        #endregion
    }
}
