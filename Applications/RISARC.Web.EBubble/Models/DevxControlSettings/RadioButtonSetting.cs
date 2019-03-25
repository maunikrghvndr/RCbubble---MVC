using System;
using DevExpress.Web.Mvc;

namespace RISARC.Web.EBubble.Models.DevxControlSettings
{
    /// <summary>
    /// General Settings for RadioButton, RadioButtonFor Dev express extension
    /// These settings can only be used with Dev express MVC Extensions
    /// </summary>
    /// <RevisionHistory>
    /// Date       | Owner     | Particulars
    /// ----------------------------------------------------------------------------------------
    /// 10/15/2013 | Dnyaneshwar   | Created
    /// </RevisionHistory>
    public class RadioButtonSetting
    {
        #region Private Static Variable

        private static Action<RadioButtonSettings> radioButtonSettings;

        #endregion Private Static Variable

        #region Public Static Function

        /// <summary>
        /// Read only property to get default Dev express extension settings of type RadioButtonSettings.
        /// </summary>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 10/15/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public static Action<RadioButtonSettings> RadioButtonSettingsMethod
        {
            get
            {
                if (radioButtonSettings == null)
                    radioButtonSettings = CreateRadioButtonSettingsMethod();
                return radioButtonSettings;
            }
        }

        /// <summary>
        /// Additional settings if required to add other than default.
        /// </summary>
        /// <param name="binaryImageEditSettingsAdditional">RadioButtonSettings</param>
        /// <returns>Returns default and addition provided RadioButtonSettings.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 10/15/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public static Action<RadioButtonSettings> RadioButtonSettingsMethodAdditional(Action<RadioButtonSettings> radioButtonSettingAdditional)
        {
            return CreateRadioButtonSettingsMethod() + radioButtonSettingAdditional;
        }

        #endregion Public Static Function

        #region Private Functions

        /// <summary>
        /// Generalized settings for RadioButtonSettings.
        /// </summary>
        /// <returns>Returns default provided RadioButtonSettings.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 10/15/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        private static Action<RadioButtonSettings> CreateRadioButtonSettingsMethod()
        {
            return settings =>
            {
            };
        }

        #endregion Private Functions
    }
}