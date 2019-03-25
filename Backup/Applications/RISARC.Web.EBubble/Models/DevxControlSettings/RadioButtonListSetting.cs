using System;
using System.Web.UI.WebControls;
using DevExpress.Web.ASPxClasses;
using DevExpress.Web.ASPxEditors;
using DevExpress.Web.Mvc;

namespace RISARC.Web.EBubble.Models.DevxControlSettings
{
    /// <summary>
    /// General Settings for RadioButtonList, RadioButtonListFor Dev express extension
    /// These settings can only be used with Dev express MVC Extensions
    /// </summary>
    /// <RevisionHistory>
    /// Date       | Owner     | Particulars
    /// ----------------------------------------------------------------------------------------
    /// 10/15/2013 | Dnyaneshwar   | Created
    /// </RevisionHistory>
    public class RadioButtonListSetting
    {
        #region Private Static Variable

        private static Action<RadioButtonListSettings> radioButtonListSettings;

        #endregion Private Static Variable

        #region Public Static Function

        /// <summary>
        /// Read only property to get default Dev express extension settings of type RadioButtonListSettings.
        /// </summary>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 10/15/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public static Action<RadioButtonListSettings> RadioButtonListSettingsMethod
        {
            get
            {
                if (radioButtonListSettings == null)
                    radioButtonListSettings = CreateRadioButtonListSettingsMethod();
                return radioButtonListSettings;
            }
        }

        /// <summary>
        /// Additional settings if required to add other than default.
        /// </summary>
        /// <param name="binaryImageEditSettingsAdditional">RadioButtonListSettings</param>
        /// <returns>Returns default and addition provided RadioButtonListSettings.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 10/15/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public static Action<RadioButtonListSettings> RadioButtonListSettingsMethodAdditional(Action<RadioButtonListSettings> radioButtonListSettingsAdditional)
        {
            return CreateRadioButtonListSettingsMethod() + radioButtonListSettingsAdditional;
        }

        #endregion Public Static Function

        #region Private Functions

        /// <summary>
        /// Generalized settings for RadioButtonListSettings.
        /// </summary>
        /// <returns>Returns default provided RadioButtonListSettings.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 10/15/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        private static Action<RadioButtonListSettings> CreateRadioButtonListSettingsMethod()
        {
            return settings =>
            {
                settings.ShowModelErrors = true;
                settings.Properties.ValueField = "Value";
                settings.Properties.TextField = "Text";
                settings.Properties.ValueType = typeof(Int32);
                settings.Properties.RepeatLayout = RepeatLayout.Table;
                settings.Properties.RepeatDirection = RepeatDirection.Horizontal;
                settings.Properties.ValidationSettings.ErrorDisplayMode = ErrorDisplayMode.ImageWithText;
                settings.Properties.ValidationSettings.ErrorTextPosition = ErrorTextPosition.Bottom;
            };
        }

        #endregion Private Functions
    }
}