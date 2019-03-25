using System.Web;
using System.Web.Mvc;
using RISARC.Web.EBubble;

namespace RISARC.Web.EBubble
{
    public class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            filters.Add(new ElmahHandleErrorAttribute());
        }
    }
}