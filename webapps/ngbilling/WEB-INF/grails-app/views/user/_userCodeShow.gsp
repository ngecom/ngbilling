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
  Display information for a User Code

  @author Gerhard Maree
  @since  25-Nov-2013
--%>


<div class="column-hold">
    <div class="heading">
	    <strong>
	    	${userCode.identifier}
	    </strong>
	</div>

	<div class="box">
        <div class="sub-box">
            <%-- product info --%>
            <table class="dataTable" cellspacing="0" cellpadding="0">
                <tbody>
                    <tr>
                        <td><g:message code="userCode.detail.id"/></td>
                        <td class="value">${userCode.id}</td>
                    </tr>
                    <tr>
                        <td><g:message code="userCode.detail.identifier"/></td>
                        <td class="value">${userCode.identifier}</td>
                    </tr>
                    <tr>
                        <td><g:message code="userCode.detail.externalReference"/></td>
                        <td class="value">${userCode.externalReference}</td>
                    </tr>
                    <tr>
                        <td><g:message code="userCode.detail.type"/></td>
                        <td class="value">${userCode.type}</td>
                    </tr>
                    <tr>
                        <td><g:message code="userCode.detail.typeDescription"/></td>
                        <td class="value">${userCode.typeDescription}</td>
                    </tr>
                    <tr>
                        <td><g:message code="userCode.detail.validFrom"/></td>
                        <td class="value"><g:formatDate format="MM/dd/yyyy" date="${userCode.validFrom}"/></span></td>
                    </tr>
                    <tr>
                        <td><g:message code="userCode.detail.validTo"/></td>
                        <td class="value"><g:formatDate format="MM/dd/yyyy" date="${userCode.validTo}"/></span></td>
                    </tr>

                </tbody>
            </table>

        </div>
    </div>


    <div class="btn-box">

            <g:link action="userCodeEdit" id="${userCode.id}" class="submit edit"><span><g:message code="button.edit"/></span></g:link>

            <g:if test="${userCode.validTo == null || userCode.validTo.after(new Date())}">
                <a onclick="showConfirm('userCodeDeactivate-${userCode.id}');" class="submit delete"><span><g:message code="button.deactivate"/></span></a>
            </g:if>
    </div>

    <g:render template="/confirm"
              model="['message': 'userCode.deactivate.confirm',
                      'controller': 'user',
                      'action': 'userCodeDeactivate',
                      'id': userCode.id,
                      'formParams': ['userId': user.id],
                      'ajax': false
                     ]"/>
</div>

