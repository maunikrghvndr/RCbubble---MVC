<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<% {
    RISARC.Web.EBubble.Controllers.ChartBarViewsDemoOptions options = (RISARC.Web.EBubble.Controllers.ChartBarViewsDemoOptions)ViewData["Options"];
    ChartControlSettings settings = new ChartControlSettings();
    settings.Name = "chart";
    settings.Width = 800;
    settings.Height = 400;
    settings.BorderOptions.Visibility = DefaultBoolean.False;
    settings.CrosshairEnabled = options.ShowLabels ? DefaultBoolean.False : DefaultBoolean.True;

    settings.Titles.Add(new DevExpress.XtraCharts.ChartTitle() {
        Font = new System.Drawing.Font("Tahoma", 18),
        Text = "ACO GPRO Performance Report"
    });
    settings.Titles.Add(new DevExpress.XtraCharts.ChartTitle() {
        Alignment = System.Drawing.StringAlignment.Far,
        Dock = ChartTitleDockStyle.Bottom,
        Font = new System.Drawing.Font("Tahoma", 8),
        TextColor = System.Drawing.Color.Gray,
        Text = "From www.risarc.com"
    });

    settings.SeriesTemplate.ChangeView(options.View);
    settings.SeriesDataMember = "parameter";
    settings.SeriesTemplate.ArgumentDataMember = "measure";
    settings.SeriesTemplate.ValueDataMembers[0] = "value";
  
       
    settings.SeriesTemplate.LabelsVisibility = options.ShowLabels ? DefaultBoolean.True : DefaultBoolean.False;
    settings.SeriesTemplate.Label.ResolveOverlappingMode = ResolveOverlappingMode.Default;

    if (options.View != DevExpress.XtraCharts.ViewType.FullStackedBar){
        settings.Legend.AlignmentHorizontal = LegendAlignmentHorizontal.Right;
    }

    if (settings.Diagram is XYDiagram) {
        ((XYDiagram)settings.Diagram).Rotated = options.Rotated;
        Axis2D axisY = ((XYDiagram)settings.Diagram).AxisY;
        axisY.Interlaced = true;
        axisY.Title.Text = "Millions of Dollars";
       
    }
    else {
        XYDiagram3D diagram = (XYDiagram3D)settings.Diagram;
        diagram.AxisY.Interlaced = true;
        diagram.RotationType = RotationType.UseAngles;
        diagram.RotationOrder = RotationOrder.XYZ;
        diagram.ZoomPercent = 140;
        diagram.VerticalScrollPercent = 4;
    }
    Html.DevExpress().Chart(settings).Bind(Model).GetHtml();
}


%>