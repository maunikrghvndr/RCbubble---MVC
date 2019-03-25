using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Text;

namespace RISARC.Web.EBubble
{
    /// <summary>
    /// Summary description for DocTypes
    /// </summary>
    public class DocTypes : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            //context.Response.ContentType = "text/plain";
            string sqlTEXT = @"SELECT T.DocumentTypeId FROM [RMSeBubble2].[Setup].[UserDocumentTypes] T INNER JOIN RMSeBUBBLEMembership.dbo.aspnet_Users U on (U.UserIndex= T.UserIndex) WHERE U.UserName='" + context.Request["UserName"] + @"' AND T.DocumentTypeId=" + context.Request["DocType"];
            context.Response.ContentType = "application/json";

            StringBuilder str = new StringBuilder();
            try
            {
                SqlConnection connection = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["RMSeBUBBLE"].ConnectionString);
                using (connection)
                {
                    SqlCommand command = new SqlCommand(sqlTEXT, connection);
                    connection.Open();

                    SqlDataReader reader = command.ExecuteReader();

                    if (reader.HasRows)
                    {
                        /*
                        str.AppendLine("[");
                        while (reader.Read())
                        {
                            str.AppendLine("{" + reader[0].ToString() + ",";
                        }
                        str = str.Remove(str.Length -1, 1);
                        */
                        context.Response.Write("true");
                    }
                    else
                    {
                       context.Response.Write("false");
                        //str.AppendLine("No rows found.");
                    }
                    reader.Close();
                }
            }
            catch (Exception e)
            {
                //str = "ERROR: " + e.Message.ToString();
                context.Response.Write("false");
            }
            context.Response.Write(str);

        }

        //public void ProcessRequest(HttpContext context)
        //{
        //    var serializer = new JavaScriptSerializer();
        //    string json = serializer.Serialize(new
        //    {
        //        messages = new[]
        //        {
        //            new { id = 1, value = "message 1" },
        //            new { id = 2, value = "message 2" },
        //        }
        //    });
        //    context.Response.ContentType = "application/json";
        //    context.Response.Write(json);
        //}

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}