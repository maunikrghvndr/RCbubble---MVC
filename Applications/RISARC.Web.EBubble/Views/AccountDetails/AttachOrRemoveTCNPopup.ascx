<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<% Html.DevExpress().PopupControl(
        settings =>
        {
            settings.Name = "AttachRemoveTCN";
            settings.PopupElementID = "AttachRemoveTCNPopUp";
         
            //settings.HeaderText = "Attach/Remove TCN";
            
            settings.Styles.Header.BackColor = System.Drawing.ColorTranslator.FromHtml("#595959");
            settings.Styles.Header.ForeColor = System.Drawing.ColorTranslator.FromHtml("#FFFFFF");
            settings.Styles.Header.Paddings.Padding = 5;
            
            settings.AllowDragging = true;
            settings.ShowCollapseButton = true;
            
            settings.CloseAction = CloseAction.CloseButton;

            settings.ShowCloseButton = true;
            settings.ShowCollapseButton = false;

         
            
            settings.Modal = true;
            settings.PopupHorizontalAlign = PopupHorizontalAlign.WindowCenter;
            settings.PopupVerticalAlign = PopupVerticalAlign.WindowCenter;

           
            settings.Height = Unit.Pixel(420);
            settings.Width = Unit.Pixel(850);

            settings.SetHeaderTemplateContent(c =>
            {
                
                ViewContext.Writer.Write("<div class=\"cutomeHeaderPopup\">Attach/Remove TCN");
                ViewContext.Writer.Write("<span class=\"moveRight dxc-close-position\">");
                Html.DevExpress().Image(image =>
                    {
                        image.Name = "TCNCloseImage";
                        image.ImageUrl = Url.Content("~/Images/icons/closePopup.jpg");
                        image.ControlStyle.Cursor = "pointer";
                        image.Width = 29;
                        image.Height = 29;
                        image.Properties.EnableClientSideAPI = true;
                        image.Properties.ClientSideEvents.Click = "function(s,e){  AttachRemoveTCNPopUpClose();  }";
                    }).Render();
                 ViewContext.Writer.Write("</span></div>");

             });
         //================= Popup Content =============== 
            settings.SetContent(() =>
             {
                 
                 Html.RenderPartial("AttachRemoveUploadControl");  
                     
                 //Action Renderd
                 System.Web.Mvc.Html.ChildActionExtensions.RenderAction(Html, "TCNFormPopupContent");

                 ViewContext.Writer.Write("<div class=\"TCNbutton_holder\">" +
                     "<div class=\"floatLeft\">");
                 Html.DevExpress().Button(
                          RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                               settingsAttach =>
                               {
                                   settingsAttach.Name = "DoneBtn";
                                   settingsAttach.Text = "Save";
                                   settingsAttach.Width = Unit.Pixel(115);                                   
                                   settingsAttach.ControlStyle.CssClass = "tcnPopUpAction";
                                   settingsAttach.ClientSideEvents.Click = "OnTcnDoneButtonClick";
                               })).GetHtml();
                 ViewContext.Writer.Write("</div><div class=\"floatRight\">");
                 Html.DevExpress().Button(
                                        RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                                settingsTCNCancel =>
                                {
                                    settingsTCNCancel.Name = "TCNCancel";
                                    settingsTCNCancel.Text = "Cancel";
                                    settingsTCNCancel.Width = Unit.Pixel(115);
                                    settingsTCNCancel.ControlStyle.CssClass = "greyBtn";
                                    settingsTCNCancel.ClientSideEvents.Click = "function(s, e) { AttachRemoveTCNPopUpClose();    }";
                                })).GetHtml();
                 ViewContext.Writer.Write("</div></div>");

             });


        }
    ).GetHtml();%>
<script type="text/javascript">
    var tcnNumber = "";
    //Look in to this function . why its not gettng called.
    function UpdateTCNDocType(s, e, visibleIndex) {
        if (visibleIndex != null && s.GetValue() != null) {

            $.ajax({
                type: "GET",
                url: "<%:(Url.Action("UpdateDocumentType","File"))%>",
                cache: false,
                data: {
                    FileID: TCNFormGrid.GetRowKey(visibleIndex),
                    DocumentTypeId: s.GetValue(),
                    IsTcnFileType: true,
                    DocumentTypeName: s.GetText()
                },
                success: function (result) {
                    if (result == "Success")
                        return true;
                },
                error: function (request, status, error) {
                    alert("Error occured while updating records.");
                }
            });
        }
    }

    function OnGetTCNValue(values) {
        tcnNumber = values;
    }
</script>


     
