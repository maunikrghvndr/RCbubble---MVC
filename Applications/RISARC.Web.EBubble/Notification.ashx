<% @ webhandler language="C#" class="SessionChecker" %>
 
using System;
using System.Web;
using System.Web.SessionState;
 
public class SessionChecker : IHttpHandler, IReadOnlySessionState
{
   public bool IsReusable { get { return true; } }
   
   public void ProcessRequest(HttpContext ctx)
   {

   	   ctx.Response.ContentType = "text/plain";
       string Result = "";
       long UniqueID = Convert.ToInt64(@"0" + ctx.Request["ID"]);
       long ProviderID = Convert.ToInt64(@"0" + ctx.Request["ProviderID"]);
       string UniqueKeyID = @"" + ctx.Request["Key"];
       if (ProviderID > 0)
       {
           if (UniqueKeyID != "TEST")
           {
                try
                {
                    clsDB log = new clsDB();
                    ctx.Response.Write(ctx.Session.Count + ":" + DateTime.Now.Ticks.ToString()); 
                    log.AddParameter("@ProviderID", ProviderID);
                    log.AddParameter("@ID", UniqueID);
                    log.AddParameter("@KeyID", UniqueKeyID);
                    //Logging.InsertUserActionLog
                    Result = @"SUCCESS: " + DateTime.Now.ToString() + @" for transaction " + log.ExecuteScalar("[RMSeBUBBLELogging].[Logging].[LogFileUploaded]");
                }
                catch(Exception Ex)
                {
                    Result = @"Error Message 3: " + Ex.Message.ToString();
                }
           }
           else
           {
                 Result = @"GENERAL ERROR 2: Creditials Or Data Failed To Meet Our Standards";   
           }
       } 
       else
       {
           if(UniqueKeyID == @"TEST")
           {
                 Result = @"SUCCESS: " + ctx.Timestamp.ToString();         
           }
           else
           {
                 Result = @"GENERAL ERROR 0: " + ctx.Timestamp.ToString() + @" - Creditials Or Data Failed To Meet Our Standards" ;  
           }
       }
       ctx.Response.Write(Result);
   }
}
