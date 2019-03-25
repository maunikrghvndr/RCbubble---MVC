<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    UploadClaimFile
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Upload Claim Files</h2>
      <div>  &nbsp; </div>
    <input type="hidden" name="redirectToWorkBucket" id="redirectToWorkBucket" value="<%= Url.Content("~/ChangeFacility/WorkBucket") %>" />
    <%using (Html.BeginForm("", ""))
      {%> <%= Html.AntiForgeryToken()%>

   <div class="UploadSection">
      <span><b>Select Claim Files</b></span> 
      <% Html.RenderPartial("_ClaimSingleFileUploader"); %>
    </div>

    <%--<div id="uploadedFiles" style="display: none;">
    <div class="floatLeft">Files successfully uploaded</div><br />
    <div id="fileContainer" style="clear:none !important;"></div>
    <div id="removeError" style="display: none; color: red;">Error occurred while removing the file.  </div>
    </div>--%>
    <br />
      <%--<%= Html.Action("UploadedDocument", "File") %>--%>
    <%} %>
  
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">

</asp:Content>


