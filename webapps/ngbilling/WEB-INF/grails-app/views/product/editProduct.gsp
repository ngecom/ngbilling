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

<%@ page import="com.sapienter.jbilling.server.user.db.CompanyDTO; com.sapienter.jbilling.server.metafields.MetaFieldBL; com.sapienter.jbilling.server.metafields.DataType; com.sapienter.jbilling.server.metafields.EntityType; com.sapienter.jbilling.server.metafields.db.MetaFieldDAS; com.sapienter.jbilling.server.metafields.MetaFieldWS; com.sapienter.jbilling.common.CommonConstants; com.sapienter.jbilling.server.util.db.EnumerationDTO; com.sapienter.jbilling.server.util.db.CurrencyDTO; com.sapienter.jbilling.server.util.db.LanguageDTO; com.sapienter.jbilling.server.item.db.ItemTypeDTO" %>

<r:require module="errors" />

<html>
<head>
    <meta name="layout" content="main" />

    <r:script>
        var getCategoriesCompaniesLink = '${g.createLink(controller: 'product', action: 'getCategoriesCompanies')}';

        $(document).ready(function() {
            $('#product\\.percentageAsDecimal').blur(function() {
                if ($(this).val()) {
                    $('#pricing :input:not(#startDate)').val('').prop('disabled', 'true');
                    $('#product\\.excludedTypes').prop('disabled', '');
                    closeSlide('#pricing');
                } else {
                    $('#pricing :input').prop('disabled', '');
                    $('#product\\.excludedTypes').val('').prop('disabled', 'true');
					$('#pricing #startDate').val('01/01/1970')
                    //the model.i.oldType field takes the value of the first option of te available modelTypes
                    $("[id$='oldType']").each(function(i, o){
                        $(o).val($(o).siblings("[id$='type']").find("option:first").val())
                    });

                    openSlide('#pricing');
                }
                
            }).blur();
			
			if ($("#global-checkbox").is(":checked")) {
				$("#company-select").attr('disabled', true);
			}
			
            $('#product\\.standardAvailability').click(function() {
                var $this = $(this);
                if ($this.is(':checked')) {
                    $('#product\\.accountTypes').prop('disabled', 'true');
                } else {
                    $('#product\\.accountTypes').val('').prop('disabled', '');
                }
            });

			hidePriceCurrency();

            var validator = $('#save-product-form').validate();
            validator.init();
            validator.hideErrors();
            
        });


		function hideCompanies(){
			$("#company-select option").removeAttr("selected");
			if ($("#global-checkbox").is(":checked")) {
				$("#company-select").attr('disabled', true);
				$.ajax({
                	type: 'POST',
                	url: '${createLink(action: 'retrieveAllMetaFields')}',
                	success: function(data) {
                		document.getElementById('product-metafields').innerHTML=data;
    						}
            		});
			} else {
				$("#company-select").removeAttr('disabled');
				$.ajax({
                	type: 'POST',
                	url: '${createLink(action: 'getAvailableMetaFields')}',
                	success: function(data) {
                		document.getElementById('product-metafields').innerHTML=data;
    						}
            		});
			}
		}
		
		function submitForm() {
			$("#company-select").removeAttr('disabled');
			$('#save-product-form').submit();
		}
			

        function checkAssetManagement(obj) {
        var assetManagementEnabledDiv = $('#assetManagementEnabledDiv');
        var assetManagementEnabled = $('#assetManagementEnabled');
            var selected = $(obj).val();
            var selectName = $(obj).attr('name');

            for(var i=0; i< selected.length; i++ ) {
                if(categoryAsstMan[selected[i]]) {
                    if(!assetManagementEnabledDiv.is(':visible')) {
                        assetManagementEnabledDiv.show();
                        assetManagementEnabled.show();
                    }
                    return;
                }
            }
            if(assetManagementEnabledDiv.is(':visible')) {
                assetManagementEnabledDiv.hide();
                assetManagementEnabled.prop('checked', false);
                $("#assetReservationDuration").hide();
                assetManagementEnabled.hide();
            }

            $.ajax({
                type: "POST",
                cache: false,
                url:getCategoriesCompaniesLink,
                data:  { productTypes : selected }
            }).done(function(data) {
                $('#company-select').empty().append(data);
            });

        }

        function checkGlobalCategory(obj){
        var globalEnabledDiv = $('#globalEnabledDiv');
        var globalCheckbox = $('#global-checkbox');
        var selected = $(obj).val();
            for(var i=0; i< selected.length; i++ ) {
            if(isCategoryGlobal[selected[i]]) {
                    if(!globalEnabledDiv.is(':visible')) {
                        globalEnabledDiv.show();
                        globalCheckbox.show();
                    }
                    return;
                }
            }
            if(globalEnabledDiv.is(':visible')) {
                 globalEnabledDiv.hide();
                 globalCheckbox.prop('checked', false);
                 hideCompanies();
                 globalCheckbox.hide();
            }
        }

        function getSelectValues(select) {
        	  var result = [];
        	  var options = select && select.options;
        	  var opt;

        	  for (var i=0, iLen=options.length; i!=iLen; i++) {
        	    opt = options[i];
				
        	    if (opt.selected) {
        	      result.push(opt.value || opt.text);
        	      result.push(",")
        	    }
        	  }
        	  return result;
       }
    </r:script>
    <script type="text/javascript">
    var categoryAsstMan = {
            <g:each in="${categories}" var="category" status="catIdx">
            <g:if test="${catIdx > 0}">,</g:if>${category.id}: Boolean(${category.allowAssetManagement == 1 ? '1' : '0'})
    </g:each>
    };
    var isCategoryGlobal = {
            <g:each in="${categories}" var = "cat" status="catIds">
            <g:if test="${catIds > 0}">, </g:if>${cat.id}:
    Boolean(${cat.global ? '1' : 0})
    </g:each>
    }
    ;
