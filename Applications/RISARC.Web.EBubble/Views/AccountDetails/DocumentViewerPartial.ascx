<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<div class="topEditOptionOuter">
<div class="topDocEditOptions">
                <ul>
                    <li>
                        <div class="AccessOption1">
                            <%  Html.DevExpress().Image(
     PrintImg =>
     {
         PrintImg.Name = "PrintImg";
         PrintImg.ImageUrl = @Url.Content("~/Images/icons/printer.png");
         PrintImg.ControlStyle.CssClass = "PrintImg";
         PrintImg.ControlStyle.Cursor = "pointer";
     }
    ).GetHtml();
                            %>
  Print
                        </div>

                        <div class="FixiedHeight20px"></div>
                        <div class="AccessOption2">
                            <% Html.DevExpress().Image(
         PrintImg =>
         {
             PrintImg.Name = "PrintOptions";
             PrintImg.ImageUrl = @Url.Content("~/Images/icons/printerOption.png");
             PrintImg.ControlStyle.CssClass = "PrintImg";
             PrintImg.ControlStyle.Cursor = "pointer";
         }
    ).GetHtml();
                            %>
                            Print Options
                        </div>
                    </li>
                    <li>
                        <div class="AccessOption1">
                            <% Html.DevExpress().Image(
    PrintImg =>
    {
        PrintImg.Name = "rotate_left";
        PrintImg.ImageUrl = @Url.Content("~/Images/icons/rotate_left.png");
        PrintImg.ControlStyle.CssClass = "PrintImg";
        PrintImg.ControlStyle.Cursor = "pointer";
    }
    ).GetHtml();
                            %>
    Rotate Left
                        </div>
                        <div class="FixiedHeight20px"></div>
                        <div class="AccessOption2">
                            <% Html.DevExpress().Image(
        PrintImg =>
        {
            PrintImg.Name = "ArrowLeft";
            PrintImg.ImageUrl = @Url.Content("~/Images/icons/ArrowLeft.png");
            PrintImg.ControlStyle.CssClass = "PrintImg";
            PrintImg.ControlStyle.Cursor = "pointer";
        }
    ).GetHtml();
                            %>
   Prev Index
                        </div>
                    </li>
                    <li>
                        <div class="AccessOption1">
                            <%  Html.DevExpress().Image(
    PrintImg =>
    {
        PrintImg.Name = "rotate_right";
        PrintImg.ImageUrl = @Url.Content("~/Images/icons/rotate_right.png");
        PrintImg.ControlStyle.CssClass = "PrintImg";
        PrintImg.ControlStyle.Cursor = "pointer";
    }
    ).GetHtml();

                            %>
     Rotate Right
                        </div>
                        <div class="FixiedHeight20px"></div>
                        <div class="AccessOption2">
                            <% Html.DevExpress().Image(
        PrintImg =>
        {
            PrintImg.Name = "ArrowRight";
            PrintImg.ImageUrl = @Url.Content("~/Images/icons/ArrowRight.png");
            PrintImg.ControlStyle.CssClass = "PrintImg";
            PrintImg.ControlStyle.Cursor = "pointer";
        }
    ).GetHtml();
                            %>
    Next Index
                        </div>

                    </li>
                    <li>
                        <div class="AccessOption1">Go to Page #</div>
                        <div class="FixiedHeight20px"></div>
                        <div class="AccessOption2">
                            <% Html.DevExpress().Image(
        PrintImg =>
        {
            PrintImg.Name = "PrevPage";
            PrintImg.ImageUrl = @Url.Content("~/Images/icons/ArrowLeft.png");
            PrintImg.ControlStyle.CssClass = "PrintImg";
            PrintImg.ControlStyle.Cursor = "pointer";
        }
    ).GetHtml();
                            %>
   Prev Page
                        </div>
                    </li>
                    <li>
                        <div class="goTextbox">
                            <div class="AccessOption1">
                                <% Html.DevExpress().TextBox(
        GoToPage =>
        {
            GoToPage.Name = "GoToPage";
            GoToPage.ControlStyle.CssClass = "GoToPage";
            GoToPage.Width = 60;
            GoToPage.Height = 26;

        }
    ).GetHtml();

                                   Html.DevExpress().Button(
                                        GoButton =>
                                        {
                                            GoButton.Name = "GoButton";
                                            GoButton.ControlStyle.CssClass = "GoButton";
                                            GoButton.Height = 27;
                                            GoButton.Text = "Go";
                                        }).GetHtml();
                                %>
                            </div>
                        </div>

                        <div class="AccessOption2">
                            Next Page
        <%
            Html.DevExpress().Image(
                PrintImg =>
                {
                    PrintImg.Name = "NextPage";
                    PrintImg.ImageUrl = @Url.Content("~/Images/icons/ArrowRight.png");
                    PrintImg.ControlStyle.CssClass = "PrintImg";
                    PrintImg.ControlStyle.Cursor = "pointer";
                }
            ).GetHtml();
        %>
                        </div>
                    </li>
                </ul>
