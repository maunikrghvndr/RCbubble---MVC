using System;
using DevExpress.Web.ASPxClasses;
using DevExpress.Web.ASPxEditors;
using DevExpress.Web.Mvc;

namespace RISARC.Web.EBubble.Models.DevxControlSettings
{
    /// <summary>
    /// General Settings for TimeEdit, TimeEditFor Dev express extension
    /// These settings can only be used with Dev express MVC Extensions
    /// </summary>
    /// <RevisionHistory>
    /// Date       | Owner     | Particulars
    /// ----------------------------------------------------------------------------------------
    /// 10/15/2013 | Dnyaneshwar   | Created
    /// </RevisionHistory>
    public class TimeEditSetting
    {
        #region Private Static Variable

        private static Action<TimeEditSettings> timeEditSettingsMethod;

        #endregion Private Static Variable

        #region Public Static Function

        /// <summary>
        /// Read only property to get default Dev express extension settings of type TimeEditSettings.
        /// </summary>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 10/15/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public static Action<TimeEditSettings> TimeEditSettingsMethod
        {
            get
            {
                if (timeEditSettingsMethod == null)
                    timeEditSettingsMethod = CreateTimeEditSettingsMethod();
                return timeEditSettingsMethod;
            }
        }

        /// <summary>
        /// Additional settings if required to add other than default.
        /// </summary>
        /// <param name="binaryImageEditSettingsAdditional">TimeEditSettings</param>
        /// <returns>Returns default and addition provided TimeEditSettings.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 10/15/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public static Action<TimeEditSettings> TimeEditSettingsMethodAdditional(Action<TimeEditSettings> timeEditSettingsAdditional)
        {
            return CreateTimeEditSettingsMethod() + timeEditSettingsAdditional;
        }

        #endregion Public Static Function

        #region Private Functions

        /// <summary>
        /// Generalized settings for TimeEditSettings.
        /// </summary>
        /// <returns>Returns default provided TimeEditSettings.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 10/15/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        private static Action<TimeEditSettings> CreateTimeEditSettingsMethod()
        {
            return settings =>
            {
                settings.ShowModelErrors = true;
                settings.Properties.NullDisplayText = "HRS : MIN";
                settings.Properties.DisplayFormatString = "HH : mm";
                settings.Properties.EditFormat = EditFormat.Time;
                settings.Properties.EditFormatString = "HH : mm";
                settings.Properties.ValidationSettings.ErrorDisplayMode = ErrorDisplayMode.ImageWithText;
                settings.Properties.ValidationSettings.ErrorTextPosition = ErrorTextPosition.Bottom;
            };
        }

        #endregion Private Functions
    }
}