</script>
</head>
<body>

<div class="form-edit">

    <g:set var="isNewProduct" value="${!product || !product?.id || product?.id == 0}"/>

    <div class="heading">
        <strong>
            <g:if test="${isNewProduct}">
                <g:message code="product.add.title"/>
            </g:if>
            <g:else>
                <g:message code="product.edit.title"/>
            </g:else>
        </strong>
    </div>

    <div class="form-hold">
        <g:form name="save-product-form" action="saveProduct">
            <g:hiddenField name="selectedCategoryId" value="${categoryId}"/>
            <fieldset>
                <!-- product info -->
                <div class="form-columns">
                    <div class="column">
                        <g:applyLayout name="form/text">
                            <content tag="label"><g:message code="product.id"/></content>

                            <g:if test="${isNewProduct}"><em><g:message code="prompt.id.new"/></em></g:if>
                            <g:else>${product?.id}</g:else>

                            <g:hiddenField name="product.id" value="${product?.id}"/>
                        </g:applyLayout>

                        <g:render template="/descriptions/descriptions" model="[multiLingualEntity: product, itemName: 'product']"/>

                        <g:applyLayout name="form/checkbox">
                            <content tag="label"><g:message code="product.allow.decimal.quantity"/></content>
                            <content tag="label.for">product.hasDecimals</content>
                            <g:checkBox class="cb checkbox" name="product.hasDecimals" checked="${product?.hasDecimals > 0}"/>
                        </g:applyLayout>
                        
                        <g:applyLayout name="form/checkbox">
                            <content tag="label"><g:message code="product.standardAvailability"/></content>
                            <content tag="label.for">product.standardAvailability</content>
                            <g:checkBox class="cb checkbox" name="product.standardAvailability" checked="${product ? product.standardAvailability : true}"/>
                        </g:applyLayout>

                        <g:applyLayout name="form/select">
                            <content tag="label"><g:message code="product.accountTypes"/></content>
                            <content tag="label.for">product.accountTypes</content>

                            <g:set var="accountTypes" value="${product?.accountTypes?.collect{ it as Integer }}"/>
                            <g:select name="product.accountTypes" multiple="true"
                                      from="${availableAccountTypes}"
                                      optionKey="id"
                                      disabled="${product? product.standardAvailability : true}"
                                      optionValue="${{it.getDescription(session['language_id'])}}"
                                      value="${accountTypes}"/>
                        </g:applyLayout>

                        <div id="assetManagementEnabledDiv" class="${!allowAssetManagement ? 'hide-element' : ''}">
                            <g:applyLayout name="form/checkbox">
                                <content tag="label"><g:message code="product.allow.asset.management"/></content>
                                <content tag="label.for">assetManagementEnabled</content>
                                <g:checkBox id="assetManagementEnabled" class="cb checkbox" name="product.assetManagementEnabled" checked="${product?.assetManagementEnabled > 0}"/>
                            </g:applyLayout>
                        </div>

                        <div id="globalEnabledDiv" class="${!isCategoryGlobal ? 'hide-element' : ''}">
						<g:if test="${isNewProduct || showEntityListAndGlobal}">            
                        	<g:isGlobal>
                        		<g:applyLayout name="form/checkbox">
                            		<content tag="label"><g:message code="product.assign.global"/></content>
                            		<content tag="label.for">global-checkbox</content>
                            		<g:checkBox id="global-checkbox" 
                            					onClick="hideCompanies()"
                                                class="cb checkbox ${!isCategoryGlobal ? 'hide-element' : ''}" name="product.global"
                                                checked="${product?.global}" />
                        		</g:applyLayout>
                        	</g:isGlobal>
                        	<g:isNotRoot>
                        		<g:hiddenField name="product.global" value="${product?.global}"/>
                        	</g:isNotRoot>
                        </g:if>
                        </div>

                        <div id="childCompanies">          
                       		<g:isRoot>
                       			<g:applyLayout name="form/select">
                           			<content tag="label"><g:message code="product.assign.entities"/><span id="mandatory-meta-field">*</span></content>
                           			<content tag="label.for">product.entities</content>
                           			<g:select id="company-select" multiple="multiple" name="product.entities" from="${allCompanies}"
                                   			  optionKey="id" optionValue="${{it?.description}}"
                           	    	    	  value="${allCompanies.size == 1 ? allCompanies?.id : entities}"
                           	    	    	  onChange="${remoteFunction(action: 'retrieveMetaFields',
                  										  update: 'product-metafields',
                  										  params: '\'entities=\' + getSelectValues(this)')}"/>
                        		</g:applyLayout>
                        	</g:isRoot>
                        	<g:isNotRoot>
                        		<g:if test="${product?.entities?.size()>0}">
                                    <g:each in="${product?.entities}">
                                        <g:hiddenField name="product.entities" value="${it}"/>
                                    </g:each>
                        		</g:if>
                        		<g:else>
                        				<g:hiddenField name="product.entities" value="${session['company_id']}"/>
								</g:else>
                        	</g:isNotRoot>
                        </div>

                        <g:applyLayout name="form/checkbox">
                            <content tag="label"><g:message code="product.allow.manual.pricing"/></content>
                            <content tag="label.for">product.priceManual</content>
                            <g:checkBox class="cb checkbox" name="product.priceManual" checked="${product?.priceManual > 0}"/>
                        </g:applyLayout>

                        <!-- meta fields -->
                        <div id="product-metafields">
                        	<g:render template="/metaFields/editMetaFields" model="[availableFields: availableFields, fieldValues: product?.metaFields]"/>
                        </div>
                    </div>

                    <div class="column">
                        <g:applyLayout name="form/input">
                            <content tag="label"><g:message code="product.internal.number"/><span id="mandatory-meta-field">*</span></content>
                            <content tag="label.for">product.number</content>
                            <g:textField class="field" name="product.number" value="${product?.number}" size="40"/>
                        </g:applyLayout>

                        <g:applyLayout name="form/input">
                            <content tag="label"><g:message code="product.gl.code"/></content>
                            <content tag="label.for">product.glCode</content>
                            <g:textField class="field" name="product.glCode" value="${product?.glCode}" size="40"/>
                        </g:applyLayout>

                        <g:applyLayout name="form/input">
                            <content tag="label"><g:message code="product.standardPartnerPercentage"/></content>
                            <content tag="label.for">product.standardPartnerPercentage</content>
                            <g:textField class="field" name="product.standardPartnerPercentageAsDecimal" value="${g.formatNumber(number: product?.standardPartnerPercentage, formatName: 'money.format')}" size="40"/>
                        </g:applyLayout>

                        <g:applyLayout name="form/input">
                            <content tag="label"><g:message code="product.masterPartnerPercentage"/></content>
                            <content tag="label.for">product.masterPartnerPercentage</content>
                            <g:textField class="field" name="product.masterPartnerPercentageAsDecimal" value="${g.formatNumber(number: product?.masterPartnerPercentage, formatName: 'money.format')}" size="40"/>
                        </g:applyLayout>

                        <g:applyLayout name="form/select">
                            <content tag="label"><g:message code="product.categories"/></content>
                            <content tag="label.for">product.types</content>

                            <g:set var="types" value="${product?.types?.collect{ it as Integer }}"/>
                            <g:select name="product.types" multiple="true"
                                      from="${categories}"
                                      optionKey="id"
                                      optionValue="${{it.description + (it.allowAssetManagement == 1 ? "*" : "")}}"
                                      value="${types ?: categoryId}"
                                      onchange="checkAssetManagement(this);checkGlobalCategory(this)"/>
                            <label for="">&nbsp;</label>
                            <span class="normal">*&nbsp;<g:message code="product.categories.with.assetmanagement"/></span>
                        </g:applyLayout>

                        <g:applyLayout name="form/select">
                            <content tag="label"><g:message code="product.excludedCategories"/></content>
                            <content tag="label.for">product.excludedTypes</content>

                            <g:set var="types" value="${product?.excludedTypes?.collect{ it as Integer }}"/>
                            <g:select name="product.excludedTypes" multiple="true"
                                      from="${categories}"
                                      optionKey="id"
                                      optionValue="description"
                                      value="${types}"/>
                        </g:applyLayout>
                        
                        <g:applyLayout name="form/date">
			                <content tag="label"><g:message code="product.detail.availability.start.date"/></content>
			                <content tag="label.for">product.activeSince</content>
			                <g:textField class="field" name="product.activeSince" value="${formatDate(date: product?.activeSince, formatName: 'datepicker.format')}"/>
			            </g:applyLayout>
			
			            <g:applyLayout name="form/date">
			                <content tag="label"><g:message code="product.detail.availability.end.date"/></content>
			                <content tag="label.for">product.activeUntil</content>
			                <g:textField class="field" name="product.activeUntil" value="${formatDate(date: product?.activeUntil, formatName: 'datepicker.format')}"/>
			            </g:applyLayout>

                        <div id="assetReservationDuration">
                            <g:applyLayout name="form/input">
                                <content tag="label"><g:message code="product.category.assetReservationDurationLabel"/></content>
                                <content tag="label.for">product.reservationDuration</content>
                                <g:textField class="field" name="product.reservationDuration" value="${g.formatNumber(number: product?.reservationDuration ?: assetReservationDefaultValue, formatName: 'asset.reservation.duration.format')}"/>
                            </g:applyLayout>
                        </div>

                    </div>
                </div>

                <!-- spacer -->
                <div>
                    <br/>&nbsp;
                </div>

                <!-- pricing controls -->
                <div id="pricing" class="box-cards box-cards-open">
                    <div class="box-cards-title">
                        <a class="btn-open" href="#"><span><g:message code="product.prices"/></span></a>
                    </div>
					<div class="box-card-hold">
                        <div class="form-columns">
                            <div class="column">
                                <g:each var="currency" in="${currencies.sort{ it.id }}">
                                    <g:applyLayout name="form/input">
                                        <content tag="label">${currency.getDescription(session['language_id'])}</content>
                                        <content tag="label.for">prices.${currency.id}</content>

                                        <g:set var="itemPrice" value="${product?.prices?.find { it.currencyId == currency.id }}"/>
                                        <g:textField class="field" name="prices.${currency.id}" value="${itemPrice?.price}"/>
                                    </g:applyLayout>
                                </g:each>
                            </div>

                            <div class="column">

                            </div>
                        </div>
                    </div>
                </div>

                <!-- dependencies controls -->
                <div id="dependency" class="box-cards">
                    <div class="box-cards-title">
                        <a class="btn-open" href="#"><span><g:message code="product.dependencies"/></span></a>
                    </div>
                    <div class="box-card-hold">
                        <g:render template="dependencies" model="[selectedProduct: product,
                                dependencyItemTypes : dependencyItemTypes,
                                dependencyItems: dependencyItems,
                                dependentTypes: dependentTypes,
                                dependentItems: dependentItems]" />
                    </div>
                </div>

                <%-- meta fields controls --%>
                <div id="orderLineMetaFields" class="box-cards ${product?.id > 0 || orderLineMetaFields?.length > 0? 'box-cards-open' : '' }">
                    <div class="box-cards-title">
                        <a class="btn-open" href="#"><span><g:message
                                code="product.orderLineMetafields.description"/></span></a>
                    </div>

                    <div class="box-card-hold">
                        <%-- buttons to add empty meta field or from templates  class="type-metafield-menu" --%>
                        <div class="type-metafield-header">

                        <div class="btn-row">
                            <span class="type-metafield-menu">

                                <label for="metaFieldTemplate.id"><g:message
                                        code="product.orderLineMetafields.import"/></label>
                                <g:select name="metaFieldTemplate.id" id="metaFieldTemplate-id" class="field"
                                          from="${new MetaFieldDAS().getAvailableFields(session['company_id'], [EntityType.ORDER_LINE] as EntityType[], true).findAll {it.isDisabled()==false}}"
                                          optionKey="id"
                                          optionValue="name"/>

                                <a onclick="${remoteFunction(action: 'populateProductOrderLineMetaFieldForEdit',
                                        update: [success: 'meta-field-load-target', failure: 'meta-field-load-target'],
                                        onComplete: 'moveMetaFieldsFromTemplate()',
                                        params: '\'mfId=\' + $(\'#metaFieldTemplate-id\').val() + \'&startIdx=\' + (metaFieldIdx+1) + \'&entityType=' + EntityType.ORDER_LINE + '\'')}">
                                    <img src="${resource(dir: 'images', file: 'add.png')}" alt="add"/>
                                </a>
                            </span>

                            <a onclick="addMetaField();" class="submit add" style="width: 150px;"><span><g:message code="button.add.new.metaField"/></span></a>
                        </div>
                        </div>

                        <div>
                            <ul id="orderLine-metafield-lines">
                                <% params.entityType = com.sapienter.jbilling.server.metafields.EntityType.ORDER_LINE.name(); %>
                                <g:render template="editProductMetaFieldsCollection"
                                          model="[metaFields: orderLineMetaFields, startIdx: 1]"/>
                            </ul>
                        </div>
                    </div>

                </div>

                <!-- spacer -->
                <div>
                    <br/>&nbsp;
                </div>

                <div class="buttons">
                    <ul>
                        <li><a onclick="$('#save-product-form').submit();" class="submit save"><span><g:message code="button.save"/></span></a></li>
                        <li><g:link controller="product" action="list" class="submit cancel"><span><g:message code="button.cancel"/></span></g:link></li>
                    </ul>
                </div>

            </fieldset>
        </g:form>

        <%-- meta fields from groups or already created ones are loaded here before being moved into the list --%>
        <div id="meta-field-load-target" style="display: none">
        </div>

        <%-- template used to create empty meta fields--%>
        <div id="meta-field-template" style="display: none">
            <li id="line-_mfIdx_" class="line active">
                <span id="metaField-header-desc-_mfIdx_" class="description">-</span>
                <span id="metaField-header-datatype-_mfIdx_" class="data-type">-</span>
                <span id="metaField-header-mandatory-_mfIdx_" class="mandatory"><g:message code="product.orderLineMetafields.notMandatory"/></span>
                <div style="clear: both;"></div>
            </li>

            <li id="line-_mfIdx_-editor" class="editor open">
                <% params.entityType = com.sapienter.jbilling.server.metafields.EntityType.PRODUCT.name(); %>
                <div class="box">
                    <g:render template="/metaFields/editMetafield"
                               model="[metaField: new MetaFieldWS(), entityType: EntityType.PRODUCT,
                                       parentId: '', metaFieldIdx: '_mfIdx_', displayMetaFieldType: false]"/>
                </div>
                <div class="btn-row">
                    <a class="submit save" onclick="$('#line-_mfIdx_').trigger('click');"><span><g:message
                            code="button.update"/></span></a>
                    <a class="submit cancel" onclick="$('#line-_mfIdx_').remove();
                                        $('#line-_mfIdx_-editor').remove();"><span><g:message
                                                code="button.remove"/></span></a>
                </div>
            </li>

        </div>
    </div>
	<div id="refresh-price-dialog" class="ui-dialog-title">
    	<div id="impersonation-text"><g:message code="product.discard.company.prices"/></div>
    	<div>
            <br/>&nbsp;
        </div>
    	<div class="buttons">
    		<ul>
    			<li><a onclick="forceRefreshPrice()" class="submit select"><span><g:message code="prompt.yes"/></span></a></li>
    			<li><a onclick="$('#refresh-price-dialog').dialog('close'); document.getElementById('product.priceModelCompanyId').value = document.getElementById('priceModelCompanyId').value;" class="submit select"><span><g:message code="prompt.no"/></span></a></li>
    		</ul>
    	</div>
	</div>
	
