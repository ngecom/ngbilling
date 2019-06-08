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

<%@ page import="com.sapienter.jbilling.server.util.db.EnumerationDTO; com.sapienter.jbilling.server.util.ServerConstants; com.sapienter.jbilling.server.order.OrderStatusFlag" %>

<%--
  Order details form. Allows editing of primary order attributes.

  @author Brian Cowdery
  @since 23-Jan-2011
--%>

<div id="details-box">
    <!-- hidden div for javascript validation errors -->
    <br/>
    <div id="error-messages" class="msg-box error" style="display: none;">
        <ul></ul>
    </div>

    <g:formRemote name="order-details-form" url="[action: 'edit']" update="ui-tabs-review" method="GET">
        <g:hiddenField name="_eventId" value="update"/>
        <g:hiddenField name="execution" value="${flowExecutionKey}"/>
        <g:hiddenField id="customerBillingCycleUnit" name="customerBillingCycleUnit" value="${order?.customerBillingCycleUnit}"/>
        <g:hiddenField id="customerBillingCycleValue" name="customerBillingCycleValue" value="${order?.customerBillingCycleValue}"/>
        <g:hiddenField id="proratingOption" name="proratingOption" value="${order?.proratingOption}"/>
        <g:hiddenField id="orderLineSize" name="orderLineSize" value="${order?.orderLines?.size()}"/>

        <div class="form-columns">
            <g:set var="hasPlan" value="${order.orderLines.find{ l -> plans.find{ p -> p.id == l.itemId }} != null}"/>

            <g:if test="${order.parentOrder && order.parentOrder.deleted == 0}">
                <g:applyLayout name="form/text">
                    <content tag="label"><g:message code="order.label.parentOrder"/></content>
                    <g:link action="edit" id="${order.parentOrder.id}" params="[_eventId: 'changeOrder']" method="GET">
                        <g:if test="${order.parentOrder.id > 0}">
                            <span>${order.parentOrder.id}</span>
                        </g:if>
                        <g:else>
                            <g:message code="default.new.label" args="['']"/>
                        </g:else>
                    </g:link>
                </g:applyLayout>
            </g:if>
            <g:applyLayout name="form/select">
                <content tag="label"><g:message code="order.label.period"/></content>
                <content tag="label.for">period</content>
                <g:select id="orderPeriod" from="${orderPeriods}"
                          optionKey="id" optionValue="${{it.getDescription(session['language_id'])}}"
                          name="period"
                          onchange="cleanProrate()"
                          value="${order?.period}" />
            </g:applyLayout>
            
            <g:applyLayout name="form/select">
                <content tag="label"><g:message code="order.label.billing.type"/></content>
                <content tag="label.for">billingTypeId</content>
                <g:select from="${orderBillingTypes}"
                          optionKey="id" optionValue="${{it.getDescription(session['language_id'])}}"
                          name="billingTypeId"
                          value="${order?.billingTypeId}"/>
            </g:applyLayout>

            <g:applyLayout name="form/select">
                <content tag="label"><g:message code="order.label.status"/></content>
                <content tag="label.for">statusId</content>
                <g:select id="statusId" from="${orderStatuses}"
                          optionKey="${{it.getId()}}" optionValue="statusValue"
                          name="orderStatusWS.id" 
                          value="${order?.orderStatusWS?.id}"/> 
            </g:applyLayout>
			
            <g:applyLayout name="form/date">
                <content tag="label"><g:message code="order.label.active.since"/></content>
                <content tag="label.for">activeSince</content>
                <g:textField class="field" name="activeSince" value="${formatDate(date: order?.activeSince, formatName: 'datepicker.format')}"/>
            </g:applyLayout>

            <g:applyLayout name="form/date">
                <content tag="label"><g:message code="order.label.active.until"/></content>
                <content tag="label.for">activeUntil</content>
                <g:textField class="field" name="activeUntil" value="${formatDate(date: order?.activeUntil, formatName: 'datepicker.format')}"/>
            </g:applyLayout>

            <g:preferenceEquals preferenceId="${ServerConstants.PREFERENCE_USE_ORDER_ANTICIPATION}" value="1">
                <g:applyLayout name="form/input">
                    <content tag="label"><g:message code="order.label.anticipate.period"/></content>
                    <content tag="label.for">anticipatePeriods</content>
                    <g:textField class="field text" name="anticipatePeriods" value="${order?.anticipatePeriods}"/>
                </g:applyLayout>
            </g:preferenceEquals>

            <g:applyLayout name="form/text">
                <content tag="label"><g:message code="prompt.due.date.override"/></content>
                <content tag="label.for">dueDateValue</content>

                <div class="inp-bg inp4">
                    <g:textField class="field text" name="dueDateValue" value="${order?.dueDateValue}"/>
                </div>
                <div class="select4">
                    <g:select from="${periodUnits}"
                              optionKey="id"
                              optionValue="${{it.getDescription(session['language_id'])}}"
                              name="dueDateUnitId"
                              value="${order?.dueDateUnitId ?: ServerConstants.PERIOD_UNIT_DAY}"/>
                </div>
            </g:applyLayout>
			
			<g:applyLayout name="form/text">
                <content tag="label"><g:message code="order.label.cancellation.minimum.period"/></content>
                <content tag="label.for">cancellationMinimumPeriod</content>

                <div class="inp-bg inp4">
                    <g:textField class="field text" name="cancellationMinimumPeriod" value="${order?.cancellationMinimumPeriod}"/>
                </div>
            </g:applyLayout>
			
			<g:applyLayout name="form/select">
                <content tag="label"><g:message code="order.label.cancellation.fee.type"/></content>
                <content tag="label.for">cancellationFeeType</content>
                <g:select from="${cancellationFeeTypes.values()}"
                          optionKey="cancellationFeeType"
                          keys="${cancellation?.values()}"
                          name="cancellationFeeType"
                          valueMessagePrefix="enum.value"
                          value="${order?.cancellationFeeType}"/>
            </g:applyLayout>
			<div id="feeDiv">
            <g:applyLayout name="form/input">
            	<content tag="label"><g:message code="order.label.cancellation.fee"/></content>
                <content tag="label.for">cancellationFee</content>
                
                <g:textField class="field" width="212" name="cancellationFee" value="${order?.cancellationFee}"/>
            </g:applyLayout>
			</div>
			<div id="percentageDiv">
            <g:applyLayout name="form/input">
            	<content tag="label"><g:message code="order.label.cancellation.fee.percentage"/></content>
                <content tag="label.for">cancellationFeePercentage</content>

                <g:textField class="field" width="212" name="cancellationFeePercentage" value="${order?.cancellationFeePercentage}"/>
            </g:applyLayout>
            
            <g:applyLayout name="form/input">
            	<content tag="label"><g:message code="order.label.cancellation.fee.maximum"/></content>
                <content tag="label.for">cancellationMaximumFee</content>

                <g:textField class="field" width="212" name="cancellationMaximumFee" value="${order?.cancellationMaximumFee}"/>
            </g:applyLayout>
			</div>
            <g:applyLayout name="form/checkbox">
                <content tag="label"><g:message code="order.label.notify.on.expire"/></content>
                <content tag="label.for">notify</content>
                <g:checkBox class="cb checkbox" name="notify" checked="${order?.notify > 0}"/>
            </g:applyLayout>
            <div class="row">
	             <g:applyLayout name="form/checkbox">
	                 <content tag="label"><g:message code="order.is.prorate"/></content>
	                 <content tag="label.for">prorateFlag</content>
	                 <g:if test="${order?.isDisable == true}">
	                 	<g:checkBox id="prorateFlag" class="cb checkbox" name="prorateFlag" checked="${order?.prorateFlag == true}" disabled="disabled"/>
	                 </g:if>
	                 <g:else>
	                 	<g:checkBox id="manualProrateFlag" class="cb checkbox" name="prorateFlag" checked="${order?.prorateFlag == true}"/>
	                 </g:else>
	             </g:applyLayout>
            </div>
            <div>
              <table style="width: 100%; margin: 0%; padding: 0%;"> 
                  <tr>
                     <td style="width: 30%; margin: 0%; padding: 0%;">
                     </td>
                     <td style="width: 70%; margin: 0%; padding: 0%;">
                        <p style="font-size: 13px; font-weight: normal;"><span style="font-weight: bold;">Note:</span> Prorating only applies when order period is equal to customers billing cycle period</p>
                     </td>
                  </tr>
              </table>
              
            </div>

            %{-- Linked User Codes--}%
            <g:applyLayout name="form/text">
                <content tag="label">&nbsp;<g:message code="prompt.userCode"/></content>
                <content tag="label.for">userCode</content>

                <g:if test="${order?.userCode}">
                    <div id="userCode">
                        <sec:ifAllGranted roles="USER_144">
                            <g:textField class="field-no-bg userCode-marker" name="userCode" value="${order.userCode}" onblur="submitForm();" />
                        </sec:ifAllGranted>
                        <sec:ifNotGranted roles="USER_144">
                            <g:hiddenField name="userCode" value="${order.userCode}" />
                            ${uc}
                        </sec:ifNotGranted>
                    </div>
                </g:if>
                <g:else>
                    <sec:ifAllGranted roles="USER_143">
                        <div>
                            <g:textField class="field-no-bg userCode-marker" name="userCode"  value="" onblur="submitForm();"/>
                        </div>
                    </sec:ifAllGranted>
                </g:else>
            </g:applyLayout>



            <br/>
			
            <g:preferenceEquals preferenceId="${ServerConstants.PREFERENCE_ORDER_OWN_INVOICE}" value="1">
                <g:applyLayout name="form/checkbox">
                    <content tag="label"><g:message code="order.label.order.own.invoice"/></content>
                    <content tag="label.for">ownInvoice</content>
                    <g:checkBox class="cb checkbox" name="ownInvoice" checked="${order?.ownInvoice > 0}"/>
                </g:applyLayout>
            </g:preferenceEquals>

            <!-- meta fields -->
            <g:render template="/metaFields/editMetaFields" model="[ availableFields: availableFields, fieldValues: order?.metaFields ]"/>
        </div>

        <hr/>

        <div class="form-columns">
            <div class="box-text">
                <label class="lb"><g:message code="prompt.notes"/></label>
                <g:textArea name="notes" rows="5" cols="60" value="${order?.notes}"/>
            </div>

            <g:applyLayout name="form/checkbox">
                <content tag="label"><g:message code="order.label.include.notes"/></content>
                <content tag="label.for">notesInInvoice</content>
                <g:checkBox class="cb checkbox" name="notesInInvoice" value="${order?.notesInInvoice > 0}"/>
            </g:applyLayout>
        </div>
    </g:formRemote>

    <script type="text/javascript">
        var orderStatus = $('#statusId').val();
				
        $('#orderPeriod').change(function() {
            if ($(this).val() == ${ServerConstants.ORDER_PERIOD_ONCE}) {
                $('#billingTypeId').val(${ServerConstants.ORDER_BILLING_POST_PAID});
                $('#billingTypeId').prop('disabled', true);
            } else {
                $('#billingTypeId').prop('disabled', '');
            }
        }).change();

        $('#statusId').change(function() {
        
        	var idVsDescription = '${params.idVsDescription}'.split(',');
        	var idVsDescriptionArr = new Array();
        	for (var i=0;i<idVsDescription.length;i++){
				idVsDescriptionArr[idVsDescription[i].split(':')[1]] = idVsDescription[i].split(':')[0];
			}
		
            if (idVsDescriptionArr[$(this).val()] == "${OrderStatusFlag.NOT_INVOICE}") {
                $('#status-suspended-dialog').dialog('open');
            } else {
                orderStatus = $(this).val();
                $('#statusId').val(orderStatus);
            }
        });

        $('#status-suspended-dialog').dialog({
             autoOpen: false,
             height: 200,
             width: 375,
             modal: true,
             buttons: {
                 '<g:message code="prompt.yes"/>': function() {
                     $(this).dialog('close');
                 },
                 '<g:message code="prompt.no"/>': function() {
                     $('#statusId').val(orderStatus);
                     submitForm();
                     $(this).dialog('close');
                 }
             }
         });

        $('.date').find('[type=text]').change( function() {
        	submitForm();
        });
        
        var submitForm = function() {
            var form = $('#order-details-form');
            form.submit();
        };

        $('#order-details-form').find('select').change(function() {
            changeDiv();
            submitForm();
        });

        $('#order-details-form').find('input:checkbox').change(function() {
            submitForm();
        });

        $('#order-details-form').find('input.text').blur(function() {
            submitForm();
        });

        $('#cancellationFee').blur(function(){
			submitForm();
        });

        $('#cancellationMaximumFee').blur(function(){
			submitForm();
        });

        $('#cancellationFeePercentage').blur(function(){
			submitForm();
        });

        $('#order-details-form').find('textarea').blur(function() {
            submitForm();
        });
		
		function changeDiv() {
		   if($('#cancellationFeeType').val() == "FLAT"){
			   $('#cancellationFeePercentage').val('');
			   $('#cancellationMaximumFee').val('');
			   $('#percentageDiv').hide();
			   $('#feeDiv').show();
		     }
		   else if($('#cancellationFeeType').val() == "PERCENTAGE"){
			   $('#cancellationFee').val('');
			   $('#percentageDiv').show();
			   $('#feeDiv').hide();
			 }
		 };
        
        var validator = $('#order-details-form').validate();
        validator.init();
        validator.hideErrors();



        $(function() {
            $('#orderPeriod').change(function() {
                if ($("#proratingOption").val() == 'PRORATING_AUTO_ON') {
           			validateOrderPeriod();
                    validateManualProrating();
                }
            });
        });

        function validateOrderPeriod() {
            $.ajax({
                type: 'POST',
                url: '${createLink(action: 'validateOrderPeriod')}',
                data: $('#prorateFlag').parents('form').serialize(),
                success: function(data) {
                $( "#prorateFlag" ).attr( "checked", data.prorateFlag );
                if (!data.prorateFlag) {
	                $("#error-messages").css("display","block");
	                $("#error-messages ul").css("display","block");
	                $("#error-messages ul").html("<li><span style=\"color: black;font-size: 12px;\">Warning: </span><g:message code="order.period.not.equal.to.customer.billing.cycle"/></li>");
                }
                }
            });
        }

        $(function() {
            if($("#proratingOption").val() == 'PRORATING_MANUAL' && (${order?.prorateFlag} == true || ${order?.isDisable} == true)) {
                $('#manualProrateFlag').prop('checked',true);
            }
            $('#manualProrateFlag').change(function() {
                validateManualProrating();
            });
        });

        function validateManualProrating() {
            if ($("#proratingOption").val() == 'PRORATING_MANUAL' &&
                    ($("#manualProrateFlag").prop("checked") == true || $("#manualProrateFlag").prop("disabled") == true)) {
                $.ajax({
                    type: 'POST',
                    url: '${createLink(action: 'validateOrderPeriod')}',
                    data: $('#manualProrateFlag').parents('form').serialize(),
                    success: function(data) {
                        prorateResult(data);
                    }
                });
            }
        }

        function prorateResult(data) {
            if (!data.prorateFlag) {
                disableProrate();
            }
        }

        function cleanProrate() {
            if ($("#manualProrateFlag").prop("checked") == true)
                $('#manualProrateFlag').click();
            $("#manualProrateFlag").prop("disabled", false);
        }

        function disableProrate() {
            $('#manualProrateFlag').click();
            $("#manualProrateFlag").prop("disabled", true);
            $("#error-messages").css("display","block");
            $("#error-messages ul").css("display","block");
            $("#error-messages ul").html("<li><g:message code="order.period.unit.should.equal"/></li>");
        }
        
    </script>
	<script type="text/javascript">
		changeDiv();

        var loggedInUserCodes = [
            <g:each in="${userCodes}" var="uc" status="tmpIdx">${tmpIdx==0?"":","}"${uc}"</g:each>
        ];

        $('.userCode-marker').autocomplete({ source: loggedInUserCodes });

	</script>
    <!-- confirmation dialog for status changes -->
    <div id="status-suspended-dialog" title="${message(code: 'popup.confirm.title')}">
        <table style="margin: 3px 0 0 10px">
            <tbody>
            <tr>
                <td valign="top">
                    <img src="${resource(dir:'images', file:'icon34.gif')}" alt="confirm">
                </td>
                <td class="col2" style="padding-left: 7px">
                    <g:message code="order.prompt.set.suspended" args="[order?.id]"/>
                </td>
            </tr>
            </tbody>
        </table>
    </div>
</div>
