<div class="column-hold">
    <div class="heading">
        <strong>
            ${selected.methodName}
        </strong>
    </div>

    <div class="box">
        <div class="sub-box">
            <table class="dataTable" cellspacing="0" cellpadding="0">
                <tbody>
                <tr>
                    <td><g:message code="paymentMethod.id.label"/></td>
                    <td class="value">${selected.id}</td>
                </tr>
                <tr>
                    <td><g:message code="paymentMethod.name.label"/></td>
                    <td class="value">${selected.methodName}</td>
                </tr>

                <tr>
                    <td><g:message code="paymentMethod.recurring.label"/></td>
                    <g:if test="${selected.isRecurring}">
                    	<td class="value"><g:message code="prompt.yes"/></td>
                    </g:if>
                    <g:else>
                    	<td class="value"><g:message code="prompt.no"/></td>
                    </g:else>
                </tr>
                
                <tr>
                    <td><g:message code="paymentMethod.accountTypes.label"/></td>
                    <g:each var="accountType" in="${selected.accountTypes}">
                    	<td class="value">${accountType.getDescription(session['language_id'].toInteger())}</td>
                    </g:each>
                </tr>
                </tbody>
            </table>
        </div>
    </div>

        <div class="heading">
            <strong><g:message code="configuration.menu.metaFields"/></strong>
        </div>
        <div class="box">
            <div class="sub-box">
                <table class="dataTable" cellspacing="0" cellpadding="0" width="100%">
	                <tbody>
						 <!-- metafields -->
                		<g:render template="/metaFieldGroup/metafields" model="[model: selected]"/>
	                </tbody>
            	</table>
            </div>

        </div>
        
    <div class="btn-box">
        <div class="row">
            <a href="${createLink(controller:'paymentMethodType', action:'edit', id:selected.id) }" class="submit edit">
                <span><g:message code="button.edit"/></span></a>
            <a onclick="showConfirm('delete-${selected.id}');" class="submit delete">
                <span><g:message code="button.delete"/></span></a>
     	</div>
    </div>

    <g:render template="/confirm"
              model="['message': 'config.paymentMethod.type.delete.confirm',
                      'controller': 'paymentMethodType',
                      'action': 'delete',
                      'id': selected.id
              ]"/>
</div>