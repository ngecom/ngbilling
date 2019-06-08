<div id="subscriptionTemplate">
	<g:applyLayout name="form/select">
		<div class="select5">
		<content tag="label"><g:message code="prompt.main.subscription.value"/></content>
		<content tag="label.for">mainSubscription.nextInvoiceDayOfPeriod</content>
				<g:select id="mainSubscription" from="${mainSubscription?.semiMonthlyDaysMap?.entrySet()}"
                   optionKey="key" optionValue="value"
                   name="mainSubscription.nextInvoiceDayOfPeriod" 
                   value="${mainSubscription?.nextInvoiceDayOfPeriod}"/>
      		</div>
	</g:applyLayout>
</div>

