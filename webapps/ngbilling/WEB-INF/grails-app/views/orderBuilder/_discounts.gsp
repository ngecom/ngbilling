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

<%@ page import="com.sapienter.jbilling.server.discount.db.DiscountDTO; com.sapienter.jbilling.server.user.db.CompanyDTO;" %>

<%--
  Allows user to define discounts at order or line level.
  
  @author Amol Gadre
  @since  30-Nov-2012
--%>

<g:set var="discountLineIndex" value="${0}"/>
<g:set var="dbDiscountList" value="${
		                			DiscountDTO.createCriteria().list(){
		                				and{
	            							eq('entity', new CompanyDTO(session['company_id']))
	            							or {
	            								ge('endDate', order.activeSince)
												isNull('endDate')
	            							}
            							}
		                			}
		                		}" />
<g:set var="attributes" value="${model?.attributes ? new TreeMap<String, String>(model.attributes) : new TreeMap<String, String>()}"/>

<div id="discount-messages" class="msg-box error" style="display: none;">
    <ul></ul>
</div>

<g:set var="countIndex" value="${1}" />
<g:set var="isNew" value="${!(order?.id && order?.id>0)}" />
<div id="discount-box">
	<g:formRemote name="discount-lines-form" url="[action: 'edit']" update="ui-tabs-discounts" method="GET">
			<g:hiddenField name="_eventId" value="addRemoveDiscountLine" />
			<g:hiddenField name="execution" value="${flowExecutionKey}"/>
			<g:hiddenField name="discountLineWhatToDo" value="" />
	
	<div class="form-columns">
			<br/>
	    	<div>
	        	<div class="tab-column" style="text-align:center;font-weight:bold;">
	                <g:message code="discountable.item.order"/>
	            </div>
	            <div class="tab-column" style="text-align:center;font-weight:bold;">
	                <g:message code="discount.label"/>
				</div>
			</div>
	    	<br/>
    		
	        <g:each var="discountLine" in="${order.discountLines}" status="counter">
	        <div>
                	<div class="tab-column">
					<g:applyLayout name="form/select">
							<g:select style="width:250px;"
								name="discountableItem.${discountLineIndex}.lineLevelDetails"
								from="${discountableItems}"
								noSelection="['': message(code: 'discountableItem.option.empty')]"
								optionKey="lineLevelDetails" optionValue="description"
								value="${discountLine.lineLevelDetails}" disabled="true"/>
						</g:applyLayout>   
		            </div>
					<div class="tab-column">
					<g:applyLayout name="form/select">
		                <g:select style="width:250px;" name="discount.${discountLineIndex}.id" 
	                		from="${dbDiscountList}" 
		                		noSelection="['': message(code: 'discount.option.empty')]"
		                		optionKey="id" 
		                		optionValue="discountCodeAndDescription" 
		                		value="${discountLine.discountId}" disabled="true"/>
		            </g:applyLayout>
		            </div>
				<g:if test="${isNew}">
				    <a onclick="removeDiscountLine(${discountLineIndex})">
				        <img src="${resource(dir:'images', file:'cross.png')}" alt="remove" style="top:10px;" />
				    </a>
				</g:if>
	            <g:set var="countIndex" value="${countIndex+1}" />
				<g:set var="discountLineIndex" value="${discountLineIndex + 1}"/>
			
			</div> 
			<br/>
	        </g:each>
	       
		<g:if test="${isNew}">
		 <div>	
		    <!-- one empty row -->
	    	<div class="tab-column">
				<g:applyLayout name="form/select">
					<g:select style="width:250px;"
						name="discountableItem.${discountLineIndex}.lineLevelDetails"
						from="${discountableItems}"
						noSelection="['': message(code: 'discountableItem.option.empty')]"
						optionKey="lineLevelDetails" optionValue="description" value="" onchange="focusNext(${discountLineIndex})"/>
				</g:applyLayout>   
	            </div>
				<div class="tab-column">
				<g:applyLayout name="form/select">
	                <g:select style="width:250px;" name="discount.${discountLineIndex}.id" 
	                		from="${dbDiscountList}"
	                		noSelection="['': message(code: 'discount.option.empty')]"
	                		optionKey="id" optionValue="discountCodeAndDescription" value="" onchange="focusNext(${discountLineIndex})"/>
	            </g:applyLayout>
	            </div>
			    <a onclick="addDiscountLine(${discountLineIndex})">
			        <img src="${resource(dir:'images', file:'add.png')}" alt="add" style="top:10px;" />
			    </a>
				
				<g:hiddenField name="discountLineIndex" value="${discountLineIndex}" />
			
		  </div>
		</g:if>
		<br/>
	</div>
	
	</g:formRemote>

	<script type="text/javascript">

		function focusNext(discountLineIndex) {
			//alert (discountLineIndex);
			//alert ( document.getElementById('discount.' + discountLineIndex + '.id').value );
			//alert ( document.getElementById('discountableItem.' + discountLineIndex + '.lineLevelDetails').value );
			var retVal= addDiscountLine(discountLineIndex);
			return retVal;
		}
		
	    function addDiscountLine(discountLineIndex) {

	    	var discountableItem = document.getElementById('discountableItem.' + discountLineIndex + '.lineLevelDetails').value;
	    	//alert (discountableItem);
	    	var discount = document.getElementById('discount.' + discountLineIndex + '.id').value;
	    	//alert (discount);
	    	
	    	if(discountableItem == '' || discount == '') {
                $("#discount-messages").css("display","block");
                $("#discount-messages ul").css("display","block");
                $("#discount-messages ul").html("<li><g:message code="validation.error.discountLine.blank"/></li>");

                if( discountableItem == '' ) {
                	document.getElementById('discountableItem.' + discountLineIndex + '.lineLevelDetails').focus();
                } else if( discount == '' ) {
                	document.getElementById('discount.' + discountLineIndex + '.id').focus();
                }
                
                return false;
            } 
	    	
	        $('#discountLineWhatToDo').val('addDiscountLine');
	        $('#discount-lines-form').submit();
	    	
	    }
	    
	    function removeDiscountLine(discountLineIndex) {
	    	$('#discountLineWhatToDo').val('removeDiscountLine');
	    	$('#discountLineIndex').val(discountLineIndex);
	    	$('#discount-lines-form').submit();
	    }
	
	</script>

</div>
