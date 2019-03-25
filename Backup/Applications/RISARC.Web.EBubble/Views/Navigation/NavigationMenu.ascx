<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IEnumerable<SpiegelDg.Common.Web.Model.NavLink>>" %>
<ul>
    <% foreach (var link in Model)
       {
           string activeClassString = link.Selected ? "navL1active" : "";%>           
       <li class="navL1  <%= activeClassString %> <%= link.Settings.AdditionalCssClass %>">
        <%--first level navigation is just button that can be clicked and children get expanded--%>
           <span><%= link.Settings.Text %></span>  
           <%--hide sub menu only if link is not selected--%>
           <ul <%= (!link.Selected ? "style='display:none'" : "")  %>>
           <% foreach (var secondLevelLink in link.ChildLinks)
              {
                  var secondLevelLinkSettings = secondLevelLink.Settings;
                  object secondLevelHtmlAttributes;
                  if (secondLevelLink.Selected)
                      secondLevelHtmlAttributes = new { @class = "active" };
                  else
                      secondLevelHtmlAttributes = null;
                  %>
                <li>
                    <%--display navigation links in second level menu--%>
                    <%= Html.ActionLink(secondLevelLinkSettings.Text, 
                        secondLevelLinkSettings.ActionName, 
                        secondLevelLinkSettings.ControllerName, 
                        secondLevelLinkSettings.RouteValues, 
                        secondLevelHtmlAttributes)%>
                </li>
           <%} %>
           </ul>
       </li>
    <% } %>
</ul>
