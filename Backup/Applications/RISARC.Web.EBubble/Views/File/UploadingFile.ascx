<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<div class="uploadInProgressWrapper" style="display:none">
    <ul>
        <li>
        Uploading file...<label id="fileName"></label>
        </li>
        <li>
        <img src="<%: Url.Content("~/images/ajax-loader-bar.gif")%>" alt="uploading..." />
        </li>
    </ul>
    
</div>
