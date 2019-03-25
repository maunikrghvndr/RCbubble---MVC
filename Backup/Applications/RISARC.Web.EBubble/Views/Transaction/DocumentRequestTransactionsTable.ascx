<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IEnumerable<RISARC.Documents.Model.DocumentRequest>>" %>

<% 
    var grid = Html.DevExpress().GridView(settings =>
    {
        settings.Name = "gvDocumentRequestTransactionsTable";
        settings.KeyFieldName = "DocumentTypeName";
        settings.CallbackRouteValues = new { Controller = "Transaction", Action = "_DocumentRequestTransactionLog" };
        
        settings.Width = System.Web.UI.WebControls.Unit.Percentage(100);

        settings.Settings.HorizontalScrollBarMode = ScrollBarMode.Auto;
        settings.Settings.VerticalScrollableHeight = 555;
        settings.Settings.VerticalScrollBarMode = ScrollBarMode.Visible;
       
        //resizing mode
        settings.SettingsBehavior.ColumnResizeMode = ColumnResizeMode.Control;
        //==================== Changing Grid Loading Icons ===================
        settings.Images.LoadingPanel.Url = Url.Content("~/Images/icons/LoadingLogo.gif");
        settings.SettingsLoadingPanel.Text = " ";
        settings.Images.LoadingPanel.Width = 76;
        settings.Images.LoadingPanel.Height = 100; 

        //Alterring color
        settings.Styles.AlternatingRow.BackColor = System.Drawing.ColorTranslator.FromHtml("#f7f7f7");
        settings.Styles.Header.BackColor = System.Drawing.ColorTranslator.FromHtml("#e3f3f4");
        settings.Styles.Header.CssClass = "gvworklistHeader";

        //Table backround color 
        //settings.Styles.Table.BackColor = System.Drawing.ColorTranslator.FromHtml("#ffffff");
        //settings.Styles.Table.ForeColor = System.Drawing.ColorTranslator.FromHtml("#707070");
        settings.Styles.Table.ForeColor = System.Drawing.ColorTranslator.FromHtml("#333333");
        
        //Account# column
        settings.Columns.Add(column =>
        {
            column.Caption = "Requested Document Type";
            column.FieldName = "DocumentTypeName";
            column.ReadOnly = true;
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.Width = 100;
        });
        
       
        settings.Columns.Add(column =>
        {
            column.Caption = "Requested Document Description";
            column.FieldName = "DocumentDescription";
            column.ReadOnly = true;
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.Width = 100;
        });

       
        settings.Columns.Add(column =>
        {
            column.Caption = "Status";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.Width = 100;
            column.SetDataItemTemplateContent(c =>
            {
                RISARC.Documents.Model.DocumentStatus DocumentStatus = (RISARC.Documents.Model.DocumentStatus)DataBinder.Eval(c.DataItem, "DocumentStatus");
                
                Html.RenderPartial("~/Views/ViewDocuments/RequestStatusDescription.ascx", new ViewDataDictionary {
                                        {"DocumentStatus",DocumentStatus }});
            });
            column.ReadOnly = true;
        });


        settings.Columns.Add(column =>
        {
            column.Caption = "Document Downloaded";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.FieldName = "ActionUTCTime";
            column.ReadOnly = true;
            column.Width = Unit.Pixel(250);
            column.SetDataItemTemplateContent(c =>
            {
                string uploadeDate = Convert.ToString(DataBinder.Eval(c.DataItem, "ActionUTCTime"));
                if (!string.IsNullOrEmpty(uploadeDate))
                {
                    Html.DevExpress().Label(lblSettings =>
                    {
                        lblSettings.Name = "ActionUTCTime" + c.VisibleIndex;
                        lblSettings.Text = string.Format("{0} {1}", uploadeDate, TimeZoneInfo.Utc.StandardName);
                        lblSettings.Properties.ClientSideEvents.Init = "function(s,e){SetLocalDate(s,e,'" + uploadeDate + "')}";
                        lblSettings.EncodeHtml = false;
                    }).GetHtml();
                }
            });

        });

        settings.Columns.Add(column =>
        {
            column.Caption = "Response Due By";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.FieldName = "RequestUTCDueBy";
            column.ReadOnly = true;
            column.Width = Unit.Pixel(250);
            column.SetDataItemTemplateContent(c =>
            {
                string uploadeDate = Convert.ToString(DataBinder.Eval(c.DataItem, "RequestUTCDueBy"));
                if (!string.IsNullOrEmpty(uploadeDate))
                {
                    Html.DevExpress().Label(lblSettings =>
                    {
                        lblSettings.Name = "RequestUTCDueBy" + c.VisibleIndex;
                        lblSettings.Text = string.Format("{0} {1}", uploadeDate, TimeZoneInfo.Utc.StandardName);
                        lblSettings.Properties.ClientSideEvents.Init = "function(s,e){SetLocalDate(s,e,'" + uploadeDate + "')}";
                        lblSettings.EncodeHtml = false;
                    }).GetHtml();
                }
            });

        });


        settings.Columns.Add(column =>
          {
              column.Caption = "Requested By";
              column.HeaderStyle.Wrap = DefaultBoolean.True;
              column.Width = 150;
              column.SetDataItemTemplateContent(c =>
              {
                  
                  string SentToProviderName = Convert.ToString(DataBinder.Eval(c.DataItem, "SentToProviderName"));
                  RISARC.Common.Model.UserDescription UserDescription = new RISARC.Common.Model.UserDescription();
                  UserDescription = (RISARC.Common.Model.UserDescription)DataBinder.Eval(c.DataItem, "CreatedByUserDescription");
                  Html.RenderPartial("UserDescription", UserDescription);
                  ViewContext.Writer.Write(Html.Encode(SentToProviderName)); 
                  
              });
          });


        settings.Columns.Add(column =>
        {
            column.Caption = "Responded To With Document";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.FieldName = "RespondedToByDocumentId";
            column.ReadOnly = true;
            column.Width = 235;

            column.CellStyle.HorizontalAlign = HorizontalAlign.Left;
            
            column.SetDataItemTemplateContent(c =>
            {
                
                string uploadeDate = Convert.ToString(DataBinder.Eval(c.DataItem, "RequestUTCDate"));
                int RespondedToByDocumentId = Convert.ToInt32(DataBinder.Eval(c.DataItem, "RespondedToByDocumentId"));
                
                if (RespondedToByDocumentId != 0)
                {
                    ViewContext.Writer.Write("Yes &nbsp;&nbsp;:&nbsp;&nbsp;");
                    ViewContext.Writer.Write(Html.ActionLink("Document details", "DocumentTransaction", new { documentId = Html.Encrypt(RespondedToByDocumentId) })+ "<br>" );
                    if (!string.IsNullOrEmpty(uploadeDate))
                    {
                        Html.DevExpress().Label(lblSettings =>
                        {
                            lblSettings.Name = "RespondedToByDocumentId" + c.VisibleIndex;
                            lblSettings.Text = string.Format("{0} {1}", uploadeDate, TimeZoneInfo.Utc.StandardName);
                            lblSettings.Properties.ClientSideEvents.Init = "function(s,e){SetLocalDate(s,e,'" + uploadeDate + "')}";
                            lblSettings.EncodeHtml = false;
                        }).GetHtml();
                    }
                
                }
                else {
                    ViewContext.Writer.Write("No");
                }
                
               
            });

        });

       
        settings.Columns.Add(column =>
        {
            column.Caption = "Details";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.Width = 70;
            column.SetDataItemTemplateContent(c =>
            {
                
                int documentId = Convert.ToInt32(DataBinder.Eval(c.DataItem, "Id"));
                string encryptedDocumentId = Html.Encrypt(documentId);
                ViewContext.Writer.Write(Html.ActionLink("Details", "DocumentRequestTransaction", new { requestId = encryptedDocumentId }));

            });
        });


    }); //grid ends 


    grid.Bind(Model).GetHtml();
