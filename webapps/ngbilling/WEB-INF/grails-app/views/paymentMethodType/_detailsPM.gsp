<g:set var="isNew" value="${!paymentMethod || !paymentMethod?.id || paymentMethod?.id == 0}"/>

<div id="details-box">
    <br/>
    <div id="error-messages" class="msg-box error" style="display: none;">
        <ul></ul>
    </div>

    <g:formRemote name="pmt-details-form" url="[action: 'editPM']" update="column2" method="GET">
        <g:hiddenField name="_eventId" value="update"/>
        <g:hiddenField name="execution" value="${flowExecutionKey}"/>

        <div class="form-columns">

            <g:applyLayout name="form/text">
                <content tag="label"><g:message code="paymentMethod.id.label"/></content>

                <g:if test="${!isNew}">
                    <span>${paymentMethod.id}</span>
                </g:if>
                <g:else>
                    <em><g:message code="prompt.id.new"/></em>
                </g:else>

                <g:hiddenField name="paymentMethod.id" value="${paymentMethod?.id}"/>
            </g:applyLayout>
            
            <g:applyLayout name="form/text">
                <content tag="label"><g:message code="paymentMethod.template.name.label"/></content>
                <span>${template?.templateName}</span>
            </g:applyLayout>

            <g:applyLayout name="form/input">
                <content tag="label">
                <g:message code="paymentMethod.name.label" /><span id="mandatory-meta-field">*</span></content>
                <content tag="label.for">methodName</content>
                <g:textField class="field text" name="methodName" value="${paymentMethod?.methodName}"/>
            </g:applyLayout>
            
            <g:applyLayout name="form/checkbox">
                <content tag="label"><g:message code="paymentMethod.recurring.label"/></content>
                <content tag="label.for">isRecurring</content>
                <g:checkBox class="cb checkbox" name="isRecurring" checked="${paymentMethod?.isRecurring}"/>
            </g:applyLayout>
            
            <g:applyLayout name="form/checkbox">
                <content tag="label"><g:message code="paymentMethod.allAccountTypes.label"/></content>
                <content tag="label.for">allAccount</content>
                <g:checkBox class="cb checkbox" id="allAccount" name="allAccountType" checked="${paymentMethod?.isAllAccountType()}" onclick="hideShowAccountTypes()"/>
            </g:applyLayout>

            <g:applyLayout name="form/select">
                <content tag="label"><g:message code="paymentMethod.accountTypes.label"/></content>
                <content tag="label.for">accountTypes</content>
                <g:select name="accountTypes" multiple="true"
                          from="${availableAccountTypes}"
                          value="${paymentMethod?.accountTypes}"
                          optionKey="id"
                          optionValue="${{it.getDescription(session['language_id'])}}"
                          noSelection="['': message(code: 'default.no.selection')]"/>
            </g:applyLayout>
        </div>

    </g:formRemote>


<script type="text/javascript">

    if ($("#allAccount").is(":checked")) {
        $("#accountTypes").attr('disabled', "disabled");
        $('#accountTypes option').removeAttr('selected', false);
    }

    function hideShowAccountTypes() {
        $('#accountTypes option').removeAttr('selected', false);
        if ($("#allAccount").is(":checked")) {
            $("#accountTypes").prop('disabled', true);
        } else {
            $("#accountTypes").removeAttr('disabled');
        }
    }

    var submitForm = function() {
        var form = $('#pmt-details-form');
        form.submit();
    };

    $('#pmt-details-form').find('input.text').blur(function() {
        submitForm();
    });

    $('#pmt-details-form').find('input').blur(function() {
        submitForm();
    });

    $('#pmt-details-form').find('select').change(function() {
        submitForm();
    });

    $('#pmt-details-form').find('checkbox').change(function() {
        submitForm();
    });

    var validator = $('#pmt-details-form').validate();
    validator.init();
    validator.hideErrors();
</script>

</div>