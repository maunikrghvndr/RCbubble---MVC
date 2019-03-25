<%@ WebHandler Language="C#" Class="MobileHandler" %>

using System;
using System.Web;
using System.Net;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.IO;
using System.IO.Compression;
using System.Xml;


public class MobileHandler : IHttpHandler {

    public void ProcessRequest(HttpContext context)
    {
        try
        {
            context.Response.ContentType = "text/plain";
            // Clear Search HACK...Hate Telerik Grid...
            context.Session["startDate"] = null;
            context.Session["endDate"] = null;
            context.Session["acn"] = null;
            context.Session["patientFName"] = null;
            context.Session["patientLName"] = null;
            context.Session["accountNo"] = null;
            // Redirect to page it came from to reload data from start
            context.Response.Redirect("../" + context.Request.QueryString["CurrentPage"]);
     
        }
        catch (Exception Ex)
        {
            context.Response.Redirect(context.Request.QueryString["CurrentPage"]);// + @"/" + Ex.Message.ToString());
        }
            
    }
    

    public bool IsReusable {
        get {
            return false;
        }
    }

}