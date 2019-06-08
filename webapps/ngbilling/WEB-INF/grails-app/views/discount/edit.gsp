%{--
     jBilling - The Enterprise Open Source Billing System
   Copyright (C) 2003-2011 Enterprise jBilling Software Ltd. and Emiliano Conde

   This file is part of jbilling.
   
   jbilling is free software: you can redistribute it and/or modify
   it under the terms of the GNU Affero General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   jbilling is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU Affero General Public License for more details.
   
   You should have received a copy of the GNU Affero General Public License
   along with jbilling.  If not, see <http://www.gnu.org/licenses/>.

 This source was modified by Web Data Technologies LLP (www.webdatatechnologies.in) since 15 Nov 2015.
You may download the latest source from webdataconsulting.github.io.

 
  --}%

<%@ page import="com.sapienter.jbilling.server.discount.strategy.DiscountStrategyType; com.sapienter.jbilling.server.util.db.LanguageDTO; org.apache.commons.lang.WordUtils; org.apache.commons.lang.StringUtils; com.sapienter.jbilling.server.util.db.EnumerationDTO; com.sapienter.jbilling.common.CommonConstants" %>
<html>
<head>
    <meta name="layout" content="main" />

    <r:script disposition='head'>
        function validateDate(element) {
            var dateFormat= "<g:message code="date.format"/>";
            if(!isValidDate(element, dateFormat)) {
                $("#error-messages").css("display","block");
                $("#error-messages ul").css("display","block");
                $("#error-messages ul").html("<li><g:message code="invalid.date.format"/></li>");
                element.focus();
                return false;
            } else {
                return true;
            }
        }
        
        function addDiscountAttribute(element, attributeIndex) {
            $('#attributeIndex').val(attributeIndex);

            $.ajax({
                       type: 'POST',
                       url: '${createLink(action: 'addAttribute')}',
                       data: $('#discountStrategy').parents('form').serialize(),
                       success: function(data) { $('#discountStrategy').replaceWith(data); }
                   });
        }

        function removeDiscountAttribute(element, attributeIndex) {
            $('#attributeIndex').val(attributeIndex);

            $.ajax({
                       type: 'POST',
                       url: '${createLink(action: 'removeAttribute')}',
                       data: $('#discountStrategy').parents('form').serialize(),
                       success: function(data) { $('#discountStrategy').replaceWith(data); }
                   });
        }
    </r:script>
    <r:external file="js/form.js" />
</head>
<body>
<div class="form-edit">

    <g:set var="isNew" value="${!discount || !discount?.id || discount?.id == 0}"/>
    <g:set var="types" value="${DiscountStrategyType.values()}"/>
    <g:set var="type" value="${!StringUtils.isEmpty(discount?.type?.trim()) ? DiscountStrategyType.valueOf(discount.type) : (types ? types[0] : null)}"/>
    <g:set var="templateName" value="${WordUtils.uncapitalize(WordUtils.capitalizeFully(type.name(), ['_'] as char[]).replaceAll('_',''))}"/>


    <div class="heading">
        <strong>
            <g:if test="${isNew}">
                New Discount
            </g:if>
            <g:else>
                Edit Discount
            </g:else>
        </strong>
    </div>

    <div class="form-hold">
        <g:form name="discount-edit-form" action="saveDiscount">
            <fieldset>
                <div class="form-columns">

                    <!-- discount details column -->
                    <div class="column">
						<g:applyLayout name="form/text">
                            <content tag="label"><g:message code="discount.id"/></content>

                            <g:if test="${isNew}"><em><g:message code="prompt.id.new"/></em></g:if>
                            <g:else>${discount?.id}</g:else>

                            <g:hiddenField name="discount.id" value="${discount?.id}"/>
                        </g:applyLayout>

                        <g:applyLayout name="form/input">
                            <content tag="label"><g:message code="discount.code"/><span id="mandatory-meta-field">*</span></content>
                            <content tag="label.for">discount.code</content>
                            <g:textField class="field" name="discount.code" value="${discount?.code}" size="20"/>
                        </g:applyLayout>
                        
                        <g:render template="/descriptions/descriptions" model="[multiLingualEntity: discount, itemName: 'discount']"/>
                        
                        <g:render id="strategyTemplate" template="/discount/strategy/${templateName}" model="[discount: discount]" />
                        
                        <g:applyLayout name="form/input">
                            <content tag="label"><g:message code="discount.rate"/><span id="mandatory-meta-field">*</span></content>
                            <content tag="label.for">discount.rate</content>
                      		<g:textField class="field" name="discount.rate"
                                         value="${discount?.rate?.isNumber() ? formatNumber(number: discount?.rate?:0, formatName: 'price.format'):discount?.rate}" size="20"/>
                        </g:applyLayout>
                        
                        <g:applyLayout name="form/date">
                            <content tag="label"><g:message code="discount.startDate"/></content>
                            <content tag="label.for">discount.startDate</content>
                            <g:textField class="field" name="discount.startDate"
                                         value="${formatDate(date: discount?.startDate, formatName:'datepicker.format')}" onblur="validateDate(this);" />
                        </g:applyLayout>
                        
                        <g:applyLayout name="form/date">
                            <content tag="label"><g:message code="discount.endDate"/></content>
                            <content tag="label.for">discount.endDate</content>
                            <g:textField class="field" name="discount.endDate"
                                         value="${formatDate(date: discount?.endDate, formatName:'datepicker.format')}" onblur="validateDate(this);" />
                        </g:applyLayout>
                        
                        <!-- meta fields -->
                        <g:render template="/metaFields/editMetaFields" model="[ availableFields: availableFields, fieldValues: discount?.metaFields ]"/>

                    </div>
                    
                </div>

				<!-- spacer -->
				<div>
					<br/>&nbsp;
				</div>

                <div class="buttons">
                    <ul>
                        <li>
                            <a onclick="$('#discount-edit-form').submit()" class="submit save"><span><g:message code="button.save"/></span></a>
                        </li>
                        <li>
                            <g:link action="list" class="submit cancel"><span><g:message code="button.cancel"/></span></g:link>
                        </li>
                    </ul>
                </div>

            </fieldset>
        </g:form>
    </div>
</div>
</body>
</html>
