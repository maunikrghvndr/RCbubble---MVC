using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace RISARC.Web.EBubble.Models.DevxControlSettings.XRChartSettings
{
    public class ChartHelper
    {
        public DevExpress.XtraCharts.ViewType? ViewType { get; set; }

        
        public string ArgumentDataMemeber { get; set; }
      
       

        public IDictionary<string, string> SeriesValueDictionary { get; set; }

       
        public ChartHelper()
        {
            SeriesValueDictionary = new Dictionary<string, string>();
        }

        /// <summary>
        /// Set the no. of series for each bar report
        /// </summary>
        /// <param name="seriesDataMember">Text for the Series</param>
        /// <param name="value">Actual column name for the series</param>
        public void SetSeriesDictionary(string seriesDataMember, string value)
        {
            SeriesValueDictionary.Add(seriesDataMember, value);
        }

    }
}