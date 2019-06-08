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


<div class="column-hold">
    <div class="heading">
        <strong>
            ${selected.name}
        </strong>
    </div>

    <div class="box">
        <div class="sub-box">
          <table class="dataTable" cellspacing="0" cellpadding="0">
              <tbody>
              <tr>
                  <td><g:message code="metaField.label.id"/></td>
                  <td class="value">${selected.id}</td>
              </tr>
  
              <tr>
                  <td><g:message code="metaField.label.entityType"/></td>
                  <td class="value">${selected.entityType.name()}</td>
              </tr>
              <tr>
                  <td><g:message code="metaField.label.dataType"/></td>
                  <td class="value">${selected.dataType.name()}</td>
              </tr>
              <tr>
                  <td><g:message code="metaField.label.disabled"/></td>
                  <td class="value">${selected.disabled}</td>
              </tr>
              
              <tr>
                  <td><g:message code="metaField.label.unique"/></td>
                  <td class="value">${selected.unique}</td>
              </tr>
              
              <tr>
                  <td><g:message code="metaField.label.mandatory"/></td>
                  <td class="value">${selected.mandatory}</td>
              </tr>
              <tr>
                  <td><g:message code="metaField.label.displayOrder"/></td>
                  <td class="value">${selected.displayOrder}</td>
              </tr>
              <tr>
                  <td><g:message code="metaField.label.defaultValue"/></td>
                  <td class="value">${selected.defaultValue?.value}</td>
              </tr>
              </tbody>
          </table>
        </div>
    </div>

    <div class="btn-box">
        <div class="row">
            <g:link action="edit" id="${selected.id}" class="submit edit"><span><g:message code="button.edit"/></span></g:link>
            <a onclick="showConfirm('delete-${selected.id}');" class="submit delete"><span><g:message code="button.delete"/></span></a>
        </div>
    </div>

    <g:render template="/confirm"
              model="['message': 'metaField.delete.confirm',
                      'controller': 'metaFields',
                      'action': 'delete',
                      'id': selected.id,
                     ]"/>
</div>