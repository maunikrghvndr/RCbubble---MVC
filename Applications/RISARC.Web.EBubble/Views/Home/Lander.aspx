<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
	<meta http-equiv="Content-type" content="text/html; charset=utf-8">
    <link rel="shortcut icon" href="https://www.rmsebubble.com/favicon.ico" />
    <link rel="icon" type="image/gif" href="https://www.rmsebubble.com/animated_favicon1.gif" />
    <link rel="apple-touch-icon-precomposed" href="https://www.rmsebubble.com/favicon.ico" />
	<title>Welcome to RMSe-bubble</title>
	<link rel="stylesheet" type="text/css" href="../../Content/reset.css" media="all" />
	<link rel="stylesheet" type="text/css" href="../../Content/lander.css" media="all" />
    <script language="javascript" type="text/javascript">
// <![CDATA[

        function viddler_4eddcfee_onclick() {

        }

// ]]>
    </script>
<script language="javascript" type="text/javascript" for="viddler_4eddcfee" event="onclick">
// <![CDATA[
return viddler_4eddcfee_onclick()
// ]]>
</script>



<!-- link href="base.css" rel="stylesheet"  type="text/css" media="screen" / -->

<style type="text/css" media="screen">
<%--
<!--body {
    background: transparent;
}

h2 a {
    display: block;
    padding: 48px 0;
}

p a {
    display: block;
    padding: 10px 10px;
}
-->
--%>

#nav-list-example {
    height: 150px;
    width: 979px;
    margin: 1px 0;
}

#nav-list-example li {
    width: 230px;
    height: 150px;
    float: left;
    margin-right: 14px;
    position: relative;
}

#nav-list-example li div {
    width: 230px;
    height: 150px;
    overflow: hidden;
    background: white;
    position: absolute;
    top: 0;
    left: 0;
}

#nav-list-example li div.back {
    left: -999em;
    background: #eeeeee;
}
</style>
<link type="text/css" href="../../Content/video-js.css" rel="stylesheet"></link>

<script type="text/javascript" src="<%: Url.Content("~/Scripts/jquery.js")%>"></script>
<script type="text/javascript" src="<%: Url.Content("~/Scripts/rotate3di.js")%>"></script>
<script type="text/javascript" src="<%: Url.Content("~/Scripts/video.js")%>"></script>


<script type="text/javascript" language="javascript" charset="utf-8">
    $(document).ready(function () {
        $('#nav-list-example li div.back').hide().css('left', 0);

        function mySideChange(front) {
            if (front) {
                $(this).parent().find('div.front').show();
                $(this).parent().find('div.back').hide();

            } else {
                $(this).parent().find('div.front').hide();
                $(this).parent().find('div.back').show();
            }
        }

        $('#nav-list-example li').hover(
        function () {
            $(this).find('div').stop().rotate3Di('flip', 250, { direction: 'clockwise', sideChange: mySideChange });
        },
        function () {
            $(this).find('div').stop().rotate3Di('unflip', 500, { sideChange: mySideChange });
        }
    );
    });
</script>
  <!-- Unless using the CDN hosted version, update the URL to the Flash SWF -->
  <script>
      _V_.options.flash.swf = "RMSeBubblePlayer.swf";
  </script>
  
