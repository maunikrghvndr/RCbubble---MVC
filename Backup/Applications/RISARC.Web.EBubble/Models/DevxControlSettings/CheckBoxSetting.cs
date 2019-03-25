using System;
using DevExpress.Web.ASPxEditors;
using DevExpress.Web.Mvc;

namespace RISARC.Web.EBubble.Models.DevxControlSettings
{
    /// <summary>
    /// General Settings for CheckBox, CheckBoxFor Dev express extension
    /// These settings can only be used with Dev express MVC Extensions
    /// </summary>
    /// <RevisionHistory>
    /// Date       | Owner     | Particulars
    /// ----------------------------------------------------------------------------------------
    /// 10/15/2013 | Dnyaneshwar   | Created
    /// </RevisionHistory>
    public class CheckBoxSetting
    {
        #region Private Static Variable

        private static Action<CheckBoxSettings> checkBoxSettingsMethod;

        #endregion Private Static Variable

        #region Public Static Function

        /// <summary>
        /// Read only property to get default Dev express extension settings of type CheckBoxSettings.
        /// </summary>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 10/15/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public static Action<CheckBoxSettings> CheckBoxSettingsMethod
        {
            get
            {
                if (checkBoxSettingsMethod == null)
                    checkBoxSettingsMethod = CreateCheckBoxSettingsMethod();
                return checkBoxSettingsMethod;
            }
        }

        /// <summary>
        /// Additional settings if required to add other than default.
        /// </summary>
        /// <param name="binaryImageEditSettingsAdditional">CheckBoxSettings</param>
        /// <returns>Returns default and addition provided CheckBoxSettings.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 10/15/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public static Action<CheckBoxSettings> CheckBoxSettingsMethodAdditional(Action<CheckBoxSettings> checkBoxSettingsAdditional)
        {
            return CreateCheckBoxSettingsMethod() + checkBoxSettingsAdditional;
        }

        #endregion Public Static Function

        #region Private Functions

        /// <summary>
        /// Generalized settings for  CheckBoxSettings.
        /// </summary>
        /// <returns>Returns default provided CheckBoxSettings.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 10/15/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        private static Action<CheckBoxSettings> CreateCheckBoxSettingsMethod()
        {
            return settings =>
            {
                //settings.Properties.ValidationSettings.ErrorDisplayMode = ErrorDisplayMode.ImageWithText;
                //settings.Properties.ValidationSettings.EnableCustomValidation = true;
                //settings.Properties.ValidationSettings.ErrorTextPosition = DevExpress.Web.ASPxClasses.ErrorTextPosition.Bottom;
            };
        }

        #endregion Private Functions
    }
}