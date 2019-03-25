<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<SpiegelDg.Common.DataTypes.SplitDate>" %>
<% string bindingPrefix = ViewData.GetBindingPrefix();
   %>

<% Html.RenderAction<RISARC.Web.EBubble.Controllers.CommonDropDownController>(x => x.MonthsDropDown(bindingPrefix + "Month", Model.Month, true)); %>
<%= Html.ValidationMessage(bindingPrefix + "BirthMonth", "Required")%>


<% Html.RenderAction<RISARC.Web.EBubble.Controllers.CommonDropDownController>(x => x.DaysDropDown(bindingPrefix + "Day", Model.Day)); %>
<%= Html.ValidationMessage(bindingPrefix + "BirthDay", "Required")%>

<% Html.RenderAction<RISARC.Web.EBubble.Controllers.CommonDropDownController>(x => x.YearsDropDown(bindingPrefix + "Year", Model.Year.ToString(), 1900, 2009)); %>
<%= Html.ValidationMessage(bindingPrefix + "BirthYear", "Required")%>