</head>
<body>
	<div id="wrapper">
		<div id="hd">

			<h1><a href="#"><img src="<%: Url.Content("~/Images/logo.jpg")%>" alt="IMAGE TEXT" /></a></h1>
			<div id="login">
				<p class="info">For More Information Visit <a href="http://www.risarc.com/rmsebubble.htm">www.risarc.com</a></p>
				<p class="login-links">
				
				    
				    <a href="<%= Url.Action("LogOn", "Account") %>"><img src="<%: Url.Content("~/images/btn-login.jpg")%>" alt="IMAGE TEXT" /></a>
					<a href="<%= Url.Action("RegisterUser", "Account") %>"><img src="<%: Url.Content("~/images/btn-register.jpg")%>" alt="IMAGE TEXT" /></a>
				</p>
			</div> <!-- login -->

		</div> <!-- hd -->

		<div id="bd">
			<div id="video-drop">

  <video id="RisarcIntroVideo" width="447" height="266" controls>
    <source src="http://test.rmsebubble.com/video/851ba93a7dfdff0b123fc3eb7f43d5220c2b2825.mp4" type='video/mp4' />
    <source src="http://test.rmsebubble.com/video/851ba93a7dfdff0b123fc3eb7f43d5220c2b2825.webm" type='video/webm' />
    <track kind="captions" src="<%: Url.Content("~/Content/captions.vtt")%>" srclang="en" label="English" />
  </video>


			</div> <!-- video-drop -->
		</div> <!-- bd --><!-- Flash player 

				<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="440" height="280" id="viddler_4eddcfee">
                <param name="movie" value="RMSeBubblePlayer.swf" />
                <param name="quality" value="high" />
                <param name="allowScriptAccess" value="sameDomain" />
                <param name="allowFullScreen" value="true" />
                <param name="wmode" value="transparent" /> 
                    <embed src="RMSeBubblePlayer.swf" width="440" height="280" wmode="transparent" type="application/x-shockwave-flash" allowScriptAccess="always" allowFullScreen="true" name="RMSeBubblePlayer.swf"></embed>
                </object>
-->
<!--
	<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,0,0" width="965" height="160" id="LowerLandingMenu" align="middle">
	<param name="allowScriptAccess" value="sameDomain" />
	<param name="allowFullScreen" value="false" />
	<param name="movie" value="LowerLandingMenu.swf" /><param name="quality" value="high" /><param name="bgcolor" value="#ffffff" />	<embed src="LowerLandingMenu.swf" quality="high" bgcolor="#ffffff" width="965" height="160" name="LowerLandingMenu" align="middle" allowScriptAccess="sameDomain" allowFullScreen="false" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
	</object>
-->

<br />
<ul id="nav-list-example">
    <li>
        <div class="front"><a href="#"><img src="<%: Url.Content("~/images/panel1.jpg")%>" /></a></div>
        <div class="back"><a href="#"><img src="<%: Url.Content("~/Images/BackPanel1.jpg")%>" alt="Technology has pushed modern medicine to new heights, but it has also made new responsibilities: to save gaurd the privacy of patients and the health information" /></a></div>
    </li>
    <li>
        <div class="front"><a href="#"><img src="<%: Url.Content("~/images/panel2.jpg")%>" /></a></div>
        <div class="back"><a href="#"><img src="<%: Url.Content("~/images/backpanel2.jpg")%>" alt="You can focus on . Increase your saving and productivity" /></a></div>
    </li>
    <li>
        <div class="front"><a href="#"><img src="<%: Url.Content("~/images/panel3.jpg")%>" /></a></div>
        <div class="back"><a href="#"><img src="<%: Url.Content("~/images/backpanel3.jpg")%>" alt="Ability to deliver quality customer service." /></a></div>
    </li>
    <li>
        <div class="front"><a href="#"><img src="<%: Url.Content("~/images/panel4.jpg")%>" /></a></div>
        <div class="back"><a href="#"><img src="<%: Url.Content("~/images/backpanel4.jpg")%>" alt="RMSeBubble helps you focus on what really matters. Your Health." /></a></div>
    </li>
</ul>

		<!-- buckets -->
		<div id="ft">
			<p>RISARC Consulting, LLC &copy; 2009. All Rights Reserved.</p>
			<ul>
				<li><%= Html.ActionLink("Contact", "Contact", "Home") %> |</li>
				<li><%= Html.ActionLink("Support", "Support", "Home")%> |</li>
				<li><%= Html.ActionLink("Terms of Use", "Terms", "Legal", null, new { target = "_blank" })%> |</li>

				<li><%= Html.ActionLink("Privacy Policy", "Privacy", "Legal", null, new { target = "_blank" })%> |</li>
				<li><a href="http://www.risarc.com/aboutus.htm" target="_blank">About Us</a></li>
			</ul>
		</div> <!-- ft -->
	</div> <!-- wrapper -->
</body>

</html>
