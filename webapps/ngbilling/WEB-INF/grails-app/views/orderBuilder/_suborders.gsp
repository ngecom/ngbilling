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
  Shows the suborders list
--%>

<div id="suborders-box">
    <div class="table-box tab-table">
        <g:if test="${order.childOrders}">
            <div class="table-scroll">
                <table id="suborders" cellspacing="0" cellpadding="0">
                    <tbody>
                        <g:each var="childOrder" in="${order.childOrders}">
                            <g:set var="activeSince" value="${formatDate(date: childOrder.activeSince ?: childOrder.createDate, formatName: 'date.pretty.format')}"/>
                            <g:set var="activeUntil" value="${formatDate(date: childOrder.activeUntil, formatName: 'date.pretty.format')}"/>
                            <tr id="suborder_tr_${childOrder.id}" onclick="$('#showChildButton').attr('href', $('#hidden_link_child_${childOrder.id}').prop('href'));">
                                <td>
                                    <a class="cell double">
                                        <strong>${childOrder.periodStr}</strong>
                                        <em><g:if test="${childOrder.id > 0}">
                                            <g:message code="table.id.format" args="[childOrder.id as String ]"/>
                                        </g:if><g:else>
                                            <g:message code="table.id.format" args="['']"/>&nbsp;<g:message code="default.new.label" args="['']"/>
                                        </g:else></em>
                                    </a>
                                </td>
                                <td><a class="cell"><em>${activeSince}</em></a></td>
                                <td><a class="cell"><em>${activeUntil ? activeUntil : '-'}</em></a></td>
                                <td style="display: none;">
                                    <g:link action="edit" elementId="hidden_link_child_${childOrder.id}" id="${childOrder.id}" params="[_eventId: 'changeOrder']" method="GET"> </g:link>
                                </td>
                            </tr>
                        </g:each>
                    </tbody>
                </table>
            </div>
            <!-- spacer -->
            <div>
                &nbsp;
            </div>
            <div class="btn-box">
                <a class="submit" id="showChildButton" href="#">
                    <span><g:message code="order.button.show"/></span>
                </a>
            </div>
        </g:if>
    </div>

</div>