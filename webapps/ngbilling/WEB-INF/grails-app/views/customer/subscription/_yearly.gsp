<div id="subscriptionTemplate">
 <table style="width: 100%; vertical-align: top; margin: 0px; padding: 0px;">
    <tr>
        <td style="width: 100%; vertical-align: top; margin: 0px; padding: 0px;">
          <g:applyLayout name="form/select">
	      	<div class="select5">
	      	<content tag="label"><g:message code="prompt.main.subscription.value"/></content>
			<content tag="label.for">mainSubscription.nextInvoiceDayOfPeriod</content>
				<g:select id="mainSubscription" from="${mainSubscription?.yearMonthsMap?.entrySet()}"
	                optionKey="key" optionValue="value"
	                name="mainSubscription.nextInvoiceDayOfPeriod" 
	                value="${mainSubscription?.nextInvoiceDayOfPeriod}"/>
	  		</div>
			<div class="select4">
				<g:select id="mainSubscription" from="${mainSubscription?.yearMonthDays}"
                	 name="mainSubscription.nextInvoiceDayOfPeriodOfYear" 
                	value="${mainSubscription?.nextInvoiceDayOfPeriodOfYear}"/>
			</div>	
	</g:applyLayout>
    	</td>
    </tr>
</table>
</div>