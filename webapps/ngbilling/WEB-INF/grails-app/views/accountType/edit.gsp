
<%@ page import="com.sapienter.jbilling.server.process.db.PeriodUnitDTO;com.sapienter.jbilling.server.util.ServerConstants; com.sapienter.jbilling.common.Util" contentType="text/html;charset=UTF-8" %>
<%@ page import="com.sapienter.jbilling.server.user.db.AccountTypeDTO"%>
<%@ page import="com.sapienter.jbilling.server.user.UserDTOEx; com.sapienter.jbilling.server.user.db.CompanyDTO; com.sapienter.jbilling.server.user.permisson.db.RoleDTO; com.sapienter.jbilling.common.CommonConstants; com.sapienter.jbilling.server.util.db.LanguageDTO" %>
<%@ page import="com.sapienter.jbilling.server.util.db.EnumerationDTO; com.sapienter.jbilling.server.user.db.AccountTypeDAS" %>

<html>
<head>
    <meta name="layout" content="main" />
    <r:require module="errors" />
</head>
<body>
<div class="column-hold">

    <g:set var="isNew" value="${!accountType || !accountType?.id || accountType?.id == 0}"/>
    <g:set var="isClone" value="${params.clone=="true"}"/>

    <div class="heading">
        <strong>
            <g:if test="${isNew}">
                <g:message code="account.type.config.add"/>
            </g:if>
            <g:elseif test="${isClone}">
                <g:message code="account.type.config.clone"/>
            </g:elseif>
            <g:else>
                <g:message code="account.type.config.edit.title"/>
            </g:else>
        </strong>
    </div>

    <g:form id="save-config-form" name="account-type-config-form" url="[controller: 'accountType', action: 'save']">
        <fieldset>

            <div class="box">
                <div class="form-columns">
                    <g:hiddenField name="id" value="${accountType?.id ?: null}"/>
                    <g:hiddenField name="clone" value="${clone}"/>
                    <g:hiddenField name="dateCreated" value="${accountType?.dateCreated ?
                        formatDate(date: accountType.dateCreated, formatName: 'date.format') : null}"/>
                    <g:applyLayout name="form/input">
                        <content tag="label"><g:message code="accountType.description"/><span id="mandatory-meta-field">*</span></content>
                        <content tag="label.for">description</content>
                        <g:textField class="field" name="description"
                                     value="${accountType ? accountType.getDescription(session['language_id'])?.content : null}"/>
                    </g:applyLayout>
                    <g:set var="mainSubscription" value="${accountType?.mainSubscription}"/>
                    <g:applyLayout name="form/select">
                        <content tag="label"><g:message code="account.type.config.billingCycle"/><span id="mandatory-meta-field">*</span></content></content>
                        <content tag="label.for">mainSubscription.nextInvoiceDayOfPeriod</content>

                        <div class="inp-bg inp2">
                            <g:textField class="field" name="mainSubscription.nextInvoiceDayOfPeriod"
                                         value="${accountType?.mainSubscription?.nextInvoiceDayOfPeriod ?: 1}" maxlength="4" size="3"/>
                        </div>

                        <div class="select5">
                            <g:select from="${orderPeriods}"
                                      optionKey="id" optionValue="${{it.getDescription(session['language_id'])}}"
                                      name="mainSubscription.periodId"
                                      value="${accountType?.mainSubscription?.periodId}"/>
                        </div>
                    </g:applyLayout>
                    <g:applyLayout name="form/input">
                        <content tag="label"><g:message code="account.type.config.invoiceDesign"/></content>
                        <content tag="label.for">invoiceDesign</content>
                        <g:textField class="field" name="invoiceDesign" value="${accountType?.invoiceDesign}"/>
                    </g:applyLayout>
                    <g:applyLayout name="form/input">
                        <content tag="label"><g:message code="account.type.config.creditLimit"/></content>
                        <content tag="label.for">creditLimit</content>
                        <g:textField class="field" name="creditLimitAsDecimal" value="${formatNumber(number: accountType?.creditLimit?:0.0, formatName: 'money.format')}"/>
                    </g:applyLayout>
                    <g:applyLayout name="form/select">
                        <content tag="label"><g:message code="prompt.user.currency"/></content>
                        <content tag="label.for">accountType.currencyId</content>
                        <g:select name="currencyId"
                                  from="${currencies}"
                                  optionKey="id"
                                  optionValue="${{it.getDescription(session['language_id'])}}"
                                  value="${accountType?.currencyId}" />
                    </g:applyLayout>
                    <g:applyLayout name="form/select">
                        <content tag="label"><g:message code="prompt.user.language"/></content>
                        <content tag="label.for">accountType.languageId</content>
                        <g:select name="languageId" from="${LanguageDTO.list()}"
                                  optionKey="id" optionValue="description" value="${accountType?.languageId}"  />
                    </g:applyLayout>

                    <g:applyLayout name="form/input">
                        <content tag="label"><g:message code="account.type.config.creditNotificationLimit1"/></content>
                        <content tag="label.for">creditNotificationLimit1</content>
                        %{--Null if credit notification limit1 is turned off --}%
                        <g:textField class="field" name="creditNotificationLimit1AsDecimal"
                                     value="${accountType?.creditNotificationLimit1 ?
                                             formatNumber(number: accountType?.creditNotificationLimit1?:0, formatName: 'money.format') :
                                             null}"/>
                    </g:applyLayout>
                    <g:applyLayout name="form/input">
                        <content tag="label"><g:message code="account.type.config.creditNotificationLimit2"/></content>
                        <content tag="label.for">creditNotificationLimit2</content>
                        %{--Null if credit notification limit2 is turned off --}%
                        <g:textField class="field" name="creditNotificationLimit2AsDecimal"
                                     value="${accountType?.creditNotificationLimit2 ?
                                             formatNumber(number: accountType?.creditNotificationLimit2?:0, formatName: 'money.format') :
                                             null}" />
                    </g:applyLayout>
                    <g:applyLayout name="form/select">
                        <content tag="label"><g:message code="prompt.invoice.delivery.method"/></content>
                        <content tag="label.for">invoiceDeliveryMethodId</content>
                        <g:select from="${CompanyDTO.get(session['company_id']).invoiceDeliveryMethods.sort{ it.id }}"
                                  optionKey="id"
                                  valueMessagePrefix="customer.invoice.delivery.method"
                                  name="invoiceDeliveryMethodId"
                                  value="${accountType?.invoiceDeliveryMethodId}"/>
                    </g:applyLayout>
                    <g:applyLayout name="form/select">
                        <content tag="label"><g:message code="prompt.payment.method.types"/></content>
                        <content tag="label.for">paymentMethodTypeIds</content>
                        <g:select id="payment-method-select" multiple="multiple" name="paymentMethodTypeIds"
                                  from="${paymentMethodTypes}"
                                  optionKey="id"
                                  optionValue="methodName"
                                  value="${selectedPaymentMethodTypeIds}" />
                    </g:applyLayout>
                    <g:if test="${!isNew}">
                    <g:applyLayout name="form/select">
                        <content tag="label"><g:message code="prompt.include.in.notifications"/></content>
                        <content tag="label.for">infoTypeName</content>
                        <g:select id ="aitName" name="infoTypeName"
                        		  noSelection="['': message(code: 'default.no.selection')]"
                                  from="${AccountTypeDTO.get(accountType?.id)?.informationTypes}"
                                  optionKey="id"
                                  optionValue="name"
                                  value="${accountType.preferredNotificationAitId}" />
                    </g:applyLayout>
                    </g:if>
                </div>
            </div>

        </fieldset>

    </g:form>

		<div id="infoTypeName-change-dialog" title="${message(code: 'popup.confirm.title')}">
        <table style="margin: 3px 0 0 10px">
            <tbody>
            <tr>
                <td valign="top">
                    <img src="${resource(dir:'images', file:'icon34.gif')}" alt="confirm">
                </td>
                <td class="col2" style="padding-left: 7px">
                    <g:message code="ait.prompt.checked.notification" />
                </td>
            </tr>
            </tbody>
        </table>
    </div>

    <div class="btn-box buttons">
        <ul>
            <li>
                <a class="submit save" onclick="$('#save-config-form').submit();">
                    <span><g:message code="button.save"/></span>
                </a>
            </li>
            <li>
                <g:link action="list" class="submit cancel">
                    <span><g:message code="button.cancel"/></span>
                </g:link>
            </li>
        </ul>
    </div>
</div>

<script type="text/javascript">
	var aitName = $('#aitName').val();
    $(document).ready(function(){

        <g:each in="${globalPaymentMethodIds}" var="globalPaymentMethodId">
        $("#payment-method-select").find("[value=${globalPaymentMethodId}]").attr("selected", "selected");
        $("#payment-method-select").find("[value=${globalPaymentMethodId}]").attr("disabled", "disabled");
        </g:each>

    });


    $('#aitName').change(function() {
		if(null != aitName) {
			$('#infoTypeName-change-dialog').dialog('open');
		}
	});

    $('#infoTypeName-change-dialog').dialog({
        autoOpen: false,
        height: 200,
        width: 375,
        modal: true,
        buttons: {
            '<g:message code="prompt.yes"/>': function() {
                $(this).dialog('close');
            },
            '<g:message code="prompt.no"/>': function() {
                $('#aitName').val(aitName);
                $(this).dialog('close');
            }
        }
    });
</script>

</body>
</html>