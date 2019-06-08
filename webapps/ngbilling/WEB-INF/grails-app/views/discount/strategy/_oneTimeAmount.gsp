<%@ page import="com.sapienter.jbilling.server.discount.strategy.DiscountStrategyType;" %>
<g:set var="types" value="${DiscountStrategyType.values()}"/>

<div id="discountStrategy">
	<g:applyLayout name="form/select">
	    <content tag="label"><g:message code="discount.type"/><span id="mandatory-meta-field">*</span></content>
	    <content tag="label.for">discount.type</content>
	    <g:select name="discount.type" class="model-type"
	    		  noSelection="['': message(code: 'default.no.selection')]"
	              from="${DiscountStrategyType.getStrategyTypes()}"
	              value="${discount?.type}"/>
	
	    <g:hiddenField name="discount.oldType" value="${discount?.type}"/>
    
	</g:applyLayout>
	<g:render template="/discount/attributes" model="[discount: discount]"/>
</div>
