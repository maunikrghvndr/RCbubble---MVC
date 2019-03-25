<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.ACO.Model.Question>" %>

<div class="qaBlock">
    <div class="questionblock">
        <span class="redText">*</span> <span class="user-generated "><%= Model.QDescription %></span>
        <input type="hidden" name="questionID" id="questionID" value="<%= Model.QId %>" />
    </div>
    <!-- For Input box Min - Max value selection -->
    <input type="hidden" name="NumericValue" id="NumericValue" value="">

    <div class="QuestionsOptions">
        <% foreach (var option in Model.Options)
           {%>

         <%  string OShowCheck = "";
             if (option.IsSelected)
             { OShowCheck = "checked"; } %>

        <div class="questionOptionBlk">
            <input onclick="return ChangeSubmitToNext()" type="radio" class="spacing" id="AnswerId" name="AnswerId" value="<%= option.OId%>:<%= option.HasNext %>" <%=OShowCheck %>>
            <label for="<%= option.OId %>"><%= option.Description %> </label>
       
        <% if (option.HasAttribute)
           { %>

            <div class="attribute_optionsblk  hide" id="optionblk_<%= option.OId%>">

            <% foreach (var attribute in option.Attributes)
               {
                   if (attribute.ControlType == "RB")
                   { %>
                     <%  string ShowCheck = "";
                       if(attribute.IsSelected){
                         ShowCheck = "checked";
                       }
                      %>  
                <div class="<%=ShowCheck %> questionblock" id="attribute_<%= option.OId%>"  >
                <div class='attributeTypeCont' >
                    <input type='hidden' name='attributeType' class="attributeType" value="<%= attribute.ControlType %>"/>
                    <input type="radio" class="spacing" id="attrId" name="attrId" value="<%= attribute.AttrId%>"  <%=ShowCheck %> >
                    <label for="<%= attribute.AttrId %>"><%= attribute.Description %> </label>
                </div>
            </div>
            <% } %>

            <% if (attribute.ControlType == "DP")
               {
                  string id= Convert.ToString(option.OId);
                  ViewContext.Writer.Write("<div class=' attributeBlock questionblock' id=attribute_" + id + ">");
                  ViewContext.Writer.Write("<div class='attributeTypeCont' ><input type='hidden' name='attributeType' class='attributeType' value=" + attribute.ControlType + ">");
                  ViewContext.Writer.Write("<input type='hidden' name='AttrId' id='AttrId' value=" + attribute.AttrId + ">");

                  if (!string.IsNullOrEmpty(attribute.AnsValue))
                   {

                       Html.DevExpress().DateEdit(
                  RISARC.Web.EBubble.Models.DevxControlSettings.DateEditSetting.DateEditSettingsMethodAdditional(settings =>
                  {
                      settings.Name = attribute.ControlType;
                      settings.Width = Unit.Percentage(25);
                  })).Bind(attribute.AnsValue).GetHtml();

                   }
                   else {

                       Html.DevExpress().DateEdit(
                             RISARC.Web.EBubble.Models.DevxControlSettings.DateEditSetting.DateEditSettingsMethodAdditional(settings =>
                             {
                                 settings.Name = attribute.ControlType;
                                 settings.Width = Unit.Percentage(25);

                                 if (!string.IsNullOrEmpty(Model.MinVal) && !string.IsNullOrEmpty(Model.MaxVal))
                                 {
                                     settings.Properties.MaxDate = DateTime.ParseExact(Model.MinVal, "MM-dd-yyyy", System.Globalization.CultureInfo.InvariantCulture);
                                     settings.Properties.MaxDate = DateTime.ParseExact(Model.MaxVal, "MM-dd-yyyy", System.Globalization.CultureInfo.InvariantCulture);
                                 }

                             })).GetHtml();

                   }
                   
                   ViewContext.Writer.Write("</div></div>");
               } %>

         <% if (attribute.ControlType == "IB")
               {
                  string id= Convert.ToString(option.OId);
                  ViewContext.Writer.Write("<div class=' attributeBlock questionblock' id=attribute_" + id + ">");
                  ViewContext.Writer.Write("<div class='attributeTypeCont' ><input type='hidden' name='attributeType' class='attributeType' value=" + attribute.ControlType + ">");
                  ViewContext.Writer.Write("<input type='hidden' name='AttrId' id='AttrId' value=" + attribute.AttrId + ">");
                  Html.DevExpress().SpinEdit(
                   settings =>
                     {
                         settings.Name = "NumericValueRange";
                       if (!string.IsNullOrEmpty(Model.MinVal) && !string.IsNullOrEmpty(Model.MaxVal))
                       {
                           settings.Properties.MinValue = Convert.ToInt32(Model.MinVal);
                           settings.Properties.MaxValue = Convert.ToInt32(Model.MaxVal);
                           settings.Properties.NullText = "From " + Model.MinVal + " to " + Model.MaxVal + "...";
                       }
                       settings.Properties.NumberType = SpinEditNumberType.Float;
                       settings.Properties.NumberFormat = SpinEditNumberFormat.Number;
                       settings.Width = Unit.Percentage(15);
                       settings.Properties.ButtonStyle.CssClass = "spinBtn";
                       settings.Properties.ClientSideEvents.NumberChanged = "CollectSpinEditValue";
                    }
                 ).GetHtml();
                   ViewContext.Writer.Write("</div></div>");
               } %>

         <% if (attribute.ControlType == "CT")
               {%>
                 <div class=' attributeBlock questionblock' id="attribute_"<%= Convert.ToString(option.OId) %>">
                 <div class='attributeTypeCont' >
                     <input type='hidden' name='attributeType' class="attributeType" value="<%=attribute.ControlType %>">
                 <input type='hidden' name='AttrId' id='AttrId' value=" + attribute.AttrId + ">
              <textarea name="CommentsBox" id="CommentsBox" cols="60" rows="4" placeholder="Please Enter comments if any" maxlength="140"  ></textarea>
                   ViewContext.Writer.Write("</div></div>");
             <%  } %>

        

            <% }  //forech ends %>
         </div>
        <% }//option has attributes  %>
             </div> <!-- .questionOptionBlk ends -->
           
           <% }//main option loop closed
        %>
     </div>
</div>



<script type="text/javascript">
    function ChangeSubmitToNext() {
        var value = $("input[name=AnswerId]:checked").val();
        var questionFlag = value.split(":");       
        var baseOptionId = questionFlag[0];
       
        if (baseOptionId != "") {
            $("#optionblk_" + baseOptionId).addClass("show").removeClass("hide");
        }
        $(".attribute_optionsblk:not(#optionblk_" + baseOptionId + ")").addClass("hide").removeClass("show");
       
        var NextQuestionFlag = questionFlag[1];
        if (NextQuestionFlag == "True") {
            SubmitQuestion.SetText("Next");
        } else {
            SubmitQuestion.SetText("Submit");
        }
    }
</script>
