<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<div class="documentIdOuter">
   <div> Please enter the Document ID which has been sent to your email</div>
    <div class="documentInnnerCont">
        <div>Document ID:</div>
        <div>

            <% using (Html.BeginForm("DownloadDocumentById", "Document", FormMethod.Post, new { id = "docdownloadform" }))
               {

                   Html.DevExpress().TextBox(
                      settings =>
                      {
                          settings.Name = "DownloadDocumentId";
                          settings.ControlStyle.CssClass = "OrgNameSeachboxCls"; // For padding Purpose
                         // settings.Properties.NullText = "Enter Document ID";

                      }).Render();
                 
            %>
        </div>
        <div>
            <%       
                   Html.DevExpress().Button(
                           RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                             settings =>
                             {
                                 settings.Name = "SumbmitDocId";
                                 settings.Text = "Download";
                                 settings.Width = 83;
                                 settings.Height = 32;
                                 settings.UseSubmitBehavior = false;
                                 settings.ClientSideEvents.Click = "CheckAcessAndSubmitDocumentId";
                                 //settings.RouteValues = new { Controller = "Document", Action = "DownloadDocumentById" };

                             })).GetHtml();

               } // form ends %>
        </div>
    </div>

</div>

<style>
    .documentIdOuter
    {
        width: 32%;
        position: absolute;
        right: 278px;
        top: 61px;
    }

    .documentInnnerCont > div
    {
        float: left;
        margin-left: 10px;
        line-height: 31px;
    }
</style>
