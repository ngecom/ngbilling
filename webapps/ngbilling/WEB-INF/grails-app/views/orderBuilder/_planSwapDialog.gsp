%{--
  JBILLING CONFIDENTIAL
  _____________________

  [2003] - [2012] Enterprise jBilling Software Ltd.
  All Rights Reserved.

  NOTICE:  All information contained herein is, and remains
  the property of Enterprise jBilling Software.
  The intellectual and technical concepts contained
  herein are proprietary to Enterprise jBilling Software
  and are protected by trade secret or copyright law.
  Dissemination of this information or reproduction of this material
  is strictly forbidden.
  --}%

<%@ page import="com.sapienter.jbilling.server.order.SwapMethod; com.sapienter.jbilling.server.user.db.CompanyDTO; com.sapienter.jbilling.server.item.db.ItemTypeDTO" %>

<%--
  Shows the plans list with filtering capabilities and provides functionality to select effective date and plan.
--%>

<div id="swap-plan-dialog" class="bg-lightbox column" title="<g:message code="popup.swap.plan.title"/>"
     style="display:none;">

    <div class="form-columns single">
        <div class="msg-box error" id="swap-plan-validation-message" style="display: none;">
            <g:message code="validation.swap.plan.select.values"/>
        </div>
        <div class="msg-box error" id="swap-plan-date-validation-message" style="display: none;">
            <g:message code="validation.swap.plan.incorrect.date"/>
        </div>
    </div>

    <div class="form-columns single">
        <g:formRemote name="swap-plan-form" id="swap-plan-form"
                      url="[controller: 'orderBuilder', action: 'edit', _eventId: 'swapPlan']"
                      update="ui-tabs-edit-changes" method="GET" >
            <g:hiddenField name="existedPlanItemId" id="existedPlanItemId" value="${line?.itemId}"/>
            <g:hiddenField name="swapPlanItemId" id="swapPlanItemId" value=""/>
            <g:hiddenField name="_eventId" value="swapPlan"/>
            <g:hiddenField name="execution" value="${flowExecutionKey}"/>

            <g:applyLayout name="form/select">
                <content tag="label"><g:message code="popup.swap.plan.method"/></content>
                <content tag="label.for">change-${changeId}.orderChangeTypeId</content>
                <g:select name="swapMethod"
                          from="${SwapMethod.values()}"
                          optionKey="${{it.name()}}" optionValue="${{it.name()}}"
                          value="${SwapMethod.DIFF.name()}"/>
            </g:applyLayout>

            <g:applyLayout name="form/date">
                <content tag="label"><g:message code="popup.swap.plan.effective.date"/></content>
                <content tag="label.for">swap_plan_effectiveDate</content>
                <g:textField class="field" name="effectiveDate" id="swap_plan_effectiveDate"
                             value="${formatDate(date: new Date(), formatName: 'datepicker.format')}"/>
            </g:applyLayout>
        </g:formRemote>
    </div>

    <!-- filter -->
    <div class="form-columns single">
        <g:formRemote name="planSwap-filter-form" url="[action: 'edit']" update="planSwap-placeholder" method="GET">
            <g:hiddenField name="forSwapPlan" value="true"/>
            <g:hiddenField name="_eventId" value="plans"/>
            <g:hiddenField name="execution" value="${flowExecutionKey}"/>

            <g:applyLayout name="form/input">
                <content tag="label"><g:message code="filters.title"/></content>
                <content tag="label.for">filterBy</content>
                <g:textField name="filterBy" class="field default"
                             placeholder="${message(code: 'products.filter.by.default')}" value="${params.filterBy}"/>
            </g:applyLayout>
        </g:formRemote>

        <script type="text/javascript">
            $('#planSwap-filter-form :input[name=filterBy]').blur(function () {
                $('#planSwap-filter-form').submit();
            });
            placeholder();
        </script>
    </div>

    <!-- plans list -->
    <div id="planSwap-placeholder">
        <g:render template="planSwapTable"/>
    </div>
</div>


<script type="text/javascript">
    $(function () {

        setTimeout(function () {
            $('#swap-plan-dialog.ui-dialog-content').remove();
            $('#swap-plan-dialog').dialog({
                autoOpen: false,
                height: 650,
                width: 800,
                modal: true,
                buttons: [
                    {
                        text: '<g:message code="button.plan.swap"/>',
                        click: function () {
                            if ($('#swap-plan-table tr.active').length > 0) {
                                if ($('#swap_plan_effectiveDate').val() == "" || !isSwapDateValid()) {
                                    $('#swap-plan-validation-message').hide();
                                    $('#swap-plan-date-validation-message').show();
                                } else {
                                    $('#swap-plan-validation-message').hide();
                                    $('#swap-plan-date-validation-message').hide();
                                    $("#swap-plan-form").submit();
                                    $(this).dialog('close');
                                }
                            } else {
                                $('#swap-plan-date-validation-message').hide();
                                $('#swap-plan-validation-message').show();
                            }
                        }
                    },
                    {
                        text: '<g:message code="button.close"/>',
                        click: function () {
                            $(this).dialog('close');
                        }
                    }
                ]
            });
        }, 100);
    });

    function swapPlan(existedPlanItemId) {
        $('#existedPlanItemId').val(existedPlanItemId);
        $('#swap-plan-validation-message').hide();
        $('#swap-plan-dialog').dialog('open');
    }

    function isSwapDateValid() {
        var dateStr = $('#swap_plan_effectiveDate').val();
        var nowStr = '${formatDate(date: new Date(), formatName: 'datepicker.format')}';
        var dateFormat= "<g:message code="date.format"/>";
        try {
            dateFormat = dateFormat.replace('MM', 'mm');   //to support java date formats
            dateFormat = dateFormat.replace('yyyy', 'yy'); //to support java date formats
            var dateValue = jQuery.datepicker.parseDate(dateFormat, dateStr, null);
            var nowValue = jQuery.datepicker.parseDate(dateFormat, nowStr, null);
            if (dateValue.getTime() < nowValue.getTime()) {
                return false;
            }
            return true;
        } catch(error){
            return false;
        }
    }
</script>