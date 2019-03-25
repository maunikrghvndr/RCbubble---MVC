<%@ WebHandler Language="C#" Class="TimeZoneCalculator" %>
using System;
using System.Web;
using System.Globalization;
using System.Text;


    /// <summary>
    /// Summary description for TimeZoneCalculator
    /// </summary>
    public class TimeZoneCalculator : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            /*
            TimeSpan refresh = new TimeSpan(0, 0, 0, 0, 0);
            HttpContext.Current.Response.Cache.SetExpires(DateTime.Now.Add(refresh));
            HttpContext.Current.Response.Cache.SetMaxAge(refresh);
            HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.Server);
            HttpContext.Current.Response.Cache.SetValidUntilExpires(true);
            */
            
            try
            {


                //int ServerTimeZone = 8;
                // TimeZone.CurrentTimeZone;
                //int ClientBrowserTimeZoneOffset = Convert.ToInt16(context.Request.QueryString["ClientTimeZone"]); 
                
                //Get the browser's timezone offset and negate the value to get actual offset
                double ClientBrowserTimeZoneOffset = Convert.ToDouble(context.Request.QueryString["ClientTimeZone"]);
                ClientBrowserTimeZoneOffset = -1 * ClientBrowserTimeZoneOffset;
                //string borwserTimeZoneOffset = context.Request.QueryString["ClientTimeZone"];
                //TimeSpan offSet = TimeSpan.Parse(borwserTimeZoneOffset);
                //int ClientBrowserTimeZoneOffset = 0;
                //int id;
                //if (!int.TryParse(context.Request.QueryString["ClientTimeZone"], out id))
                //{
                //    id = -1;
                //}
                //else
                //{
                //    int.TryParse(context.Request.QueryString["ClientTimeZone"]);
                //    context.Request.QueryString["ClientTimeZone"])
                //}
                if ((context.Request.QueryString["Date"] != null) && (context.Request.QueryString["Date"] != "")) 
                {
                    //DateTimeWithZone PostedDate = new DateTimeWithZone(Convert.ToDateTime(context.Request.QueryString["Date"]), TimeZone.CurrentTimeZone);
                    //PostedDate.TimeZone.BaseUtcOffset
                    DateTime PostedUtcDate = Convert.ToDateTime(context.Request.QueryString["Date"]);
                    //DateTime ServerTimeDate = DateTime; 
                    PostedUtcDate = PostedUtcDate.AddHours(ClientBrowserTimeZoneOffset);
                    //DateTime PostedUTCDate = GetDateTimeByClientTimeZone(PostedDate.ToUniversalTime(), offSet);
                    context.Response.ContentType = "text/plain";
                    context.Response.Write("" + PostedUtcDate.ToString());//.GetUtcOffset;//TEST());
                }
                else
                {
                    context.Response.Write("");//.GetUtcOffset;//TEST());
                }
            }
            catch (Exception Ex)
            {
                context.Response.Write("ERROR: " + Ex.Message.ToString());
            }
        }
        
        /// <summary>
        /// Get date time baed on client timezone.
        /// </summary>
        /// <param name="utcDate"></param>
        /// <returns></returns>
        public DateTime GetDateTimeByClientTimeZone(DateTime utcDate, TimeSpan offSet)
        {
            TimeZoneInfo timeZoneInfo = TimeZoneInfo.FindSystemTimeZoneById(TimeZoneInfo.Local.Id);
            DateTimeOffset currentDateTime = new DateTimeOffset(utcDate, offSet);
            return currentDateTime.DateTime;
            //return TimeZoneInfo.ConvertTimeFromUtc(utcDate, timeZoneInfo);
        }
        
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
        
        public struct DateTimeWithZone
        {
            private readonly DateTime utcDateTime;
            private readonly TimeZoneInfo timeZone;

            public DateTimeWithZone(DateTime dateTime, TimeZoneInfo timeZone)
            {
                utcDateTime = TimeZoneInfo.ConvertTimeToUtc(dateTime, timeZone);
                this.timeZone = timeZone;
            }

            public DateTime UniversalTime { get { return utcDateTime; } }

            public TimeZoneInfo TimeZone { get { return timeZone; } }

            public DateTime LocalTime
            {
                get
                {
                    return TimeZoneInfo.ConvertTime(utcDateTime, timeZone);
                }
            }
        }
        
        private string TEST()
        {
            const string dataFmt = "{0,-30}{1}";
            const string timeFmt = "{0,-30}{1:yyyy-MM-dd HH:mm}";
            StringBuilder TextOutPut = new StringBuilder();
            TextOutPut.AppendLine(
                "This example of selected TimeZone class " +
                "elements generates the following \n" +
                "output, which varies depending on the " +
                "time zone in which it is run.\n");

            // Get the local time zone and the current local time and year.
            TimeZone localZone = TimeZone.CurrentTimeZone;
            DateTime currentDate = DateTime.Now;
            int currentYear = currentDate.Year;

            // Display the names for standard time and daylight saving  
            // time for the local time zone.
            TextOutPut.AppendLine(dataFmt + "Standard time name:" + localZone.StandardName);
            TextOutPut.AppendLine(dataFmt + "Daylight saving time name:" + localZone.DaylightName);

            // Display the current date and time and show if they occur  
            // in daylight saving time.
            TextOutPut.AppendLine("\n" + timeFmt + "Current date and time:" + currentDate);
            TextOutPut.AppendLine(dataFmt + "Daylight saving time?" + localZone.IsDaylightSavingTime(currentDate));

            // Get the current Coordinated Universal Time (UTC) and UTC  
            // offset.
            DateTime currentUTC =
                localZone.ToUniversalTime(currentDate);
            TimeSpan currentOffset =
                localZone.GetUtcOffset(currentDate);

            TextOutPut.AppendLine(timeFmt + "Coordinated Universal Time:" + currentUTC);
            TextOutPut.AppendLine(dataFmt + "UTC offset:" +  currentOffset);

            // Get the DaylightTime object for the current year.
            DaylightTime daylight =
                localZone.GetDaylightChanges(currentYear);

            // Display the daylight saving time range for the current year.
            TextOutPut.AppendLine("\nDaylight saving time for year {0}:" + currentYear);
            TextOutPut.AppendLine("{0:yyyy-MM-dd HH:mm} to " + "{1:yyyy-MM-dd HH:mm}, delta: {2}" + daylight.Start + daylight.End +  daylight.Delta);
            return TextOutPut.ToString();
        }

        /*
        This example of selected TimeZone class elements generates the following
        output, which varies depending on the time zone in which it is run.

        Standard time name:           Pacific Standard Time
        Daylight saving time name:    Pacific Daylight Time

        Current date and time:        2006-01-06 16:47
        Daylight saving time?         False
        Coordinated Universal Time:   2006-01-07 00:47
        UTC offset:                   -08:00:00

        Daylight saving time for year 2006:
        2006-04-02 02:00 to 2006-10-29 02:00, delta: 01:00:00
        */

    }

