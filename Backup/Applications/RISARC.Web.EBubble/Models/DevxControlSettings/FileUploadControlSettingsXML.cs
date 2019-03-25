using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace RISARC.Web.EBubble.Models.DevxControlSettings
{
    /// <summary>
    /// This class represents settings pertaining to the upload control
    /// </summary>
    public class FileUploadControlSettingsXML
    {
        public DevExpress.Web.ASPxUploadControl.ValidationSettings ValidationSettings = new DevExpress.Web.ASPxUploadControl.ValidationSettings()
        {
            MaxFileSize = 1073741824, //Set MaxFileSize to 1GB
            AllowedFileExtensions = new string[] {".xml"},
            NotAllowedFileExtensionErrorText = "File types other than .xml not allowed",
        };
    }
}