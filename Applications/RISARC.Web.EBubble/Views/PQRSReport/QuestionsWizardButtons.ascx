<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>


<div class="viewerActionBtnADetails">
    <div class="floatLeft">
        <%  Html.DevExpress().Button(
                   settings =>
                   {
                       settings.Name = "SubmitQuestion";
                       settings.ControlStyle.CssClass = "orangeBtn SubmitQuestion";
                       settings.Width = Unit.Pixel(80);
                       settings.Text = "Submit";
                       settings.UseSubmitBehavior = false;

                   }).GetHtml();  %>
    </div>
    <div class="floatRight">
        <%  Html.DevExpress().Button(
                   settings =>
                   {
                       settings.Name = "Cancel";
                       settings.ControlStyle.CssClass = "greyBtn ";
                       settings.Width = Unit.Pixel(80);
                       settings.Text = "Cancel";
                       if (Request["bk"] == "pending")
                       {
                           settings.RouteValues = new { Controller = "PQRSReport", Action = "PendingWorkBucket" };
                       }
                       else
                       {
                           settings.RouteValues = new { Controller = "PQRSReport", Action = "ClosedWorkBucket" };
                       }
                   }).GetHtml();  %>
    </div>
</div>


<%--<div class="BtnFinish" style="display: none">
    <% 
        Html.DevExpress().Button(
           settings =>
           {
               settings.Name = "FinishQuestion";
               settings.ControlStyle.CssClass = "orangeBtn";
               settings.Width = Unit.Pixel(80);
               settings.Text = "Back to bucket";
               settings.UseSubmitBehavior = true;

               if (Request["bk"] == "pending") {
                   settings.RouteValues = new { Controller = "PQRSReport", Action = "PendingWorkBucket" };
               } else {
                   settings.RouteValues = new { Controller = "PQRSReport", Action = "ClosedWorkBucket" };
               }
               
               

           }).GetHtml();  %>
</div>--%>


