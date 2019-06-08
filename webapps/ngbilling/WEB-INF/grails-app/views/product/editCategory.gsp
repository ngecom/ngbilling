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

<%@page import="java.lang.System"%>
<%@ page import="grails.plugin.springsecurity.SpringSecurityService; com.sapienter.jbilling.server.user.db.CompanyDTO; com.sapienter.jbilling.server.metafields.db.MetaFieldDAS; com.sapienter.jbilling.server.metafields.EntityType; com.sapienter.jbilling.server.metafields.db.MetaFieldGroupDAS; com.sapienter.jbilling.server.metafields.DataType; com.sapienter.jbilling.server.metafields.MetaFieldWS; com.sapienter.jbilling.server.metafields.MetaFieldBL; com.sapienter.jbilling.server.metafields.db.MetaField; com.sapienter.jbilling.server.order.db.OrderLineTypeDTO;com.sapienter.jbilling.server.item.db.ItemTypeDTO" %>

<r:require module="errors" />

<html>
<head>
    <meta name="layout" content="main"/>
</head>

<body>
<div class="form-edit">

    <g:set var="isNew" value="${!category || !category?.id || category?.id == 0}"/>

    <div class="heading">
        <strong>
            <g:if test="${isNew}">
                <g:message code="product.category.add.title"/>
            </g:if>
            <g:else>
                <g:message code="product.category.edit.title"/>
            </g:else>
        </strong>
    </div>

    <div class="form-hold">
        <g:form name="save-category-form" action="saveCategory">

        <g:hiddenField name="entityId" value="${entityId}"/>

            <fieldset>
                <div class="form-columns">
                    <div class="column">
                        <g:applyLayout name="form/text">
                            <content tag="label"><g:message code="product.category.id"/></content>

                            <g:if test="${isNew}"><em><g:message code="prompt.id.new"/></em></g:if>
                            <g:else>${category?.id}</g:else>

                            <g:hiddenField name="id" value="${category?.id}"/>
                        </g:applyLayout>

                        <g:applyLayout name="form/select">
                            <content tag="label"><g:message code="product.category.type"/></content>
                            <g:select name="orderLineTypeId" from="${OrderLineTypeDTO.list()}"
                                      optionKey="id" optionValue="description"
                                      value="${category?.orderLineTypeId}"
                                      onChange="verifyAssetManagement(this.value)"/>
                        </g:applyLayout>

                        <g:applyLayout name="form/select">
                            <content tag="label"><g:message code="parent.product.category"/></content>
                            <g:if test="${category instanceof ItemTypeDTO}">
                            	<g:select name="parentItemTypeId" from="${parentCategories}"
                                      optionKey="id" optionValue="description"
                                      noSelection="['': message(code: 'default.no.selection')]"
                                             value="${category?.parent?.id}" />
       						</g:if>
       						<g:else>
       							<g:select name="parentItemTypeId" from="${parentCategories}"
                                      optionKey="id" optionValue="description"
                                      noSelection="['': message(code: 'default.no.selection')]"
                                      value="${category?.parentItemTypeId}" />
                            </g:else>
                        </g:applyLayout>

     				    <g:isGlobal>
                        	<g:applyLayout name="form/checkbox">
                            	<content tag="label"><g:message code="product.assign.global"/></content>
                            	<content tag="label.for">global-checkbox</content>
                            	<g:checkBox id="global-checkbox" onClick="hideCompanies()" class="cb checkbox" name="global" checked="${category?.global}"/>
                        	</g:applyLayout>
                        </g:isGlobal>
                        <g:isNotRoot>
                        	<g:hiddenField name="global" value="${category?.global}"/>
                        </g:isNotRoot>

         				<g:if test="${isNew}">
	                        <div id="childCompanies">
	                        	<g:isRoot>
	                        		<g:applyLayout name="form/select">
	                            		<content tag="label"><g:message code="product.assign.entities"/><span id="mandatory-meta-field">*</span></content>
	                            		<g:select id="company-select" multiple="multiple" name="entities" from="${allCompanies}"
	                                    		  optionKey="id" optionValue="${{it?.description}}"
	                            	       		  value="${allCompanies.size == 1 ? allCompanies?.id : category.entities?.id}"
                                                  onChange="${remoteFunction(action: 'retrieveMetaFields',
                                                          update: 'category-metafields',
                                                          params: "\'entityType=${EntityType.PRODUCT_CATEGORY}\'+"+'\'&entities=\' + getSelectValues(this)')}" />
	                        		</g:applyLayout>
	                        	</g:isRoot>
	                        	<g:isNotRoot>
									<g:hiddenField name="entities" value="${session['company_id']}"/>
	                        	</g:isNotRoot>
	                        </div>
                        </g:if>
                        <g:if test="${!isNew}">
                        	<div id="childCompanies">
                        	   	<g:isRoot>
	                        		<g:applyLayout name="form/select">
	                            		<content tag="label"><g:message code="product.assign.entities"/><span id="mandatory-meta-field">*</span></content>
	                            		<g:select id="company-select" multiple="true" name="entities" from="${allCompanies}"
	                                    		  optionKey="id" optionValue="${{it?.description}}"
	                            	       		  value="${category.entities?.id}"
                                                  onChange="${remoteFunction(action: 'retrieveMetaFields',
                                                          update: 'category-metafields',
                                                          params: "\'entityType=${EntityType.PRODUCT_CATEGORY}\'+"+'\'&entities=\' + getSelectValues(this)+'+'\'&categoryId=\' + getCategoryId()')}"/>
	                        		</g:applyLayout>
	                        	</g:isRoot>
	                        	<g:isNotRoot>
									<g:each in="${category?.entities}">
	                        			<g:hiddenField name="entities" value="${it.id}"/>
	                        		</g:each>
								</g:isNotRoot>
							</div>
                        </g:if>

                        <g:applyLayout name="form/checkbox">
                            <content tag="label"><g:message code="product.category.one.per.order"/></content>
                            <content tag="label.for">onePerOrder</content>
                            <g:checkBox id="onePerOrder" class="field" name="onePerOrder"
                                        checked="${category?.onePerOrder}"
                                        onchange="isExclusive()"/>
                        </g:applyLayout>
                        <g:applyLayout name="form/checkbox">
                            <content tag="label"><g:message code="product.category.one.per.customer"/></content>
                            <content tag="label.for">onePerCustomer</content>
                            <g:checkBox id="onePerCustomer" class="field" name="onePerCustomer"
                                        checked="${category?.onePerCustomer}"
                                        onchange="isExclusive()"/>
                        </g:applyLayout>

                        <g:applyLayout name="form/checkbox">
                            <content tag="label"><g:message code="product.category.allowAssetManagement"/></content>
                            <content tag="label.for">allowAssetManagement</content>
                            <g:checkBox id="allowAssetManagement" class="field" name="allowAssetManagement"
                                        checked="${category?.allowAssetManagement == 1}"
                                        onchange="showAssetManagement()"/>
                        </g:applyLayout>

                        <div id="assetIdentifierLabelDiv" >
                            <g:applyLayout name="form/input">
                                <content tag="label"><g:message code="product.category.assetIdentifierLabel"/></content>
                                <content tag="label.for">assetIdentifierLabel</content>
                                <g:textField class="field" id="assetIdentifierLabel" name="assetIdentifierLabel"
                                             value="${category?.assetIdentifierLabel}"/>
                            </g:applyLayout>
                        </div>

                    </div>

                    <div class="column">
                        <g:applyLayout name="form/input">
                            <content tag="label"><g:message code="product.category.name"/><span id="mandatory-meta-field">*</span></content>
                            <content tag="label.for">description</content>
                            <g:textField class="field" name="description" value="${category?.description}"/>
                        </g:applyLayout>


                    <!-- meta fields -->
                        <div id="category-metafields">
                            <g:render template="/metaFields/editMetaFields" model="[availableFields: availableFields, fieldValues: availableFieldValues]"/>
                        </div>
                    </div>

                </div>

                <div>
                    <br/>&nbsp;
                </div>

                <!-- status controls -->
                <div id="assetStatuses" class="box-cards box-cards-open">
                    <div class="box-cards-title">
                        <a class="btn-open" href="#"><span><g:message
                                code="product.category.status.description"/></span></a>
                    </div>

                    <div class="box-card-hold">
                        <g:render template="/product/assetStatus" model="[statuses: orderedStatuses]"/>
                    </div>
                </div>

                <%-- meta fields controls --%>
                    <div id="assetMetaFields" class="box-cards box-cards-open">
                        <div class="box-cards-title">
                            <a class="btn-open" href="#"><span><g:message
                                    code="product.category.metafields.description"/></span></a>
                        </div>

                        <div class="box-card-hold">
                            <%-- buttons to add empty meta field or from templates  class="type-metafield-menu" --%>
                            <%-- hidden input to store metaFieldIdx. The AJAX calls read this value. --%>
                            <input type="hidden" name="metaFieldIdxInp" id="metaFieldIdxInp" value="${category.assetMetaFields.size() + 1}" />

                            <g:set var="loggedInUser" value="${new SpringSecurityService().getPrincipal()}"/>
                            <g:if test="${!category?.entity || loggedInUser.companyId == category?.entity?.id}">
                                <div class="type-metafield-header">
                                    <span class="type-metafield-menu"><label for="metaFieldTemplate.id"><g:message
                                            code="button.add.metaField"/></label><a
                                            onclick="addMetaField()">
                                        <img src="${resource(dir: 'images', file: 'add.png')}" alt="add"/>
                                    </a>
                                    </span>

                                    <span class="type-metafield-menu">

                                        <label for="metaFieldTemplate.id"><g:message
                                                code="product.category.metafield.select"/></label>
                                        <g:select name="metaFieldTemplate.id" id="metaFieldTemplate-id" class="field"
                                                  from="${new MetaFieldDAS().getAvailableFields(session['company_id'], [EntityType.ASSET] as EntityType[], true).findAll {it.isDisabled()==false}}"
                                                  optionKey="id"
                                                  optionValue="name"/>

                                        <a onclick="${remoteFunction(action: 'populateMetaFieldForEdit',
                                                update: [success: 'meta-field-load-target', failure: 'meta-field-load-target'],
                                                onComplete: 'moveMetaFieldsFromTemplate()',
                                                params: '\'mfId=\' + $(\'#metaFieldTemplate-id\').val() + \'&startIdx=\' + $(\'#metaFieldIdxInp\').val() + \'&entityType=' + EntityType.ASSET + '\'')}">
                                            <img src="${resource(dir: 'images', file: 'add.png')}" alt="add"/>
                                        </a>
                                    </span>

                                    <span class="type-metafield-menu">
                                        <label for="metaFieldGroupTemplate.id"><g:message
                                                code="product.category.metafieldgroup.select"/></label>
                                        <g:select name="metaFieldGroupTemplate.id" id="metaFieldGroupTemplate-id"
                                                  class="field"
                                                  from="${new MetaFieldGroupDAS().getAvailableFieldGroups(session['company_id'], EntityType.ASSET)}"
                                                  optionKey="id"
                                                  optionValue="description"/>

                                        <a onclick="${remoteFunction(action: 'populateCategoryMetaFieldsForEdit',
                                                update: [success: 'meta-field-load-target', failure: 'meta-field-load-target'],
                                                onComplete: 'moveMetaFieldsFromTemplate()',
                                                params: '\'groupId=\' + $(\'#metaFieldGroupTemplate-id\').val() + \'&startIdx=\' + $(\'#metaFieldIdxInp\').val() + \'&entityType=' + EntityType.ASSET + '\'')}">
                                            <img src="${resource(dir: 'images', file: 'add.png')}" alt="add"/>
                                        </a>
                                    </span>

                                </div>
                            </g:if>


                            <div>
                                <ul id="asset-metafield-lines">
                                    <% params.entityType = com.sapienter.jbilling.server.metafields.EntityType.ASSET.name(); %>
                                    <g:render template="editCategoryMetaFieldsCollection"
                                              model="[metaFields: category.assetMetaFields.collect {  MetaFieldBL.getWS(it)}.sort {it.displayOrder}, startIdx: 1,
                                                      loggedInUser: loggedInUser, category: category]"/>
                                </ul>
                            </div>
                        </div>
                    </div>

                </div>

                <div class="buttons">
                    <ul>
                        <li><a onclick="submitForm()" class="submit save"><span><g:message
                                code="button.save"/></span></a></li>
                        <li><g:link action="list" class="submit cancel"><span><g:message
                                code="button.cancel"/></span></g:link></li>
                    </ul>
                </div>
            </fieldset>
        </g:form>

        <%-- meta fields from groups or already created ones are loaded here before being moved into the list --%>
        <div id="meta-field-load-target" style="display: none">
        </div>

        <%-- template used to create empty meta fields--%>
        <div id="meta-field-template" style="display: none">
            <li id="line-_mfIdx_" class="line">
                <span id="metaField-header-desc-_mfIdx_" class="description">-</span>
                <span id="metaField-header-datatype-_mfIdx_" class="data-type">-</span>
                <div style="clear: both;"></div>
            </li>

            <li id="line-_mfIdx_-editor" class="editor open">
                <% params.entityType = com.sapienter.jbilling.server.metafields.EntityType.ASSET.name(); %>
                <div><g:render template="/metaFields/editMetafield"
                               model="[metaField: new MetaFieldWS(), entityType: EntityType.ACCOUNT_TYPE,
                                       parentId: '', metaFieldIdx: '_mfIdx_', displayMetaFieldType: false]"/>
                    <div class="buttons">
                        <a class="submit remove" onclick="$('#line-_mfIdx_').remove();
                        $('#line-_mfIdx_-editor').remove();"><span><g:message
                                code="button.remove"/></span></a>
                    </div>
                </div>
            </li>
        </div>
    </div>

	<div id="subscription-asset-management-dialog">
    	<div id="impersonation-text"><g:message code="subcription.category.asset.management.mandatory"/></div>
    	<div>
            <br/>&nbsp;
        </div>
    	<div class="buttons">
    		<ul>
    			<li><a onclick="$('#subscription-asset-management-dialog').dialog('close');" class="submit select"><span><g:message code="prompt.ok"/></span></a></li>
    		</ul>
    	</div>
	</div>
