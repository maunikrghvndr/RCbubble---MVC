<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.ACO.Model.Question>" %>

<%      Html.DevExpress().CallbackPanel(
          settings =>
          {
              settings.Name = "cbpQuestionsAnswers";
             // settings.ClientSideEvents.BeginCallback = "OnBeginCallback";
              settings.ClientSideEvents.EndCallback = "OnEndCallback";
              if (Model.QDescription != null)
              {
                  settings.CallbackRouteValues = new { Controller = "PQRSReport", Action = "_QuestionsList" };
                  settings.SetContent(() =>
                  {

                      switch (Model.Qtype)
                      {
                          case "RB": ViewContext.Writer.Write(Html.Partial("_RadioButtonQuestionsList", Model));
                              break;
                          case "TA": ViewContext.Writer.Write(Html.Partial("_CommentQuestionsList", Model));
                              break;
                          case "TB": ViewContext.Writer.Write(Html.Partial("_InputBoxQuestionsList", Model));
                              break;
                          case "DP": ViewContext.Writer.Write(Html.Partial("_DatePickerQuestionsList", Model));
                              break;
                          case "CMB": ViewContext.Writer.Write(Html.Partial("_DropDownQuestionsList", Model));
                              break;
                      }

                      // This is very important line!!!
                      ViewContext.Writer.Write("<input type='hidden' value='1'  name='questionDesc' id='questionDesc' />");
                      //This code is written to check whether question are set or not. if not go to finish button


                  });
              } else {

                  settings.SetContent(() =>
                  {
                      ViewContext.Writer.Write("<div class='thankyou'><div>");

                  });
              }
            
          }).GetHtml();
 %>
