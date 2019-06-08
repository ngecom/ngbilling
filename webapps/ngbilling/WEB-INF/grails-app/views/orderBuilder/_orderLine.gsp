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

<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="com.sapienter.jbilling.common.CommonConstants"%>
<%@page import="com.sapienter.jbilling.server.util.PreferenceBL"%>
<%@page import="com.sapienter.jbilling.server.item.db.AssetDTO"%>
<%@page import="org.apache.commons.lang.WordUtils"%>
<%@page import="com.sapienter.jbilling.server.item.db.ItemDTO"%>
<%@page import="com.sapienter.jbilling.server.user.db.UserDTO"%>
<%@page import="com.sapienter.jbilling.server.process.db.ProratingType"%>

<%--
  Renders an OrderLineWS as an editable row for the order builder preview pane.

  @author Brian Cowdery
  @since 24-Jan-2011
--%>

<g:set var="product" value="${ItemDTO.get(line.itemId)}"/>
<g:set var="quantityNumberFormat" value="${product?.hasDecimals ? 'money.format' : 'default.number.format'}"/>
<g:set var="editable" value="${line.id > 0}"/>
<g:set var="lineId" value="${line.id}" />
<g:set var="lineDependencies" value="${productDependencies["line_" + lineId]}" />
<g:set var="mandatoryNotMet" value="${lineDependencies?.any{it.type == 'mandatory' && !it.met}}"/>
<g:set var="optionalNotMet" value="${lineDependencies?.any{it.type == 'optional' && !it.met}}"/>
<g:set var="isNew" value="${line.id < 0 ? true : persistedOrderOrderLinesMap[line.orderId]?.every {ln -> ln.id != line.id } }" />

