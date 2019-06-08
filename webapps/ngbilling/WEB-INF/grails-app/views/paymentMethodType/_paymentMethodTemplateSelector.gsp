<div class="form-edit">
    <div class="heading">
        <strong>
            <g:message code="paymentMethod.template.title"/>
        </strong>
    </div>

    <g:form name="payment-method-template-select-form" action="edit">
        <fieldset>
            <div class="form-columns">
                <div class="column">
	                <g:applyLayout name="form/select">
	                    <content tag="label"><g:message code="prompt.paymentMethod.template"/></content>
	                    <content tag="label.for">templateId</content>
	                    <g:select name="templateId"
	                              from="${templates}"
	                              optionKey="id"
	                              optionValue="templateName"/>
	                </g:applyLayout>
                </div>
            </div>
            <!-- spacer -->
            <div>
                <br/>&nbsp;
            </div>
        </fieldset>
    </g:form>

    <div class="buttons">
        <div class="btn-row">
            <ul>
                <li>
                    <a onclick="$('#payment-method-template-select-form').submit()" class="submit save">
                        <span><g:message code="button.select"/></span>
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
</div>