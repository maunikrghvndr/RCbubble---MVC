<%@ Page Title=" " Language="C#" MasterPageFile="~/Views/Shared/Members.master" Inherits="System.Web.Mvc.ViewPage<RISARC.eTAR.Model.AccountDetailsMain>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Account Details
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="AccountDetailsMaster" runat="server">

    <%--<%if (ViewData["ViewDocumentReadyToDownload"] != null && ViewData["ViewDocumentReadyToDownload"].ToString() == "ViewDocument")
      { %>
    <div id = "ViewDocument">
        <% Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "DocumentViewer", "AccountDetails", new { DocumentFileIDValue = Model.DocumentFileID }); %>
            <%--<% Html.RenderPartial("DocumentViewer", Model); %>--%>
  
    
    <%--</div>--%>
    <%--<%//}else{ %>--%>

   <%-- <% Html.RenderPartial("_popUpHtmlFileViewer"); %>--%>

    <div id="FieldOfficerContainer">
        <% string path = " ~/Home/Members";%>
        <%if (ViewData["ViewDocumentReadyToDownload"] != null && ViewData["ReferringPath"] != null)
          {
              path = ViewData["ReferringPath"].ToString();
          } %>
        <%= System.Web.Mvc.Html.InputExtensions.HiddenFor(Html,Model => Model.TCNIdentificationID) %>
        <%= System.Web.Mvc.Html.InputExtensions.HiddenFor(Html,Model => Model.AccountNo) %>
        <%= System.Web.Mvc.Html.InputExtensions.HiddenFor(Html,Model => Model.TCNNo) %>
        <%= System.Web.Mvc.Html.InputExtensions.HiddenFor(Html,Model => Model.SenderProviderID) %>
        <%= System.Web.Mvc.Html.InputExtensions.HiddenFor(Html,Model => Model.AccountSubmissionDetailsID) %>
        <%= System.Web.Mvc.Html.InputExtensions.HiddenFor(Html,Model => Model.IsTCNSubmitted) %>
        <%= System.Web.Mvc.Html.InputExtensions.HiddenFor(Html,Model => Model.IsProviderEtar_SenderProvider) %>
        <%= System.Web.Mvc.Html.InputExtensions.HiddenFor(Html,Model => Model.IsProviderEtar_LoggedInUser) %>
        <%= System.Web.Mvc.Html.InputExtensions.HiddenFor(Html,Model => Model.HasExternalNoteAccess) %>
        <%= System.Web.Mvc.Html.InputExtensions.HiddenFor(Html,Model => Model.DocumentID) %>
        <!-- this filed is for question answer wizards -->
         <%= System.Web.Mvc.Html.InputExtensions.HiddenFor(Html,Model => Model.PatientId) %>
         <input type="hidden" name="measureName" id="measureName" value="" />

        <%--Model.DocumentFileID exists only when Viewer is opened on the basis of Documnet File ID--%>
        <%= System.Web.Mvc.Html.InputExtensions.HiddenFor(Html,Model => Model.DocumentFileID) %>
        <input type="hidden" name="worklistPath" id="worklistPath" value="<%= Url.Content("~/WorkList/WorkListSearch") %>" />
        <input type="hidden" name="globalsearchPath" id="globalsearchPath" value="<%= Url.Content("~/WorkList/GlobalSearch") %>" />
        <input type="hidden" name="documentsReviewedPath" id="documentsReviewedPath" value="<%= Url.Content("~/ViewDocuments/DocumentsReviewedByDHS") %>" />
        <input type="hidden" name="documentPendingPath" id="documentPendingPath" value="<%= Url.Content("~/ViewDocuments/MyDocumentsPendingForTCN") %>" />
        <input type="hidden" name="eNoteSearchPath" id="eNoteSearchPath" value="<%= Url.Content("~/WorkList/ENotesSearch") %>" />
        <input type="hidden" name="eNoteSearchPath" id="SentDocumentsPath" value="<%= Url.Content(path) %>" />
         <input type="hidden" name="RLFieldID" id="RLFieldID" value=""/>
         <input type="hidden" name="RLFieldIDPopup" id="RLFieldIDPopup" value=""/>
        <input type="hidden" name="SelectedDocId" id="SelectedDocId" value="" />

        <%if (ViewData["ViewDocumentReadyToDownload"] == null)
          { %>
        <%= Html.Partial("AttachOrRemoveTCNPopup") %>
        <%-- This is commented by surekha <%= Html.Partial("DocumentIndexPopup") %>--%>
        <%-- <%= Html.Partial("ReassignTaskPopup") %>--%>
        <%  if (Request.QueryString["eNoteID"] != null)
            {
                Model.enote.eNoteID = Convert.ToInt64(Request.QueryString["eNoteID"]);
                Model.enote.ReplyToeNoteID = Convert.ToInt64(Request.QueryString["eNoteID"]);
            }
        %>
        <%} %>

          

        <table class="FldOffTableHoldar">
            <%if (ViewData["ViewDocumentReadyToDownload"] == null)
              { %>
            <tr class="FirstRow">
                <td colspan="3">
                    <div class="topTable">
                        <ul class="topUl">
                            <!--This code is for question answers related patient information -->
                             <% if (Request["pn"] != null)
                               {%>
                            <li>
                                <span class="boldText">Patient Name</span>
                                <span><%= Request["pn"] %></span>
                            </li>
                            <% } %>


                              <% if (Request["mid"] != null)
                               {%>
                            <li>
                                <span class="boldText">Medicare ID</span>
                                <span><%= Request["mid"] %></span>
                            </li>
                            <% } %>


                            <!-- Q&A wizaed info done -->
                            <% if (ViewData["sourceFlag"] != null && Convert.ToInt16(ViewData["sourceFlag"]) == 1)
                               { %>
                            <li class="popupArrow">
                                <%
                                   Html.DevExpress().Image(settings =>
                                   {
                                       settings.ImageUrl = @Url.Content("~/Images/icons/panel_arrow_down.png");
                                       settings.Name = "DownArrow";
                                       settings.ControlStyle.Cursor = "pointer";

                                   }).GetHtml();
                                %>

                                <%= Html.Partial("ProviderPatientInfoPopup",Model) %>
                            </li>
                            <% } %>


                            <% if (Model.AccountNo != null)
                               {%>
                            <li>
                                <span class="boldText">Account# </span>
                                <span><%= Html.DisplayFor(model => model.AccountNo) %></span>
                            </li>
                            <% } %>


                             <% if (Model.patientInformation != null)
                               {%>
                            <li>
                                <span class="boldText">Patient Name</span>
                                <span>
                                    <%= Html.DisplayFor(model => model.patientInformation.PatientFirstName) %>
                                    <%= Html.DisplayFor(model => model.patientInformation.PatientLastName) %>
                                </span>
                            </li>
                            <% } %>

                            <% if (Model.DeadLineDate != null)
                               {%>
                            <li>
                                <span class="boldText">Deadline</span>
                                <span><%= Html.DisplayFor(model => model.DeadLineDate) %></span>
                            </li>
                            <%} %>

                            <% if (!String.IsNullOrEmpty(Model.TCNNo))
                               {%>
                            <li>
                                <span class="boldText">TCN #</span>
                                <span><%= Html.DisplayFor(model => model.TCNNo) %> </span>
                            </li>
                            <%} %>


                            <%if (Session["IsFieldOffierLogin"] != null && (bool)Session["IsFieldOffierLogin"])
                              {%>
                             
                            <li><span class="boldText">Time Spent</span>
                                <%= Html.Action("TimeSpent","AccountDetails") %> </li>
                            <%} %>
                        </ul>

                        <div class="floatRight dxc-spaceRight">
                             <%--This popup is replaced by new popup as below. 02.02.2015--%>
                             <%--  <%= Html.Partial("AccountNotesPopup", Model)%>--%>
                             <%= Html.Partial("StatusConfirmationPopup")%>
                          
                     <% if (ViewData["QuesAnsPending"] == null)  //hide this controle for question answer wizard
                           {%>
                            
                            <% Html.DevExpress().Button(
                                   RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                           settings =>
                           {
                               settings.Name = "DoneButton";
                               settings.Text = "Ready to Send to Field Office";
                               settings.Height = 32;
                               settings.Width = 83;
                               settings.ControlStyle.CssClass = "orangeBtn";
                               settings.UseSubmitBehavior = false;
                               
                               //ViewData["sourceFlag"] == 1 Means its came from document pending for TSN screen
                               if (ViewData["sourceFlag"] != null && Convert.ToInt16(ViewData["sourceFlag"]) == 1)
                               {
                                   //settings.ClientSideEvents.Click = "function(s,e){ OnTopDoneButtonClick(s,e,\"documentPendingPath\") } ";
                                   //settings.Text = "Approve";
                                   settings.ClientVisible = false;
                               }
                               else if (ViewData["sourceFlag"] != null && Convert.ToInt16(ViewData["sourceFlag"]) == 2)
                               {   //settings.Text = "Done" ;
                                   settings.Text = "Next Page" ;
                                   settings.ClientSideEvents.Click = "function(s,e){ OnTopDoneButtonClick(s,e,\"globalsearchPath\") } ";

                               }
                               else if (ViewData["sourceFlag"] != null && Convert.ToInt16(ViewData["sourceFlag"]) == 3)
                               {
                                   if (Request.QueryString["extFlag"] == "1")
                                   { //Don't show for Document reviwed by DHS

                                       // settings.ClientVisible = false;
                                       settings.ClientSideEvents.Click = "function(s,e){ OnTopDoneButtonClick(s,e,\"documentsReviewedPath\") } ";
                                       settings.Text = "Continue...";

                                   }
                                   else
                                   {
                                       settings.ClientSideEvents.Click = "function(s,e){ OnTopDoneButtonClick(s,e,\"documentsReviewedPath\") } ";
                                       settings.Text = "Ready to Send to Field Office";
                                   }
                               }
                               else if (Model.enote.eNoteID != null && Convert.ToInt16(ViewData["sourceFlag"]) == 4)
                               {
                                   settings.ClientSideEvents.Click = "function(s,e){ OnTopDoneButtonClick(s,e,\"eNoteSearchPath\") } ";
                                   settings.Text = "Continue...";
                               }
                               else
                               {
                                   settings.ClientSideEvents.Click = "function(s,e){ OnTopDoneButtonClick(s,e,\"fieldOfficer\") } ";
                                   //  settings.Text = "Next Page";
                                   //  settings.Text = "Done";
                                   //newly added on 02.02.2015
                                   settings.Text = "Save & Exit"; 
                               }
                           })).GetHtml(); %>
                            <% if (ViewData["sourceFlag"] != null && Convert.ToInt16(ViewData["sourceFlag"]) == 1)
                               {%>
                            <div class="viewerActionBtnADetails">
                                <div class="floatLeft">
                                    <% Html.DevExpress().Button(
                                   RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                                   settings =>
                                   {
                                       settings.Name = "RejectButton";
                                       settings.Height = 32;
                                       settings.Width = 83;
                                       settings.ControlStyle.CssClass = "orangeBtn";
                                       settings.UseSubmitBehavior = false;
                                       //ViewData["sourceFlag"] == 1 Means its came from document pending for TSN screen
                                       settings.ClientSideEvents.Click = "function(s,e){ OnTopDoneButtonClick(s,e,\"documentPendingPath\") } ";
                                       settings.Text = "Reject";

                                   })).GetHtml(); %>
                                </div>

                                <div class="floatRight">
                                    <% Html.DevExpress().Button(
                                   RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                                   settings =>
                                   {
                                       settings.Name = "GoBackButton";
                                       settings.Height = 32;
                                       settings.Width = 83;
                                       settings.ControlStyle.CssClass = "greyBtn";
                                       settings.UseSubmitBehavior = false;
                                       settings.Text = "Go Back";
                                       settings.ClientSideEvents.Click = "function(s,e){ OnTopDoneButtonClick(s,e,\"goBackToTCNBucket\") } ";
                                   })).GetHtml(); %>

                                    <%--TO BE USED LATER FOR REASSIGN TASK
                                            <% Html.DevExpress().Button(
                                   RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                                   settings =>
                                   {
                                       settings.Name = "ReassignButton";
                                       settings.Height = 32;
                                       settings.Width = 83;
                                       settings.ControlStyle.CssClass = "greyBtn";
                                       settings.UseSubmitBehavior = false;                                      
                                        settings.Text = "Re-Assign";
                                        //settings.RouteValues = new { Controller = "ViewDocuments", Action = "MyDocumentsPendingForTCN" };
                                        settings.ClientSideEvents.Click = "function(s,e){ ReassignTaskPopup.Show(); } ";
                                   })).GetHtml(); %>--%>
                                </div>
                            </div>
                            <% }

                           }else{
                            Html.DevExpress().Button(
                               settings =>
                               {
                                   settings.Name = "FinishQuestion";
                                   settings.ControlStyle.CssClass = "orangeBtn";
                                   settings.Width = Unit.Pixel(80);
                                   settings.Text = "Done";
                                   settings.UseSubmitBehavior = true;

                                   if (Request["bk"] == "pending") {
                                       settings.RouteValues = new { Controller = "PQRSReport", Action = "PendingWorkBucket" };
                                   } else {
                                       settings.RouteValues = new { Controller = "PQRSReport", Action = "ClosedWorkBucket" };
                                   }
                               }).GetHtml();  
                        
                        } //hide this controle for question answer wizard ENDS
                        //and show done button to get back to buckte pending / closed  %> 


                        </div>
                    </div>
                </td>
            </tr>
            <%}
              else
              { %>
            <tr class="FirstRow">
                <td colspan="3">
                <div class="makeSpace"></div>
                <div class="dxc-spaceRight" >
                    <% Html.DevExpress().Button(
                                   RISARC.Web.EBubble.Models.DevxControlSettings.ButtonSetting.ButtonSettingsMethodAdditional(
                                   settings =>
                                   {
                                       settings.Name = "GoBackPereviousButton";
                                       settings.Height = 32;
                                       settings.Width = 83;
                                       settings.ControlStyle.CssClass = "orangeBtn";
                                       settings.UseSubmitBehavior = false;
                                       //ViewData["sourceFlag"] == 1 Means its came from document pending for TSN screen
                                       settings.ClientSideEvents.Click = "function(s,e){ GoBackPreviousButton(s,e,\"SentDocumentsPath\") } ";
                                       settings.Text = "Go Back";

                                   })).GetHtml(); %>
                </div>
                    </td>
            </tr>
            <%} %>
            <!-- .FirstRow -->

            <tr class="SecondRow">
                <td>
                    <%
                        Html.DevExpress().Splitter(settings =>
                       {
                           settings.Name = "Splitter";
                           settings.Height = 800;   //Height of whole splitor

                           //   settings.PaneMinSize = 800;
                           settings.Width = System.Web.UI.WebControls.Unit.Percentage(100);
                           settings.AllowResize = true;
                           settings.Styles.Pane.Paddings.Padding = 0;

                           //Client side validation 
                           settings.ClientSideEvents.PaneCollapsed = "PaneCollapsed";
                           settings.ClientSideEvents.PaneExpanded = "PaneExpanded";

                           
                           //When Internal Extrenal Grid Load, Only that time call this function
                           //THis line of code commentd noe : 9-May-2014, it is not required now
                           //if (ViewData["sourceFlag"] == null && Convert.ToInt16(ViewData["sourceFlag"]) != 1)
                           //{
                           
                           settings.ClientSideEvents.PaneResized = "OnSplitterPaneResized";
                           
                           //}
                           //Main splitor setting ends
                           //============================================== Pane Left Start =================
                           //if (ViewData["ViewDocumentReadyToDownload"] == null)
                           //{
                           settings.Panes.Add(paneLeft =>
                           {
                               paneLeft.Name = "paneLeft";
                               paneLeft.Size = System.Web.UI.WebControls.Unit.Percentage(20);
                               paneLeft.ShowCollapseBackwardButton = DefaultBoolean.True;
                               paneLeft.PaneStyle.CssClass = "dvc-PaneBgcolor";

                               paneLeft.SetContent(() =>
                               {
                                   ViewContext.Writer.Write("<div class=\"SelectDoc\"><div class=\"floatLeft\">");

                                   Html.DevExpress().Label(
                                       SelectDocType =>
                                       {
                                           SelectDocType.Text = "Select Document Type";
                                       }).GetHtml();
                                   ViewContext.Writer.Write("</div><div class=\"floatRight\">");

                                   Html.DevExpress().Image(collapseSettings =>
                                   {
                                       collapseSettings.ImageUrl = @Url.Content("~/Images/icons/panel_arrow_left.png");
                                       collapseSettings.Name = "btnCollapseLeft";
                                       collapseSettings.ControlStyle.Cursor = "pointer";
                                       collapseSettings.ToolTip = "Click to collapse";

                                   }).GetHtml();
                                   if (ViewData["ViewDocumentReadyToDownload"] == null)
                                   {
                                       ViewContext.Writer.Write("</div>");
                                      
                                       //commmented by abdul as autobinding is done in case of model.
                                      // System.Web.Mvc.Html.ChildActionExtensions.RenderAction(Html, "RMSDocumentsCombo", new { TCNNo = Model.TCNNo, AccountSubmissionDetailsID = Model.AccountSubmissionDetailsID, SenderProviderID = Model.SenderProviderID });
                                       System.Web.Mvc.Html.ChildActionExtensions.RenderAction(Html, "RMSDocumentsCombo", Model);
                                       ViewContext.Writer.Write("</div>");
                                       
                                       //commmented by abdul as autobinding is done in case of model.
                                       //System.Web.Mvc.Html.ChildActionExtensions.RenderAction(Html, "RMSDocumentsGrid", new { TCNNo = Model.TCNNo, AccountSubmissionDetailsID = Model.AccountSubmissionDetailsID, SenderProviderID = Model.SenderProviderID });
                                       System.Web.Mvc.Html.ChildActionExtensions.RenderAction(Html, "RMSDocumentsGrid", Model);
                                       ViewContext.Writer.Write(Html.Hidden("IndexRowCount"));
                                       //added by surekha 15.01.2015
                                      // if (ViewData["QuesAnsPending"] == null)
                                     //  {  //hide this controle for question answer wizard
                                           System.Web.Mvc.Html.ChildActionExtensions.RenderAction(Html, "DocumentIndexGrid", new { TCNIdentificationID = Model.TCNIdentificationID });
                                      // }
                                       }
                                   else if (ViewData["ViewDocumentReadyToDownload"] == "ViewDocument")
                                   {
                                       ViewContext.Writer.Write("</div>");
                                       System.Web.Mvc.Html.ChildActionExtensions.RenderAction(Html, "RMSDocumentsCombo", new { DocumentFileID = Model.DocumentFileID });
                                       ViewContext.Writer.Write("</div>");
                                       System.Web.Mvc.Html.ChildActionExtensions.RenderAction(Html, "RMSDocumentsGrid", new { DocumentFileID = Model.DocumentFileID });
                                       ViewContext.Writer.Write(Html.Hidden("IndexRowCount"));
                                      
                                         System.Web.Mvc.Html.ChildActionExtensions.RenderAction(Html, "DocumentIndexGrid", new { TCNIdentificationID = Model.TCNIdentificationID });
                                      
                                   }
                               });


                           });//Left Panes ends
                           //}

                           //============================================ Pane Middle Start ========================================
                           settings.Panes.Add(paneMiddle =>
                           {
                               paneMiddle.Name = "paneMiddle";

                               paneMiddle.Size = System.Web.UI.WebControls.Unit.Percentage(60); //It takes its width
                               
                               //Middle content seprated into 2 blocks internally : heights 50% as 100 of their own block
                               //#######################################  Middle Up Part Start  #######################################  
                               paneMiddle.Panes.Add(RMSDocument =>
                               {
                                   RMSDocument.Name = "DocumentViewerPanes";
                                   RMSDocument.Size = System.Web.UI.WebControls.Unit.Percentage(100); //It takes as whole height 
                                   if (ViewData["ViewDocumentReadyToDownload"] == null)
                                   {
                                       RMSDocument.SetContent(() =>
                                       {
                                           //System.Web.Mvc.Html.ChildActionExtensions.RenderAction(Html, "DocumentViewerPartial", "AccountDetails");
                                           ViewContext.Writer.Write("<div id= 'DocumentViewerMain' >");

                                           Html.RenderPartial("DocumentViewer", Model);
                                           ViewContext.Writer.Write("</div>");

                                       });
                                   }
                                   else
                                   {
                                       RMSDocument.SetContent(() =>
                                       {
                                           //System.Web.Mvc.Html.ChildActionExtensions.RenderAction(Html, "DocumentViewerPartial", "AccountDetails");
                                           ViewContext.Writer.Write("<div id= 'DocumentViewerMain' >");
                                           Microsoft.Web.Mvc.ViewExtensions.RenderAction(this.Html, "DocumentViewer", "AccountDetails", new { DocumentFileIDValue = Model.DocumentFileID });
                                           ViewContext.Writer.Write("</div>");
                                       });
                                   }
                               });

                               //#######################################  Middle Down Part Start  ####################################### 
                               var sFlag = "";
                               if (Request.QueryString["sourceFlag"] != null)
                                   sFlag = Convert.ToString(Request.QueryString["sourceFlag"]);
                               if (ViewData["ViewDocumentReadyToDownload"] == null || sFlag.Equals("4"))
                               {
                                   paneMiddle.Panes.Add(NotePane =>
                                   {
                                       NotePane.Name = "DownNotePane";
                                       if (ViewData["QuesAnsPending"] == null){ NotePane.MinSize = 200;}else{NotePane.MinSize = 400;}
                                      
                                       NotePane.ScrollBars = ScrollBars.Auto;
                                       NotePane.Size = System.Web.UI.WebControls.Unit.Percentage(65); //It work as height of Note pane.
                                       NotePane.ShowCollapseForwardButton = DefaultBoolean.True;
                                       NotePane.PaneStyle.CssClass = "dvc-PaneBgcolor";
                                      
                                       NotePane.SetContent(() =>
                                       {
                                           if (ViewData["QuesAnsPending"] == null)
                                           {
                                               //Tempraroy commentd by surekha
                                               System.Web.Mvc.Html.ChildActionExtensions.RenderAction(Html, "InternalExternalENote", "AccountDetails", new { TCNIdentificationID = Model.TCNIdentificationID, SenderProviderID = Model.SenderProviderID, AccountSubmissionDetailsID = Model.AccountSubmissionDetailsID, DocumentID = Model.DocumentID });
                                           }else { //Show question answer wizard for ACO GPRO Application 

                                               System.Web.Mvc.Html.ChildActionExtensions.RenderAction(Html, "_gvGroupStatus", "PQRSReport", new { isViwer = 1, PatientId = Model.PatientId });
                                               if (Request["bk"] == "pending")
                                               {
                                                   ViewContext.Writer.Write("</br><div class='underline'><div class='subheader'>Pending Questions&nbsp;&nbsp;&nbsp;&nbsp;   <span class='measure-name'>Select measure from the above table</span></div></div>");
                                               }
                                               else
                                               {
                                                   ViewContext.Writer.Write("</br><div class='underline'><div class='subheader'>Completed Questions&nbsp;&nbsp;&nbsp;&nbsp;   <span class='measure-name'>Select measure from the above table</span></div></div>");
                                               }
                                               //ViewContext.Writer.Write("</br><div class='underline'><div class='subheader'>Pending Questions&nbsp;&nbsp;&nbsp;&nbsp;   <span class='measure-name'>Select measure from the above table</span></div></div>");
                                               ViewContext.Writer.Write("</br><div id='question-wizard' class='hide'>");
                                               System.Web.Mvc.Html.ChildActionExtensions.RenderAction(Html, "_QuestionsList", "PQRSReport", new { PatientId = Model.PatientId, Viewer = 1 });
                                            
                                              System.Web.Mvc.Html.ChildActionExtensions.RenderAction(Html, "QuestionsWizardButtons", "PQRSReport");
                                             //  System.Web.Mvc.Html.ChildActionExtensions.RenderAction(Html, "QAButtonsCallbackPanel", "PQRSReport");
                                            //   Html.RenderPartial("~/Views/PQRSReport/QAButtonsCallbackPanel.ascx");
                                               
                                                   
                                               ViewContext.Writer.Write("</div>");
                                           }//else ends 
                                       });

                                   });
                               }
                           }); //Pane Middle Ends 

                           //=============================== Pane Right Start =========================================
                           if (ViewData["ViewDocumentReadyToDownload"] == null && ViewData["QuesAnsPending"] == null)
                           { //  hide right panel for questions answers wizard. 
                               settings.Panes.Add(paneRight =>
                               {
                                   paneRight.Name = "paneRight";
                                   paneRight.Size = System.Web.UI.WebControls.Unit.Percentage(20);
                                   //Here Changed Default seprator image  
                                   paneRight.ShowCollapseForwardButton = DefaultBoolean.True;

                                   paneRight.Separator.ButtonStyle.CssClass = "sepratorBtn";
                                   paneRight.Separator.SeparatorStyle.CssClass = "sepratorStyle";
                                   //   paneRight.Separator.ButtonStyle.BackgroundImage.ImageUrl = @Url.Content("~/Images/icons/printerOption.png");


                                   paneRight.SetContent(() =>
                                   {

                                       ViewContext.Writer.Write("<div class='RightSideBar'> <div class='rightLinkBlock'><div >");
                                       ViewContext.Writer.Write("<span class='RightSideLableText'>TCN Form</span></div>");
                                       //Dont show this link
                                       if (ViewData["sourceFlag"] != null && Convert.ToInt16(ViewData["sourceFlag"]) == 1)
                                       {

                                           ViewContext.Writer.Write("<div class='attacheRemovelink'><a id='AttachRemoveTCNPopUp' href='#' onclick='BindTCNFormsGrid(true);'>Attach/Remove TCN</a></div>");
                                       }
                                       ViewContext.Writer.Write("<div class=\"customeExpColArrow\">");

                                       Html.DevExpress().Image(collapseSettings =>
                                       {
                                           collapseSettings.ImageUrl = @Url.Content("~/Images/icons/panel_arrow_right.png");
                                           collapseSettings.Name = "btnCollapseRight";
                                           collapseSettings.ControlStyle.Cursor = "pointer";
                                           collapseSettings.ToolTip = "Click to collapse";

                                       }).GetHtml();

                                       ViewContext.Writer.Write("</div> <div class='clear'>&nbsp;</div>");


                                       System.Web.Mvc.Html.ChildActionExtensions.RenderAction(Html, "TCNDocumentCombo", "AccountDetails", new { AccountSubmissionDetailsID = Model.AccountSubmissionDetailsID, SenderProviderID = Model.SenderProviderID, TCNNo = Model.TCNNo });

                                       ViewContext.Writer.Write("</div> <div class='clear'>&nbsp;</div>");
                                       
                                       ViewContext.Writer.Write("<div class=\"TCNForm\">");
                                       //Html.RenderPartial("TCNFormPartial"); 
                                       System.Web.Mvc.Html.ChildActionExtensions.RenderAction(Html, "TCNFormPartial", "AccountDetails", new { AccountSubmissionDetailsID = Model.AccountSubmissionDetailsID, SenderProviderID = Model.SenderProviderID, TCNNo = Model.TCNNo });
                                       ViewContext.Writer.Write("</div>");


                                       ViewContext.Writer.Write("</div>");
                                   });
                               }); //Panel Right Ends
                           }
                       }).GetHtml();
                    %>
                </td>
            </tr>
            <!-- .SecondRow -->

        </table>
        <!-- .FldOffTableHoldar -->
    </div>
    <%--  <%}%>--%>