</div>
    </div>


<% 
    

    //Middle ShowDocumentContainer 
    ViewContext.Writer.Write("<div class=\"ShowDocumentContainer\">" +
     "Document would be displayed hereDocument would be displayed hereDocument would be displayed hereDocument would be displayed hereDocument would be displayed hereDocument would be displayed hereDocument would be displayed hereDocument would be displayed hereDocument would be displayed hereDocument would be displayed hereDocument would be displayed hereDocument would be displayed hereDocument would be displayed here</div>"
     );
    //Middle ShowDocumentContainer ends 

    //======================= DownDocEditOptions Starts  =============================

    ViewContext.Writer.Write("<div class=\"downDocEditOptions\"><table border=\"0\"><tr>");

    //First Td 
    ViewContext.Writer.Write("<td><div class=\"DownArrows\" >");
    @Html.DevExpress().Image(
               PrintImg =>
               {
                   PrintImg.Name = "DownArrowLeft";
                   PrintImg.ImageUrl = @Url.Content("~/Images/icons/ArrowLeft.png");
                   PrintImg.ControlStyle.CssClass = "PrintImg";
               }
           ).GetHtml();
    Html.DevExpress().Label(lbl =>
    {
        lbl.Name = "lbl1";
        lbl.Text = "Prev Index";
        lbl.ControlStyle.CssClass = "lableClass";
    }).Render();
    ViewContext.Writer.Write("</div></td>");
    //First TD Ends


    //2nd Td 
    ViewContext.Writer.Write("<td><div class=\"DownArrows\" >");
    @Html.DevExpress().Image(
           PrintImg =>
           {
               PrintImg.Name = "DownArrowRight";
               PrintImg.ImageUrl = @Url.Content("~/Images/icons/ArrowRight.png");
               PrintImg.ControlStyle.CssClass = "PrintImg";
           }
       ).GetHtml();
    Html.DevExpress().Label(lbl =>
    {
        lbl.Name = "lbl2";
        lbl.Text = "Next Index";
        lbl.ControlStyle.CssClass = "lableClass";
    }).Render();
    ViewContext.Writer.Write("</div></td>");
    //2nd TD Ends


    //3rd Td 
    ViewContext.Writer.Write("<td><div class=\"DownArrows\">01 of 15");
    ViewContext.Writer.Write("</div></td>");
    //3rd TD Ends

    //4th Td 
    ViewContext.Writer.Write("<td><div class=\"DownArrows\" >");
    @Html.DevExpress().Image(
               PrintImg =>
               {
                   PrintImg.Name = "DownPrevPage";
                   PrintImg.ImageUrl = @Url.Content("~/Images/icons/ArrowLeft.png");
                   PrintImg.ControlStyle.CssClass = "PrintImg";
               }
           ).GetHtml();
    Html.DevExpress().Label(lbl =>
    {
        lbl.Name = "lbl4";
        lbl.Text = "Prev Page";
        lbl.ControlStyle.CssClass = "lableClass";
    }).Render();
    ViewContext.Writer.Write("</div></td>");
    //4th TD Ends

    //5th Td 
    ViewContext.Writer.Write("<td><div class=\"DownArrows\" >");
    @Html.DevExpress().Image(
          PrintImg =>
          {
              PrintImg.Name = "DownNextPage";
              PrintImg.ImageUrl = @Url.Content("~/Images/icons/ArrowRight.png");
              PrintImg.ControlStyle.CssClass = "PrintImg";
          }
      ).GetHtml();

    Html.DevExpress().Label(lbl =>
    {
        lbl.Name = "lbl5";
        lbl.Text = "Next Index";
        lbl.ControlStyle.CssClass = "lableClass";
    }).Render();
    ViewContext.Writer.Write("</div></td>");
    //5th TD Ends

    ViewContext.Writer.Write("</tr></table></div>");
    //downDocEditOptions  ends 
    
%>

