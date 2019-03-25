using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Ajax;
using RISARC.Emr.Web.DataTypes;
using System.Collections.ObjectModel;
using RISARC.Setup.Implementation.Repository;
using DevExpress.Web.Mvc;

namespace RISARC.Web.EBubble.Controllers
{
    public class CommonDropDownController : Controller
    {
        private static IDictionary<string, string> _States;
        private static IDictionary<string, string> _Provinces;
        //private static IDictionary<string, string> _Countries;
        private static IDictionary<string, string> _Months;
        private static IDictionary<string, string> _Days;

        private ISetupDataRepository _SetupDataRepository;

        static CommonDropDownController()
        {            
            InitializeStaticDropDownItems();
        }

        public CommonDropDownController(ISetupDataRepository setupDataRepository)
        {
            this._SetupDataRepository = setupDataRepository;
        }
        //
        // GET: /CommonDropDown/
        [OutputCacheAttribute(VaryByParam = "*", Duration = 0, NoStore = true)]
        public ActionResult StatesDropDown(string fieldName, string emptyOptionText, string selectedValue)
        {
            ICollection<SelectListItem> dropDownItems;
            string actualEmptyOptionText;

            dropDownItems = (from state in _States
                            orderby state.Value
                            select new SelectListItem
                            {
                                Text = state.Value,
                                Value = state.Key,
                                Selected = state.Key == selectedValue
                            }).ToList();
            ViewData.SetValue(GlobalViewDataKey.ClassName, fieldName);

            if (String.IsNullOrEmpty(emptyOptionText))
                actualEmptyOptionText = "-State-";
            else
                actualEmptyOptionText = emptyOptionText;

            return DropDown(fieldName, actualEmptyOptionText, dropDownItems);
        }
        
