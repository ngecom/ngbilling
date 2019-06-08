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

<%--
  This template shows discount details.

  @author Amol Gadre
  @since  28-Nov-2012
--%>

<%@ page import="com.sapienter.jbilling.server.order.db.OrderPeriodDTO" %>

<div class="column-hold">
    <div class="heading">
	    <strong>${selected.description}</strong>
	</div>

	<div class="box">
        <!-- discount info -->
        <div class="sub-box">
        <table class="dataTable" cellspacing="0" cellpadding="0">
            <tbody>
                <tr>
                    <td><g:message code="discount.detail.id"/></td>
                    <td class="value">${selected?.id}</td>
                </tr>
                <tr>
                    <td><g:message code="discount.detail.code"/></td>
                    <td class="value">${selected?.code}</td>
                </tr>
                <tr>
                    <td><g:message code="discount.detail.description"/></td>
                    <td class="value">${selected?.description}</td>
                </tr>
                <tr>
                    <td><g:message code="discount.detail.rate"/></td>
                    <td class="value">
                    <g:if test="${selected?.type?.name()?.equals('ONE_TIME_PERCENTAGE')}">
                    	%<g:formatNumber number="${selectedDiscountRate}" formatName='money.format'/>
                    </g:if>
                    <g:elseif test="${selected?.type?.name()?.equals('RECURRING_PERIODBASED')}">
                    	<g:if test="${Boolean.TRUE.equals(selected?.isPercentageRate())}">
                    		%<g:formatNumber number="${selectedDiscountRate}" formatName='money.format'/>
                    	</g:if>
                    	<g:else>
                    		<g:formatNumber number="${selectedDiscountRate}" type="currency" currencySymbol="${selected?.entity?.currency?.symbol}"/>
                    	</g:else>
                    </g:elseif>
                    <g:else>
                    	<g:formatNumber number="${selectedDiscountRate}" type="currency" currencySymbol="${selected?.entity?.currency?.symbol}"/>
                    </g:else>
                    </td>
                </tr>
                <tr>
                    <td><g:message code="discount.detail.type"/></td>
                    <td class="value"><g:message code="${selected?.type?.messageKey}"/></td>
                </tr>
                <tr>
                    <td><g:message code="discount.detail.startDate"/></td>
                    <td class="value"><g:formatDate date="${selected?.startDate}" formatName="date.pretty.format"/></td>
                </tr>
                <tr>
                    <td><g:message code="discount.detail.endDate"/></td>
                    <td class="value"><g:formatDate date="${selected?.endDate}" formatName="date.pretty.format"/></td>
                </tr>
                <g:render template="/metaFields/metaFields" model="[metaFields: selected?.metaFields]"/>
                <tr><td>&nbsp;</td><td>&nbsp;</td></tr>
                
                <g:each var="attribute" in="${selected?.attributes?.entrySet()}" status="s">
			        <g:if test="${attribute.key.equals('periodUnit')}">
			            <tr class="attribute">
			            	<td><g:if test="${s==0}"><g:message code="discount.detail.attributes"/></g:if><g:else></g:else></td>
			                <td><g:message code="discount.detail.${attribute.key}"/></td>
			                <td class="value">${selectedOrderPeriodDescription}</td>
			            </tr>
			        </g:if>
			        <g:elseif test="${attribute.key.equals('isPercentage')}">
			            <tr class="attribute">
			            	<td><g:if test="${s==0}"><g:message code="discount.detail.attributes"/></g:if><g:else></g:else></td>
			                <td><g:message code="discount.detail.${attribute.key}"/></td>
			                <td class="value">${isPercentageValue}</td>
			            </tr>
			        </g:elseif>
			        <g:elseif test="${attribute.key.equals('periodValue')}">
				        <g:if test="${attribute.value}">
				            <tr class="attribute">
				            	<td><g:if test="${s==0}"><g:message code="discount.detail.attributes"/></g:if><g:else></g:else></td>
				                <td><g:message code="discount.detail.${attribute.key}"/></td>
				                <td class="value">${attribute.value}</td>
				            </tr>
				        </g:if>
			        </g:elseif>
			        <g:else>
				        <g:if test="${attribute.value}">
				            <tr class="attribute">
				            	<td><g:if test="${s==0}"><g:message code="discount.detail.attributes"/></g:if><g:else></g:else></td>
				                <td><g:message code="${attribute.key}"/></td>
				                <td class="value">${attribute.value}</td>
				            </tr>
				        </g:if>
			        </g:else>
			    </g:each>
    
            </tbody>
        </table>
    	</div>
    </div>

    <div class="btn-box">
        	<g:link action="edit" id="${selected.id}" class="submit edit"><span><g:message code="button.edit"/></span></g:link>
	        <a onclick="showConfirm('deleteDiscount-${selected.id}');" class="submit delete"><span><g:message code="button.delete"/></span></a>
    </div>

    <g:render template="/confirm"
          model="[message: 'discount.prompt.are.you.sure',
                  controller: 'discount',
                  action: 'deleteDiscount',
                  id: selected.id,
                 ]"/>

</div>
