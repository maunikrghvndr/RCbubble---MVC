using System;
using DevExpress.Web.ASPxEditors;
using DevExpress.Web.Mvc;

namespace RISARC.Web.EBubble.Models.DevxControlSettings
{
    /// <summary>
    /// General Settings for SpinEdit, SpinEditFor Dev express extension
    /// These settings can only be used with Dev express MVC Extensions
    /// </summary>
    /// <RevisionHistory>
    /// Date       | Owner     | Particulars
    /// ----------------------------------------------------------------------------------------
    /// 10/15/2013 | Dnyaneshwar   | Created
    /// </RevisionHistory>
    public class SpinEditSetting
    {
        #region Private Static Variable

        private static Action<SpinEditSettings> spinEditSettingsMethod;

        #endregion Private Static Variable

        #region Public Static Function

        /// <summary>
        /// Read only property to get default Dev express extension settings of type SpinEditSettings.
        /// </summary>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 10/15/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public static Action<SpinEditSettings> SpinEditSettingsMethod
        {
            get
            {
                if (spinEditSettingsMethod == null)
                    spinEditSettingsMethod = CreateSpinEditSettingsMethod();
                return spinEditSettingsMethod;
            }
        }

        /// <summary>
        /// Additional settings if required to add other than default.
        /// </summary>
        /// <param name="binaryImageEditSettingsAdditional">SpinEditSettings</param>
        /// <returns>Returns default and addition provided SpinEditSettings.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 10/15/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public static Action<SpinEditSettings> SpinEditSettingsMethodAdditional(Action<SpinEditSettings> spinEditSettingsAdditional)
        {
            return CreateSpinEditSettingsMethod() + spinEditSettingsAdditional;
        }

        #endregion Public Static Function

        #region Private Functions

        /// <summary>
        /// Generalized settings for SpinEditSettings.
        /// </summary>
        /// <returns>Returns default provided SpinEditSettings.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 10/15/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        private static Action<SpinEditSettings> CreateSpinEditSettingsMethod()
        {
            return settings =>
            {
                settings.ShowModelErrors = true;
                settings.Properties.ValidationSettings.ErrorDisplayMode = ErrorDisplayMode.ImageWithText;
                settings.Properties.NumberType = SpinEditNumberType.Float;
                settings.Properties.Increment = 0.1M;
                settings.Properties.LargeIncrement = 1;
                settings.Properties.SpinButtons.ShowLargeIncrementButtons = true;
            };
        }

        #endregion Private Functions
    }
}