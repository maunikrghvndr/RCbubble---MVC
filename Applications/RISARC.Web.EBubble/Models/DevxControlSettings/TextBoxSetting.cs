using System;
using System.Web.UI.WebControls;
using DevExpress.Web.ASPxEditors;
using DevExpress.Web.Mvc;

namespace RISARC.Web.EBubble.Models.DevxControlSettings
{
    /// <summary>
    /// General Settings for TextBox, TextBoxFor Dev express extension
    /// These settings can only be used with Dev express MVC Extensions
    /// </summary>
    /// <RevisionHistory>
    /// Date       | Owner     | Particulars
    /// ----------------------------------------------------------------------------------------
    /// 10/15/2013 | Dnyaneshwar   | Created
    /// </RevisionHistory>
    public class TextBoxSetting
    {
        #region Private Static Variable

        private static Action<TextBoxSettings> textBoxSettingsMethod;

        #endregion Private Static Variable

        #region Public Static Function

        /// <summary>
        /// Read only property to get default Dev express extension settings of type TextBoxSettings.
        /// </summary>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 10/15/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public static Action<TextBoxSettings> TextBoxSettingsMethod
        {
            get
            {
                if (textBoxSettingsMethod == null)
                    textBoxSettingsMethod = CreateTextBoxSettingsMethod();
                return textBoxSettingsMethod;
            }
        }

        /// <summary>
        /// Additional settings if required to add other than default.
        /// </summary>
        /// <param name="binaryImageEditSettingsAdditional">TextBoxSettings</param>
        /// <returns>Returns default and addition provided TextBoxSettings.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 10/15/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public static Action<TextBoxSettings> TextBoxSettingsMethodAdditional(Action<TextBoxSettings> textBoxSettingsAdditional)
        {
            return CreateTextBoxSettingsMethod() + textBoxSettingsAdditional;
        }

        #endregion Public Static Function

        #region Private Functions

        /// <summary>
        /// Generalized settings for TextBoxSettings.
        /// </summary>
        /// <returns>Returns default provided TextBoxSettings.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 10/15/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        private static Action<TextBoxSettings> CreateTextBoxSettingsMethod()
        {
            return settings =>
            {
                settings.Width = Unit.Percentage(96);
                // settings.Width = 312;
                settings.Height = 32;
                settings.ShowModelErrors = true;
                settings.Properties.ValidationSettings.ErrorDisplayMode = ErrorDisplayMode.ImageWithText;
                settings.Properties.ValidationSettings.EnableCustomValidation = true;
                settings.Properties.ValidationSettings.ErrorTextPosition = DevExpress.Web.ASPxClasses.ErrorTextPosition.Bottom;
                //   settings.ControlStyle.CssClass = "OrgNameSeachboxCls"; // For padding Purpose
              //  settings.ControlStyle.CssClass = "dxcTextBoxStyle";
                //if ((bool)SessionBL.getSessionValue(ConstantManager.SessionKeyNames.IsReadOnlyControls))
                //    settings.ReadOnly = true;
                //if ((bool)SessionBL.getSessionValue(ConstantManager.SessionKeyNames.IsDisabledControls))
                //    settings.Enabled = false;
            };
        }

        #endregion Private Functions
    }
}