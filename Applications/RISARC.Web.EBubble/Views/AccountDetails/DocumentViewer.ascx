<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.eTAR.Model.AccountDetailsMain>" %>


<div class="setToolBorder setHeight">

<div class="topEditOptionOuter">
    <%= System.Web.Mvc.Html.InputExtensions.HiddenFor(Html, model=> model.documentViewer.DocumentPath) %>
    <%= System.Web.Mvc.Html.InputExtensions.HiddenFor(Html, model=> model.documentViewer.DocumentFileName) %>
    <%= System.Web.Mvc.Html.InputExtensions.HiddenFor(Html, model=> model.documentViewer.NumberOfPages) %>
    <%= System.Web.Mvc.Html.InputExtensions.HiddenFor(Html, model=> model.documentViewer.ContentType) %>
    <div class="topDocEditOptions">
        <ul>
            <li>
                  <div class="btnExpandLeft">
                    <% 
                        Html.DevExpress().Image(collapseSettings =>
                        {
                            collapseSettings.ImageUrl = @Url.Content("~/Images/icons/panel_arrow_right.png");
                            collapseSettings.Name = "btnExpandLeft";
                            collapseSettings.ControlStyle.Cursor = "pointer";
                            collapseSettings.ToolTip = "Click to expand";

                        }).GetHtml();
                    %>
                </div>
            </li>
            <li>
              

                <div id="optionPrint" class="AccessOption1 optionPrint" onclick="printCurrentPage_onclick('optionPrint')" title="click to print">
                   
                </div>

            </li>

            <li>
                <div id="PrevIndex" class="AccessOption1 PrevIndex" onclick="GoToDocumentIndexPrevious('PrevIndex')" title="Prev Index">
                 
                </div>
            </li>
            <li>
                <div id="NextIndex" class="AccessOption1 NextIndex" onclick="GoToDocumentIndexNext('NextIndex')" title="Next Index">
                 

                </div>
            </li>

            <li>
                <div id="RotateLeft" class="AccessOption1 RotateLeft" onclick="rotateLeftToolButton_onclick('RotateLeft')" title="Rotate Left">
               

                </div>
            </li>


            <li>
                <div id="RotateRight" class="AccessOption1 RotateRight" onclick="rotateRightToolButton_onclick('RotateRight')" title="Rotate Right">
                
                </div>
            </li>


            <li>
                <div id="PrevPage" class="AccessOption1 PrevPage" onclick="previousToolButton_onclick('PrevPage')" title="Prev Page">
                  
                </div>
            </li>

            <li>
                <div id="NextPage" class="AccessOption1 NextPage" onclick="nextToolButton_onclick('NextPage')" title="Next Page" >
                    
                </div>
            </li>
            <li>
                
                 <div class="gobtnText">
                   <div class="lineHeight floatLeft">
                     <div class="floatLeft spaceRight">Page </div>
                     <div class="floatLeft setBorder">
                        <input  class="floatLeft" type="text" name="txtGoToPage" id="txtGoToPage" maxlength="7"  placeholder="" onkeypress="gotoKeyPress(event)" />
                         <input  class="floatLeft" type="text" name="totalPageCount" id="totalPageCount"  value=""  disabled />
                    </div>
                       
                   </div>
                    <div class="floatRight">
                        <button class="goButton" type="button" onclick="goToPageToolButton_onClick()" value=" Go">Go</button></div>
                  </div>
            </li>

          
               
           
        </ul>
       
    </div>

</div>
  <div class="btnExpandRight">
                                    <%
                                        Html.DevExpress().Image(collapseSettings =>
                                        {
                                            collapseSettings.ImageUrl = @Url.Content("~/Images/icons/panel_arrow_left.png");
                                            collapseSettings.Name = "btnExpandRight";
                                            collapseSettings.ControlStyle.Cursor = "pointer";
                                            collapseSettings.ToolTip = "Click to expand";
                                        }).GetHtml();
                                    %>
                                </div>
<!-- .topEditOptionOuter -->
</div>


<div class="documentHolder" style="overflow: auto; width: 100%; height: 100%;">
    <div id="MainImageWindow">
        <div id="pluginPageView" style="height: 100%; width: 100%">
        </div>
    </div>
</div>

