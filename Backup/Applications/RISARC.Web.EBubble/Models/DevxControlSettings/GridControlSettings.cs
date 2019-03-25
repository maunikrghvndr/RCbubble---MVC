using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DevExpress.Web.Mvc;

namespace RISARC.Web.EBubble.Models.DevxControlSettings
{
    public class GridControlSettings
    {
        #region Private Static Variable

        private static Action<GridViewSettings> gridViewSettingsMethod;

        #endregion Private Static Variable

        #region Public Static Function

        /// <summary>
        /// Read only property to get default Dev express extension settings of type GridViewSettings.
        /// </summary>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 12/19/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public static Action<GridViewSettings> GridViewSettingsMethod
        {
            get
            {
                if (gridViewSettingsMethod == null)
                    gridViewSettingsMethod = CreateGridViewSettingsMethod();
                return gridViewSettingsMethod;
            }
        }

        /// <summary>
        /// Additional settings if required to add other than default.
        /// </summary>
        /// <param name="binaryImageEditSettingsAdditional">GridViewSettings</param>
        /// <returns>Returns default and addition provided GridViewSettings.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 12/19/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        public static Action<GridViewSettings> GridViewSettingsMethodAdditional(Action<GridViewSettings> gridViewSettingsAdditional)
        {
            return CreateGridViewSettingsMethod() + gridViewSettingsAdditional;
        }

        #endregion Public Static Function

        #region Private Functions

        /// <summary>
        /// Generalized settings for GridViewSettings.
        /// </summary>
        /// <returns>Returns default provided BinaryImageEditSettings.</returns>
        /// <RevisionHistory>
        /// Date       | Owner     | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 12/19/2013 | Dnyaneshwar   | Created
        /// </RevisionHistory>
        private static Action<GridViewSettings> CreateGridViewSettingsMethod()
        {
            return settings =>
            {
            };
        }

        #endregion Private Functions
    }
}