</asp:Content>



<asp:Content ID="Content3" ContentPlaceHolderID="AdditionalHeadContent" runat="server">
    <script src="<%: Url.Content("~/Scripts/AccountDetailsCommon.js") %>" type="text/javascript"></script>
    <script src="<%: Url.Content("~/Scripts/eNote.js") %>" type="text/javascript"></script>
    <script src="<%: Url.Content("~/Scripts/InternalNote.js") %>" type="text/javascript"></script>

    <%if (Session["IsFieldOffierLogin"] != null && (bool)Session["IsFieldOffierLogin"])
      {%>
    <script src="<%: Url.Content("~/Scripts/TimeTracker.js") %>" type="text/javascript"></script>
    <%} %>

    
     <%if (ViewData["QuesAnsPending"] != null)
       {%> 
    <script type="text/javascript">
     //function to show quesution answes block.
        //depending on patient id & measure id 
        function ShowQuestionAnswers(measureName) {
            $("#question-wizard").addClass("show").removeClass("hide");
            var PatientId = "<%: Model.PatientId %>";
            $("#measureName").val(measureName);

            $(".measure-name").html("Selected Measure - "+measureName.toUpperCase());
            if (!cbpQuestionsAnswers.InCallback())
                cbpQuestionsAnswers.PerformCallback({ PatientId: PatientId, measureName: measureName });

            //Show this buttons on click of measure
            $(".viewerActionBtnADetails").show();
            //  $(".BtnFinish").hide();
        }

</script>
     <script src="<%: Url.Content("~/Scripts/QuestionsWizardCommon.js") %>" type="text/javascript"></script>
    <% } %>



    <script type="text/javascript">
        //This is for conditional popup of provider & patient information popup.
        //<![CDATA[

        function SetImageState(value) {
            var popupButton = "<%: Url.Content("~/Images/icons/panel_arrow_down.png") %>";
            var closeButton = "<%: Url.Content("~/Images/icons/panel_arrow_top.png") %>";

            $("#DownArrow").attr("src", value ? closeButton : popupButton);

        }


        // ]]>
    </script>

    <script type="text/javascript">
        var AccountSubmissionDetailsID = '<%= Model.AccountSubmissionDetailsID %>';
        var TCNNumber = '<%= Model.TCNNo %>';
        function AddExternalNote(s, e) {
            var TCNIdentificationIDVal;
            var sendValuesInCalback = false;
            //if ($('#TCNId').length != 0 && $('#TCNIdentificationID').length != 0 && $('#TCNIdentificationID').val() == '' && TCNId.GetSelectedItem() != null && TCNId.GetSelectedItem().value == '') {
            if ($('#TCNId').length != 0 && $('#TCNIdentificationID').length != 0 && $('#TCNIdentificationID').val() == '' && (TCNId.GetSelectedItem() == null || TCNId.GetSelectedItem().value == '')) {
                alert('Please select TCN# to add external note.');
                return false;
            }
            else if ($('#TCNId').length == 0 || $('#TCNIdentificationID').val() != '') {
                TCNIdentificationIDVal = '<%= Model.TCNIdentificationID%>';
            }
            else {
                if ($('#TCNId').length != 0 && TCNId.GetSelectedItem() != null) {
                    TCNIdentificationIDVal = TCNId.GetSelectedItem().value
                    sendValuesInCalback = true;
                }
            }

        if ($('#ExternalNoteMemo').length != 0) {
            if (ExternalNoteMemo.GetText() == '') {
                alert("Please add note and then click Add.");
                return false;
            }
        }
        else {
            return false;
        }
        if (ExternalNoteMemo.GetText() != null && ExternalNoteMemo.GetText() != '')
            var memo = ExternalNoteMemo.GetText()
        else if (popupExternalNoteMemo.GetText() != null && popupExternalNoteMemo.GetText() != '')
            var memo = popupExternalNoteMemo.GetText()
        var routData = {
            Note: ExternalNoteMemo.GetText(),
            TCNIdentificationID: TCNIdentificationIDVal //'<%= Model.TCNIdentificationID%>'
        };

        $.ajax({
            url: "<%:(Url.Action("AddExternalNote","AccountDetails"))%>",
                type: 'POST',
                datatype: 'json',
                data: routData,
                cache: false,
                success: function (data) {
                    if (data == "Success" && !($('#ExternalNoteGrid').length == 0)) {
                        if (sendValuesInCalback) {
                            ExternalNoteGrid.PerformCallback({ TCNIdentificationID: TCNIdentificationIDVal, TCNNo: TCNId.GetSelectedItem().text });
                        }
                        else {
                            ExternalNoteGrid.PerformCallback();
                        }
                    }
                    ExternalNoteMemo.SetText("");
                },
                error: function (data) {
                    alert('Something might went wrong!');
                },
                complete: function () {
                    //Reset time remaining
                    RestartExpirationTime();
                },
                autoLoad: true
            });
        }

        function AddExternalNotePopup(s, e) {
            if (document.getElementById('popupExternalNoteMemo') != null) {
                if (popupExternalNoteMemo.GetText() == '') {
                    alert("Please add note and then click Add.");
                    return false;
                }
            }
            else {
                return false;
            }
            var routData = {
                Note: popupExternalNoteMemo.GetText(),
                TCNIdentificationID: '<%= Model.TCNIdentificationID%>'
            };

            $.ajax({
                url: "<%:(Url.Action("AddExternalNote","AccountDetails"))%>",
                type: 'POST',
                datatype: 'json',
                data: routData,
                cache: false,
                success: function (data) {
                    if (data == "Success" && !($('#ExternalNoteGridPopup').length == 0))
                        ExternalNoteGridPopup.PerformCallback();
                    popupExternalNoteMemo.SetText("");
                },
                error: function (data) {
                    alert('Something might went wrong!');
                },
                autoLoad: true
            });
        }

        function AddComments(s, e) {
            if (document.getElementById('Comments') != null) {
                var routData = {
                    Comments: Comments.GetText(),
                    AccountSubmissionDetailsID: '<%= Model.AccountSubmissionDetailsID %>'
                };

                $.ajax({
                    url: "<%:(Url.Action("AddComments","AccountDetails"))%>",
                    type: 'POST',
                    datatype: 'json',
                    data: routData,
                    cache: false,
                    success: function (data) {
                        if (Comments.GetText() == '') {
                            alert('Please Add TAR Language.');
                        } else {
                            alert('TAR Comment added successfully!');
                        }
                    },
                    error: function (data) {
                        alert('Something might went wrong!');
                    },
                    complete: function () {
                        //Reset time remaining
                        RestartExpirationTime();
                    },
                    autoLoad: true
                });
            }
        }

        // Added by Abhishek 04-Feb-2015 for AddAdditionalTARLanguage
        function AddAdditionalTARLanguage(s, e) {
            if (document.getElementById('AdditionalTARLanguage') != null) {
                var routData = {
                    AdditionalTARLanguage: AdditionalTARLanguage.GetText(),
                    AccountSubmissionDetailsID: '<%= Model.AccountSubmissionDetailsID %>'
                };

                $.ajax({
                    url: "<%:(Url.Action("AddAdditionalTARLanguage","AccountDetails"))%>",
                    type: 'POST',
                    datatype: 'json',
                    data: routData,
                    cache: false,
                    success: function (data) {
                        if (AdditionalTARLanguage.GetText() == '') {
                            alert('Please Add AddAdditional TAR Language.');
                        } else {
                            alert('Additional TAR Language Comment added successfully!');
                        }
                    },
                    error: function (data) {
                        alert('Something might went wrong!');
                    },
                    complete: function () {
                        //Reset time remaining
                        RestartExpirationTime();
                    },
                    autoLoad: true
                });
            }
        }


        //to set tcn number and recipient's provider Id- added by Guru
        function SetTCNNumberAndRecipientProviderId() {
            var tcnNumber = txtTCNNumber.GetValue();
            // Check for value of TCN No.
            if (tcnNumber == null) {
                $(".error").html("* Please enter TCN number !");
                $(".error").show();
                return false;
            }
            $.ajax({
                type: "GET",
                url: "<%:(Url.Action("SetTCNNumberAndRecipientProviderId","AccountDetails"))%>",
                cache: false,
                data: { tcnNumber: tcnNumber, accountNumberId: '<%= Model.AccountSubmissionDetailsID %>' },
                success: function (result) {
                    if (result == "True")
                        TCNMultiSelectUploadControl.Upload();
                    $(".error").html(" ");
                },
                error: function (request, status, error) {
                    alert("Error occured while attaching TCN form.");
                }
            });
        }

        function SendTCNDocument() {
            var routData = {
                AccountSubmissionDetailsID: '<%= Model.AccountSubmissionDetailsID %>',
            SenderProviderID: '<%= Model.SenderProviderID%>'
        };

        $.ajax({
            type: "GET",
            url: "<%:(Url.Action("SendTCNForms","AccountDetails"))%>",
            cache: false,
            data: routData,
            success: function (result) {

                if (result == "True") {
                    $(".error").hide();
                    AttachRemoveTCN.Hide();
                    //set tcn froms submission status
                    $("#IsTCNSubmitted").val("True");


                    //perform callback for TCN Dropdown
                    RefreshDocumentTypeDropDown();
                    //perform call back for document grid
                    RMSDocumentsGrid.PerformCallback({ TCNNo: '<%= Model.TCNNo %>', AccountSubmissionDetailsID: '<%= Model.AccountSubmissionDetailsID %>', SenderProviderID: '<%= Model.SenderProviderID %>' });
                        //Perform call back for RMS Documnet
                        selectDocumentType.PerformCallback({ TCNNo: '<%= Model.TCNNo %>', AccountSubmissionDetailsID: '<%= Model.AccountSubmissionDetailsID %>', SenderProviderID: '<%= Model.SenderProviderID %>' });

                        // Added By Dnyaneshwar
                        if ($('#TCNId').length != 0)
                            TCNId.PerformCallback({ AccountSubmissionDetailsID: '<%= Model.AccountSubmissionDetailsID %>' });
                        // End Added
                        TCNFormDisplayCP.PerformCallback({ TCNNo: '<%= Model.TCNNo %>', AccountSubmissionDetailsID: '<%= Model.AccountSubmissionDetailsID %>', SenderProviderID: '<%= Model.SenderProviderID %>' });

                    }
                    else {
                        $(".error").html(result).show();

                    }

                    $(window).scroll(function () {
                        window.scrollTo(0, 0);

                    });


                },
            error: function (request, status, error) {
                alert("Error occured while saving TCN form.");
            }
        });

        }

        function AddTCNFileToContainer(callbackData) {
            $("#IsFileUploaded").val("true");

            if ($(".field-validation-error").length === 1)
                $(".field-validation-error").hide();

            BindTCNFormsGrid();

        }

        function BindTCNFormsGrid(isClearSession) {
            // On attach button click set default value to null Text 
          //  $(".dxc-AttachRemoveTCN").find("input").val(null);

            if (isClearSession == null)
                isClearSession = false;
            $(".error").hide();
            if (!(document.getElementById('TCNFormGrid') == null)) {
                TCNFormGrid.PerformCallback({ AccountSubmissionDetailsID: '<%= Model.AccountSubmissionDetailsID %>', SenderProviderID: '<%= Model.SenderProviderID %>', IsClearSession: isClearSession });
                TCNFormGrid.ExpandAll();
            }
        }

        //======To open popUp Box of intenal , extrnal & enote seaction =====
        function OnTopDoneButtonClick(s, e, Path) {
            //02-Apr-2014

            if (Path == "fieldOfficer")
            {
                //This  code is changed for Save & Exit button 02.02.2015
                // if ($('#InternalNoteGridPopup').length != 0)
                //   InternalNoteGridPopup.PerformCallback();
                // if ($('#ExternalNoteGridPopup').length != 0)
                //   ExternalNoteGridPopup.PerformCallback();
                // AccountNotesPopup.Show();
                //BindRLGrid('<%= Model.AccountSubmissionDetailsID %>', true);
                //======== above code is comment for new requirments 02.02.2015 =============
                
                var TCNIdentificationID_FO = '<%= Html.Encrypt(Model.TCNNo) %>';
                CheckLockStatus(TCNIdentificationID_FO);
                CustomLoadingPanelHide();
                TCNStatusConfirmation.Show();
            }
            else if (Path == "globalsearchPath" || Path == "eNoteSearchPath" || Path == "documentsReviewedPath") {

                window.location = $("#" + Path).val();

            }
            else {
                var statusFlag = '2';   //to reject the documents
                //set global variable
                var accountNumberId = '<%= Html.Encrypt(Model.AccountSubmissionDetailsID) %>';
                var documentId = '';
                var tcnNumber = '<%= Model.TCNNo %>';

                //jquery ajax call to clear TCN files session collection
                $.ajax({
                    type: "GET",
                    url: "<%:(Url.Action("ClearTCNFilesCollection","AccountDetails"))%>",
                    cache: false,
                    data: {},
                    success: function (result) {
                        if (result == "True") {
                            if (Path == "documentPendingPath") {
                                //Reject the documents
                                UpdateReviewStatus(accountNumberId, documentId, statusFlag, '2');
                            }
                            else if (Path == "goBackToTCNBucket") {
                                window.location = $("#documentPendingPath").val();
                            }
                        }
                    },
                    error: function (request, status, error) {
                        alert("Error occured while attaching TCN form.");
                    }
                });
            }

    }//func ends 

    // The following function is duplicated.
    function removeTcnFile(id) {
        var totalFilesCount = $("#fileContainer div").length;
        var currentFileCount;
        //ajax request to RemoveFile action method and if the response is true then hide file from the screen.
        $.ajax({
            type: "GET",
            cache: false,
            url: "<%:(Url.Action("RemoveTCNUploadedFile","File"))%>",
            data: { documentFileId: id, accountNumberId: '<%= Model.AccountSubmissionDetailsID %>' },
            success: function (result) {
                $("#removeError").hide();
                if (result == "True") {
                    $("a[encid='" + id + "']").parent().next("br").remove();
                    $("a[encid='" + id + "']").parent().remove()
                    currentFileCount = $("#fileContainer div").length;
                    if (!(document.getElementById('fileUploadGrid') == null))
                        currentFileCount = (fileUploadGrid.pageRowCount - 1);
                    //hide file container if all files are removed.
                    if (currentFileCount === 0) {
                        $("#uploadedFiles").hide();
                        $("#IsFileUploaded").val("false");
                    }
                    //perform call back for document grid
                }
                else {
                    $("#removeError").show();
                }
                //perform call back for document grid
                BindTCNFormsGrid();
            },
            error: function (request, status, error) {
                $("#removeError").show();
            }
        });
    }
    //Guru: Convert this into function
    function RefreshDocumentTypeDropDown() {

        var TCNNo = '<%= Model.TCNNo %>';
        var AccountSubmissionDetailsID = '<%= Model.AccountSubmissionDetailsID %>';
        var SenderProviderID = '<%= Model.SenderProviderID %>';
        DocumentType.PerformCallback({ AccountSubmissionDetailsID: AccountSubmissionDetailsID, SenderProviderID: SenderProviderID, TCNNo: TCNNo });
    }
    //Function for select paege on right side
    function SelectPageComboBox(s, e) {
        //Reset time remaining
        RestartExpirationTime();
        var id = s.GetValue();

        TCNFormDisplayCP.PerformCallback({ documentId: id });
    }


    function StatusSaveSubmitBtnClick(s, e, btnValue) {
        var accountNoId = '<%= Model.AccountSubmissionDetailsID%>';
        var tcnId = '<%= Model.TCNIdentificationID%>';
        //saveBtn  //submitBtn
        // alert(btnValue);
        var flag = false;
        var Button = "Save";
        if (btnValue == 'submitBtn') {
            flag = true;
            Button = "Submit";
        }

        //Reset time remaining
        RestartExpirationTime();

        //stop time tracker
        StopTaskTimer();
        var status = StatusComboBox.GetValue();
        if (flag == true && status == 6) {
            alert("Do Not Notify Provider does not allow submit operation.Please click save");
            return false;
        }
        if (status != null) {
            //get confimration
            if (flag && !confirm('Do you want to submit this record to Provider?')) {
                return false;
            }
            var routData = {
                //SubmitTcnStatus
                accountSubmissionId: accountNoId,
                statusId: status,
                TCNIdentificationID: tcnId,
                flag: flag,
                TCNNumber: '<%= Model.TCNNo %>'
            };

            $.ajax({
                url: "<%:(Url.Action("SubmitTcnStatus","AccountDetails"))%>",
                type: 'POST',
                datatype: 'json',
                data: routData,
                cache: false,
                success: function (data) {
                    //track time spent to before saving / submitting the details

                    LogTimeForScreen(1, accountNoId, tcnId, false);
                    setTimeout(function () {
                        window.location = $("#worklistPath").val();
                    }, 2000);
                },
                error: function (data) {
                    alert('Something might went wrong!');
                },
                autoLoad: true
            });
        }
        else
            alert('Please Select the Status before ' + Button);
    }
  
        //=============== New function for above function work due to new requirments 02.02.2015=============

        function StatusSaveClick(s, e, btnValue) {
            var accountNoId = '<%= Model.AccountSubmissionDetailsID%>';
            var tcnId = '<%= Model.TCNIdentificationID%>';

            //Pending: Would save the current record and return to the worklist
            // btnValue = "Save"; means it pending 
            var flag = false;
            var ButtonText = "Save";

            //Reviewed: Would save and submit the current record
            // btnValue = "Submit"; means it pending 
            if (btnValue == 'submitBtn') {
                flag = true;
                ButtonText = "Submit";
            }

            //Reset time remaining
            RestartExpirationTime();
            //stop time tracker
            StopTaskTimer();

            //  var status = StatusComboBox.GetValue();
            //02.02.2015 pass the button value which will decide whether record needs to save or submit.

            
            if (ButtonText != null)
            {
                //Commented on 06-Feb-2015 by Abhishek, confimration is not required
                //get confimration
                //if (flag && !confirm('Do you want to submit this record to Provider?')) {
                //    return false;
                //}

                var routData = { accountSubmissionId: accountNoId, ButtonText: ButtonText, TCNIdentificationID: tcnId, flag: flag, TCNNumber: '<%= Model.TCNNo %>' };

            $.ajax({
                url: "<%:(Url.Action("SaveOrSubmitTCNStatus","AccountDetails"))%>",
                type: 'POST',
                datatype: 'json',
                data: routData,
                cache: false,
                success: function (data) {
                    //track time spent to before saving / submitting the details
                    LogTimeForScreen(1, accountNoId, tcnId, false);
                    setTimeout(function () {
                        window.location = $("#worklistPath").val();
                    }, 2000);
                },

                error: function (data) {
                    alert('Something might went wrong!');
                },
                autoLoad: true
            });
        }
        else
            alert('Please Select the Status before ' + Button);
    }
    //=============== New function ends ==========================================

        function CheckLockStatus(TCNIdentification) {
            generalizedShowLoader();

            var isTCNLockedOut = false;
            $.ajax({
                type: "GET",
                url: "<%:(Url.Action("IsTCNLockedOut","WorkList"))%>",
                data: { TCNIdentification: TCNIdentification },
                cache: false,
                async: false,
                success: function (result) {
                    if (result != "False") {
                        CustomLoadingPanelHide();
                        alert("This TCN is under review by " + result);
                    }
                    isTCNLockedOut = (result != "False" ? false : true);
                },
                error: function (request, status, error) {
                    console.error("Error occured while accessing the document.")
                    alert("Error occured while accessing the document.");
                }

            });
            return isTCNLockedOut;

        }


      




    ////======On Document List row Cliked will populate Document Index -- Moved from AccountDetailsCommon.js to here  //======
        function RMSDocumentRowClicked(s, e) {
            var fieldOfficer = '<%= Session["IsFieldOffierLogin"] %>'
            var TCNIdentificationID_FO = '<%= Html.Encrypt(Model.TCNNo) %>';
            if (fieldOfficer != null && fieldOfficer == 'True') {
                CheckLockStatus(TCNIdentificationID_FO);
            }
        RestartExpirationTime();
        s.GetRowValues(e.visibleIndex, "DocumentFileID", CallbackToDocumentIndexGrid);
        s.GetRowValues(e.visibleIndex, "DocumentID", CallbackToInternalNote);
        s.GetRowValues(e.visibleIndex, "DocumentID", CallbackToeNote);
        //s.GetRowValues(e.visibleIndex, "DocumentID", CallbackToEnoteReviewer);
    }

    //function CallbackToEnoteReviewer(values) {
    //    alert(values);
    //    if ($('#cbpENoteReviewer').length > 0) {
    //        cbpENoteReviewer.PerformCallback({ documentId: values });
    //    }
    //}

        var removeCurrentFileIDForResponseLetter;

        function CallbackToDocumentIndexGrid(values) {
          
              removeCurrentFileIDForResponseLetter = values;
              $("#RLFieldIDPopup").val(values); // Setting current opened document ID here
            var TCNIdentificationIDV = $("#TCNIdentificationID").val();
            var accountNumberId = '<%= Html.Encrypt(Model.AccountSubmissionDetailsID) %>';
            documentFileId = values;

    //Restrict user to proceed if it document type or document format type is not assigned to the user.
    if (!CheckDocumentAccess(accountNumberId, documentFileId)) {
        documentFileId = "";    //to show no indexes if reviewer doesn't have access to selected document.
        DocumentIndexGrid.PerformCallback();
        return false;
    }

    var isIndexEditionAllowed = GetIndexModificationStatus();
    DocumentIndexGrid.PerformCallback({ documentFileId: documentFileId, visibilityFlag: isIndexEditionAllowed });

    $.ajax({
        type: "GET",
        cache: false,
        url: "../AccountDetails/DocumentViewer",
        data: { DocumentFileID: documentFileId },
        success: function (result) {
            if (result != null) {
                if ($('#documentViewer_DocumentPath').length != 0)
                    $('#documentViewer_DocumentPath').val(result.DocumentPath);
                if ($('#documentViewer_DocumentFileName').length != 0)
                    $('#DocumentFileName').val(result.DocumentFileName);
                if ($('#documentViewer_NumberOfPages').length != 0)
                    $('#documentViewer_NumberOfPages').val(parseInt(result.NumberOfPages + ""));
                if ($('#documentViewer_ContentType').length != 0)
                    $('#documentViewer_ContentType').val(result.ContentType);
                if (preViousDocumentFileID == documentFileId) {
                    LoadDocument();
                }
                else {
                    preViousDocumentFileID = documentFileId;
                    LoadDocument(true);
                }
            }
        },
        error: function (request, status, error) {
            $("#removeError").show();
        }
    });
}

