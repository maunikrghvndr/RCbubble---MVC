using System;
using DevExpress.Web.Mvc;

namespace RISARC.Web.EBubble.Models.DevxControlSettings
{
    /// <summary>
    /// General Settings for Label, LabelFor Dev express extension
    /// These settings can only be used with Dev express MVC Extensions
    /// </summary>
    /// <RevisionHistory>
    /// Date       | Owner     | Particulars
    /// ----------------------------------------------------------------------------------------
    /// 10/15/2013 | Dnyaneshwar   | Created
    /// </RevisionHistory>
    public class LabelSetting
    {
        #region Private Static Variable

        private static Action<LabelSettings> labelSettingsMethod;

        #endregion Private Static Variable

        #region Public Static Function

        /// <summary>
        /// Read only property to get default Dev express extension settings of type LabelSettings.
        /// </summary>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 10/15/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public static Action<LabelSettings> LabelSettingsMethod
        {
            get
            {
                if (labelSettingsMethod == null)
                    labelSettingsMethod = CreateLabelSettingsMethod();
                return labelSettingsMethod;
            }
        }

        /// <summary>
        /// Additional settings if required to add other than default.
        /// </summary>
        /// <param name="binaryImageEditSettingsAdditional">LabelSettings</param>
        /// <returns>Returns default and addition provided LabelSettings.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 10/15/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public static Action<LabelSettings> LabelSettingsMethodAdditional(Action<LabelSettings> labelSettingsAdditional)
        {
            return CreateLabelSettingsMethod() + labelSettingsAdditional;
        }

        #endregion Public Static Function

        #region Private Functions

        /// <summary>
        /// Generalized settings for  LabelSettings.
        /// </summary>
        /// <returns>Returns default provided LabelSettings.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 10/15/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        private static Action<LabelSettings> CreateLabelSettingsMethod()
        {
            return settings => { 
                settings.Properties.EnableDefaultAppearance = false;
                settings.ControlStyle.CssClass = "CommanLableCls";
             
            };
        }

        #endregion Private Functions
    }
}