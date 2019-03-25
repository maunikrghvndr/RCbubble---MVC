using System;
using DevExpress.Web.ASPxClasses;
using DevExpress.Web.ASPxEditors;
using DevExpress.Web.Mvc;
using System.Web.UI.WebControls;

namespace RISARC.Web.EBubble.Models.DevxControlSettings
{
    /// <summary>
    /// General Settings for ComboBox, ComboBoxFor Dev express extension
    /// These settings can only be used with Dev express MVC Extensions
    /// </summary>
    /// <RevisionHistory>
    /// Date       | Owner     | Particulars
    /// ----------------------------------------------------------------------------------------
    /// 10/15/2013 | Dnyaneshwar   | Created
    /// </RevisionHistory>
    public class ComboBoxSetting
    {
        #region Private Static Variable

        private static Action<ComboBoxSettings> comboBoxsettingsMethod;

        #endregion Private Static Variable

        #region Public Static Function

        /// <summary>
        /// Read only property to get default Dev express extension settings of type ComboBoxSettings.
        /// </summary>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 10/15/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public static Action<ComboBoxSettings> ComboBoxSettingsMethod
        {
            get
            {
                if (comboBoxsettingsMethod == null)
                    comboBoxsettingsMethod = CreateComboBoxSettingsMethod();
                return comboBoxsettingsMethod;
            }
        }

        /// <summary>
        /// Additional settings if required to add other than default.
        /// </summary>
        /// <param name="binaryImageEditSettingsAdditional">ComboBoxSettings</param>
        /// <returns>Returns default and addition provided ComboBoxSettings.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 10/15/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public static Action<ComboBoxSettings> ComboBoxSettingsMethodAdditional(Action<ComboBoxSettings> comboBoxsettingsAdditional)
        {
            return CreateComboBoxSettingsMethod() + comboBoxsettingsAdditional;
        }

        #endregion Public Static Function

        #region Private Functions

        /// <summary>
        /// Generalized settings for  ComboBoxSettings.
        /// </summary>
        /// <returns>Returns default provided ComboBoxSettings.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 10/15/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        private static Action<ComboBoxSettings> CreateComboBoxSettingsMethod()
        {
            return settings =>
            {
                settings.Width = System.Web.UI.WebControls.Unit.Percentage(91);
                settings.ShowModelErrors = true;
                settings.Properties.ValueField = "Value";
                settings.Properties.TextField = "Text";
                settings.Properties.NullText = "";
                settings.Properties.ValueType = typeof(Int32);
                settings.Properties.AnimationType = AnimationType.Slide;
                settings.Properties.ValidationSettings.ErrorDisplayMode = ErrorDisplayMode.ImageWithText;
                settings.Properties.ValidationSettings.EnableCustomValidation = true;
                settings.Properties.ValidationSettings.ErrorTextPosition = DevExpress.Web.ASPxClasses.ErrorTextPosition.Bottom;
                // settings.Width = 312;
                settings.Height = 32;
                settings.Width = Unit.Percentage(96);

                settings.ControlStyle.CssClass = "OrgNameSeachboxCls";
                settings.Properties.DropDownButton.Image.Url = "~/Images/icons/dropdown_button.png";
                settings.Properties.ButtonStyle.Border.BorderWidth = 0;
                settings.Properties.ButtonStyle.Paddings.Padding = 0;
                settings.Properties.ButtonStyle.CssClass = "dropdownButton";

                //  settings.ControlStyle.CssClass = "OrgNameSeachboxCls";
                //settings.ControlStyle.CssClass = "OrgNameSeachboxCls"; // For padding Purpose
            };
        }

        #endregion Private Functions
    }
}