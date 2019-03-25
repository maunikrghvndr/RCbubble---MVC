<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Membership.Model.RMSeBubbleMembershipUser>" %>
<% int rowIndex = (int)ViewData["rowIndex"];
   bool isEven = rowIndex % 2 == 0;
   string rowClassString;
   if (isEven)
       rowClassString = "class='alt'";
   else
       rowClassString = "";  %>
<tr <%= rowClassString %>>
    <td>
        <%= Html.Mailto(Model.UserName, Model.UserName) %>
    </td>
  <%--  <td>
        <%string userName = Html.Encrypt(Model.UserName);%>
       
    </td>--%>
    <td>
        <%= Html.Encode(Model.PersonalInformation.LastName) %>,
        <%= Html.Encode(Model.PersonalInformation.FirstName) %>
    </td>
   
    <td>
        <%= Html.SplitLineDate(Model.LastActivityDate) %>
    </td>
    <td class="headerCell">
        <i>
            <% Html.RenderPartial("StatusFlags", Model); %>
        </i>
    </td>
    <td>
        <%= Html.ImageAction("Administrate", Url.Content("~/Images/icons/user_edit.png"), Url.Action( "AdministerUser", "AccountAdministration", 
            new { emailAddress = Html.Encrypt(Model.UserName),
                returnUrl = HttpContext.Current.Request.Url.AbsoluteUri
            }))%>
    </td>
</tr>
<script type="text/javascript">
   function MakeResponsibleMember(s,e)
    {
        //var userName=userName;
        //alert("<%=Model.UserName%>");
    }
</script>