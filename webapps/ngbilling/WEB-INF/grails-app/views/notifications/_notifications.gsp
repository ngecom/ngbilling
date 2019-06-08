<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
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

<g:set var="languageId" value="${session['language_id'] as Integer}"/>
<g:set var="entityId" value="${session['company_id'] as Integer}"/>
<div id="notification-box">
<div class="table-box">
    <table cellpadding="0" cellspacing="0">
        <thead>
            <th><g:message code="title.notification" /></th>
            <th><g:message code="title.notification.active" /></th>
            <g:set var="categoryId" value="${selected}"/>
        </thead>
        <tbody>
		<g:each in="${lstByCategory}" status="idx" var="dto">
			<tr class="${dto.id == messageTypeId ? 'active' : ''}">
    			<td><g:remoteLink breadcrumb="id" class="cell" action="show" id="${dto.id}" params="['template': 'show']"
    	                   before="register(this);" onSuccess="render(data, next);">
    				    <strong>${StringEscapeUtils.escapeHtml(dto?.getDescription(languageId))}</strong>
						<em><g:message code="table.id.format" args="[dto.id as String]"/></em>
				</g:remoteLink>
				</td>
                <td>
    				<g:set var="flag" value="${true}"/>
    				<g:each status="iter" var="var" in="${dto.getNotificationMessages()}">
    					<g:if test="${flag}">
    						<g:if test="${languageId == var.language.id && var.entity.id == entityId && var.useFlag > 0}">
    								<g:set var="flag" value="${false}"/>
    						</g:if>
    					</g:if>
    				</g:each>
    				<span class="block">
    					<span>
        					<g:if test="${flag}">
        						<g:message code="prompt.no"/>
        					</g:if>
        					<g:else>
        						<g:message code="prompt.yes"/>
        					</g:else>
    					</span>
    				</span>
    			</td>
            </tr>
		</g:each>
	</tbody>
    </table>
</div>
%{--<g:set var="updateColumn" value="${actionName == 'list' ? 'column1' : 'column2'}"/>--}%
<div class="pager-box">
	<div class="row">
		<div class="results">
			<g:render template="/layouts/includes/pagerShowResults"  model="[steps: [10, 20, 50], update: 'column1', id: categoryId]"/>
		</div>
	</div>
	<div class="row">
		<util:remotePaginate controller="notifications" action="list" params="${sortableParams(params: [partial: true, id: categoryId])}" total="${lstByCategory?.totalCount ?: 0}" update="notification-box"/>
	</div>
</div>

<div class="btn-box">
    <g:remoteLink action="editNotification" class="submit add"
                  before="register(this);"
                  onSuccess="render(data, next);" params="['categoryId':categoryId]">
        <span><g:message code="button.create.notification"/></span>
    </g:remoteLink>
</div>
</div>
