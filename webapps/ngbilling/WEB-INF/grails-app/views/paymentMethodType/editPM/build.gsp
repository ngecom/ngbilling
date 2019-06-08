<%@ page import="com.sapienter.jbilling.server.metafields.DataType" contentType="text/html;charset=UTF-8" %>
<g:if test="${params.template}">
    <g:render template="${params.template}"/>
</g:if>
<g:else>
	<html>
	<head>
	
	    <meta name="layout" content="builder"/>
	    <r:require module="errors" />
	    <r:script disposition="head">
	        $(document).ready(function() {
	            $('#builder-tabs').tabs();
	
	            // prevent the Save Changes button to be clicked more than once.
	            $('.ait-btn-box .submit.save').on('click', function (e) {
	                var saveInProgress = $('#saveInProgress').val();
	
	                if (saveInProgress == "true") {
	                    e.preventDefault();
	                } else {
	                    $('#saveInProgress').val("true");
	                }
	            });
	            changeMetafieldDataType();
	        });
	
	        function changeMetafieldDataType(){
	           $('#metaField\\.dataType').on("change", function() {
	            if ($(this).val() == '${DataType.ENUMERATION}' || $(this).val() == '${DataType.LIST}') {
	                $('.field-name').hide().find('input').prop('disabled', 'true');
	                $('.field-enumeration').show().find('select').prop('disabled', '');
	                $('.field-filename').hide().find('input').prop('disabled', 'true')
	            } else if ($(this).val() == '${DataType.SCRIPT}'){
	                    $('.field-name').show().find('input').prop('disabled', '');
	                    $('.field-enumeration').hide().find('select').prop('disabled', 'true');
	                    $('.field-filename').show().find('input').prop('disabled', '')
	                } else {
	                    $('.field-name').show().find('input').prop('disabled', '');
	                    $('.field-enumeration').hide().find('select').prop('disabled', 'true');
	                    $('.field-filename').hide().find('input').prop('disabled', 'true')
	                }
	            }).change();
	}
	        </r:script>
	</head>
	<body>
	<content tag="builder">
		<div id="builder-tabs">
            <ul>
                <li><a href="${createLink(action: 'editPM', event: 'details')}"><g:message code="account.information.type.details.title"/></a></li>
            </ul>
        </div>
        
	    <div class="btn-box ait-btn-box">
	        <g:remoteLink class="submit save" action="editPM" params="[_eventId: 'addMetaField']" update="column2" method="GET">
	            <span><g:message code="button.new.metafield"/></span>
	        </g:remoteLink>
	    </div>
	
	</content>
	
	<content tag="review">
	    <g:render template="reviewPM"/>
	</content>
	</body>
	</html>
</g:else>