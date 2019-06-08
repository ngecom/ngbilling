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

<%@ page import="com.sapienter.jbilling.server.user.db.CompanyDTO; com.sapienter.jbilling.server.order.db.OrderPeriodDTO; com.sapienter.jbilling.server.discount.strategy.DiscountStrategyType; org.apache.commons.lang.StringUtils" %>

<%--
  Editor form for discount attributes.
  @author Amol Gadre
  @since  29-Nov-2012
--%>

<g:set var="attributeIndex" value="${0}"/>
<g:set var="attributes" value="${discount?.attributes ? new TreeMap<String, String>(discount.attributes) : new TreeMap<String, String>()}"/>
<g:set var="type" value="${!StringUtils.isEmpty(discount?.type?.trim()) ? DiscountStrategyType.valueOf(discount.type) : (types ? types[0] : null)}"/>

<!-- all attribute definitions -->
<g:each var="definition" in="${type?.strategy?.attributeDefinitions}">
    <g:set var="attributeIndex" value="${attributeIndex + 1}"/>

    <g:set var="attribute" value="${discount?.attributes?.get(definition.name)}"/>

    <g:if test="${definition.name== 'isPercentage'}">
        <g:hiddenField name="discount.attribute.${attributeIndex}.name" value="${definition.name}"/>
        <g:applyLayout name="form/checkbox">
            <content tag="label"><g:message code="discount.attribute.${definition.name}"/></content>
            <content tag="label.for">discount.attribute.${attributeIndex}.value</content>
            <g:checkBox class="cb checkbox" name="discount.attribute.${attributeIndex}.value" checked="${attribute!=null && (attribute.equals('on') || attribute.equals('1'))}"/>
        </g:applyLayout>
    </g:if>

    <g:elseif test="${definition.name == 'periodUnit'}">
        <g:hiddenField name="discount.attribute.${attributeIndex}.name" value="${definition.name}"/>
        <g:applyLayout name="form/select">
            <content tag="label"><g:message code="discount.attribute.${definition.name}"/></content>
            <content tag="label.for">discount.attribute.${attributeIndex}.value</content>
            <g:select name="discount.attribute.${attributeIndex}.value"
                      from="${OrderPeriodDTO.findAllByCompany(new CompanyDTO(session['company_id']), [sort: 'id'])}"
                      optionKey="id" optionValue="${{it.description}}"
                      value="${attribute as Integer}"/>
        </g:applyLayout>
    </g:elseif>

    <g:else>
        <g:applyLayout name="form/input">
            <content tag="label"><g:message code="discount.attribute.${definition.name}"/></content>
            <content tag="label.for">discount.attribute.${attributeIndex}.value</content>

            <g:hiddenField name="discount.attribute.${attributeIndex}.name" value="${definition.name}"/>
            <g:textField class="field" name="discount.attribute.${attributeIndex}.value"
                         value="${attribute}"/>
        </g:applyLayout>
    </g:else>
</g:each>

<g:hiddenField name="attributeIndex" value="${attributeIndex}" />

<script type="text/javascript">

	$(function() {
        $('.model-type').change(function() {
            updateStrategy();
        });
    });

    function updateStrategy() {
        $.ajax({
            type: 'POST',
            url: '${createLink(action: 'updateStrategy')}',
            data: $('#discountStrategy').parents('form').serialize(),
            success: function(data) {
                $('#discountStrategy').replaceWith(data);
                $("#discount\\.type").val($('#discount\\.oldType').val());
            }
        });
    }

</script>
