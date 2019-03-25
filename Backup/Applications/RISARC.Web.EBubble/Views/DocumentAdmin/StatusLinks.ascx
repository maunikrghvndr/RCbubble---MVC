<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IEnumerable<SpiegelDg.Common.Web.Model.NavLink>>" %>
<div class="SubSectionLinks">
    <h4>
        Filter by Status</h4>
    <ul>
        <% foreach (var navLink in Model)
           {%>
        <li>
            <%if (navLink.Selected)
              {%>
            <%= Html.Encode(navLink.Settings.Text)%>
            <%}
              else
              {
                  Html.RenderPartial("CategoryLink", navLink.Settings);%>
        </li>
        <%}
           } %>
        <div class="clear">
        </div>
</div>
