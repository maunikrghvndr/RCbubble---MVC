using System;
using DevExpress.Web.ASPxClasses;
using DevExpress.Web.ASPxEditors;
using DevExpress.Web.Mvc;
using System.Web.UI.WebControls;


namespace RISARC.Web.EBubble.Models.DevxControlSettings
{
    /// <summary>
    /// General Settings for DateEdit, DateEditFor Dev express extension
    /// These settings can only be used with Dev express MVC Extensions
    /// </summary>
    /// <RevisionHistory>
    /// Date       | Owner     | Particulars
    /// ----------------------------------------------------------------------------------------
    /// 10/15/2013 | Dnyaneshwar   | Created
    /// </RevisionHistory>
    public class DateEditSetting
    {
        #region Private Static Variable

        private static Action<DateEditSettings> dateEditSettingsMethod;

        #endregion Private Static Variable

        #region Public Static Function

        /// <summary>
        /// Read only property to get default Dev express extension settings of type DateEditSettings.
        /// </summary>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 10/15/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public static Action<DateEditSettings> DateEditSettingsMethod
        {
            get
            {
                if (dateEditSettingsMethod == null)
                    dateEditSettingsMethod = CreateDateEditSettingsMethod();
                return dateEditSettingsMethod;
            }
        }

        /// <summary>
        /// Additional settings if required to add other than default.
        /// </summary>
        /// <param name="binaryImageEditSettingsAdditional">DateEditSettings</param>
        /// <returns>Returns default and addition provided DateEditSettings.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 10/15/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public static Action<DateEditSettings> DateEditSettingsMethodAdditional(Action<DateEditSettings> dateEditSettingsAdditional)
        {
            return CreateDateEditSettingsMethod() + dateEditSettingsAdditional;
        }

        #endregion Public Static Function

        #region Private Functions

        /// <summary>
        /// Generalized settings for  DateEditSettings.
        /// </summary>
        /// <returns>Returns default provided DateEditSettings.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 10/15/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        private static Action<DateEditSettings> CreateDateEditSettingsMethod()
        {
            return settings =>
            {
                settings.ShowModelErrors = true;
                //  settings.Width = 180;
                settings.Properties.NullText = "mm/dd/yyyy";
                settings.Properties.EditFormat = EditFormat.Custom;
                settings.Properties.EditFormatString = "MM/dd/yyyy";
              //  settings.Properties.DropDownButton.Image.Url = @"~/Images/calendar.png";
                settings.Properties.DisplayFormatString = "MM/dd/yyyy";
                settings.Properties.ValidationSettings.EnableCustomValidation = true;
                settings.Properties.ValidationSettings.ErrorDisplayMode = ErrorDisplayMode.ImageWithText;
                settings.Properties.ValidationSettings.ErrorTextPosition = ErrorTextPosition.Bottom;

                //Changing button of date control
                settings.Properties.DropDownButton.Image.Url = "~/Images/icons/calenderIcon.png";
                settings.Properties.ButtonStyle.CssClass = "calenderIcon";
               // settings.Properties.ButtonStyle.Paddings.Padding = 0;

                // settings.Width = 312;
                //  settings.Width =  
                settings.Width = Unit.Percentage(96);
              //  settings.Height = 32;
                settings.ControlStyle.CssClass = "dxDatePicker";

            };
        }

        #endregion Private Functions
    }
}