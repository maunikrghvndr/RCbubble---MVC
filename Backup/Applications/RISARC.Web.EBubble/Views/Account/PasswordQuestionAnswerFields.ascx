<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<li>
    <label for="PasswordQuestion">
        Security question <span class="ValidationInstructor">*</span></label>
    <%= Html.DropDownList("PasswordQuestion", 
                new System.Collections.ObjectModel.Collection<SelectListItem>{
                    new SelectListItem { Text = "What is your primary frequent flyer number?" },
                    new SelectListItem { Text = "What was your first pet's name?" },
                    new SelectListItem { Text = "What was your High School Mascot?" },
                    new SelectListItem { Text = "What street did you grow up on?" },
                },
                "Choose a question...")
    %>
    <%= Html.ValidationMessage("PasswordQuestionRequired", "Required") %>
    <div class="FieldInstructions">
        In case you forget your password we will ask you this</div>
</li>
<li>
    <label for="PasswordAnswer">
        Answer: <span class="ValidationInstructor">*</span></label>
    <%= Html.StyledTextBox("PasswordAnswer") %>
    <%= Html.ValidationMessage("PasswordAnswerRequired", "Required") %>
</li>
