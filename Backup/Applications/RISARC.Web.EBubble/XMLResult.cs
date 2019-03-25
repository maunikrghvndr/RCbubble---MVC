using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Xml.Serialization;

namespace RISARC.Web.EBubble
{
    public class XMLResult : ActionResult
    {
        private readonly object _data;
        private string _name;
        public XMLResult(object data, string name)
    {
        _data = data;
        _name = name;
    }

    public override void ExecuteResult(ControllerContext context)
    {
        if (_data != null)
        {
            var response = context.HttpContext.Response;
            
            response.ContentType = "text/xml";
            response.AddHeader("content-disposition", "attachment; filename=" + _name + ".xml");
            var serializer = new XmlSerializer(_data.GetType());
            serializer.Serialize(response.OutputStream, _data);
        }
    }

    }
}