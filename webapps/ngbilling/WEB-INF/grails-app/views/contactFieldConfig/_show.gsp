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
  Shows contact field.

  @author Vikas Bodani
  @since  3-Oct-2011
--%>

<div class="column-hold">
    <div class="heading">
        <strong>
            ${selected.getDescription(session['language_id'])}
        <%-- <em>${selected.id}</em> --%>
        </strong>
    </div>

    <div class="box">
      <div class="sub-box">
        <table class="dataTable" cellspacing="0" cellpadding="0">
            <tbody>
            <tr>
                <td><g:message code="contact.field.type.id"/></td>
                <td class="value">${selected.id}</td>
            </tr>
            
            <tr>
                <td><g:message code="contact.field.datatype"/></td>
                <td class="value"><g:showProperCase value="${selected?.dataType}"/></td>
            </tr>
            <tr>
                <td><g:message code="contact.field.isReadOnly"/></td>
                <td class="value"><g:formatBoolean boolean="${selected?.readOnly > 0}"/></td>
            </tr>
            
            <tr>
                <td><g:message code="contact.field.displayOnView"/></td>
                <td class="value"><g:formatBoolean boolean="${selected?.displayInView>0}"/></td>
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
            <%-- 
                <a onclick="showConfirm('delete-${selected.id}');" class="submit delete"><span><g:message code="button.delete"/></span></a>
            --%>
        </div>
    </div>
    <%--
    <g:render template="/confirm"
              model="['message': 'contact.field.delete.confirm',
                      'controller': 'contactFieldConfig',
                      'action': 'delete',
                      'id': selected.id,
                      'ajax': true,
                      'update': 'column1',
                      'onYes': 'closePanel(\'#column2\')'
                     ]"/>
     --%>
</div>