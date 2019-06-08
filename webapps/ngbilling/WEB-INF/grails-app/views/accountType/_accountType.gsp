<div class="column-hold">
    <div class="heading">
        <strong>
            ${selected.getDescription(session['language_id'].toInteger())}
        </strong>
    </div>

    <div class="box">
        <div class="sub-box">
            <table class="dataTable" cellspacing="0" cellpadding="0">
                <tbody>
                <tr>
                    <td><g:message code="accountType.id"/></td>
                    <td class="value">${selected.id}</td>
                </tr>
                <tr>
                    <td><g:message code="accountType.description"/></td>
                    <td class="value">${selected.getDescription(session['language_id'])}</td>
                </tr>
                <tr>
                    <td><g:message code="account.type.config.invoiceDesign"/></td>
                    <td class="value">${selected?.invoiceDesign}</td>
                </tr>
                <tr>
                    <td><g:message code="account.type.config.creditLimit"/></td>
                    <td class="value"><g:formatNumber number="${selected?.creditLimit?:0}" type="currency" currencySymbol="${selected.currency?.symbol}"/></td>
                </tr>
                <tr>
                    <td><g:message code="account.type.config.creditNotificationLimit1"/></td>
                    <td class="value">
                        %{--If there is a credit notification limit 1 value display it in currency format--}%
                        <g:if test="${selected?.creditNotificationLimit1}">
                            <g:formatNumber number="${selected?.creditNotificationLimit1?:0}" type="currency" currencySymbol="${selected.currency?.symbol}"/>
                        </g:if>
                    </td>
                </tr>
                <tr>
                    <td><g:message code="account.type.config.creditNotificationLimit2"/></td>
                    <td class="value">
                        %{--If there is a credit notification limit 2 value display it in currency format--}%
                        <g:if test="${selected?.creditNotificationLimit2}">
                            <g:formatNumber number="${selected?.creditNotificationLimit2?:0}" type="currency" currencySymbol="${selected.currency?.symbol}"/>
                        </g:if>
                    </td>
                </tr>
                <tr>
                    <td><g:message code="account.type.payment.method"/></td>
                    <g:each var="pmt" in="${selected.paymentMethodTypes}">
                    	<td class="value">${pmt.methodName}</td>
                    </g:each>
                </tr>
                
                 <tr>
                    <td><g:message code="account.information.type.title"/></td>
                    <td class="value">${infoTypeName}</td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>

    <!-- account information types -->
    <g:if test="${selected.informationTypes}">
        <div class="heading">
            <strong><g:message code="account.information.type.title"/></strong>
        </div>
        <div class="box">
            <div class="sub-box">
                <table class="dataTable" cellspacing="0" cellpadding="0" width="100%">
                <tbody>

                <g:each var="ait" status="index" in="${selected.informationTypes.sort{ it.displayOrder }}">

                    <tr>
                        <td><g:message code="account.information.type.id.label"/></td>
                        <td class="value" colspan="3">
                            <g:remoteLink controller="accountType" action="showAIT" id="${ait.id}" params="[accountTypeId: selected.id, template: 'showAIT']" before="register(this);" onSuccess="render(data, next);">
                                ${ait.id}
                            </g:remoteLink>
                        </td>
                    </tr>
                    <tr>
                        <td><g:message code="account.information.type.name.label"/></td>
                        <td class="value" colspan="3">
                            ${ait.name}
                        </td>
                    </tr>
                    <tr>
                        <td><g:message code="account.information.type.display.label"/></td>
                        <td class="value">${ait.displayOrder}</td>
                    </tr>

                    <!-- ait metafields -->
                    <tr><td colspan="4">&nbsp;</td></tr>
                    <g:render template="/metaFieldGroup/metafields" model="[model: ait]"/>

                    <!-- separator line -->
                    <g:if test="${index < selected.informationTypes.size()-1}">
                        <tr><td colspan="4"><hr/></td></tr>
                    </g:if>
                </g:each>

                </tbody>
            </table>
            </div>

        </div>
        <div style="text-align: right">
            <g:link controller="accountType" action="listAIT" params="[accountTypeId: selected.id]">
                <span><g:message code="button.show.all"/></span>
            </g:link>
        </div>
    </g:if>

    <div class="btn-box">
        <div class="row">
            <a href="${createLink(controller:'accountType', action:'edit', id:selected.id) }" class="submit edit">
                <span><g:message code="button.edit"/></span></a>
            <a href="${createLink(controller:'accountType', action:'edit', id:selected.id ,params:[clone:'true']) }" class="submit add">
                <span><g:message code="button.clone"/></span></a>
            <a onclick="showConfirm('delete-${selected.id}');" class="submit delete">
                <span><g:message code="button.delete"/></span></a>
            <a href="${createLink(controller:'accountType', action:'editAIT', params:[accountTypeId : selected.id]) }" class="submit edit">
                <span><g:message code="button.create.account.information.types"/></span></a>
        </div>
    </div>

    <g:render template="/confirm"
              model="['message': 'config.account.type.delete.confirm',
                      'controller': 'accountType',
                      'action': 'delete',
                      'id': selected.id
              ]"/>
</div>