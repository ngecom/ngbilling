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

<g:set var="next" value="${model}"/>

<g:while test="${next}">
    <tr class="price">
        <td><g:message code="plan.model.type"/></td>
        <td class="value"><g:message code="price.strategy.${next.type.name()}"/></td>
        <td><g:message code="plan.model.rate"/></td>
        <td class="value">
            <g:if test="${next.rate || next.rate?.compareTo(BigDecimal.ZERO) == 0}">
                <g:textField name="line-${index}_plan-${planIndex++}.price" value="${olpi.price.setScale(4)}" id="textField_price_${planIndex}" style="display:inline; width:80px;"/>
                <div id="label_price_${planIndex}"><g:formatNumber number="${olpi.price}" maxFractionDigits="4" type="currency" currencySymbol="${next.currency?.symbol}"/></div> 
            </g:if>
            <g:else>
				-
            </g:else>
        </td>
    </tr>
    <g:each var="attribute" in="${next.attributes.entrySet()}">
        <g:if test="${attribute.value}">
            <tr class="attribute">
                <td></td><td></td>
                <td><g:message code="${attribute.key}"/></td>
                <td class="value">${attribute.value}</td>
            </tr>
        </g:if>
    </g:each>

    <g:set var="next" value="${next.next}"/>
    
</g:while>
