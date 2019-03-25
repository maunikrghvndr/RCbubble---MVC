<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<div class="questionblock">
    <span class="redText">*</span> <span class="user-generated "><%= Model.QDescription %></span>
   <input type="hidden" name="questionID" id="questionID" value="<%= Model.QId %>" />
</div>

<%  Html.DevExpress().SpinEdit(
                settings => {
                    settings.Name = "NumericValueRange";
                    if (!string.IsNullOrEmpty(Model.MinVal) && !string.IsNullOrEmpty(Model.MaxVal))
                    {
                        settings.Properties.MinValue = Convert.ToDecimal(Model.MinVal);
                        settings.Properties.MaxValue = Convert.ToDecimal(Model.MaxVal);
                        settings.Properties.NullText = "From " + Model.MinVal + " to " + Model.MaxVal + "...";
                    }
                    settings.Properties.NumberType = SpinEditNumberType.Float;
                    settings.Properties.NumberFormat = SpinEditNumberFormat.Number;
                    settings.Width = Unit.Percentage(20);
                    settings.Properties.ButtonStyle.CssClass = "spinBtn";
                    settings.Properties.ClientSideEvents.NumberChanged = "CollectSpinEditValue";
                    
                    if (!string.IsNullOrEmpty(Model.PopulatedAnswer)){
                       settings.Number = Convert.ToDecimal(Model.PopulatedAnswer);
                    }
                    
                }
            ).GetHtml();
%>

<input type="hidden" name="NumericValue" id="NumericValue" value="">
<input type="hidden" class="NextQuestionFlag" name="NextQuestionFlag" value="<%= Model.Options[0].HasNext%>" >