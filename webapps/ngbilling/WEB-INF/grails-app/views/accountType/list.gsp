
<%@ page import="com.sapienter.jbilling.common.CommonConstants;" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<html>
<head>
    <meta name="layout" content="configuration" />
    <g:preferenceEquals preferenceId="${CommonConstants.PREFERENCE_USE_JQGRID}" value="1">
        <link type="text/css" href="${resource(file: '/css/ui.jqgrid.css')}" rel="stylesheet" media="screen, projection" />
        <g:javascript src="jquery.jqGrid.min.js"  />
        <g:javascript src="jqGrid/i18n/grid.locale-${session.locale.language}.js"  />
    </g:preferenceEquals>
</head>
<body>
<!-- selected configuration menu item -->
<content tag="menu.item">accountType</content>

<content tag="column1">
    <g:render template="accountTypesTemplate"/>
</content>

<content tag="column2">
    <g:if test="${selected}">
        <!-- show account type role -->
        <g:render template="accountType" model="[ selected: selected ]"/>
    </g:if>
    <g:elseif test="${accountTypeWS}">
        <!-- show new or editing account type (used when new period fails on validation ) -->
        <g:link controller="accountType" action="invalid"  model="[ accountTypeWS: accountTypeWS,company:company]"/>
    </g:elseif>
</content>
</body>
</html>