</div>
</body>
<r:script>
    var metaFieldIdx = ${category.assetMetaFields.size() + 1};

	$(document).ready(function() {
    	if ($("#global-checkbox").is(":checked")) {
        	$("#company-select").attr('disabled', true);
       	}
       	isExclusive();
    });

    var getCategoryId = function(){
        return $("input[name='id'][type='hidden']").val();
    };

    function hideCompanies(){
            var categoryId = getCategoryId();
			if ($("#global-checkbox").is(":checked")) {
				$("#company-select").attr('disabled', true);
				$.ajax({
                	type: 'POST',
                	data: 'entityType=${EntityType.PRODUCT_CATEGORY}&categoryId='+categoryId,
                	url: '${createLink(action: 'retrieveAllMetaFields')}',
                	success: function(data) {
                		document.getElementById('category-metafields').innerHTML=data;
    						}
            		});
			} else {
				$("#company-select").removeAttr('disabled');
				$.ajax({
                	type: 'POST',
                	data: 'entityType=${EntityType.PRODUCT_CATEGORY}&categoryId='+categoryId,
                	url: '${createLink(action: 'getAvailableMetaFields')}',
                	success: function(data) {
                		document.getElementById('category-metafields').innerHTML=data;
    						}
            		});
			}
		}

    <%-- Display if div with asset statuses if the user select 'allow asset management' --%>
    function showAssetManagement() {
    	// if category is subscription then asset management can not be disabled
    	if($('#orderLineTypeId').val() == 5) {
    		$('#allowAssetManagement').prop('checked',true);
    		$('#subscription-asset-management-dialog').dialog('open');
    	}
    	
        var allow = $("#allowAssetManagement").prop("checked");
		
        $("#assetStatuses").css("display", (allow?"block":"none"));
        $("#assetMetaFields").css("display", (allow?"block":"none"));
        $("#assetIdentifierLabelDiv").css("display", (allow?"block":"none"));
        if(!allow) {
            $("#assetIdentifierLabel").val("")
        }
    }

    <%-- The AJAX call not read the js var metaFieldIdx correctly more than once. So we populate the hidden input
        and the AJAX call read the value from the hidden input --%>
    function updateMetaFieldIndexInput() {
        $('#metaFieldIdxInp').val(''+(metaFieldIdx+1));
    }

    <%-- move meta fields loaded from template (group or other meta field) to the list of editable meta fields--%>
    function moveMetaFieldsFromTemplate() {
        var metaFields = $("#meta-field-load-target").children().detach();
        metaFieldIdx += metaFields.length;
        $("#asset-metafield-lines").append(metaFields);

        updateMetaFieldIndexInput();
    }

    <%-- Add a new empty meta field line to the table --%>
    function addMetaField() {
        metaFieldIdx ++;
        <%-- Clone the template --%>
        var template = $("#meta-field-template").clone().html().replace(/_mfIdx_/g, metaFieldIdx);
        $("#asset-metafield-lines").append(template);


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

        <%-- enable drop down effect when user clicks on a row header --%>
        $('#line-'+metaFieldIdx).click(function() {
            var id = $(this).attr('id');
            $('#' + id).toggleClass('active');
            $('#' + id + '-editor').toggle('blind');
        });

        updateMetaFieldIndexInput();
    }

	function submitForm() {
		$("#company-select").removeAttr('disabled');
		$('#save-category-form').submit();
	}

	function isExclusive() {

        var opo = $("#onePerOrder").prop("checked");
        var opc = $("#onePerCustomer").prop("checked");

        if(opc) {
        	$("#onePerOrder").attr("disabled", "disabled");
        }

        if(opo) {
        	$("#onePerCustomer").attr("disabled", "disabled");
        }

        if(!opc && !opo) {
        	$("#onePerCustomer").removeAttr("disabled");
        	$("#onePerOrder").removeAttr("disabled");
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

    showAssetManagement();
    updateMetaFieldIndexInput();
    
    function verifyAssetManagement(val) {
    	// if its a subscription product line
    	if(val == 5) {
    		$('#allowAssetManagement').prop('checked',true);
    		showAssetManagement()
    	}	
    }
    
    $(function() {
        $('#subscription-asset-management-dialog').dialog({
            autoOpen: false,
            height: 140,
            width: 420,
            modal: true,
        });
    });
</r:script>
</html>
