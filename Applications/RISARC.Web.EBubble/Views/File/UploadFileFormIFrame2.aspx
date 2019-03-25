<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>UploadFileFormIFrame</title>
    <script type="text/javascript" src="<%# Url.Content("~/Scripts/FileUploader.js")%>"></script>
    <script type="text/javascript">
        function init() {
            if (top.populateResponseToForm) top.populateResponseToForm(); //top means parent frame.
            if (top.additionalPostUpload) top.additionalPostUpload();
        }
        window.onload = init;

        function jqStarted() {
            $("#jqFileUploadForm").hide();
            var theFrame = $("#ifjqFileUploadForm", parent.document.body);
            theFrame.height($(document.body).height() + 240);
        }
    </script>
    <link href="../../Content/risarc.css" rel="stylesheet" type="text/css" />
    <link href="../../Content/Form.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <div>
        <telerik:RadScriptManager ID="RadScriptManager2" runat="server">
            <Scripts>
                <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.Core.js" />
                <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQuery.js" />
            </Scripts>
        </telerik:RadScriptManager>

        <%using (Html.BeginForm("UploadMedicalDocument", "File", FormMethod.Post,
        new
        {
            enctype = "multipart/form-data",
        }
        ))
          {%>
        <%= Html.AntiForgeryToken()%>
        <div class="formContents">
            <% 
              bool uploadCompleted;
              var yourList = (List<Int32>)ViewData["DocumentFileID"];
               if (ViewData["DocumentFileID"] == null)
              {
                  yourList = (List<Int32>)Session["DocumentFileID"];
              }
              if (yourList != null)
              {
                  Response.Write(Html.Hidden("UploadedFileId", Html.Encrypt(yourList[0], true)));
                  string jscriptout = "";

                  jscriptout = "<script language='javascript' type='text/javascript'> window.top.document.getElementById('UploadedFileId').value='" + Html.Encrypt(yourList[0], true) + "' " + "  </script>";

                  Response.Write(jscriptout);

              }

              if ((Session["DocumentFileID"] != null || ViewData["DocumentFileId"] != null))
              {
                  uploadCompleted = true;
                  if (Session["DocumentFileID"] != null)
                      ViewData["DocumentFileId"] = Session["DocumentFileID"];
                  else
                      Session["DocumentFileID"] = yourList;// ViewData["DocumentFileId"];
              }
              else
              {
                  uploadCompleted = false;
                  string jscriptout = "";

                  jscriptout = "<script language='javascript' type='text/javascript'> if(window.top.document.getElementById('UploadedFileId') != null){ window.top.document.getElementById('UploadedFileId').value= '';}if(window.top.document.getElementById('submittedComplianceFileId') != null){window.top.document.getElementById('submittedComplianceFileId').value='';}</script>";

                  Response.Write(jscriptout);
              }

              if (uploadCompleted)
              {
                  ViewData["DocumentFileId"] = Session["DocumentFileID"];
            %>
            <% string encryptedRequestId = Html.Encrypt(ViewData["RequestId"]); %>
            <%--     <% Html.RenderAction("RequestDetails", "DocumentAdmin", new { requestId = encryptedRequestId }); %>--%>            <%--value from this hidden field can be grabbed and populated into other forms--%>

            <%--<script type="text/javascript">
                function jqStarted() {
                    $("#jqFileUploadForm").hide();
                }
            </script>--%>
            <%--            <script language="javascript" type="text/javascript">
                window.top.document.getElementById("UploadedFileId").value = '<%= Html.Encrypt(ViewData["DocumentFileId"], true)%>';
            </script>--%>
            <% Session["DocumentFileID"] = yourList; //ViewData["DocumentFileId"]; %>
            <%--            <%= Html.Hidden("UploadedFileId", Html.Encrypt(ViewData["DocumentFileId"], true))%>--%>

            <% Session["DocumentFileID"] = yourList; //ViewData["DocumentFileId"]; %>

            <%--    <%  RISARC.Web.EBubble.App_Code.Class1 TempCls = new RISARC.Web.EBubble.App_Code.Class1();%>
            --%>
            <ul>
                <li>
                    <label class="StatusMessage">
                        File successfully uploaded</label><%= Html.Encode(ViewData["ExtraInfo"])%>
                    <%--   <% Html.RenderAction("PreviewFileLink", "File", new { documentFileId = Html.Encrypt(ViewData["DocumentFileId"]) }); %>--%>
                    <%  for (int i = 0; i <= yourList.Count - 1; i++)
                        {
                            ViewData["DocumentFileId"] = Session["DocumentFileID"];
                            Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "PreviewFileLink", "File", new { documentFileId = Html.Encrypt(yourList[i]) });//ViewData["DocumentFileId"]) });
                        }
                     
                    %>

                </li>
                <li>

                    <input type="submit" value="Upload a different file" class="tinybuttons" onclick="swapToUploadPrompt(this); return false" />
                </li>
            </ul>
            <%} %>
            <div class="uploadFormWrapper" style='<%= uploadCompleted ? "display:none": (string)null %>'>
                <table cellpadding="0" cellspacing="0">
                    <tr>
                        <td align="left" valign="top">
                            <telerik:RadProgressManager ID="RadProgressManager1" runat="server"
                                Height="119px" />
                            <telerik:RadProgressArea ID="RadProgressArea1" runat="server" Skin="Default">
                            </telerik:RadProgressArea>
                            <!-- "vista"; -->
                        </td>
                        <td align="left" valign="top">
                            <ul id="jqFileUploadForm">
                                <li>
                                    <label for="FileUpload">
                                        <%--   <telerik:RadUpload ID="RadUpload1" Runat="server">
                                    </telerik:RadUpload> --%>
                                        <%= Html.Telerik().Upload()
                                            .HtmlAttributes(new { @class = "btnUploaderCss" })
                                            .Name("RadUpload1")
                                            .Multiple(true)
                                        %>
                                    </label>
                                </li>
                                <li></li>
                                <li>
                                    <%--     <b>Choose a file to upload <span class="ValidationInstructor">*</span></b>--%>
                                    <%--<input type="file" id="FileUpload" name="FileUpload" />--%>
                                    <div class="FieldInstructions">
                                        Acrobat files and TIFF files are recommended. 'Zip' or Compressed files of any type
                                        are not accepted.
                                    </div>
                                </li>
                                <li>
                                    <input type="submit" value="Upload File" class="t-button" onclick="JavaScript: jqStarted();"
                                        style="font-weight: bold" />
                                    <%= ViewData["theFileName"]%>
                                    <%--<input type="submit" value="Upload File" onclick="displayUpLoadingPanel(this);" class="actionButton" />--%>
                                    <%= Html.ValidationMessage("FileToUpload")%>
                                    <%= Html.ValidationMessage("FileTypeInvalid")%>
                                    <label class="field-validation-error">
                                        <%= Html.Encode(ViewData["ErrorMessage"])%>
                                    </label>
                                </li>
                            </ul>
                        </td>
                    </tr>
                </table>
            </div>
            <% Html.RenderPartial("UploadingFile"); %>
        </div>
        <%
          }%>
    </div>
</body>
</html>
<%--<%= Html.Telerik().StyleSheetRegistrar()
     .DefaultGroup(group => group
     .Add("telerik.common.min.css")
     .Add("telerik.sitefinity.css")
     .Add("telerik." + Html.GetCurrentTheme() + ".css")
     .Add("telerik.rtl.css")
     .Add("jquery-ui-1.7.2.custom.css")
     //.Add("charcount")   
     )
%>--%>
<%--<% Html.Telerik().ScriptRegistrar().DefaultGroup(config => config.Combined(true).Compress(true)).Render(); %>--%>