<g:formRemote name="line-${lineId}-update-form" url="[action: 'edit']" update="ui-tabs-review" method="GET">

    <g:hiddenField name="_eventId" value="updateLine"/>
    <g:hiddenField name="execution" value="${flowExecutionKey}"/>
    
    <li id="line-${lineId}" class="line ${editable ? 'active' : ''} ${mandatoryNotMet ? 'mandatory-dependency' : (optionalNotMet ? 'optional-dependency' : '')}">
        <span class="description">
            ${line.description}${planPeriod?.period ?' ('+planPeriod?.period?.getDescription(session['language_id'])+')' : ''} 
            <g:if test="${isNew}">
            	<span class="newOrderLine">(<g:message code="prompt.id.new"/>)</span>
            </g:if>
        </span>
        
        <span class="sub-total">
            <g:set var="subTotal"
                   value="${formatNumber(number: line.getAmountAsDecimal(), type: 'currency', currencySymbol: currency.symbol, maxFractionDigits: 4)}"/>
            <g:message code="order.review.line.total" args="[subTotal]"   encodeAs="None"/>
        </span>
        <span class="qty-price">
            <g:set var="quantity"
                   value="${formatNumber(number: line.getQuantityAsDecimal(), formatName: quantityNumberFormat)}"/>
                <g:set var="price" value="${formatNumber(number: line.getPriceAsDecimal(), type: 'currency', currencySymbol: currency.symbol, maxFractionDigits: 4)}"/>
                <g:message code="order.review.quantity.by.price" args="[quantity, price]"  encodeAs="None"/>
        </span>
        <div style="clear: both;"></div>
    </li>

    <li id="line-${lineId}-editor" class="editor">
        <div class="box">
            <div class="form-columns">

                <g:applyLayout name="form/text">
                    <content tag="label"><g:message code="order.label.quantity"/></content>

                    <content tag="label.for">line-${index}.quantityAsDecimal</content>
                    ${formatNumber(number: line.getQuantityAsDecimal()!=null? line.getQuantityAsDecimal(): BigDecimal.ONE, formatName: quantityNumberFormat)}

                </g:applyLayout>

                    <g:applyLayout name="form/input">
                        <content tag="label"><g:message code="order.label.line.price"/></content>
                        <content tag="label.for">line-${lineId}.priceAsDecimal</content>
                        ${formatNumber(number: line.getPriceAsDecimal() ?: BigDecimal.ZERO, formatName: 'money.format', maxFractionDigits: 4)}
                    </g:applyLayout>

                <g:if test="${editable}">
                        <g:applyLayout name="form/input">
                            <content tag="label"><g:message code="order.label.line.descr"/></content>
                            <content tag="label.for">line-${lineId}.description</content>
                            <g:textField name="line-${lineId}.description" class="field description" value="${line.description}" disabled="${line.useItem}"/>
                        </g:applyLayout>
                </g:if>
                <g:else>
                        <g:applyLayout name="form/text">
                            <content tag="label"><g:message code="order.label.line.descr"/></content>
                            <content tag="label.for">line-${lineId}.description</content>
                            ${line.description}
                        </g:applyLayout>
                </g:else>

                    <g:applyLayout name="form/checkbox">
                        <content tag="label">
                            <g:message code="order.label.line.use.item"/>
                        </content>
                        <content tag="label.for">line-${lineId}.useItem</content>
                        <g:checkBox name="line-${lineId}.useItem" line="${lineId}" class="cb check" value="${line.useItem}" disabled="${!editable}" />

                        <script type="text/javascript">
                            $('#line-${lineId}\\.useItem').change(function() {
                                var line = $(this).attr('line');

                                if ($(this).is(':checked')) {
                                    $('#line-' + line + '\\.description').prop('disabled', 'true');
                                } else {
                                    $('#line-' + line + '\\.description').prop('disabled', '');
                                }
                            }).change();

                            var id="";
                            $('.line,.line .active').click(function(){
	                            if($('#'+$(this).closest('form').attr('id')).find('li.bundled-price').hasClass('bundled-price')){
	                            	//alert("test");
	                            	setTimeout("showLabelOrTextFields(this)",100);
	                            }
	                            id = $(this).attr('id');
                        	});

                        	//This script to show label/text field in create/edit the order page.
                        	function showLabelOrTextFields(){
                        		 if($('#'+id).attr('class').replace(/\s/g, "") =='lineactive'){
                                	$("[id^='textField_']").each(function(){

										$(this).show();
									});
									$("[id^='label_']").each(function(){
										$(this).hide();
									});
                                } else {
                                	$("[id^='textField_']").each(function(){
										$(this).hide();
									});
									$("[id^='label_']").each(function(){
										$(this).show();
									});
                                }
                        	}

                        </script>
                    </g:applyLayout>

                <g:hiddenField name="lineId" value="${lineId}"/>

                %{-- Show/Edit the 'order line metafields' --}%
                <g:if test="${editable && product}">
                    <g:render template="/metaFields/editMetaFields" model="[availableFields: product.orderLineMetaFields, fieldValues: line.metaFields]"/>
                </g:if>
                <g:else>
                    <g:each var="metaField" in="${line.metaFields?.sort{ it.displayOrder }}">
                        <g:render template="/metaFields/displayMetaFieldWS" model="[metaField: metaField]"/>
                    </g:each>
                </g:else>

                <g:if test="${params.plan != "true" && line.hasAssets()}">
                    <g:each var="assetId" in="${line.assetIds}" status="assetIdx">
                        <g:set var="assetObj" value="${AssetDTO.get(assetId)}" />
                        <div title="${assetObj.identifier}" >
                            <g:applyLayout name="form/checkbox">
                                <content tag="label">
                                    <jB:truncateLabel label="${assetObj.identifier}" max="${15}" suffix="..." />
                                </content>
                                <content tag="label.for">line-${lineId}.asset.${assetIdx}</content>
                                <g:if test="${assetIdx == 0}">
                                    <content tag="group.label"><g:message code="order.label.assets"/></content>
                                </g:if>
                            </g:applyLayout>
                        </div>
                    </g:each>
                </g:if>
                <div class="btn-box">
                    <g:if test="${editable}">
                        <a class="submit save" onclick="$('#line-${lineId}-update-form').submit();"><span><g:message
                                    code="button.update"/></span></a>
                        <g:remoteLink class="submit cancel" action="edit" params="[_eventId: 'removeLine', lineId: line.id]"
                                      update="ui-tabs-edit-changes" method="GET">
                            <span><g:message code="button.remove"/></span>
                        </g:remoteLink>
                        <g:remoteLink class="submit add" action="edit" id="${line.id}" params="[_eventId: 'initUpdateLine' ]" update="ui-tabs-edit-changes" method="GET" >
                            <span><g:message code="button.change"/></span>
                        </g:remoteLink>
                        <a class="submit show" onclick="showOrderLineCharges('${line?.id}');">
                            <span><g:message code="button.details"/></span>
                        </a>
                        <g:if test="${lineDependencies}">
                            <a onclick="showDependencies_line('line_${line?.id}');" class="submit add">
                                <span><g:message code="button.show.dependencies"/></span>
                            </a>
                        </g:if>

                    </g:if>
                    <g:else>
                        <g:remoteLink class="submit" action="edit" id="${line.id}" params="[_eventId: 'showChangeForLine' ]" update="ui-tabs-edit-changes" method="GET">
                            <span><g:message code="button.change"/></span>
                        </g:remoteLink>
                    </g:else>
                </div>
            </div>
        </div>
    </li>
</g:formRemote>

