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
  
<%@ page import="org.apache.commons.lang.StringEscapeUtils" contentType="text/html;charset=UTF-8" %>

<%--
  Shows a list of Custom Contact Fields.

  @author Vikas Bodani
  @since  03-Oct-2011
--%>

<div class="table-box">
    <table id="ccf-fields" cellspacing="0" cellpadding="0">
        <thead>
            <tr>
                <th class="medium"><g:message code="contact.field.name"/></th>
                <th class="medium"><g:message code="contact.field.datatype"/></th>
                <th class="medium"><g:message code="contact.field.isReadOnly"/></th>
                <th class="medium"><g:message code="contact.field.displayInView"/></th>
            </tr>
        </thead>

        <tbody>
            <g:each var="type" in="${types}">

                <tr id="ccf-${type.id}" class="${selected?.id == type.id ? 'active' : ''}">
                    <!-- ID -->
                    <td>
                        <g:remoteLink class="cell double" action="show" id="${type.id}" before="register(this);" onSuccess="render(data, next);">
                            <strong>${StringEscapeUtils.escapeHtml(type?.getDescription(session['language_id']))}</strong>
                            <em><g:message code="table.id.format" args="[type.id]"/></em>
                        </g:remoteLink>
                    </td>
                    
                    <!-- datatype TODO utility method to use proper case-->
                    <td>
                        <g:remoteLink class="cell double" action="show" id="${type.id}" before="register(this);" onSuccess="render(data, next);">
                            <g:showProperCase value="${StringEscapeUtils.escapeHtml(type?.dataType)}"/>
                        </g:remoteLink>
                    </td>
                    
                    <!-- read only -->
                    <td>
                        <g:remoteLink class="cell double" action="show" id="${type.id}" before="register(this);" onSuccess="render(data, next);">
                            <g:formatBoolean boolean="${type?.readOnly > 0}"/>
                        </g:remoteLink>
                    </td>
                    
                    <!-- display -->
                    <td>
                        <g:remoteLink class="cell double" action="show" id="${type.id}" before="register(this);" onSuccess="render(data, next);">
                            <g:formatBoolean boolean="${type?.displayInView>0}"/>
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