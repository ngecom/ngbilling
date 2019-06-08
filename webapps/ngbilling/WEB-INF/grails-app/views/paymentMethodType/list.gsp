<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="com.sapienter.jbilling.common.CommonConstants" %>

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
<content tag="menu.item">paymentMethod</content>

<g:if test="${templates}" >
        <content tag="column1">
            <g:render template="paymentMethodTemplateSelector" model="[templates: templates]"/>
        </content>
</g:if>
<g:else>
	<content tag="column1">
	    <g:render template="paymentMethodsTemplate"/>
	</content>
	
	<content tag="column2">
	    <g:if test="${selected}">
	        <g:render template="paymentMethodType" model="[ selected: selected ]"/>
	    </g:if>
	</content>
</g:else>
</body>
</html>
