<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<%--Inherits="System.Web.Mvc.ViewPage<IEnumerable<RISARC.Files.Model.DocumentFormatType>>"--%>

<%= Html.DevExpress().CheckBoxList(
            settings =>
            {
                settings.Name = "OrgDocumentFormatList";
                settings.Properties.ValueField = "Id";
                settings.Properties.TextField = "DocumentFormat";
                settings.Properties.ValueType = typeof(int);
                settings.Properties.RepeatLayout = RepeatLayout.Table;
                settings.Properties.RepeatDirection = RepeatDirection.Horizontal;
                settings.Properties.RepeatColumns = 2;
                settings.Width = Unit.Percentage(80);

               
                settings.PreRender = (sender, e) =>
                {
                    ASPxCheckBoxList cbl = (ASPxCheckBoxList)sender;
                    foreach (ListEditItem item in cbl.Items)
                    {

                        if (Model[item.Index].IsAssigned == true)
                            item.Selected = true;
                    }
                    //To Disable the Checkbox for Provider admin to display the Document Format type.
                    if (ViewData["ProviderAdmin"] != null)
                    {
                        if (Convert.ToString(ViewData["ProviderAdmin"]) == "1")
                        {
                            cbl.Enabled = false;
                        }
                    }
                    else
                    {
                        cbl.Enabled = true;
                    }       
                };
                
 }).BindList(Model).GetHtml()
%>

