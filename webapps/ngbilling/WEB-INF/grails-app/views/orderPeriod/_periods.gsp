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
  
<%@page import="org.apache.commons.lang.StringEscapeUtils; com.sapienter.jbilling.server.process.db.PeriodUnitDTO" %>

<%@ page contentType="text/html;charset=UTF-8" %>

<%--
  Shows a list of order periods.

  @author Vikas Bodani
  @since  30-Sept-2011
--%>

<div class="table-box">
    <table id="periods" cellspacing="0" cellpadding="0">
        <thead>
            <tr>
                <th class="medium"><g:message code="orderPeriod.description"/></th>
                <th class="medium"><g:message code="orderPeriod.unit"/></th>
                <th class="large"><g:message code="orderPeriod.value"/></th>
            </tr>
        </thead>

        <tbody>
            <g:each var="period" in="${periods}">

                <tr id="period-${period.id}" class="${selected?.id == period.id ? 'active' : ''}">
                    <!-- ID -->
                    <g:set var="descriptionTmp" value="${period?.getDescription(session['language_id'])}"/>
                    <td>
                        <g:remoteLink class="cell double" action="show" id="${period.id}" before="register(this);" onSuccess="render(data, next);">
                            <strong ${descriptionTmp.length() > 50 ? 'style=\"white-space: nowrap;\"' : ''}>
                                ${descriptionTmp.length() > 50 ? StringEscapeUtils.escapeHtml(descriptionTmp.substring(0, 50) + '...') : StringEscapeUtils.escapeHtml(descriptionTmp)}
                            </strong>
                            <em><g:message code="table.id.format" args="[period.id]"/></em>
                        </g:remoteLink>
                    </td>
                    
                    <!-- Unit -->
                    <td>
                        <g:remoteLink class="cell double" action="show" id="${period.id}" before="register(this);" onSuccess="render(data, next);">
                            ${StringEscapeUtils.escapeHtml(period?.periodUnit?.getDescription(session['language_id']))}
                        </g:remoteLink>
                    </td>
                    
                    <!-- Value -->
                    <td>
                        <g:remoteLink class="cell double" action="show" id="${period.id}" before="register(this);" onSuccess="render(data, next);">
                            ${period.value}
                        </g:remoteLink>
                    </td>
                    
                </tr>

            </g:each>
        </tbody>
    </table>
</div>
<div class="pager-box">
   <div class="row">
        <div class="results">
            <g:render template="/layouts/includes/pagerShowResults"
                      model="[steps: [10, 20, 50], update: 'column1']"/>
        </div>
    </div>

    <div class="row">
        <util:remotePaginate controller="orderPeriod" action="${action ?: 'list'}"
                             params="${sortableParams(params: [partial: true])}"
                             total="${periods?.totalCount ?: 0}" update="column1"/>
    </div>
</div>
<div class="btn-box">
    <g:remoteLink class="submit add" action="edit" before="register(this);" onSuccess="render(data, next);">
        <span><g:message code="button.create"/></span>
    </g:remoteLink>
</div>