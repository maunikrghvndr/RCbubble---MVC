using System;
using DevExpress.Web.ASPxEditors;
using DevExpress.Web.Mvc;

namespace RISARC.Web.EBubble.Models.DevxControlSettings
{
    /// <summary>
    /// General Settings for Memo, MemoFor Dev express extension
    /// These settings can only be used with Dev express MVC Extensions
    /// </summary>
    /// <RevisionHistory>
    /// Date       | Owner     | Particulars
    /// ----------------------------------------------------------------------------------------
    /// 10/15/2013 | Dnyaneshwar   | Created
    /// </RevisionHistory>
    public class MemoSetting
    {
        #region Private Static Variable

        private static Action<MemoSettings> memoSettingsMethod;

        #endregion Private Static Variable

        #region Public Static Function

        /// <summary>
        /// Read only property to get default Dev express extension settings of type MemoSettings.
        /// </summary>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 10/15/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public static Action<MemoSettings> MemoSettingsMethod
        {
            get
            {
                if (memoSettingsMethod == null)
                    memoSettingsMethod = CreateMemoSettingsMethod();
                return memoSettingsMethod;
            }
        }

        /// <summary>
        /// Additional settings if required to add other than default.
        /// </summary>
        /// <param name="binaryImageEditSettingsAdditional">MemoSettings</param>
        /// <returns>Returns default and addition provided MemoSettings.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 10/15/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public static Action<MemoSettings> MemoSettingsMethodAdditional(Action<MemoSettings> memoSettingsAdditional)
        {
            return CreateMemoSettingsMethod() + memoSettingsAdditional;
        }

        #endregion Public Static Function

        #region Private Functions

        /// <summary>
        /// Generalized settings for  MemoSettings.
        /// </summary>
        /// <returns>Returns default provided MemoSettings.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 10/15/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        private static Action<MemoSettings> CreateMemoSettingsMethod()
        {
            return settings =>
            {
                settings.Height = 50;
                settings.ShowModelErrors = true;
                settings.Properties.ValidationSettings.ErrorDisplayMode = ErrorDisplayMode.ImageWithText;
            };
        }

        #endregion Private Functions
    }
}