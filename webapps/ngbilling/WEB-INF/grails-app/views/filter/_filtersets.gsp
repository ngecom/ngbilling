<%@ page import="org.apache.commons.lang.StringEscapeUtils; org.apache.commons.lang.StringUtils" %>
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
<g:hasErrors bean="${selected}">
    <div id="error-messages" class="msg-box error">
        <img src="${resource(dir: 'images', file: 'icon14.gif')}"
             alt="${message(code: 'error.icon.alt', default: 'Error')}"/>
        <strong><g:message code="flash.error.title"/></strong>
        <ul>
            <g:eachError var="err" bean="${selected}">
                <li><g:message error="${err}"/></li>
            </g:eachError>
        </ul>
    </div>
</g:hasErrors>

<div id="filterset-list" class="column">
    <div class="column-hold">
        <div class="table-box">
            <table id="users" cellspacing="0" cellpadding="0">
                <thead>
                <tr>
                    <th><g:message code="filters.save.th.name"/></th>
                    <th class="medium"><g:message code="filters.save.th.filters"/></th>
                </tr>
                </thead>
                <tbody>

                <g:each var="filterset" in="${filtersets}">
                    <tr id="filterset-${filterset.id}" class="${selected?.id == filterset.id ? 'active' : ''}">
                        <td>
                            <g:remoteLink class="cell double" controller="filter" action="edit" id="${filterset.id}" update="filterset-edit">
                                <strong>${StringUtils.abbreviate(StringEscapeUtils.escapeHtml(filterset?.name), 30)}</strong>
                                <em><g:message code="table.id.format" args="[filterset.id]"/></em>
                            </g:remoteLink>
                        </td>
                        <td>
                            <g:set var="count" value="${filterset.filters.findAll { it.value }?.size()}"/>
                            <g:remoteLink class="cell" controller="filter" action="edit" id="${filterset.id}" update="filterset-edit">
                                ${count}
                            </g:remoteLink>
                        </td>
                    </tr>
                </g:each>

                </tbody>
            </table>
        </div>
        <div class="btn-box">
            <div class="row"></div>
        </div>
    </div>
</div>

<div id="filterset-edit" class="column">
    <g:render template="edit" model="[selected: selected, filters: filters]"/>
</div>