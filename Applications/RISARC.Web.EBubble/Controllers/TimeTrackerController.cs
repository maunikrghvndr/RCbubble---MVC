using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RISARC.eTAR.Model;
using RISARC.eTAR.Service;
using RISARC.Membership.Service;

namespace RISARC.Web.EBubble.Controllers
{
    /// <summary>
    /// Represent members required to log time spent on particular screen.
    /// </summary>
    public class TimeTrackerController : Controller
    {
        #region Private Variables
        //private IRMSeBubbleMempershipService _MembershipService;
        private ITimeTrackerService _TimeTrackerService; 
        #endregion

        #region Constructor
        /// <summary>
        /// Constructor to initialize reference of IRMSeBubbleMempershipService
        /// so that it can be used get the logged in user's information while traking time 
        /// for particular screen.
        /// </summary>
        /// <param name="membershipService">Instance of RMSeBubbleMempershipService.</param>
        public TimeTrackerController(ITimeTrackerService timeTrackerService)
        {
            _TimeTrackerService = timeTrackerService;
        } 
        #endregion

        #region Public Methods
        /// <summary>
        /// Log time spent on currentScreenName screen by the logged in user.
        /// </summary>
        /// <param name="currentScreenName">Name of the currentScreenName screen.</param>
        /// <param name="previousScreen">Name of the previous screen from which user is redirected to currentScreenName screen.</param>
        /// <returns>True/False</returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 04/16/2014 | Gurudatta   | Created
        /// </RevisionHistory>
        [HttpGet]
        public object LogTimeForScreen(string currentScreenName, string previousScreen, bool isPopup, long? accountNumberId, long? tcnId, long? eNoteId,string timeSpent, bool isUserLoggingOut, long trackingInterval)
        {
            int rowsAffected = -1;
            bool result = false;

            //Call TimeTrackerService method to track time for currentScreenName screen.
            rowsAffected = _TimeTrackerService.LogTimeTrackerForScreen(currentScreenName, previousScreen, isPopup, accountNumberId, tcnId, eNoteId, timeSpent, isUserLoggingOut, trackingInterval);

            result = rowsAffected != -1;
            JsonResult jsonResult = new JsonResult()
            {
                Data = result,
                JsonRequestBehavior = JsonRequestBehavior.AllowGet
            };
            return jsonResult.Data;
        }

        /// <summary>
        /// Get time spent on particular screen by logged in user for currentScreenName day.
        /// </summary>
        /// <param name="currentScreenName">Name of the currentScreenName screen.</param>
        /// <returns>Time spent in seconds.</returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 04/16/2014 | Gurudatta   | Created
        /// </RevisionHistory>
        [HttpGet]
        public object GetSpentTimeOnScreen(string currentScreenName)
        {
            
            long timeSpent= 0;
            //TODO: Get logged in user's index and it's organization id i.e. Provider Id

            //TODO: Call TimeTrackerService method to get time in seconds on currentScreenName screen for the day.

            JsonResult jsonResult = new JsonResult()
            {
                Data = timeSpent,
                JsonRequestBehavior = JsonRequestBehavior.AllowGet
            };
            return jsonResult.Data;
        }

        /// <summary>
        /// Get interval in minutes for tracking time spent on eTAR screens.
        /// </summary>
        /// <returns>interval in minutes (JsonResult)</returns>
        /// <RevisionHistory>
        /// Date       | Owner       | Particulars
        /// ----------------------------------------------------------------------------------------
        /// 01/06/2014 | Gurudatta   | Modified
        /// </RevisionHistory>
        [AcceptVerbs("GET")]
        public JsonResult GetTimeTrackingInterval()
        {
            return new JsonResult
            {
                Data = new
                {

                    intervalTime = _TimeTrackerService.TimeTrackingInterval,
                },
                JsonRequestBehavior = JsonRequestBehavior.AllowGet
            };
        }
        #endregion

      
    }

       
}