</div>
</body>
<r:script>

	$(document).ready(function () {
	    	if('${subscriptionCategory}'  == 'true') {
        		$('#assetManagementEnabled').prop('checked',true);
        		$("#assetReservationDuration").show();
        	}
        	if(!$('#assetManagementEnabled').is(":checked")) {
                $("#assetReservationDuration").hide();
        	}

        	$('#assetManagementEnabled').change(function() {
                if ($(this).is(":checked")) {
                    $("#assetReservationDuration").show();
                } else {
                    $("#assetReservationDuration").hide();
                }
            });
	});
    <%-- move meta fields loaded from template to the list of editable meta fields--%>
    function moveMetaFieldsFromTemplate() {
        var metaFields = $("#meta-field-load-target").children().detach();
        metaFieldIdx += metaFields.length;
        $("#orderLine-metafield-lines").append(metaFields);
    }

    var metaFieldIdx = ${1 + (orderLineMetaFields != null ? product.orderLineMetaFields.size() : 0)};

    <%-- Add a new empty meta field line to the table --%>
    function addMetaField() {
        metaFieldIdx ++;
        <%-- Clone the template --%>
        var template = $("#meta-field-template").clone().html().replace(/_mfIdx_/g, metaFieldIdx);
        $("#orderLine-metafield-lines").append(template);


        <%-- Display the correct input depending if the type is list or enumeration --%>
        $('#metaField'+metaFieldIdx+'\\.dataType').change(function () {
            var idx = $(this).prop('id').substring(9, $(this).prop('id').length - 9);
            $('#metaField-header-datatype-'+idx).html($(this).val());

            var visibleFieldId;
            if ($(this).val() == '${DataType.ENUMERATION}' || $(this).val() == '${DataType.LIST}') {
                $('#field-name'+idx).hide().find('input').prop('disabled', 'true');
                $('#field-enumeration'+idx).show().find('select').prop('disabled', '');
                $('#field-filename'+idx).hide().find('input').prop('disabled', 'true')
                visibleFieldId = '#field-enumeration'+idx;
            } else if ($(this).val() == '${DataType.SCRIPT}'){
                $('#field-name'+idx).show().find('input').prop('disabled', '');
                $('#field-enumeration'+idx).hide().find('select').prop('disabled', 'true');
                $('#field-filename'+idx).show().find('input').prop('disabled', '')
                visibleFieldId = '#field-filename'+idx;
            } else {
                $('#field-name'+idx).show().find('input').prop('disabled', '');
                $('#field-enumeration'+idx).hide().find('select').prop('disabled', 'true');
                $('#field-filename'+idx).hide().find('input').prop('disabled', 'true')
                visibleFieldId = '#field-name'+idx;
            }
            var newName = $(visibleFieldId + ' #metaField'+idx+'\\.name').val();
            if(newName == '') {
                newName = '-';
            }
            $('#metaField-header-desc-'+idx).html(newName)
        }).change();

        <%-- Set the header to the name of the meta field --%>
        $('#metaField'+metaFieldIdx+'\\.name').change(function () {
            var idx = $(this).prop('id').substring(9, $(this).prop('id').length - 5);
            $('#metaField-header-desc-'+idx).html($(this).val())
        });

        <%-- Set mandatory depending on the checkbox--%>
        $('#metaField'+metaFieldIdx+'\\.mandatory').change(function () {
            var idx = $(this).prop('id').substring(9, $(this).prop('id').length - 10);
            $('#metaField-header-mandatory-'+idx).html($(this).is(':checked')
                                ? '<g:message code="product.orderLineMetafields.isMandatory"/>'
                                : '<g:message code="product.orderLineMetafields.notMandatory"/>')
        });

        <%-- enable drop down effect when user clicks on a row header --%>
        $('#line-'+metaFieldIdx).click(function() {
            var id = $(this).attr('id');
            $('#' + id).toggleClass('active');
            $('#' + id + '-editor').toggle('blind');
        });
    }
    
  	function refreshChainModel() {
       	$.ajax({
        	type: 'POST',
            url: '${createLink(action: 'refreshChainModel')}',
            data: $('#priceModel').parents('form').serialize(),
            success: function(data) { $('#priceModel').replaceWith(data); },
            error: function(data) { showRefreshDialog(); }
       	});
  	}
  	
  	 function showRefreshDialog() {
    	$( "#refresh-price-dialog" ).dialog( "open" );
    }
    
    function forceRefreshPrice() {
    	document.getElementById('forceRefreshModel').value = 1;
    	refreshChainModel();
    	$( "#refresh-price-dialog" ).dialog( "close" );
    }
    
    $(function() {
        $('#refresh-price-dialog').dialog({
            autoOpen: false,
            height: 140,
            width: 420,
            modal: true,
        });
    });
</r:script>
</html>
