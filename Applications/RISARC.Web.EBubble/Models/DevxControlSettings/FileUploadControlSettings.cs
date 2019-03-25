using RISARC.Common;
using RISARC.Documents.Implementation.Service;
using RISARC.Files.Service;

namespace RISARC.Web.EBubble.Models.DevxControlSettings
{
    /// <summary>
    /// This class represents settings pertaining to the upload control
    /// </summary>
    public class FileUploadControlSettings
    {
        public DevExpress.Web.ASPxUploadControl.ValidationSettings ValidationSettings = new DevExpress.Web.ASPxUploadControl.ValidationSettings()
        {
            MaxFileSize = 1073741824, //Set MaxFileSize to 1GB
            AllowedFileExtensions = DocumentsAdminService.GetAllowedFileExtensions(),
            NotAllowedFileExtensionErrorText = string.Format(ConstantManager.FileUploadConstants.NotAllowedFileExtensionErrorText,
                                                                                 string.Join(",", DocumentsAdminService.GetAllowedFileExtensions())),
        };
    }
}