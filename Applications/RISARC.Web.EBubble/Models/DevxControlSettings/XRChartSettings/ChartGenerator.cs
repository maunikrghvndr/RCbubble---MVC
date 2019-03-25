using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DevExpress.XtraReports.UI;
using DevExpress.XtraCharts;
using System.Data;

namespace RISARC.Web.EBubble.Models.DevxControlSettings.XRChartSettings
{
    public class ChartGenerator
    {


        /// <summary>
        /// Chart Settings
        /// </summary>
        /// <param name="chart">object of Chart</param>
        /// <param name="chartHelper">chart helper withn parameters</param>
        /// <param name="dataSet">dataset or the chart</param>
        /// <returns>object of chart with data and settings</returns>
        public static XRChart ChartSettings(XRChart chart, ChartHelper chartHelper, DataTable dataTable)
        {

            DataTable DataTable = new DataTable();
            DataColumn ArgumentDataMember = new DataColumn("ArgumentDataMember");
            DataColumn SeriesDataMember = new DataColumn("SeriesDataMember");
            DataColumn ValueDataMembers = new DataColumn("ValueDataMembers", System.Type.GetType("System.Decimal"));

            DataTable.Columns.Add(ArgumentDataMember);
            DataTable.Columns.Add(SeriesDataMember);
            DataTable.Columns.Add(ValueDataMembers);

            foreach (DataRow item in dataTable.Rows)
            {
                foreach (KeyValuePair<string, string> kvpair in chartHelper.SeriesValueDictionary)
                {
                    DataRow DR = DataTable.NewRow();
                    DR["ArgumentDataMember"] = Convert.ToString(item[chartHelper.ArgumentDataMemeber]);
                    DR["SeriesDataMember"] = kvpair.Key;
                    DR["ValueDataMembers"] = Convert.ToDecimal(item[kvpair.Value]);
                    DataTable.Rows.Add(DR);
                }


            }

            chart.SeriesTemplate.ChangeView(ViewTypeValue(chartHelper.ViewType)); 
            chart.DataSource = DataTable;

            chart.SeriesTemplate.ArgumentDataMember = "ArgumentDataMember";
            chart.SeriesDataMember = "SeriesDataMember";
            chart.SeriesTemplate.ValueDataMembers[0] = "ValueDataMembers";

            return null;
        }

        private static ViewType ViewTypeValue(ViewType? ViewType)
        {
            return ViewType ?? DevExpress.XtraCharts.ViewType.Bar;
        }


    }
}