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
  Shows order period.

  @author Vikas Bodani
  @since  30-Sept-2011
--%>

<%@page import="com.sapienter.jbilling.server.process.db.PeriodUnitDTO" %>

<div class="column-hold">
    <div class="heading">
        <g:set var="descriptionTmp" value="${selected?.getDescription(session['language_id'].toInteger())}"/>
        <strong>${descriptionTmp.length() > 50 ? descriptionTmp.substring(0, 50) + '...' : descriptionTmp}</strong>
    </div>

    <div class="box">
        <div class="sub-box">
          <table class="dataTable" cellspacing="0" cellpadding="0">
            <tbody>
            <tr>
                <td><g:message code="orderPeriod.id"/></td>
                <td class="value">${selected.id}</td>
            </tr>
            <%-- 
            <tr>
                <td><g:message code="orderPeriod.description"/></td>
                <td class="value">${selected.getDescription(session['language_id'])}</td>
            </tr>
            --%>
            <tr>
                <td><g:message code="orderPeriod.unit"/></td>
                <td class="value">${selected?.periodUnit?.getDescription(session['language_id'])}</td>
            </tr>
            <tr>
                <td><g:message code="orderPeriod.value"/></td>
                <td class="value">${selected.value}</td>
            </tr>
            </tbody>
        </table>
      </div>
    </div>

    <div class="btn-box">
        <div class="row">
            <g:remoteLink class="submit add" id="${selected.id}" action="edit" update="column2">
                <span><g:message code="button.edit"/></span>
            </g:remoteLink>
            <a onclick="showConfirm('delete-${selected.id}');" class="submit delete"><span><g:message code="button.delete"/></span></a>
        </div>
    </div>

    <g:render template="/confirm"
              model="['message': 'config.period.delete.confirm',
                      'controller': 'orderPeriod',
                      'action': 'delete',
                      'id': selected.id,
                     ]"/>
</div>