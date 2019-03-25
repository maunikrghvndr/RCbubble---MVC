using System;
using DevExpress.Web.Mvc;

namespace RISARC.Web.EBubble.Models.DevxControlSettings
{
    /// <summary>
    /// General Settings for BinaryImageEdit Dev express extension
    /// These settings can only be used with Dev express MVC Extensions
    /// </summary>
    /// <RevisionHistory>
    /// Date       | Owner     | Particulars
    /// ----------------------------------------------------------------------------------------
    /// 10/15/2013 | Dnyaneshwar   | Created
    /// </RevisionHistory>
    public class BinaryImageEditSetting
    {
        #region Private Static Variable

        private static Action<BinaryImageEditSettings> binaryImageEditSettingsMethod;

        #endregion Private Static Variable

        #region Public Static Function

        /// <summary>
        /// Read only property to get default Dev express extension settings of type BinaryImageEditSettings.
        /// </summary>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 10/15/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public static Action<BinaryImageEditSettings> BinaryImageEditSettingsMethod
        {
            get
            {
                if (binaryImageEditSettingsMethod == null)
                    binaryImageEditSettingsMethod = CreateBinaryImageEditSettingsMethod();
                return binaryImageEditSettingsMethod;
            }
        }

        /// <summary>
        /// Additional settings if required to add other than default.
        /// </summary>
        /// <param name="binaryImageEditSettingsAdditional">BinaryImageEditSettings</param>
        /// <returns>Returns default and addition provided BinaryImageEditSettings.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 10/15/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public static Action<BinaryImageEditSettings> BinaryImageEditSettingsMethodAdditional(Action<BinaryImageEditSettings> binaryImageEditSettingsAdditional)
        {
            return CreateBinaryImageEditSettingsMethod() + binaryImageEditSettingsAdditional;
        }

        #endregion Public Static Function

        #region Private Functions

        /// <summary>
        /// Generalized settings for  BinaryImageEditSettings.
        /// </summary>
        /// <returns>Returns default provided BinaryImageEditSettings.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 10/15/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        private static Action<BinaryImageEditSettings> CreateBinaryImageEditSettingsMethod()
        {
            return settings =>
            {
                settings.Width = System.Web.UI.WebControls.Unit.Pixel(85);
                settings.Height = System.Web.UI.WebControls.Unit.Pixel(95);
            };
        }

        #endregion Private Functions
    }
}