<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<RISARC.Membership.Model.RMSeBubbleMembershipUser>" %>
<% string encryptedUserName = Html.Encrypt(Model.UserName); %>
<% IEnumerable<string> userRoles = ViewData["UserRoles"] as IEnumerable<string>;
   bool IsSuperadmin = (bool)ViewData["SetProviderAdmin"];
   %>

<% // if locked out, need to unlock account before can reset password
    if (Model.IsLockedOut)
    {
        using (Html.BeginForm("UnlockAccount", "AccountAdministration", new { emailAddress = encryptedUserName }))
        {%>
<ul>
    <li>
        <%= Html.AntiForgeryToken()%>
        <%= Html.Hidden("ReturnUrl", ViewData.GetValue(GlobalViewDataKey.ReturnUrl))%>
        <input type="submit" value="Unlock Account" />
    </li>
</ul>
<% }
    }
    else
    {%>
<% using (Html.BeginForm("ResetPassword", "AccountAdministration", new { emailAddress = encryptedUserName }))
   {%>
<ul>
    <li>
        <%= Html.AntiForgeryToken()%>
        <%= Html.Hidden("ReturnUrl", ViewData.GetValue(GlobalViewDataKey.ReturnUrl))%>
        <input type="submit" value="Reset Password" onclick="return confirm('Are you sure you want to reset this password?  This cannot be undone.')" />
    </li>
</ul>
<% } %>

<% 
   // both approving and dissapproving happen on same method, so just set value of 'enabled' and text
   // on submit button differently
   using (Html.BeginForm("SetUserEnabled", "AccountAdministration", new { emailAddress = encryptedUserName }))
   {%>
<ul>
    <li>
        <%= Html.AntiForgeryToken()%>
        <%= Html.Hidden("ReturnUrl", ViewData.GetValue(GlobalViewDataKey.ReturnUrl))%>

        <%// if approved, render buttons to diable, and visa versa
       if (Model.IsApproved)
       {%>
        <input type="hidden" name="setEnabled" value="False" />
        <%--<%= Html.Hidden("setEnabled", false)%>--%>
        <input type="submit" value="Disable User" onclick="return confirm('Are you sure you want to disable this user?')" />
        <%}
       else
       {
        %>
        <input type="hidden" name="setEnabled" value="True" />
        <input type="submit" value="Enable User" />

        <%
       } %>
    </li>
</ul>
<%}%>

<% 
  
        using (Html.BeginForm("SetUserResponsible", "AccountAdministration", new { emailAddress = encryptedUserName }))
        {%>
<ul>
    <li>
        <%= Html.AntiForgeryToken()%>
        <%= Html.Hidden("ReturnUrl", ViewData.GetValue(GlobalViewDataKey.ReturnUrl))%>

        <%
       if (Model.IsResponsible)
       {%>
        <input type="hidden" name="setResponsible" value="False" />

        <div class="UnmarkAlignToolTip">
            <div>
                <input type="submit" value="Unmark Responsible" onclick="return confirm('Are you sure to unmark this user Responsible?')" id="Unmark" />

            </div>

            <div class="clsMarginTopRev">
                <div class="setTooltipButton" title="Responsible Members have the right to view and respond to transactions sent by reviewers">&nbsp;</div>
            </div>
        </div>
        <div class="clear"></div>

        <%}
       else
       {%>
        <input type="hidden" name="setResponsible" value="True" />

        <div class="AlignToolTip">
            <div>

                <input type="submit" value="Mark Responsible" id="mark" onclick="return confirm('Are you sure to mark this user Responsible?')" />
            </div>

            <div class="clsMarginTopRev">

                <div class="setTooltipButton" title="Responsible Members have the right to view and respond to transactions sent by reviewers">&nbsp;</div>
            </div>
        </div>

        <div class="clear"></div>

        <%
                } %>
    </li>
</ul>
<%}%>


<% // if user is member of provider, then render options to grant/remove access from reports
   if (IsSuperadmin)
   {
       using (Html.BeginForm("MakeProviderAdmin", "AccountAdministration", new { emailAddress = encryptedUserName }))
       {%>
<%= Html.AntiForgeryToken() %>
<ul>
    <li>
        <% // if contains provider reports viewer role, display option to remove it
           if (userRoles.Contains(RISARC.Common.ConstantManager.StoredProcedureConstants.ProviderAdminRoleAccess))
           {%>
        <label>Member is a provider admin</label>
       <%-- <%= Html.Hidden("setProviderAdmin", false)%>--%>
        <input type="hidden" name="setProviderAdmin" value="False" />
        <input type="submit" value="Remove Provider Admin Access" />
        <%}
                    else
                    {%>
        <label>Member is currently not having provider admin access</label>
         <input type="hidden" name="setProviderAdmin" value="True" />
        <input type="submit" value="Configure Provider Admin Access" />
        <%}%>
    </li>
</ul>
<%}
   } %>



<% // if user is member of provider, then render options to grant/remove access from reports
   if (userRoles.Contains(RISARC.Common.ConstantManager.StoredProcedureConstants.DocumentAdmin))
   {
       using (Html.BeginForm("SetProviderReportsAccess", "AccountAdministration", new { emailAddress = encryptedUserName }))
       {%>
<%= Html.AntiForgeryToken() %>
<ul>
    <li>
        <% // if contains provider reports viewer role, display option to remove it
           if (userRoles.Contains(RISARC.Common.ConstantManager.StoredProcedureConstants.ProviderReportsViewer))
           {%>
        <label>Member can view provider reports</label>
        <%= Html.Hidden("setEnabled", false)%>
        <input type="submit" value="Remove Access to Reports" />
        <%}
                    else
                    {%>
        <label>Member cannot view provider reports</label>
        <%= Html.Hidden("setEnabled", false)%>
        <input type="submit" value="Grant Access to Reports" />
        <%}%>
    </li>
</ul>
<%}
   } %>
<%}%>
    </ul>
<script type="text/javascript">

    $(document).ready(function () {
        if ($("#UserStatus").val() == "False") {

            if ($("#Unmark").length > 0) {
                $("#Unmark").attr("disabled", true);
            }
            if ($("#mark").length > 0) {
                $("#mark").attr("disabled", true);
            }

        }
        //var testStatus = $('#span1').text().toLowerCase();
        //var cars = new Array("Locked Out", "Disabled", "New Password Required", "Email Confirmation Required", "Awaiting Registration Completion");
        //if (testStatus.indexOf("new password required") >= 0) {
        //    alert($('#span1').text());
        //}
        return true;
        //alert($('input[name=setEnabled]').val());
    });

</script>
