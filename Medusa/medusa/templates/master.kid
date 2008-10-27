<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<?python import sitetemplate ?>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:py="http://purl.org/kid/ns#" py:extends="sitetemplate">

<head py:match="item.tag=='{http://www.w3.org/1999/xhtml}head'" py:attrs="item.items()">
    <meta content="text/html; charset=UTF-8" http-equiv="content-type" py:replace="''"/>
    <title py:replace="''">Your title goes here</title>
    <script type="text/javascript" src="${tg.url('/static/javascript/jquery.js')}"></script>
    <meta py:replace="item[:]"/>
    <style type="text/css">
        #pageLogin
        {
            font-size: 10px;
            font-family: verdana;
            text-align: right;
        }
    </style>
    <style type="text/css" media="screen">
@import "${tg.url('/static/css/layout-uncompressed.css')}";
</style>
</head>

<body py:match="item.tag=='{http://www.w3.org/1999/xhtml}body'" py:attrs="item.items()">

<?python
from medusa.model import device_classes
?>
<script type="text/javascript" py:if="'admin' in tg.identity.groups">
$(document).ready(function() {
    $('#administration').click( function() { $('#adminlist').toggle('slow'); });
});
</script>
    <div id="fedora-header">
        <div id="fedora-header-logo">
            <a href="${tg.url('/')}"><img src="${tg.url('/static/images/header-fedora_logo.png')}" /></a>
        </div>

        <div id="fedora-header-items">
            <table><tr><td> &nbsp; </td><td>
                <div id="wait" style="display: none">
                    <img src="${tg.url('/static/images/wait.gif')}" height="48" width="48"/>
                </div>
            </td></tr></table>
        </div>
    </div>

    <div id="fedora-nav"></div>
    <!-- header END -->
   <!-- leftside BEGIN -->
    <div id="fedora-side-left">
        <div id="fedora-side-nav-label">Site Navigation:</div>
            <div py:if="not tg.identity.anonymous and 'admin' in tg.identity.groups">
                <ul id="fedora-side-nav">
                    <li><a id="administration" href="#">Administration</a></li>
                    <div id="adminlist" style="display: none">
                        <ul>
                            <li><a href="${tg.url('/labcontrollers')}">Lab Controllers</a></li>
                            <li><a href="${tg.url('/groups')}">Groups</a></li>
                            <li><a href="${tg.url('/powertypes')}">Power Types</a></li>
                            <li><a href="${tg.url('/powercontrollers')}">Power Controllers</a></li>
                        </ul>
                    </div>
                </ul>
            </div>
            <ul id="fedora-side-nav">
                <li py:if="not tg.identity.anonymous"><a href="${tg.url('/mine')}">${tg.identity.user_name}'s Home</a></li>
                <li py:if="not tg.identity.anonymous"><a href="${tg.url('/available')}">Available Systems</a></li>
                <li><a href="${tg.url('/')}">All Systems</a></li>
                <li><a href="${tg.url('/devices')}">Devices</a>
                <ul>
                    <li py:for="device_class in device_classes()">
                    <a href="${tg.url('/devices/%s' % device_class)}">${device_class}</a></li>
                </ul></li>
                <li><a href="${tg.url('/distros')}">Distros</a></li>
                <li><a href="${tg.url('/activity')}">Activity</a></li>
                <li py:if="not tg.identity.anonymous"><a href="${tg.url('/logout')}">Logout</a></li>
                <li py:if="tg.identity.anonymous"><a href="${tg.url('/login')}">Login</a></li>
            </ul>
        </div>
        <!-- leftside END -->

    <div id="fedora-middle-two">
        <div class="fedora-corner-tr">&nbsp;</div>
        <div class="fedora-corner-tl">&nbsp;</div>
        <div id="fedora-content">
            <center>
                <div id="status_block" class="flash" py:if="value_of('tg_flash', None)" py:content="tg_flash"></div>
           </center>
           <div py:replace="[item.text]+item[:]"/>

        </div>
        <div class="fedora-corner-br">&nbsp;</div>
        <div class="fedora-corner-bl">&nbsp;</div>
    </div>
    <!-- End of main_content -->
</body>

</html>