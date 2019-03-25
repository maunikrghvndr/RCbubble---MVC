<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<div class="Comments">
    <div class="questionblock">
        <span class="user-generated "><%= Model.QDescription %></span>
        <input type="hidden" name="questionID" id="questionID" value="<%= Model.QId %>" />
    </div>

    <%if (!string.IsNullOrEmpty(Model.PopulatedAnswer))
      {
    %>
    <textarea name="CommentsBox" id="CommentsBox" cols="60" rows="4" placeholder="Please Enter comments if any" maxlength="140"><%= Model.PopulatedAnswer %></textarea>
    <%}
      else
      {
    %>
    <textarea name="CommentsBox" id="CommentsBox" cols="60" rows="4" placeholder="Please Enter comments if any" maxlength="140"></textarea>
    <%} %>
</div>
<input type="hidden" class="NextQuestionFlag" name="NextQuestionFlag" value="<%= Model.Options[0].HasNext%>">