%>


<%--        <br />
    <div align="right">  <span id="undo" class="t-button">Data Grid Member Guide</span></div>
     <% Html.Telerik().Window()           
        .Name("Window")
        .Title("Data Grid Guide")          
        .Draggable(true)           
        .Resizable(resizing => resizing              
            .Enabled(true)               
            .MinHeight(250)               .MinWidth(250)              
            .MaxHeight(500)               .MaxWidth(500)            )      
            .Scrollable(true)
            .Visible(false)           
            .Modal(false)        
            .Buttons(b => b.Maximize().Close())       
            .Content(() =>  
            {%>              
                 
                <p>
                 <ul><font color="#004080"> 
   	            <li>&#8226; <b>Sort column:</b>      Click on column name to sort</li>
                     <br />
	            <li>&#8226; <b>Search filter:</b> Click on filter <img src="<%= Url.Content("~/Images/untitled1.png")%>" width="15" height="18" alt="" title="" border="0" /> icon in column field to search for a specific record </li> 
                     <br />
	            <li>&#8226; <b>Group by:</b>&nbsp&nbsp&nbsp&nbsp&nbsp      Drag and drop column header and drop in space above column name(Note: when placing column name, make sure the <img src="<%= Url.Content("~/Images/2.png")%>" width="13" height="13" alt="" title="" border="0" />  icon 
                                   is displayed)example &rarr; <img src="<%= Url.Content("~/Images/1.png")%>"  width="100" height="17" alt="" title="" border="0" />

	            </li></font></p>
                </ul>
 
         
                        <%})
                  .Width(500)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
                    .Render();  
                    %>       
                <% Html.Telerik().ScriptRegistrar()           
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
                .OnDocumentReady(() => {%>                
                var windowElement = $('#Window');                
                var undoButton = $('#undo');                
                undoButton                  
                  .bind('click', function(e) {           
                               windowElement.data('tWindow').open();         
                                              undoButton.hide();                    })       
                                                           .toggle(!windowElement.is(':visible'));    
                                                                       windowElement.bind('close', function() {                   
                                                                        undoButton.show();                });           <%}); %>    
