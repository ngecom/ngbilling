<div id="subscriptionTemplate">
	<g:applyLayout name="form/select">
		<div class="inp-bg inp2" style="display: none;">
				<g:textField class="field" name="mainSubscription.nextInvoiceDayOfPeriod" 
				value="${mainSubscription?.nextInvoiceDayOfPeriod ?: 1}" maxlength="4" size="3"/>				            					           	                
   		</div>
	</g:applyLayout>
</div>