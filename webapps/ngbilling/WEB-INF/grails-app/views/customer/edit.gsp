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

<%@ page import="com.sapienter.jbilling.server.user.db.UserDAS" %>
<%@ page import="com.sapienter.jbilling.server.user.UserDTOEx; com.sapienter.jbilling.server.user.db.CompanyDTO; com.sapienter.jbilling.server.user.permisson.db.RoleDTO; com.sapienter.jbilling.server.util.db.LanguageDTO; com.sapienter.jbilling.common.CommonConstants" %>
<%@ page import="com.sapienter.jbilling.server.util.db.EnumerationDTO; com.sapienter.jbilling.server.util.ServerConstants" %>

<html>
<head>
    <meta name="layout" content="main" />
    <style>
		.ui-widget-content .ui-state-error{
			background-color:white;
			background: none;
		}
		.row .inp-bg{
			display: table-caption;
		}
	</style>
    <r:script>
        function replacePhoneCountryCodePlusSign(phoneCountryCodeFields) {
        
        	for (var i=0; i < phoneCountryCodeFields.length; i++) {
        		phoneCountryCodeField = phoneCountryCodeFields[i];
	        	var phoneCountryCode = phoneCountryCodeField.value;
	        	
				if (phoneCountryCode != null && $.trim(phoneCountryCode) != '') {
					if (phoneCountryCode.indexOf('+') == 0) {
						phoneCountryCode = phoneCountryCode.replace('+', '');
					}
					phoneCountryCodeField.value = phoneCountryCode; 
				}
			}
		}
		
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
     
		$(function() {
	        $('#mainSubscription').change(function() {
	        	updateSubscription();
	        });
	    });
	
	    function updateSubscription() {
	        $.ajax({
	            type: 'POST',
	            url: '${createLink(action: 'updateSubscription')}',
	            data: $('#subscriptionTemplate').parents('form').serialize(),
	            success: function(data) { $('#subscriptionTemplate').replaceWith(data);}
	        });
	    }
	    
	    
	    $(function() {
	        $('#companyBillingCycle').click(function() {
	        	 $("#mainSubscription").val($("#orderPeriodSubscriptionUnit").val());
	        	 updateSubscriptionOnBillingCycle()
	        });
	    });
	
	    function updateSubscriptionOnBillingCycle() {
	        $.ajax({
	            type: 'POST',
	            url: '${createLink(action: 'updateSubscriptionOnBillingCycle')}',
	            data: $('#subscriptionTemplate').parents('form').serialize(),
	            success: function(data) { $('#subscriptionTemplate').replaceWith(data);}
	        });
	    }
   		
   		var hasChild = ${user?.childIds?.toList()?.size() > 0}

    	$(document).ready(function() {
    	    //apply date picker to each startDate-*
    		$.each( $("input[name^='startDate']"), function () {
  				$(this).datepicker({dateFormat: "${message(code: 'datepicker.jquery.ui.format')}", showOn: "both", buttonImage: "${resource(dir:'images', file:'icon04.gif')}", buttonImageOnly: true});
			});
		
			$('#user\\.isParent').change(function() {
	       		if ( ! this.checked && hasChild) {
	       		    $("#background").height($(document).height());
       			    $("#background").show();
	        		$("#user\\.isParent").prop('checked', true);
	        		$( "#dialog" ).dialog({
					  dialogClass: "no-close",
					  buttons: [
					    {
					      text: "Close",
					      click: function() {
					        $( this ).dialog( "close" );
					        $("#background").hide();
					      }
					    }
					  ]
					});
				}
	        });
	   	});

        var noteTitle = $( "#noteTitle" ),
                userId = "${new UserDAS().find(session['user_id']).getUserName()}",
                noteContent = $("#noteContent" );
                allFields = $( [] ).add( noteTitle ).add( noteContent ),
                tips = $( ".validateTips" );
                i=0;
        $( "#customer-add-note-dialog" ).dialog({ autoOpen: false,
                height: 380,
                width: 550,
                modal: true ,buttons: {
                   "${g.message(code:'button.add.note')}": function() {
                    var bValid = true;
                    allFields.removeClass( "ui-state-error" );
                    bValid = bValid && checkLength( noteTitle, "title", 1, 50 );
                    bValid = bValid && checkLength( noteContent, "content", 1, 1000 );
						if(bValid){
                        	$( "#users tbody" ).
                            prepend( "<tr>" +
                                "<input type='hidden' name ='notes."+i+".noteId' value='0'>" +
                                "<td style='background-position: 0 -71px;padding: 3px 0 3px 15px;'>" + userId + "<input type='hidden' name ='notes."+i+".userId' value='"+${session['user_id']}+"'></td>" +
                                "<td>" +  $.datepicker.formatDate('d-M-yy', new Date())+"</td>"+
                                "<td>" + noteTitle.val() + "<input type='hidden' name ='notes."+i+".noteTitle' value='"+noteTitle.val()+"'></td>" +
                                "<td>" + noteContent.val() + "<input type='hidden' name ='notes."+i+".noteContent' value='"+noteContent.val()+"'></td>" +
                                "</tr>" );
                                 i++
                                $("#newNotesTotal").val(i)
                            $( this ).dialog( "close" );
              	 		}
                    },
                    "${g.message(code:'button.cancel')}": function() {
                        $( this ).dialog( "close" );
                    }
                },
                "${g.message(code:'button.close')}": function() {
                	allFields.val( "" ).removeClass( "ui-state-error" );
                }
        });
        
        
        function checkLength( o, n, min, max ) {
	        if ( o.val().length > max || o.val().length < min ) {
	            o.addClass( "ui-state-error" );
	            updateTips( "Length of " + n + " must be between " +min + " and " + max + "." );
	            return false;
	        } else {
	            return true;
	        }
	    }

	    function updateTips( t ) {
	        tips.text( t ).addClass( "ui-state-error" );
	    }
            
        $('#contactType').change(function() {
            var selected = $('#contact-' + $(this).val());
            $(selected).show();
            $('div.contact').not(selected).hide();
        }).change();

		function openDialog() {
		    $("#noteTitle").val("");
		    $("#noteContent").val("");
		    tips.text("${g.message(code:'customer.note.fields.required')}").removeClass( "ui-state-error" );
		    $( "#customer-add-note-dialog" ).dialog( "open" );
		}

    </r:script>
    
