using System;
using DevExpress.Web.Mvc;

namespace RISARC.Web.EBubble.Models.DevxControlSettings
{
    /// <summary>
    /// General Settings for Button Dev express extension
    /// These settings can only be used with Dev express MVC Extensions
    /// </summary>
    /// <RevisionHistory>
    /// Date       | Owner     | Particulars
    /// ----------------------------------------------------------------------------------------
    /// 10/15/2013 | Dnyaneshwar   | Created
    /// </RevisionHistory>
    public class ButtonSetting
    {
        #region Private Static Variable

        private static Action<ButtonSettings> buttonSettingsMethod;

        #endregion Private Static Variable

        #region Public Static Function

        /// <summary>
        /// Read only property to get default Dev express extension settings of type ButtonSettings.
        /// </summary>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 10/15/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public static Action<ButtonSettings> ButtonSettingsMethod
        {
            get
            {
                if (buttonSettingsMethod == null)
                    buttonSettingsMethod = CreateButtonSettingsMethod();
                return buttonSettingsMethod;
            }
        }

        /// <summary>
        /// Additional settings if required to add other than default.
        /// </summary>
        /// <param name="binaryImageEditSettingsAdditional">ButtonSettings</param>
        /// <returns>Returns default and addition provided ButtonSettings.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 10/15/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public static Action<ButtonSettings> ButtonSettingsMethodAdditional(Action<ButtonSettings> buttonSettingsAdditional)
        {
            return CreateButtonSettingsMethod() + buttonSettingsAdditional;
        }

        #endregion Public Static Function

        #region Private Functions

        /// <summary>
        /// Generalized settings for ButtonSettings.
        /// </summary>
        /// <returns>Returns default provided BinaryImageEditSettings.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 10/15/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        private static Action<ButtonSettings> CreateButtonSettingsMethod()
        {
            return settings =>
            {
                settings.ControlStyle.CssClass = "orangeBtn";
                //settings.Width = System.Web.UI.WebControls.Unit.Pixel(100);
                settings.Height = 32;
                //settings.Height = 35;
                settings.Width = System.Web.UI.WebControls.Unit.Percentage(100);
                settings.ControlStyle.HorizontalAlign = System.Web.UI.WebControls.HorizontalAlign.Center;
                settings.UseSubmitBehavior = true;
            };
        }

        #endregion Private Functions
    }
}