        public ActionResult ProvincesDropDown(string fieldName, string selectedValue)
        {
            ICollection<SelectListItem> dropDownItems;

            dropDownItems = (from province in _Provinces
                             orderby province.Value
                             select new SelectListItem
                             {
                                 Text = province.Value,
                                 Value = province.Key,
                                 Selected = province.Key == selectedValue
                             }).ToList();
            return DropDown(fieldName, "-Province-", dropDownItems);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="fieldName"></param>
        /// <param name="selectedValue"></param>
        /// <param name="showMonthName">If set to true, month name will be shown.  Otherwise, month number will be shown</param>
        /// <returns></returns>
        public ActionResult MonthsDropDown(string fieldName, int? selectedValue, bool showMonthName)
        {
            ICollection<SelectListItem> dropDownItems;
            string selectedValueString;

            // automatically pads with 0 on left to match values
            if (selectedValue.HasValue)
            {
                if(selectedValue.Value < 10)
                    selectedValueString = '0' + selectedValue.Value.ToString();
                else
                    selectedValueString = selectedValue.Value.ToString();
            }
            else
                selectedValueString = null;

            if (showMonthName)
                dropDownItems = (from month in _Months
                                 orderby month.Key
                                 select new SelectListItem
                                 {
                                     Text = month.Value,
                                     Value = month.Key,
                                     Selected = month.Key == selectedValueString
                                 }).ToList();
            else
                dropDownItems = (from month in _Months
                                 orderby month.Key
                                 select new SelectListItem
                                 {
                                     Text = month.Key, // only difference in queries
                                     Value = month.Key,
                                     Selected = month.Key == selectedValueString
                                 }).ToList();


            return DropDown(fieldName, "-Month-", dropDownItems);
        }
        
        /// <summary>
        /// 
        /// </summary>
        /// <param name="fieldName"></param>
        /// <param name="selectedValue"></param>
        /// <param name="showMonthName">If set to true, month name will be shown.  Otherwise, month number will be shown</param>
        /// <returns></returns>
        public ActionResult DaysDropDown(string fieldName, int? selectedValue)
        {
            ICollection<SelectListItem> dropDownItems;
            string selectedValueString;

            // automatically pads with 0 on left to match values
            if (selectedValue.HasValue)
            {
                if (selectedValue.Value < 10)
                    selectedValueString = '0' + selectedValue.Value.ToString();
                else
                    selectedValueString = selectedValue.Value.ToString();
            }
            else
                selectedValueString = null;

            
                dropDownItems = (from day in _Days
                                 orderby day.Key
                                 select new SelectListItem
                                 {
                                     Text = day.Value,
                                     Value = day.Key,
                                     Selected = day.Key == selectedValueString
                                 }).ToList();
            

            return DropDown(fieldName, "-Day-", dropDownItems);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="fieldName"></param>
        /// <param name="selectedValue"></param>
        /// <param name="minYear">Minimum year to show</param>
        /// <param name="maxYear">Maximum year to show</param>
        /// <returns></returns>
        public ActionResult YearsDropDown(string fieldName, string selectedValue, int minYear, int maxYear)
        {
            if (maxYear <= minYear)
                throw new ArgumentException("maxYear less than or equal to minYear", "maxYear");

            ICollection<SelectListItem> selectListItems;
            string yearString;

            selectListItems = new Collection<SelectListItem>();

            for (int year = minYear; year <= maxYear; year++)
            {
                yearString = year.ToString();

                selectListItems.Add(new SelectListItem
                {
                    Text = yearString,
                    Value = yearString,
                    Selected = yearString == selectedValue
                });
            }

            return DropDown(fieldName, "-Year-", selectListItems);
        }

        public ActionResult CountriesDropDown(string fieldName, string selectedValue)
        {
            ICollection<SelectListItem> dropDownItems;

            dropDownItems = (from country in _SetupDataRepository.GetAllCountries()
                             //orderby country.Value
                             select new SelectListItem
                             {
                                 Text = country.Value,
                                 Value = country.Key,
                                 Selected = country.Key == selectedValue
                             }).ToList();

            ViewData.SetValue(GlobalViewDataKey.ClassName, "CountriesDropDown");



            return DropDown(fieldName, "-Country-", dropDownItems);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="fieldName"></param>
        /// <param name="optionText">What will appear for default option</param>
        /// <param name="dropDownItems"></param>
        /// <returns></returns>
        public ActionResult DropDown(string fieldName, string optionText, IEnumerable<SelectListItem> dropDownItems)
        {
            ViewData.SetValue(GlobalViewDataKey.FieldName, fieldName);
            ViewData.SetValue(GlobalViewDataKey.OptionText, optionText);

            return View("DropDown", dropDownItems);
        }

        private static void InitializeStaticDropDownItems()
        {
            // initialize states drop down items
            _States = new Dictionary<string, string>()
            {
                {"AL","ALABAMA"},
                {"AK","ALASKA"},
                {"AZ","ARIZONA"},
                {"AR","ARKANSAS"},
                {"CA","CALIFORNIA"},
                {"CO","COLORADO"},
                {"CT","CONNECTICUT"},
                {"DE","DELAWARE"},
                {"DC","DISTRICT OF COLUMBIA"},
                {"FL","FLORIDA"},
                {"GA","GEORGIA"},
                {"GU","GUAM"},
                {"HI","HAWAII"},
                {"ID","IDAHO"},
                {"IL","ILLINOIS"},
                {"IN","INDIANA"},
                {"IA","IOWA"},
                {"KS","KANSAS"},
                {"KY","KENTUCKY"},
                {"LA","LOUISIANA"},
                {"ME","MAINE"},
                {"MD","MARYLAND"},
                {"MA","MASSACHUSETTS"},
                {"MI","MICHIGAN"},
                {"MN","MINNESOTA"},
                {"MS","MISSISSIPPI"},
                {"MO","MISSOURI"},
                {"MT","MONTANA"},
                {"NE","NEBRASKA"},
                {"NV","NEVADA"},
                {"NH","NEW HAMPSHIRE"},
                {"NJ","NEW JERSEY"},
                {"NM","NEW MEXICO"},
                {"NY","NEW YORK"},
                {"NC","NORTH CAROLINA"},
                {"ND","NORTH DAKOTA"},
                {"OH","OHIO"},
                {"OK","OKLAHOMA"},
                {"OR","OREGON"},
                {"PA","PENNSYLVANIA"},
                {"RI","RHODE ISLAND"},
                {"SC","SOUTH CAROLINA"},
                {"SD","SOUTH DAKOTA"},
                {"TN","TENNESSEE"},
                {"TX","TEXAS"},
                {"UT","UTAH"},
                {"VT","VERMONT"},
                {"VA","VIRGINIA"},
                {"WA","WASHINGTON"},
                {"WV","WEST VIRGINIA"},
                {"WI","WISCONSIN"},
                {"WY","WYOMING"}
            };

            _Provinces = new Dictionary<string, string>
            {
                {"AB"	, "AB"},
                {"BC"	, "BC"},
                {"MB"	, "MB"},
                {"NB"	, "NB"},
                {"NL"	, "NL"},
                {"NT"	, "NT"},
                {"NS"	, "NS"},
                {"NU"	, "NU"},
                {"ON"	, "ON"},
                {"PE"	, "PE"},
                {"QC"	, "QC"},
                {"SK"	, "SK"},
                {"YT"	, "YT"},
            };

            //_Countries = new Dictionary<string, string>()
            //{
            //    {"USA", "United States of America"},
            //    {"Canada", "Canada"},
            //};

            _Months = new Dictionary<string, string>()
            {
                {"01", "Jan"},
                {"02", "Feb"},
                {"03", "Mar"},
                {"04", "Apr"},
                {"05", "May"},
                {"06", "Jun"},
                {"07", "Jul"},
                {"08", "Aug"},
                {"09", "Sept"},
                {"10", "Oct"},
                {"11", "Nov"},
                {"12", "Dec"},
            };

            _Days = new Dictionary<string, string>()
            {
                {"01",	"01"},
                {"02",	"02"},
                {"03",	"03"},
                {"04",	"04"},
                {"05",	"05"},
                {"06",	"06"},
                {"07",	"07"},
                {"08",	"08"},
                {"09",	"09"},
                {"10",	"10"},
                {"11",	"11"},
                {"12",	"12"},
                {"13",	"13"},
                {"14",	"14"},
                {"15",	"15"},
                {"16",	"16"},
                {"17",	"17"},
                {"18",	"18"},
                {"19",	"19"},
                {"20",	"20"},
                {"21",	"21"},
                {"22",	"22"},
                {"23",	"23"},
                {"24",	"24"},
                {"25",	"25"},
                {"26",	"26"},
                {"27",	"27"},
                {"28",	"28"},
                {"29",	"29"},
                {"30",	"30"},
                {"31",	"31"},
            };           
        }
               
    }
}