function GetIndexModificationStatus() {
    //Show / hide Edit command columns based on previous URL.
    var referrerPath = $("#SentDocumentsPath").val();
    var indexVisibilityFlag = true;
    if (referrerPath != '') {
        referrerPath = referrerPath.substring(referrerPath.lastIndexOf("/") + 1, referrerPath.length)
        indexVisibilityFlag = (referrerPath.toLowerCase() == "mydownloadeddocuments") ? false : true;
    }
    return indexVisibilityFlag;
}

function removeRLFile_DocumentGrid(fileId) {
     
    $.ajax({
        type: "GET",
        url: "<%:(Url.Action("_RemoveRLUploadedFile","File"))%>",
        data: { documentFileId: fileId },
        success: function (result) {

                if (result) {
                    if ($('#fileUploadGrid_RL').length != 0)
                        fileUploadGrid_RL.PerformCallback();

                    if ($('#RMSDocumentsGrid').length != 0)
                        RMSDocumentsGrid.PerformCallback({ TCNNo: '<%= Model.TCNNo %>', AccountSubmissionDetailsID: '<%= Model.AccountSubmissionDetailsID %>', SenderProviderID: '<%= Model.SenderProviderID %>' });

                } else {
                    alert('Something might went wrong!');
                }
                // IF response letter getting deleted then refer its corresponding enote also.
            if ($('#NoteTabs').length != 0)
                NoteTabs.PerformCallback();
            }

            }).done(function () {
             //   debugger;
             //   var selectedDocmentViewerFileID = documentFileId;
                if (fileId == removeCurrentFileIDForResponseLetter) // Current File ID == Selcted One Then Remove files from Document Viewer.
                {
                    $("#pluginPageView").html("");
                    $("#txtGoToPage").val("");
                    $("#totalPageCount").val("");
                }

            });

    }

        function removeRLFileWithDocid(s, e) {
            var conf = confirm("Are you sure you want to delete this record?");
            if (conf == true) {
                s.GetRowValues(e.visibleIndex, 'DocumentFileID', getRemoveDocFileID);
            }
       
    }

    function getRemoveDocFileID(DocFileID) {
        removeRLFile_DocumentGrid(DocFileID);
    }


    </script>
    <script type="text/javascript" src="<%: Url.Content("~/Scripts/jquery-1.9.0.js") %>"> </script>
    <script type="text/javascript" src="<%: Url.Content("~/Scripts/ImGearPlugins21.1.js") %>"> </script>
    <script type="text/javascript" src="<%: Url.Content("~/Scripts/ImGearCore21.1.js") %>"> </script>
    <script type="text/javascript" src="<%: Url.Content("~/Scripts/ImGearClientViewer21.1.js") %>"> </script>
    <script type="text/javascript" src="<%: Url.Content("~/Scripts/ImGearThumbnailList21.1.js") %>"> </script>
    <script type="text/javascript" src="<%: Url.Content("~/Scripts/NotesCommon.js") %>"> </script>
    <%if (ViewData["ViewDocumentReadyToDownload"] != null && ViewData["ViewDocumentReadyToDownload"].ToString() == "ViewDocument")
      { %>
    <script type="text/javascript">

        function DownloadedDocument() {

            var path = $('#documentViewer_DocumentPath').val();
            var filename = $('#documentViewer_DocumentFileName').val();
            var pages = $('#documentViewer_NumberOfPages').val();
            RMSDocumentsGrid.SelectRows();

            var isIndexEditionAllowed = GetIndexModificationStatus();
            documentFileId = $('#DocumentFileID').val();
            if (CheckDocumentAccess("", documentFileId)) {
                DocumentIndexGrid.PerformCallback({ documentFileId: documentFileId, visibilityFlag: isIndexEditionAllowed });
                LoadDocument(true);
            }
        }

        function GoBackPreviousButton(s, e, Path) {
            window.location = $("#" + Path).val();
        }

    </script>
    <%}
      else
      { %>
    <script type="text/javascript">

        function DownloadedDocument() { }
        <% } %>
    </script>
</asp:Content>
