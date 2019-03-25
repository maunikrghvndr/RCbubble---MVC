using System;
using System.Collections.Generic;
using System.Web.Mvc;
using DevExpress.Web.Mvc;

namespace RISARC.Web.EBubble.Models.DevxCommonModels
{
    public class DevExpressComboModel
    {
        public IEnumerable<SelectListItem> Items { get; set; }

        public dynamic SelectedValue { get; set; }

        public Action<ComboBoxSettings> cmbSettings { get; set; }
    }
}