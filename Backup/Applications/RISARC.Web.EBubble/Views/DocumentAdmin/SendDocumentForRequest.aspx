<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Members.Master" Inherits="System.Web.Mvc.ViewPage<RISARC.Documents.Model.DocumentRequestResponse>" %>
<%@ Import Namespace="RISARC.Documents.Model" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Respond To Document Request
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <form id="form1" runat="server" onkeypress="javascript: CancelEnterKey();" >
    <h2>Respond To Document Request</h2>
    <p class="Instructions">
        Locate requested document to send</p>
        <%= Html.ValidationInstructionHeader() %>

    <%= Html.FormStepHeader("Review Request")%>
    <div class="SubDetails">
    <%Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "RequestDetails", "DocumentAdmin", new { requestId = Html.Encrypt(Model.DocumentRequestId) }); %>
    </div>
 

<script type="text/javascript">

    function toggle() {
        var ele = document.getElementById("toggleText");
        if (ele.style.display == "block") {
            ele.style.display = "none";
        }
        else {
            ele.style.display = "block";
        }
    }
    // Cancel the enter key when pressed
    function CancelEnterKey() {
        event.retrunValue = false;
        event.cancel = true;
    }
</script>

<!-- test button <input type="button" id="displayText" Value="Test"  onClick="javascript:toggle();" />-->



<script type="text/javascript">

    function disableEnterKey(e) {
        setDOBDIV();
               var key;
               if (window.event)
                   key = window.event.keyCode; //IE 
               else
                   key = e.which; // firefox      
               return (key != 13);
           } 

</script>

        <div id="IsDOBNULL">
            <br>
            Please verify the Patient's Date of Birth:&nbsp;&nbsp;
            <br />
            <%= Html.DevExpress().DateEdit( RISARC.Web.EBubble.Models.DevxControlSettings.DateEditSetting.DateEditSettingsMethodAdditional(settings => {
                settings.Name = "DateOfBirthCalender";
                settings.Width = Unit.Pixel(120);
                settings.Properties.ValidationSettings.ErrorText = "Please select validate date.";
            })).GetHtml() %>
            <input type="button" id="txtVidateButton" value="Validate" onclick="setValue(document.aspnetForm.DateOfBirthCalender);" onsubmit="return false;" />
            Date should be entered using the following format (e.g mm/dd/yyyy)<br />
        </div>
      <script type="text/javascript">


            function setValue(target0) // Check DOB field for Compliance 
            {
                var ele = document.getElementById("toggleText");
                if (target0.value == '<%=Html.Encode(ViewData.GetValue(GlobalViewDataKey.DateOfBirth))%>') {
                     ele.style.display = "block";
                }
                else {
                    var DOBlength = document.getElementById('DateOfBirthCalender_I').value;
                    if (DOBlength.length == 10) {
                       if (isDate(target0.value) == true) {
                            alert("You have entered the wrong date");  // : " + target.value);
                        }
                        else {
                            alert("You have not entered a date");
                        }
                    } 
                    else
                    {
                        alert("Please enter the correct format (MM/DD/YYYY)");
                    }
                    ele.style.display = "none";
                }
               
            }

            function setDOBDIV() // Check DOB field for Compliance 
            {
                var ele = document.getElementById("toggleText");
                var EmptyDOB = '';
                if (EmptyDOB == '<%=Html.Encode(ViewData.GetValue(GlobalViewDataKey.DateOfBirth))%>') {
                    IsDOBNULL.style.display = "none"; 
                    ele.style.display = "block";
                }
                else
                {
                    IsDOBNULL.style.display = "block";
                    ele.style.display = "none";
                }
            }

            // ******************************************************************
            // This function accepts a string variable and verifies if it is a
            // proper date or not. It validates format matching either
            // mm-dd-yyyy or mm/dd/yyyy. Then it checks to make sure the month
            // has the proper number of days, based on which month it is.

            // The function returns true if a valid date, false if not.
            // ******************************************************************

            function isDate(dateStr) {

                var datePat = /^(\d{1,2})(\/|-)(\d{1,2})(\/|-)(\d{4})$/;
                var matchArray = dateStr.match(datePat); // is the format ok?

                if (matchArray == null) {
                    //alert("Please enter date as either mm/dd/yyyy.");
                    return false;
                }

                month = matchArray[1]; // p@rse date into variables
                day = matchArray[3];
                year = matchArray[5];

                if (month < 1 || month > 12) { // check month range
                    alert("Month must be between 01 and 12.");
                    return false;
                }

                if (day < 1 || day > 31) {
                    alert("Day must be between 01 and 31.");
                    return false;
                }

                if ((month == 4 || month == 6 || month == 9 || month == 11) && day == 31) {
                    alert("Month " + month + " doesn`t have 31 days!")
                    return false;
                }

                if (month == 2) { // check for february 29th
                    var isleap = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
                    if (day > 29 || (day == 29 && !isleap)) {
                        alert("February " + year + " doesn`t have " + day + " days!");
                        return false;
                    }
                }
                return true; // date is valid
            }

        </script>
        <script type="text/javascript">
            window.onload = setDOBDIV;
        </script>