</head>
<body>
<div id="customer-add-note-dialog" title="${g.message(code:'button.add.note')}">
    <p id="validateTips" class="validateTips" style=" border: 1px solid transparent; padding: 0.3em; "></p>
    <g:form id="notes-form" name="notes-form" url="[action: 'saveCustomerNotes']">
		<g:render template="customerNotesForm" />
    </g:form>
</div>

<g:set var="defaultCurrency" value="${CompanyDTO.get(session['company_id']).getCurrency()}"/>

<div class="form-edit">

    <g:set var="isNew" value="${!user || !user?.userId || user?.userId == 0}"/>
    <g:set var="accountTypeId" value="${accountType?.id}"/>
    <g:set var="templateName" value="${null != templateName? templateName : "monthly"}"/>
	
    <div class="heading">
        <strong>
            <g:if test="${isNew}">
                <g:message code="customer.create.title"/>
            </g:if>
            <g:else>
                <g:message code="customer.edit.title"/>
            </g:else>
        </strong>
    </div>
	
    <div class="form-hold">
        <g:form name="user-edit-form" action="save">
            <fieldset>
                <div class="form-columns">

                    <!-- user details column -->
                    <div class="column">
                        <g:applyLayout name="form/text">
                            <content tag="label"><g:message code="prompt.customer.number"/></content>

                            <g:if test="${!isNew}">
                                <span>
                                    <g:link controller="customerInspector" action="inspect"
                                            id="${user.userId}" title="${message(code: 'customer.inspect.link')}">
                                        ${user.userId}
                                    </g:link>
                                </span>
                            </g:if>
                            <g:else>
                                <em><g:message code="prompt.id.new"/></em>
                            </g:else>

                            <g:hiddenField name="user.userId" value="${user?.userId}"/>
                        </g:applyLayout>

                        <g:applyLayout name="form/text">
                            <content tag="label"><g:message code="prompt.user.account.type"/></content>
                            <em>
                                <g:if test="${null != accountType}">
                                    ${accountType?.description}
                                </g:if><g:else>-</g:else>
                            </em>

                            <g:hiddenField name="user.accountTypeId" value="${accountType?.id}"/>
                            <g:hiddenField name="user.entityId" value="${company?.id}"/>
                        </g:applyLayout>

                        <g:if test="${isNew}">
                            <g:applyLayout name="form/input">
                                <content tag="label"><g:message code="prompt.login.name"/><span id="mandatory-meta-field">*</span></content>
                                <content tag="label.for">user.userName</content>
                                <g:textField class="field" name="user.userName" value="${user?.userName}"/>
                            </g:applyLayout>
                        </g:if>
                        <g:else>
                            <g:applyLayout name="form/text">
                                <content tag="label"><g:message code="prompt.login.name"/></content>

                                ${user?.userName}
                                <g:hiddenField name="user.userName" value="${user?.userName}"/>
                            </g:applyLayout>
                        </g:else>

                        <g:if test="${!isNew && user?.userId == loggedInUser?.id}">
                           
                                <g:applyLayout name="form/input">
                                    <content tag="label"><g:message code="prompt.current.password"/><span id="mandatory-meta-field">*</span></content>
                                    <content tag="label.for">oldPassword</content>
                                    <g:passwordField class="field" name="oldPassword"/>
                                </g:applyLayout>

                                <g:applyLayout name="form/input">
                                    <content tag="label"><g:message code="prompt.password"/><span id="mandatory-meta-field">*</span></content>
                                    <content tag="label.for">newPassword</content>
                                    <g:passwordField class="field" name="newPassword"/>
                                </g:applyLayout>

                                <g:applyLayout name="form/input">
                                    <content tag="label"><g:message code="prompt.verify.password"/><span id="mandatory-meta-field">*</span></content>
                                    <content tag="label.for">verifiedPassword</content>
                                    <g:passwordField class="field" name="verifiedPassword"/>
                                </g:applyLayout>
                           
                        </g:if>

                        <!-- CUSTOMER CREDENTIALS -->
                        <g:if test="${isNew}">
                            <g:preferenceEquals preferenceId="${CommonConstants.PREFERENCE_CREATE_CREDENTIALS_BY_DEFAULT}" value="0">
                                <g:applyLayout name="form/checkbox">
                                    <content tag="label"><g:message code="prompt.create.credentials"/></content>
                                    <content tag="label.for">user.createCredentials</content>
                                    <g:checkBox class="cb checkbox" name="user.createCredentials" checked="${user?.createCredentials}"/>
                                </g:applyLayout>
                            </g:preferenceEquals>
                        </g:if>

                        <g:applyLayout name="form/select">
                            <content tag="label"><g:message code="prompt.user.status"/></content>
                            <content tag="label.for">user.statusId</content>
                            <g:if test="${params.id}">
                                <g:userStatus name="user.statusId" value="${user?.statusId}" languageId="${session['language_id']}" roleId="${CommonConstants.TYPE_CUSTOMER}"/>
							</g:if>
							<g:else>
								<g:userStatus name="user.statusId" value="${user?.statusId}" languageId="${session['language_id']}" roleId="${CommonConstants.TYPE_CUSTOMER}" disabled="true"/>
							</g:else>
                        </g:applyLayout>

                        <g:applyLayout name="form/select">
                            <content tag="label"><g:message code="prompt.user.subscriber.status"/></content>
                            <content tag="label.for">user.subscriberStatusId</content>
                            <g:subscriberStatus name="user.subscriberStatusId" value="${user?.subscriberStatusId}" languageId="${session['language_id']}" />
                        </g:applyLayout>

                        <g:applyLayout name="form/select">
                            <content tag="label"><g:message code="prompt.user.language"/></content>
                            <content tag="label.for">user.languageId</content>
                            <g:select name="user.languageId" from="${LanguageDTO.list()}"
                                    optionKey="id" optionValue="description" value="${user?.languageId}"  />
                        </g:applyLayout>

                        <g:applyLayout name="form/select">
                            <content tag="label"><g:message code="prompt.user.currency"/></content>
                            <content tag="label.for">user.currencyId</content>
                            <g:select name="user.currencyId"
                                      from="${currencies?.sort {it.description}}"
                                      optionKey="id"
                                      optionValue="${{it.getDescription(session['language_id'])}}"
                                      value="${user?.currencyId ?: defaultCurrency?.id}" />
                        </g:applyLayout>

                        <g:applyLayout name="form/select">
                            <content tag="label"><g:message code="prompt.preferred.auto.payment"/></content>
                            <content tag="label.for">user.automaticPaymentType</content>
                            <g:select name="user.automaticPaymentType"
                                      from="${[CommonConstants.AUTO_PAYMENT_TYPE_CC, CommonConstants.AUTO_PAYMENT_TYPE_ACH]}"
                                      valueMessagePrefix="auto.payment.type"
                                      value="${user?.automaticPaymentType}"/>
                        </g:applyLayout>

                        <g:if test="${user?.partnerId || !partnerId}">
                            <g:applyLayout name="form/input">
                                <content tag="label"><g:message code="prompt.partner.id"/></content>
                                <content tag="label.for">user.partnerId</content>
                                <g:textField class="field" name="user.partnerId" value="${user?.partnerId ?: partnerId}"/>
                            </g:applyLayout>
                        </g:if>
                        <g:else>
                            <g:applyLayout name="form/text">
                                <content tag="label"><g:message code="prompt.partner.id"/></content>
                                ${partnerId}
                                <g:hiddenField class="field" name="user.partnerId" value="${partnerId}"/>
                            </g:applyLayout>
                        </g:else>

                        <g:if test="${parent?.customerId}">
                            <g:applyLayout name="form/text">
                                <content tag="label"><g:message code="prompt.parent.id"/></content>
                                <g:link action="list" id="${parent.userId}">${parent.userId} ${parent.userName}</g:link>
                                <g:hiddenField class="field" name="user.parentId" value="${parent.userId}"/>
                            </g:applyLayout>
                        </g:if>

                        <g:else>
                            <g:applyLayout name="form/input">
                                <content tag="label"><g:message code="prompt.parent.id"/></content>
                                <content tag="label.for">user.parentId</content>
                                <g:textField class="field" name="user.parentId" value="${user?.parentId}"/>
                            </g:applyLayout>
                        </g:else>

                        <g:applyLayout name="form/checkbox">
                            <content tag="label"><g:message code="prompt.allow.sub.accounts"/></content>
                            <content tag="label.for">user.isParent</content>
                            <g:checkBox class="cb checkbox" name="user.isParent" checked="${user?.isParent}"/>
                        </g:applyLayout>

                        <g:applyLayout name="form/checkbox">
                            <content tag="label"><g:message code="prompt.invoice.if.child"/></content>
                            <content tag="label.for">user.invoiceChild</content>
                            <g:checkBox class="cb checkbox" name="user.invoiceChild" checked="${user?.invoiceChild}"/>
                        </g:applyLayout>

                        <g:applyLayout name="form/checkbox">
                            <content tag="label"><g:message code="prompt.use.parent.pricing"/></content>
                            <content tag="label.for">user.useParentPricing</content>
                            <g:checkBox class="cb checkbox" name="user.useParentPricing" checked="${user?.useParentPricing}"/>
                        </g:applyLayout>

                        <g:applyLayout name="form/checkbox">
                            <content tag="label"><g:message code="prompt.exclude.ageing"/></content>
                            <content tag="label.for">user.excludeAgeing</content>
                            <g:checkBox class="cb checkbox" name="user.excludeAgeing" checked="${user?.excludeAgeing}"/>
                        </g:applyLayout>

                        <g:set var="isReadOnly" value="true"/>
                        <sec:ifAllGranted roles="CUSTOMER_11">
                            <g:set var="isReadOnly" value="false"/>
                        </sec:ifAllGranted>
                        <g:applyLayout name="form/checkbox">
                            <content tag="label"><g:message code="user.account.lock"/></content>
                            <content tag="label.for">user.isAccountLocked</content>
                            <g:checkBox class="cb checkbox" name="user.isAccountLocked" checked="${user?.isAccountLocked}" disabled="${isReadOnly}"/>
                        </g:applyLayout>
                    </div>

                    <div class="column">

                    %{-- Allow the user to add linked user codes --}%
                        <g:applyLayout name="form/input">
                            <content tag="label">&nbsp;<g:message code="prompt.userCode"/></content>
                            <content tag="label.for">user.userCode[${ucIndex}]</content>

                        %{-- Display the existing user codes --}%
                            <g:if test="${user?.userCodeLink}">
                                <div id="userCode">
                                    <sec:ifAllGranted roles="USER_144">
                                        <g:textField class="field userCode-marker" name="user.userCodeLink" value="${user.userCodeLink}" />
                                    </sec:ifAllGranted>
                                    <sec:ifNotGranted roles="USER_144">
                                        <g:hiddenField name="user.userCodeLink" value="${user.userCodeLink}" />
                                        ${uc}
                                    </sec:ifNotGranted>
                                </div>
                            </g:if>
                            <g:else>
                            %{-- Allow the user to add user codes --}%
                                <sec:ifAllGranted roles="USER_143">
                                    <div>
                                        <g:textField class="field userCode-marker" name="user.userCodeLink"  value=""/>
                                    </div>
                                </sec:ifAllGranted>
                            </g:else>
                        </g:applyLayout>

                        <g:applyLayout name="form/input">
                            <content tag="label"><g:message code="prompt.credit.limit"/></content>
                            <content tag="label.for">user.creditLimitAsDecimal</content>
                            <g:textField class="field" name="user.creditLimitAsDecimal" value="${formatNumber(number: user?.creditLimitAsDecimal ?: 0, formatName: 'money.format')}"/>
                        </g:applyLayout>

                        <g:applyLayout name="form/input">
                            <content tag="label"><g:message code="prompt.auto.recharge"/></content>
                            <content tag="label.for">user.autoRechargeAsDecimal</content>
                            <g:textField class="field" name="user.autoRechargeAsDecimal" value="${formatNumber(number: user?.autoRechargeAsDecimal ?: 0, formatName: 'money.format')}"/>
                        </g:applyLayout>

                        <g:applyLayout name="form/input">
                            <content tag="label"><g:message code="prompt.auto.recharge.threshold"/></content>
                            <content tag="label.for">user.rechargeThreshold</content>
                            <g:textField class="field" name="user.rechargeThreshold" value="${formatNumber(number: user?.rechargeThreshold ?: 0, formatName: 'money.format')}"/>
                        </g:applyLayout>

                        <g:applyLayout name="form/input">
                            <content tag="label"><g:message code="prompt.auto.recharge.monthly.limit"/></content>
                            <content tag="label.for">user.monthlyLimit</content>
                            <g:textField class="field" name="user.monthlyLimit" value="${formatNumber(number: user?.monthlyLimit ?: 0, formatName: 'money.format')}"/>
                        </g:applyLayout>
						</div>
						<div class="column">
                        <g:applyLayout name="form/select">
                            <content tag="label"><g:message code="prompt.invoice.delivery.method"/></content>
                            <content tag="label.for">user.invoiceDeliveryMethodId</content>
                            <g:select from="${company.invoiceDeliveryMethods.sort{ it.id }}"
                                      optionKey="id"
                                      valueMessagePrefix="customer.invoice.delivery.method"
                                      name="user.invoiceDeliveryMethodId"
                                      value="${user?.invoiceDeliveryMethodId}"/>
                        </g:applyLayout>

                        <g:applyLayout name="form/text">
                            <content tag="label"><g:message code="prompt.due.date.override"/></content>
                            <content tag="label.for">user.dueDateValue</content>

                            <div class="inp-bg inp4">
                                <g:textField class="field" name="user.dueDateValue" value="${user?.dueDateValue}"/>
                            </div>
                            <div class="select4">
                                <g:select from="${periodUnits}"
                                          optionKey="id"
                                          optionValue="${{it.getDescription(session['language_id'])}}"
                                          name="user.dueDateUnitId"
                                          value="${user?.dueDateUnitId ?: ServerConstants.PERIOD_UNIT_DAY}"/>
                            </div>
                        </g:applyLayout>
                         <g:applyLayout name="form/text">
                          	<content tag="label">&nbsp;</content>
							<content tag="label.for">orderPeriodSubscriptionUnit</content>
							<div class="btn-row" style="vertical-align: top; margin: 0px; padding: 0px;">
	                            <a id="companyBillingCycle" class="submit save" style="width: 53%; font-size: 10px;"><span><g:message code="button.use.company.billing.cycle"/></span></a>
	                            <g:hiddenField id="orderPeriodSubscriptionUnit" name="orderPeriodSubscriptionUnit" value="${orderPeriodSubscriptionUnit}"/>
	                        </div>
	                     </g:applyLayout>
                         <g:applyLayout name="form/select">
	                        <div class="select5">
	                        	<content tag="label"><g:message code="prompt.main.subscription"/></content>
								<content tag="label.for">mainSubscription.periodId</content>
					        	 <g:select id="mainSubscription" from="${orderPeriods}"
					                   optionKey="id" optionValue="${{it.getDescription(session['language_id'])}}"
					                   name="mainSubscription.periodId"
					                   value="${mainSubscription?.periodId ?: orderPeriods.find {
					  							it?.periodUnit?.id == ServerConstants.PERIOD_UNIT_MONTH && it?.value == 1}?.id}"/>
					    	</div>
					    </g:applyLayout>
					    <g:render id="subscriptionTemplate" template="/customer/subscription/${templateName}" model="[mainSubscription: mainSubscription]" />
						<g:if test="${!isNew}">
						<g:applyLayout name="form/date">
							<content tag="label"><g:message code="next.invoice.date"/></content>
							<content tag="label.for">user.nextInvoiceDate</content>
								<g:textField class="field" name="user.nextInvoiceDate" value="${formatDate(date: user?.nextInvoiceDate, formatName:'datepicker.format')}" onblur="validateDate(this)"/>
						</g:applyLayout>
                     </g:if>
                     	 <br/>&nbsp;
                        <g:applyLayout name="form/input">
                            <content tag="label"><g:message code="prompt.invoice.design"/></content>
                            <content tag="label.for">user.invoiceDesign</content>
                            <g:textField class="field" name="user.invoiceDesign" value="${user?.invoiceDesign}"/>
                            </g:applyLayout>

                        <!-- customer meta fields -->
                        <g:render template="/metaFields/editMetaFields" model="[ availableFields: availableFields, fieldValues: user?.metaFields ]"/>
                    </div>
                </div>

                <!-- separator -->
                <div class="form-columns">
                    <hr/>
                </div>

                <!-- dynamic balance and invoice delivery -->
                <div class="form-columns">
                    <div class="column">
                    </div>

                    <div class="column">
                    </div>
                </div>

                <!-- spacer -->
                <div>
                    <br/>&nbsp;
                </div>
                
                <g:hiddenField name="datesXml" value="${datesXml}"/>
                <g:hiddenField name="effectiveDatesXml" value="${effectiveDatesXml}"/>
                <g:hiddenField name="infoFieldsMapXml" value="${infoFieldsMapXml}"/>
                <g:hiddenField name="removedDatesXml" value="${removedDatesXml}"/>
                
                <g:if test="${accountInformationTypes && accountInformationTypes.size()>0}">
                <g:each in="${accountInformationTypes}" var="ait">
                <g:set var="effectiveDate" value="${effectiveDates.get(ait.id)}"/>
                    <div id="ait-${ait.id}" class="box-cards box-cards-open" >
                        <div class="box-cards-title">
                            <a class="btn-open"><span>
                                ${ait.name}
                            </span></a>
                        </div>
                        <div class="box-card-hold">
                        	<g:render template="timeline" model="[startDate : effectiveDate , pricingDates : pricingDates, aitVal : ait.id]"/>
                        	<g:render template="aITMetaFields" model="[ait : ait , values : user?.metaFields, aitVal : ait.id]"/>                         	
                        </div>
                    </div>
                </g:each>
                </g:if>

				<!-- Payment Methods -->
				<g:if test="${paymentMethods?.size() > 0}">
					<div id="payment-methods" class="box-cards box-cards-open" >
                    	    <div class="box-cards-title">
                        	    <a class="btn-open"><span>
                            	    <label><g:message code="promt.payment.methods"/></label>
                            	</span></a>
                        	</div>
                        	<div id= "payment-method-main" class="box-card-hold">
								<g:render template="/customer/paymentMethods" model="[ paymentMethods: paymentMethods, paymentInstruments : user.paymentInstruments, user: user ]"/>
							</div>
             		</div>
             	</g:if>
                
				<!-- Notes-->
                <div id="ach" class="box-cards ${customerNotes ? 'box-cards-open' : ''}">
                    <div class="box-cards-title">
                        <a class="btn-open" href="#"><span><g:message code="prompt.notes"/></span></a>
                    </div>
                    <div class="box-card-hold">
                        <div id="users-contain"  >
                            <div class="table-box">
                                <table id="users" cellspacing="0" cellpadding="0">
                                <thead>
                                <tr class="ui-widget-header" >
                                <th width="150px"><g:message code="customer.detail.note.form.author"/></th>
                                <th width="150px"><g:message code="customer.detail.note.form.createdDate"/></th>
                                <th width="150px"><g:message code="customer.detail.note.form.title"/></th>
                                <th width="550px"><g:message code="customer.detail.note.form.content"/></th>
                                </thead>
                                <tbody>
                                <g:hiddenField name="newNotesTotal" id="newNotesTotal" />
                                    <g:if test="${customerNotes}">
                                        <g:each in="${customerNotes}">
                                            <tr>
                                                <td>${it?.user.userName}</td>
                                                <td><g:formatDate date="${it?.creationTime}" type="date" style="MEDIUM"/>  </td>
                                                <td>${it?.noteTitle}</td>
                                                <td> ${it?.noteContent}</td>
                                            </tr>
                                        </g:each>
                                    </g:if>
                                    <g:else>
                                        <p><em><g:message code="customer.detail.note.empty.message"/></em></p>
                                    </g:else>
                                </tbody>
                            </table>
                        </div>
                        </div>
                        <div class="form-columns">
                                <div class="btn-box">
                                    <div class="center">
                                        <a onclick="openDialog()" class="submit add"><span><g:message code="button.add.note"/></span></a>
                                    </div>
                                </div>
                            </div>
                        </div> </div>
                      </div>
                </div>
                <div class="buttons">
                    <ul>
                        <li>
                            <a onclick="replacePhoneCountryCodePlusSign($('input[name*=phoneCountryCode]')); $('#user-edit-form').submit()" class="submit save"><span><g:message code="button.save"/></span></a>
                        </li>
                        <li>
                            <g:link action="list" class="submit cancel"><span><g:message code="button.cancel"/></span></g:link>
                        </li>
                    </ul>
                </div>

            </fieldset>
        </g:form>
        <div id="dialog" style="display: none;" title="Alert!"><g:message code="allow.subAccounts.not.removed"/></div>
        <div id="background" style="position: absolute;width: 100%;height: 100%;background-color: grey;top: 0px;left: 0px;opacity: 0.5;display: none;"></div>
    </div>
</div>

</body>

<r:script>

	var userCodedIdx = ${ucIndex}+1;
	var loggedInUserCodes = [
	    <g:each in="${userCodes}" var="uc" status="tmpIdx">${tmpIdx == 0 ? "" : ","}"${uc}"</g:each>
    ];

	$('.userCode-marker').autocomplete({ source: loggedInUserCodes });

</r:script>

</html>
