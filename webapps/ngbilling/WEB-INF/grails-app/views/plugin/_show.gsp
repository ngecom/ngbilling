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
  details

  @author E. Conde
  @since  26-11-2010
--%>

<div class="column-hold">

    <!-- the plug-in details -->
    <div class="heading">
        <strong>${plugin?.type?.getDescription(session['language_id'], "title")}</strong>
    </div>
    <div class="box">
      <div class="sub-box">
        <strong><g:message code="plugins.plugin.description"/></strong>
        <p>${plugin?.type?.getDescription(session['language_id'])}</p>
        <br/>
        
        <table class="dataTable">
           <tr>
            <td><g:message code="plugins.plugin.id-long"/></td>
            <td class="value">${plugin?.getId()}</td>
           </tr>
           <tr>
            <td><g:message code="plugins.plugin.notes"/></td>
            <td class="value">
                <g:if test="${plugin?.getNotes() != null}">
                    ${plugin?.getNotes()}
                </g:if>
                <g:else>
                    <g:message code="plugins.plugin.noNotes"/>
                </g:else>
            </td>
           </tr>
           <tr>
            <td><g:message code="plugins.plugin.order"/></td>
            <td class="value">${plugin?.getProcessingOrder()}</td>
           </tr>
           <g:if test="${plugin?.parameters.size() == 0}">
           <tr>
            <td><g:message code="plugins.plugin.noParamaters"/></td>
            <td class="value"><g:message code="plugins.plugin.noParamatersTxt"/></td>
           </tr>
           </g:if>
        </table>

        <table class="innerTable">
             <thead class="innerHeader">
             <tr>
                <th><g:message code="plugins.plugin.parameter"/></th>
                <th><g:message code="plugins.plugin.value"/></th>
             </tr>
             </thead>
             <tbody>
             <g:each in="${plugin?.parameters}" var="parameter">
                 <tr>
                    <td class="innerContent">${parameter.name}</td>
                     <g:if test="${!parametersDesc.find({it -> it.name == parameter.name})?.isPassword }">
                        <td class="innerContent">${parameter.value}</td>
                     </g:if>
                     <g:else>
                         <td>******</td>
                     </g:else>
                 </tr>
             </g:each>
             </tbody>
        </table>
      </div>
    </div>

    <g:render template="/confirm" 
              model="['message':'plugins.delete.confirm','controller':'plugin','action':'delete','id':plugin?.getId()]"/>

    <div class="btn-box">
            <a href="${createLink(controller:'plugin', action:'edit', id:plugin?.getId()) }" class="submit">
                <span><g:message code="plugins.plugin.edit"/></span>
            </a>
            <a onclick="$('#confirm-dialog-delete-${plugin?.id}').dialog('open');" class="submit delete">
                <span><g:message code="plugins.plugin.delete"/></span>
            </a>
    </div>
</div>


