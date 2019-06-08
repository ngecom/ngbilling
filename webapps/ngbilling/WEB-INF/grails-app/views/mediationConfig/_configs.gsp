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
  
<%@ page contentType="text/html;charset=UTF-8" %>

<%--
  Shows a list of Mediation COnfigurations.

  @author Vikas Bodani
  @since  05-Oct-2011
--%>

<div class="table-box">
    <table id="tbl-mediation-config" cellspacing="0" cellpadding="0">
        <thead>
            <tr>
                <th><g:message code="mediation.config.name"/></th>
                <th><g:message code="mediation.config.order"/></th>
                <th><g:message code="mediation.config.plugin"/></th>
            </tr>
        </thead>

        <tbody>
            <g:each var="config" in="${types}">
            
                <g:set var="configReader" value="${readers.find{ it.id == config.pluggableTaskId}}"/>

                <tr id="config-${config.id}" class="${selected?.id == config.id ? 'active' : ''}">
                    <!-- Name ID -->
                    <td>
                        <g:remoteLink class="cell double" action="show" id="${config.id}" before="register(this);" onSuccess="render(data, next);">
                            <strong>${config?.name}</strong>
                            <em><g:message code="table.id.format" args="[config.id as String]"/></em>
                        </g:remoteLink>
                    </td>
                    
                    <!-- Order -->
                    <td>
                        <g:remoteLink class="cell double" action="show" id="${config.id}" before="register(this);" onSuccess="render(data, next);">
                            ${config?.orderValue}
                        </g:remoteLink>
                    </td>
                    
                    <!-- Plugin -->
                    <td>
                        <g:remoteLink class="cell double" action="show" id="${config.id}" before="register(this);" onSuccess="render(data, next);">
                            
                            ${'(' + configReader.id + ') ' + configReader.type?.getDescription(session.language_id)}
                            
                        </g:remoteLink>
                    </td>
                    
                </tr>

            </g:each>
        </tbody>
    </table>
</div>

<div class="btn-box">
    <g:remoteLink class="submit add" action="edit" before="register(this);" onSuccess="render(data, next);">
        <span><g:message code="button.create"/></span>
    </g:remoteLink>
</div>