<div class="DataGridXScroll">
      <% Html.Telerik().Grid(Model)
      .Filterable()
       .BindTo(Model)
       .Name("Documents")
        .Footer(true)
        .Groupable()
       .Sortable()
       .Pageable()
       .HtmlAttributes(new { style = "font-weight: bolder" })
       .Columns(columns =>
           
      {
          //Column which will display the OrderID property of the Order
        columns.Bound(o => o.DocumentTypeName).Width(150).Title("Requested Document Type");

        columns.Bound(o => o.DocumentDescription).Title("Requested Document Description");
          
        columns.Template(o =>
        {   %>
                 
        <% Html.RenderPartial("~/Views/ViewDocuments/RequestStatusDescription.ascx", null, new ViewDataDictionary {
                                        {"DocumentStatus", o.DocumentStatus}}); %> <%}).Title("Status");
          columns.Template(o =>
          {
              if (o.ActionUTCTime.HasValue)
              {%>
                <span class="clientFormattedDate"><%= o.ActionUTCTime.Value.ToString("MM/dd/yyyy hh':'mm tt")%><br /><%= TimeZoneInfo.Utc.StandardName%></span>  
                <div style="border-style: solid; border-width: 1px; border-color: inherit; background-color:#FFFFDD; white-space: nowrap; width: 140px;" 
                 id="ClientActionTimeA_C<%= o.Id%>"></div> 

                <script type="text/javascript">
                    //Michael Bert time calculations and ASHX/AJAX based on browser timezone on Jan 21, 2012
                    //Changes done to show UTC date and current browser time based on the client timezone - Guru
                    var myDate = new Date();
                    var timezone = jstz.determine();
                    $.ajax({ url: "../TimeZoneCalculator.ashx?Date=<%=  o.ActionUTCTime%>&ClientTimeZone=" + (myDate.getTimezoneOffset() / 60), cache: false }).done(function (html) { $("#ClientActionTimeA_C<%= o.Id%>").append("<b>Local Time Zone:</b><br />" + html + "<br />(" + timezone.name() + ")"); });
                </script>
                <% }
          }).Title("Document Downloaded");
        // columns.Bound(o => o.RequestDueBy).Title("Response Due By");

        columns.Bound(o => o.RequestUTCDueBy).Template(o =>
        {%>
            <%     
            if (o.RequestUTCDueBy.HasValue)
            {%>   
                <span class="clientFormattedDate"><%= o.RequestUTCDueBy.Value.ToString("MM/dd/yyyy hh':'mm tt")%><br /><%= TimeZoneInfo.Utc.StandardName%></span>  
                <div style="border-style: solid; border-width: 1px; border-color: inherit; background-color:#FFFFDD; white-space: nowrap; width: 140px;" 
                id="ClientTimeA_C<%= o.Id%>"></div> 

                <script type="text/javascript">
                //Michael Bert time calculations and ASHX/AJAX based on browser timezone on Jan 21, 2012
                //Changes done to show UTC date and current browser time based on the client timezone - Guru
                var myDate = new Date();
                var timezone = jstz.determine();
                $.ajax({ url: "../TimeZoneCalculator.ashx?Date=<%=  o.RequestUTCDueBy%>&ClientTimeZone=" + (myDate.getTimezoneOffset() / 60), cache: false }).done(function (html) { $("#ClientTimeA_C<%= o.Id%>").append("<b>Local Time Zone:</b><br />" + html + "<br />(" + timezone.name() + ")"); });
                </script>
                <% }
        }).Title("Response Due By");
          
        columns.Template(o =>
        {   %> <b><%= o.SentToProviderName %></b><br />
                <% Html.RenderPartial("UserDescription", o.CreatedByUserDescription); %>
            <%
        }).Title("Requested by");

        columns.Template(o =>
        {   %>
                <% if (o.RespondedToByDocumentId.HasValue)
                { %>
                    Yes : 
                    <%= Html.ActionLink("Document details", "DocumentTransaction", new { documentId = Html.Encrypt(o.RespondedToByDocumentId) })%>
                    <br />
                    <%     
                    if (o.CreateUTCDate.HasValue)
                    {%>   
                        <span class="clientFormattedDate"><%= o.CreateUTCDate.Value.ToString("MM/dd/yyyy hh':'mm tt")%><br /><%= TimeZoneInfo.Utc.StandardName%></span>  
                        <div style="border-style: solid; border-width: 1px; border-color: inherit; background-color:#FFFFDD; white-space: nowrap; width: 140px;" 
                         id="ClientTimeB_ccR<%= o.Id%>"></div> 

                       <script type="text/javascript">
                           //Michael Bert time calculations and ASHX/AJAX based on browser timezone on Jan 21, 2012
                           //Changes done to show UTC date and current browser time based on the client timezone - Guru
                           var myDate = new Date();
                           var timezone = jstz.determine();
                           $.ajax({ url: "../TimeZoneCalculator.ashx?Date=<%=  o.CreateUTCDate%>&ClientTimeZone=" + (myDate.getTimezoneOffset() / 60), cache: false }).done(function (html) { $("#ClientTimeB_ccR<%= o.Id%>").append("<b>Local Time Zone:</b><br />" + html + "<br />(" + timezone.name() + ")"); });
                        </script>
                    <%}
                }
                else
                {%>
                    <div class="FieldInstructions">No</div>
                <%}
        }).Title("Responded To With Document");
                        
        columns.Template(o =>
        {   %>
            <%= Html.ActionLink("Details",
                    "DocumentRequestTransaction", new { requestId = Html.Encrypt(o.Id) })%>
            <%
        }).Title("Details");
    }).HtmlAttributes(new { style = "font-weight: bolder" }).Render();     
%>
    </div>

     <%= Html.ActionLink("Export to Excel", "ExportExcelSentRequests2", new { page = 1, orderBy = "~", filter = "~"}, new { id = "exportLink" }) %>
   <script type ="text/javascript">
       //function onLoad(e) {
       //    if ($(this).find(".clientFormattedDate").length > 0) {
       //        $(this).find(".clientFormattedDate").each(function () {
       //            var $cell = $(this);
       //            var formattedDate = new Date($cell.text() + ' MST').toLocaleString();
       //            $cell.text(formattedDate);

       //            $(this).find(".clientFormattedDate1").each(function () {
       //                var $cell = $(this);
       //                var formattedDate = new Date($cell.text() + ' MST').toLocaleString();
       //                $cell.text(formattedDate);
       //            });
       //        });
       //    }
       //}
          </script>--%>