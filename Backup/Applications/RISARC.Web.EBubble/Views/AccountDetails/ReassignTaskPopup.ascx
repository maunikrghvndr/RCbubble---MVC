<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>"  %>
<% Html.DevExpress().PopupControl(
        settings =>
        {
            settings.Name = "ReassignTaskPopup";
            settings.PopupElementID = "ReassignTask";
         
            settings.HeaderText = "Re-Assign Document For Review";
            settings.AllowDragging = true;
            settings.ShowCollapseButton = true;
            settings.CloseAction = CloseAction.CloseButton;
            settings.ShowCloseButton = true;
            settings.Modal = true;
            settings.PopupHorizontalAlign = PopupHorizontalAlign.WindowCenter;
            settings.PopupVerticalAlign = PopupVerticalAlign.WindowCenter;

            settings.Styles.Header.BackColor = System.Drawing.ColorTranslator.FromHtml("#595959");
            settings.Styles.Header.ForeColor = System.Drawing.ColorTranslator.FromHtml("#FFFFFF");
            settings.Styles.Header.Paddings.Padding = 5;
            
           
            settings.Height = Unit.Pixel(190);
            settings.Width = Unit.Pixel(300);
            settings.SetContent(() =>
             {
                 System.Web.Mvc.Html.ChildActionExtensions.RenderAction(Html, "ReAssignTaskContent",Model);
             }); 
             
        }).GetHtml();%>