<br>
   <%= Html.ActionLink("Click here if you cannot respond to this request or the requested document is unavailable", "CancelRequest", "DocumentAdmin",
        new { requestId = Html.Encrypt(Model.DocumentRequestId)}, null) %>
        </br>
       </form>


    <%using (Html.BeginForm("SendDocumentForRequest", "DocumentAdmin", new { requestId = Html.Encrypt(Model.DocumentRequestId) }))
       {%>
    <%= Html.AntiForgeryToken()%>
    <div id="toggleText" style="display: none;">

        <%= Html.FormStepHeader("Attach the file to send") %>

        <div class="FieldInstructions">
            Attach the file that will be sent to the requestor.
      
        <table>
            <tr>
                <td>
                    <span id="fileUploaderHoler"></span>
                    <% Html.RenderPartial("_FileUploadPartial"); %>
                </td>
            </tr>
        </table>
          </div>
        <%= Html.FormStepHeader("Enter Information about Document To Send") %>

        <% Html.RenderPartial("DocumentRequestResponse", Model);%>
    </div>
    <%} %>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
    
    <script src="<%: Url.Content("~/Scripts/jqModal.js")%>" type="text/javascript"></script>
    <script src="<%: Url.Content("~/Scripts/Views/SendDocumentForRequest.js")%>" type="text/javascript"></script>
    <script type="text/javascript">
        // performed after file is uploaded, will copy uploaded file id to documents file id hidden field
        function additionalPostUpload() {
            //CancelEnterKeyForUploadForm();  //  test canceling enter pressed key

            parseResponeInForm();
        }

        function parseResponeInForm() {
            // find file id.
            var fileId = $('#UploadedFileId').val();
            if (fileId != null && fileId != '') {
                var targetElement = $('#DocumentFileId');
                targetElement.val(fileId);
            }
            // If not null or empty populate hidden field on page with file id
        }

        // Cancel the enter key when pressed
        //function CancelEnterKeyForUploadForm() {
        //    event.retrunValue = false;
        //    event.cancel = true;
        //}      
        </script>
    <%--Added by Guru--%>
     <script type="text/javascript">

         $(this).submit(function () {
             var isFileUploaded = $("#IsFileUploaded").val();
             if (isFileUploaded == 'false') {
                 alert("Alert: File Missing, please select file(s) and upload before submitting.");
                 return false;
             }
         });

         $(this).load(function () {
             if ($(".field-validation-error").length > 0 || $(".validation-summary-errors").length > 0) {
                 //make ajax call to get uploaded file html string.
                 $.ajax({
                     type: "GET",
                     url: "<%:(Url.Action("GetUploadedFilesCallbackString","File"))%>",
                    cache: false,
                    success: function (result) {
                        var fileContainerHtmlString = "";
                        fileContainerHtmlString = result;
                        if (fileContainerHtmlString != "") {
                            $("#fileContainer").html(fileContainerHtmlString).parent().show();
                            $("#IsFileUploaded").val("true");
                        }
                    },
                    error: function (request, status, error) {
                        $("#removeError").show();
                    }
                });
            }
        });
    </script>
</asp:Content>
