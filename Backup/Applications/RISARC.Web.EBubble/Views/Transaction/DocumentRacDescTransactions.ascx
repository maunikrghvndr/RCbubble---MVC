<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IEnumerable<RISARC.Documents.Model.Document>>" %>

<% 
   
    var grid = Html.DevExpress().GridView(settings =>
    {
        settings.Name = "gvRacDecisionReport";


        settings.KeyFieldName = "AccountNumber";
        settings.CallbackRouteValues = new { Controller = "Transaction", Action = "_DocumentRACDecision" };
        
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

        settings.SettingsPager.PageSize = 20;
        //Account# column
        settings.Columns.Add(column =>
        {
            column.Caption = "Account No";
            column.FieldName = "AccountNoRac";
            column.ReadOnly = true;
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.Width = 100;
        });
        
       
        settings.Columns.Add(column =>
        {
            column.Caption = "First Name";
            column.FieldName = "PatientFirstname";
          //  column.Width = Unit.Percentage(7);
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.ReadOnly = true;
            column.Width = 110;
        });

       
        settings.Columns.Add(column =>
        {
            column.Caption = "Last Name";
            column.FieldName = "PatientLastname";
           // column.Width = Unit.Percentage(16);
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.ReadOnly = true;
            column.Width = 110;
        });


		settings.Columns.Add(column =>
        {
            column.Caption = "Request Date";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.FieldName = "RequestUTCDate";
            column.ReadOnly = true;
            column.Width = Unit.Pixel(250);
            column.SetDataItemTemplateContent(c =>
            {
                string uploadeDate = Convert.ToString(DataBinder.Eval(c.DataItem, "RequestUTCDate"));
                if (!string.IsNullOrEmpty(uploadeDate))
                {
                    Html.DevExpress().Label(lblSettings =>
                    {
                        lblSettings.Name = "RequestUTCDate" + c.VisibleIndex;
                        lblSettings.Text = string.Format("{0} {1}", uploadeDate, TimeZoneInfo.Utc.StandardName);
                        lblSettings.Properties.ClientSideEvents.Init = "function(s,e){SetLocalDate(s,e,'" + uploadeDate + "')}";
                        lblSettings.EncodeHtml = false;
                    }).GetHtml();
                }
            });
            
        });

        settings.Columns.Add(column =>
        {
            column.Caption = "Denial Date";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.FieldName = "DenialUTCDate";
            column.ReadOnly = true;
            column.Width = Unit.Pixel(250);
            column.SetDataItemTemplateContent(c =>
            {
                string uploadeDate = Convert.ToString(DataBinder.Eval(c.DataItem, "RequestUTCDate"));
                if (!string.IsNullOrEmpty(uploadeDate))
                {
                    Html.DevExpress().Label(lblSettings =>
                    {
                        lblSettings.Name = "DenialUTCDate" + c.VisibleIndex;
                        lblSettings.Text = string.Format("{0} {1}", uploadeDate, TimeZoneInfo.Utc.StandardName);
                        lblSettings.Properties.ClientSideEvents.Init = "function(s,e){SetLocalDate(s,e,'" + uploadeDate + "')}";
                        lblSettings.EncodeHtml = false;
                    }).GetHtml();
                }
            });

        });


        settings.Columns.Add(column =>
        {
            column.Caption = "Appeal Level";
            column.FieldName = "AppealLevel";
        
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.ReadOnly = true;
        });


      
        settings.Columns.Add(column =>
        {
            column.Caption = "Denial Reason";
            column.FieldName = "DenialReason";
           //column.Width = Unit.Percentage(8);
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.ReadOnly = true;
        });


        settings.Columns.Add(column =>
        {
            column.Caption = "Response Due Date";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.FieldName = "ResponseUTCDueDate";
            column.ReadOnly = true;
            column.Width = Unit.Pixel(250);
            column.SetDataItemTemplateContent(c =>
            {
                string uploadeDate = Convert.ToString(DataBinder.Eval(c.DataItem, "RequestUTCDate"));
                if (!string.IsNullOrEmpty(uploadeDate))
                {
                    Html.DevExpress().Label(lblSettings =>
                    {
                        lblSettings.Name = "ResponseUTCDueDate" + c.VisibleIndex;
                        lblSettings.Text = string.Format("{0} {1}", uploadeDate, TimeZoneInfo.Utc.StandardName);
                        lblSettings.Properties.ClientSideEvents.Init = "function(s,e){SetLocalDate(s,e,'" + uploadeDate + "')}";
                        lblSettings.EncodeHtml = false;
                    }).GetHtml();
                }
            });

        });
  

     
        settings.Columns.Add(column =>
        {
            column.Caption = "Appeal Status";
            column.FieldName = "AppealStatus";
           // column.Width = Unit.Percentage(8);
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.ReadOnly = true;
        });

       
        settings.Columns.Add(column =>
        {
            column.Caption = "Recoup Deadline";
            column.FieldName = "RecoupedDeadline";
          //  column.Width = Unit.Percentage(8);
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.ReadOnly = true;
        });


        settings.Columns.Add(column =>
        {
            column.Caption = "Date Denial Letter Received";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.FieldName = "UTCDateDenialLetterRecieved";
            column.ReadOnly = true;
            column.Width = Unit.Pixel(250);
            column.SetDataItemTemplateContent(c =>
            {
                string uploadeDate = Convert.ToString(DataBinder.Eval(c.DataItem, "RequestUTCDate"));
                if (!string.IsNullOrEmpty(uploadeDate))
                {
                    Html.DevExpress().Label(lblSettings =>
                    {
                        lblSettings.Name = "UTCDateDenialLetterRecieved" + c.VisibleIndex;
                        lblSettings.Text = string.Format("{0} {1}", uploadeDate, TimeZoneInfo.Utc.StandardName);
                        lblSettings.Properties.ClientSideEvents.Init = "function(s,e){SetLocalDate(s,e,'" + uploadeDate + "')}";
                        lblSettings.EncodeHtml = false;
                    }).GetHtml();
                }
            });

        });
      
        settings.Columns.Add(column =>
        {
            column.Caption = "Notes";
           // column.Width = Unit.Pixel(250);
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.FieldName = "Notes";
        });


        settings.Columns.Add(column =>
        {
            column.Caption = "Sent By (Provider)";
            column.FieldName = "SentFromProviderName";
            column.Width = 150;
            column.ReadOnly = true;
			column.HeaderStyle.Wrap = DefaultBoolean.True;
			column.SetDataItemTemplateContent(c =>
            {
               string  SentFromProviderName = Convert.ToString(DataBinder.Eval(c.DataItem, "SentFromProviderName"));
               RISARC.Common.Model.UserDescription   UserDescription =  new RISARC.Common.Model.UserDescription();
               UserDescription = (RISARC.Common.Model.UserDescription)DataBinder.Eval(c.DataItem, "CreatedByUserDescription");
               Html.RenderPartial("UserDescription",UserDescription); 
               ViewContext.Writer.Write(Html.Encode(SentFromProviderName)); 
            });
        });

		 settings.Columns.Add(column =>
           {
            column.Caption = "Sent to";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.Width = 110;
			column.SetDataItemTemplateContent(c =>
            {
               object DocumentRecipient = DataBinder.Eval(c.DataItem, "DocumentRecipient");
               Html.RenderPartial("~/Views/ViewDocuments/DocumentRecipient.ascx", DocumentRecipient);
                  
            });
        });


		 settings.Columns.Add(column =>
           {
             column.Caption = "# of Pages";
             column.HeaderStyle.Wrap = DefaultBoolean.True;
			 column.FieldName = "NumberOfPages";
             column.Width = 50;
			
        });

        
		 settings.Columns.Add(column =>
           {
            column.Caption = "Details";
            column.HeaderStyle.Wrap = DefaultBoolean.True;
            column.Width = 50;
			column.SetDataItemTemplateContent(c =>
            {
			 // int documentId = Model
                int documentId = Convert.ToInt32(DataBinder.Eval(c.DataItem, "Id"));
                string encryptedDocumentId = Html.Encrypt(documentId);
                 ViewContext.Writer.Write( Html.ActionLink("Details", "DocumentTransaction", "ViewDocuments", new { documentId = encryptedDocumentId }, null));

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
                <font color="#004080"> 
                 <ul>
   	            <li>&#8226; <b>Sort column:</b>      Click on column name to sort</li><br />
	            <li>&#8226; <b>Search filter:</b> Click on filter <img src="<%= Url.Content("~/Images/untitled1.png")%>" width="15" height="18" alt="" title="" border="0" /> icon in column field to search for a specific record </li> <br />
	            <li>&#8226; <b>Group by:</b>&nbsp&nbsp&nbsp&nbsp&nbsp      Drag and drop column header and drop in space above column name(Note: when placing column name, make sure the <img src="<%= Url.Content("~/Images/2.png")%>" width="13" height="13" alt="" title="" border="0" />  icon 
                                   is displayed)example &rarr; <img src="<%= Url.Content("~/Images/1.png")%>"  width="100" height="17" alt="" title="" border="0" /></li></p>
                </ul>
 
                </font>
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
        columns.Bound(o => o.AccountNoRac).Title("Account No");
        columns.Bound(o => o.PatientFirstname).Title("First name");
        columns.Bound(o => o.PatientLastname).Title("Last name");
        ////UTC dates added by Guru
        columns.Bound(o => o.RequestUTCDate).Template(o =>
        {%>
        <%     
            if (o.RequestUTCDate.HasValue)
            {%>   
            <span class="clientFormattedDate"><%= o.RequestUTCDate.Value.ToString("MM/dd/yyyy hh':'mm tt")%><br /><%= TimeZoneInfo.Utc.StandardName%></span>  
            <div style="border-style: solid; border-width: 1px; border-color: inherit; background-color:#FFFFDD; white-space: nowrap; width: 140px;" 
            id="ClientTimeA_C<%= o.Id%>"></div> 

            <script type="text/javascript">
                //Michael Bert time calculations and ASHX/AJAX based on browser timezone on Jan 21, 2012
                //Changes done to show UTC date and current browser time based on the client timezone - Guru
                var myDate = new Date();
                var timezone = jstz.determine();
                $.ajax({ url: "../TimeZoneCalculator.ashx?Date=<%=  o.RequestUTCDate%>&ClientTimeZone=" + (myDate.getTimezoneOffset() / 60), cache: false }).done(function (html) { $("#ClientTimeA_C<%= o.Id%>").append("<b>Local Time Zone:</b><br />" + html + "<br />(" + timezone.name() + ")"); });
            </script>
            <% }
        }).Width(150).Title("Request Date");
        
        columns.Bound(o => o.DenialUTCDate).Template(o =>
        {%>
            <%     
            if (o.DenialUTCDate.HasValue)
            {%>   
                <span class="clientFormattedDate"><%= o.DenialUTCDate.Value.ToString("MM/dd/yyyy hh':'mm tt")%><br /><%= TimeZoneInfo.Utc.StandardName%></span>  
                <div style="border-style: solid; border-width: 1px; border-color: inherit; background-color:#FFFFDD; white-space: nowrap; width: 140px;" 
                id="Div1"></div> 

                <script type="text/javascript">
                    //Michael Bert time calculations and ASHX/AJAX based on browser timezone on Jan 21, 2012
                    //Changes done to show UTC date and current browser time based on the client timezone - Guru
                    var myDate = new Date();
                    var timezone = jstz.determine();
                    $.ajax({ url: "../TimeZoneCalculator.ashx?Date=<%=  o.DenialUTCDate%>&ClientTimeZone=" + (myDate.getTimezoneOffset() / 60), cache: false }).done(function (html) { $("#ClientTimeA_C<%= o.Id%>").append("<b>Local Time Zone:</b><br />" + html + "<br />(" + timezone.name() + ")"); });
                </script>
                <% }
        }).Title("Denial Date");
          
            columns.Bound(o => o.AppealLevel).Title("Appeal Level");
            columns.Bound(o => o.DenialReason).Title("Denial Reason");
            
            columns.Bound(o => o.ResponseUTCDueDate).Template(o =>
            {%>
                <%     
                if (o.ResponseUTCDueDate.HasValue)
                {%>   
                    <span class="clientFormattedDate"><%= o.ResponseUTCDueDate.Value.ToString("MM/dd/yyyy hh':'mm tt")%><br /><%= TimeZoneInfo.Utc.StandardName%></span>  
                    <div style="border-style: solid; border-width: 1px; border-color: inherit; background-color:#FFFFDD; white-space: nowrap; width: 140px;" 
                    id="Div2"></div> 

                    <script type="text/javascript">
                        //Michael Bert time calculations and ASHX/AJAX based on browser timezone on Jan 21, 2012
                        //Changes done to show UTC date and current browser time based on the client timezone - Guru
                        var myDate = new Date();
                        var timezone = jstz.determine();
                        $.ajax({ url: "../TimeZoneCalculator.ashx?Date=<%=  o.ResponseUTCDueDate%>&ClientTimeZone=" + (myDate.getTimezoneOffset() / 60), cache: false }).done(function (html) { $("#ClientTimeA_C<%= o.Id%>").append("<b>Local Time Zone:</b><br />" + html + "<br />(" + timezone.name() + ")"); });
                    </script>
                <% }
            }).Title("Response Due Date").Format("{0:dd/MM/yyyy}");
            
          columns.Bound(o => o.AppealStatus).Title("Appeal Status");
          columns.Bound(o => o.RecoupedDeadline).Title("Recoup Deadline");
          
          columns.Bound(o => o.UTCDateDenialLetterRecieved).Template(o =>
          {%>
                <%     
              if (o.UTCDateDenialLetterRecieved.HasValue)
              {%>   
                    <span class="clientFormattedDate"><%= o.UTCDateDenialLetterRecieved.Value.ToString("MM/dd/yyyy hh':'mm tt")%><br /><%= TimeZoneInfo.Utc.StandardName%></span>  
                    <div style="border-style: solid; border-width: 1px; border-color: inherit; background-color:#FFFFDD; white-space: nowrap; width: 140px;" 
                    id="Div3"></div> 

                    <script type="text/javascript">
                        //Michael Bert time calculations and ASHX/AJAX based on browser timezone on Jan 21, 2012
                        //Changes done to show UTC date and current browser time based on the client timezone - Guru
                        var myDate = new Date();
                        var timezone = jstz.determine();
                        $.ajax({ url: "../TimeZoneCalculator.ashx?Date=<%=  o.UTCDateDenialLetterRecieved%>&ClientTimeZone=" + (myDate.getTimezoneOffset() / 60), cache: false }).done(function (html) { $("#ClientTimeA_C<%= o.Id%>").append("<b>Local Time Zone:</b><br />" + html + "<br />(" + timezone.name() + ")"); });
                    </script>
                <% }
          }).Title("Date Denial Letter Received");
          
          columns.Bound(o => o.Notes).Title("Notes");
          columns.Template(o =>
          {   %>
         
            <% Html.RenderPartial("UserDescription", o.CreatedByUserDescription); %>
            <br />
            <%= Html.Encode(o.SentFromProviderName)%>
              <%
        }).Title("Sent by (provider)");


 
                       
                columns.Template(o =>
              {
                  %>
             <% Html.RenderPartial("~/Views/ViewDocuments/DocumentRecipient.ascx", o.DocumentRecipient); %>
                  <%
                }).Title("Sent to");
                   
          //colums.Bound(o => o.Date).Width(200);
          //Column which will display the OrderDate property. The header will display "Order"
    
           

          columns.Bound(o => o.NumberOfPages).Title("# of Pages");
          columns.Template(o =>
                {
                    %>
           
         
    <%       int documentId = o.Id;
      string encryptedDocumentId = Html.Encrypt(documentId); %>  
       <%= Html.ActionLink("Details", "DocumentTransaction", "ViewDocuments", new { documentId = encryptedDocumentId }, null)%>
                  <%
                }).Title("Details");
 
                			
      })
            .HtmlAttributes(new { style = "font-weight: bolder" })
       .Render();
%></div>
     <%= Html.ActionLink("Export to Excel", "ExportExcelSentRequests", new { page = 1, orderBy = "~", filter = "~" }, new { id = "exportLink" })%>
  --%>
   
