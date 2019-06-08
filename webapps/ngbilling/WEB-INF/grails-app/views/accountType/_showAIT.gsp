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

  @author Panche Isajeski
  @since  05/24/2013
--%>


<div class="column-hold">
    <div class="heading">
        <strong>
            ${selected.name}
        </strong>
    </div>

    <div class="box">
        <div class="sub-box">
            <!-- ait info -->
            <table class="dataTable" cellspacing="0" cellpadding="0">
                <tbody>
                <tr>
                    <td><g:message code="account.information.type.id.label"/></td>
                    <td class="value" colspan="3">
                        ${selected.id}
                    </td>
                </tr>
                <tr>
                    <td><g:message code="account.information.type.name.label"/></td>
                    <td class="value" colspan="3">
                        ${selected.name}
                    </td>
                </tr>
                <tr>
                    <td><g:message code="account.information.type.display.label"/></td>
                    <td class="value">${selected.displayOrder}</td>
                </tr>
                </tbody>
            </table>

            <!-- metafields -->
            <g:if test="${selected.metaFields}">
                <table class="dataTable" cellspacing="0" cellpadding="0" width="100%">
                    <tbody>
                    <g:render template="/metaFieldGroup/metafields" model="[model: selected]"/>
                    </tbody>
                </table>
            </g:if>
        </div>
    </div>

    <div class="btn-box">
        <g:link action="editAIT" id="${selected.id}" params="[accountTypeId: selected.accountType.id]" class="submit edit"><span><g:message code="button.edit"/></span></g:link>
        <a href="${createLink(controller:'accountType', action:'editAIT', id:selected.id ,params:[accountTypeId: selected.accountType.id, clone:'true']) }" class="submit add">
            <span><g:message code="button.clone"/></span></a>
        <a onclick="showConfirm('deleteAIT-${selected.id}');" class="submit delete"><span><g:message code="button.delete"/></span></a>
    </div>

    <g:render template="/confirm"
              model="['message': 'account.information.type.delete.confirm',
                      'controller': 'accountType',
                      'action': 'deleteAIT',
                      'id': selected.id,
                      'formParams': ['accountTypeId': selected.accountType.id],
                      'ajax': false,
                      'update': 'column1',
              ]"/>
</div>

