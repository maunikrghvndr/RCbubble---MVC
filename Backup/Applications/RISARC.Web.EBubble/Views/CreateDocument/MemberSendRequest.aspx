<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.Master" Inherits="System.Web.Mvc.ViewPage<RISARC.Documents.Model.DocumentRequestSend>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Request a Document
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>
        Request a Document</h2>
    <p class="Instructions">
         Complete the information below to send out a request to an organization. Fill out information completely and submit document request.</p>
        <%= Html.ValidationInstructionHeader() %>
    <% using (Html.BeginForm("MemberSendRequest", "CreateDocument"))
       {%>
       <%= Html.AntiForgeryToken() %>
<%--              <label for="recipientEmailAddress">
                Provider Member to Send To <span class="ValidationInstructor">*</span>
            </label>
            <div class="RecipientEmailHolder">
            <% Html.RenderAction<RISARC.Web.EBubble.Controllers.CreateDocumentController>(drc =>
                   drc.ProvidersMembersListBox("recipientEmailAddress", "-Select-", Model.ProviderId, (string)ViewData["RecipientEmailAddress"])
                   ); %>
                   <%= Html.ValidationMessage("RecipientEmailRequired", "Required")%>
            </div>--%>
    <% Html.RenderPartial("DocumentRequestSend", Model); %>
    <% } %>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
    <script type="text/javascript" src="<%: Url.Content("~/Scripts/OptionExpander.js")%>"></script>
    
    <link rel="Stylesheet" type="text/css" href="<%: Url.Content("~/Content/custom-theme/jquery-ui-1.7.2.custom.css")%>" />
    <%--<script type="text/javascript" src="<%: Url.Content("~/Scripts/jquery-ui-1.9.2.custom.min.js"></script>--%>
    <script type="text/javascript" src="<%: Url.Content("~/Scripts/LoadDatePickers.js")%>"></script>
    
    <script type="text/javascript" src="<%: Url.Content("~/Scripts/ProviderToProviderSettings.js")%>"></script>
    <!-- Add by Mike: testing send page jq with current dropdown -->
    <script type="text/javascript" src="<%: Url.Content("~/Scripts/SendRequest.js")%>"></script>
    <script type="text/javascript">


            var wordCount = 0;
            function CharCount() {
                var text1 = trim(document.getElementById('Comments').value);
                var text1 = oldtrim(document.getElementById('Comments').value);
                if (text1.length > 0) 
                {
                   document.getElementById('CharCountDisplay').innerHTML = "Char Count: " + (text1.length + 1);
                }
               else 
                {
                     document.getElementById('CharCountDisplay').innerHTML = "";
                }
             }

            function trim(stringToTrim) {
                //return stringToTrim.replace(/^\s+|\s+$/g, "");
                return stringToTrim.replace(/^s*|s(?=s)|s*$/g, "");
            }
            function ltrim(stringToTrim) {
                return stringToTrim.replace(/^\s+/, "");
            }
            function rtrim(stringToTrim) {
                return stringToTrim.replace(/\s+$/, "");
            }
            // works for old browsers
            function oldltrim(str) {
                for (var k = 0; k < str.length && isWhitespace(str.charAt(k)); k++);
                return str.substring(k, str.length);
            }
            function oldrtrim(str) {
                for (var j = str.length - 1; j >= 0 && isWhitespace(str.charAt(j)); j--);
                return str.substring(0, j + 1);
            }
            function oldtrim(str) {
                return ltrim(rtrim(str));
            }
            function oldisWhitespace(charToCheck) {
                var whitespaceChars = " \t\n\r\f";
                return (whitespaceChars.indexOf(charToCheck) != -1);
            }
</script> 


</asp:Content>
