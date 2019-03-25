<%@ WebHandler Language="C#" Class="CheckForContractor" %>
using System;
using System.Web;
using System.Globalization;
using System.Text;


    /// <summary>
    /// Summary description for Contractor
    /// </summary>
    public class CheckForContractor : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            //TimeSpan refresh = new TimeSpan(0, 0, 0, 0, 0);
            //HttpContext.Current.Response.Cache.SetExpires(DateTime.Now.Add(refresh));
            //HttpContext.Current.Response.Cache.SetMaxAge(refresh);
            //HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.Server);
            //HttpContext.Current.Response.Cache.SetValidUntilExpires(true);
            context.Response.ContentType = "text/plain";
            try
            {
                clsDB xDB = new clsDB();
                xDB.AddParameter("@ID", Convert.ToInt32("0" + context.Request.QueryString["ID"]));
                context.Response.Write("" + xDB.ExecuteScalar("[dbo].[IsContractor]").ToString());//.GetUtcOffset;//TEST()); 
                // close all connections, memory issue will develop.
                xDB.Connection.Close();
                xDB.Dispose();
            }
            catch (Exception Ex)
            {
                context.Response.Write("ERROR: " + Ex.Message.ToString());
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }

