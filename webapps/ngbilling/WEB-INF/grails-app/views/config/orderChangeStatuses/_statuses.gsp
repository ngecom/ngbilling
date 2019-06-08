<%@page import="com.sapienter.jbilling.server.util.ServerConstants; com.sapienter.jbilling.server.order.ApplyToOrder"%>
<%@ page import="com.sapienter.jbilling.server.util.InternationalDescriptionWS; com.sapienter.jbilling.server.order.db.OrderChangeStatusDTO" %>
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

    <div id="orderChangeStatuses" class="form-hold">
        <g:hiddenField name="recCnt" value="${statuses.size()}"/>
        <g:set var="nextIndex" value="${statuses.size()}"/>
        <g:hiddenField name="stepIndex" value="${nextIndex}"/>
        <fieldset>
            <div class="form-columns column single">
                <table id="orderChangeStatusesTable" class="innerTable">
                    <thead class="innerHeader">
                    <tr>
                        <th class="left tiny"></th>
                        <th class="left large2"><g:message code="config.order.change.status.name"/></th>
                        <th class="left tiny2"><g:message code="config.order.change.status.order"/></th>
                        <th class="left tiny2"><g:message code="config.order.change.status.apply"/></th>
                        <th class="left tiny2"></th>
                    </tr>
                    </thead>
                    <tbody>
                    <g:each status="iter" var="status" in="${statuses}">
                        <g:hiddenField name="obj[${iter}].id" value="${status.id}" />
                        <g:hiddenField name="obj[${iter}].deleted" value="${status.deleted}" />
                        <g:if test="${status.deleted == 0}">
                            <tr valign="top">
                                <td class="tiny">
                                    <g:each in="${languages}" var="lang">
                                        <div class="lang_description_${lang.id}" style="${lang.id != ServerConstants.LANGUAGE_ENGLISH_ID ? 'display: none;' : ''}">
                                            <label for="obj_${iter}_description_${lang.id}">${lang.description}</label>
                                        </div>
                                    </g:each>
                                </td>
                                <td class="large2">
                                    <g:each in="${languages}" var="lang">
                                        <div class="lang_description_${lang.id}" style="${lang.id != ServerConstants.LANGUAGE_ENGLISH_ID ? 'display: none;' : ''}">
                                            <g:set var="currentLangDescription" value=""/>
                                            <g:each in="${status.descriptions}" var="langDescription">
                                                <g:if test="${langDescription.languageId == lang.id}">
                                                    <g:set var="currentLangDescription" value="${langDescription.content}"/>
                                                </g:if>
                                            </g:each>
                                            <g:textField class="inp-bg inp-desc"
                                                         name="obj[${iter}].description_${lang.id}" id="obj_${iter}_description_${lang.id}"
                                                         value="${currentLangDescription}"/>
                                        </div>
                                    </g:each>
                                </td>
                                <td class="medium">
                                    <g:textField class="inp-bg numericOnly inp4" name="obj[${iter}].order" value="${status.order}"/>
                                </td>
                                <td class="tiny">
                                    <g:checkBox class="cb checkbox" name="obj[${iter}].applyToOrder" value="true" checked="${ApplyToOrder.YES.equals(status.applyToOrder)}"/>
                                </td>
                                <td class="tiny">
                                    <a onclick="removeOrderChangeStatus(${iter});">
                                        <img src="${resource(dir:'images', file:'cross.png')}" alt="remove"/>
                                    </a>
                                </td>
                            </tr>
                        </g:if>
                        <g:else>
                            <g:each in="${languages}" var="lang">
                                <g:set var="currentLangDescription" value=""/>
                                <g:each in="${status.descriptions}" var="langDescription">
                                    <g:if test="${langDescription.languageId == lang.id}">
                                        <g:set var="currentLangDescription" value="${langDescription.content}"/>
                                    </g:if>
                                </g:each>
                                <g:hiddenField name="obj[${iter}].description_${lang.id}" value="${currentLangDescription}"/>
                            </g:each>
                        </g:else>
                    </g:each>

                    <tr valign="top">
                        <td class="tiny">
                            <g:each in="${languages}" var="lang">
                                <div class="lang_description_${lang.id}" style="${lang.id != ServerConstants.LANGUAGE_ENGLISH_ID ? 'display: none;' : ''}">
                                    <label for="obj_${nextIndex}_description_${lang.id}">${lang.description}</label>
                                </div>
                            </g:each>
                        </td>
                        <td class="large2">
                            <g:each in="${languages}" var="lang">
                                <div class="lang_description_${lang.id}" style="${lang.id != ServerConstants.LANGUAGE_ENGLISH_ID ? 'display: none;' : ''}">
                                    <g:textField class="inp-bg inp-desc"
                                                 name="obj[${nextIndex}].description_${lang.id}" id="obj_${nextIndex}_description_${lang.id}"/>
                                </div>
                            </g:each>
                        </td>
                        <td class="medium">
                            <g:textField class="inp-bg numericOnly inp4" name="obj[${nextIndex}].order"/>
                        </td>
                        <td class="tiny">
                            <g:checkBox class="cb checkbox" value="true" name="obj[${nextIndex}].applyToOrder" checked="false"/>

                        </td>
                        <td class="tiny">
                            <a onclick="addOrderChangeStatus()">
                                <img src="${resource(dir:'images', file:'add.png')}" alt="add"/>
                            </a>
                        </td>
                    </tr>
                    </tbody>
                </table>
                <div class="row">&nbsp;</div>
            </div>
        </fieldset>
        <div class="btn-box">
            <a onclick="$('#save-orderChangeStatuses-form').submit();" class="submit save"><span><g:message code="button.save"/></span></a>
            <g:link controller="config" action="index" class="submit cancel"><span><g:message code="button.cancel"/></span></g:link>
        </div>

        <script type="text/javascript">
            $(".numericOnly").keydown(function(event){
                // Allow only backspace, delete, left & right
                if ( event.keyCode==37 || event.keyCode== 39 || event.keyCode == 46 || event.keyCode == 8 || event.keyCode == 9 ) {
                    // let it happen, don't do anything
                }
                else {
                    // Ensure that it is a number and stop the keypress
                    if (event.keyCode < 48 || event.keyCode > 57 ) {
                        event.preventDefault();
                    }
                }
            });

            $(".numericOnly").change(function (event){
                if ($(this).val() > 0 ) {
                    $(this).parent().parent().find(':input[type=checkbox]').attr('checked', false);
                }
            });

            %{--
                Post with ajax adding new OrderChangeStatus to conversation, update existed one in conversation.
                Repaint form on success with html data from response
            --}%
            function addOrderChangeStatus() {
                $.ajax({
                    type: 'POST',
                    url: '${createLink(action: 'addOrderChangeStatus')}',
                    data: $('#orderChangeStatuses').parents('form').serialize(),
                    success: function(data) {
                        $('#orderChangeStatuses').replaceWith(data);
                        onLanguageChange($('#language_selector'));
                    }
                });
            }

            function removeOrderChangeStatus(stepIndex) {
                $('#stepIndex').val(stepIndex);
                $.ajax({
                    type: 'POST',
                    url: '${createLink(action: 'removeOrderChangeStatus')}',
                    data: $('#orderChangeStatuses').parents('form').serialize(),
                    success: function(data) {
                        $('#orderChangeStatuses').replaceWith(data);
                        onLanguageChange($('#language_selector'));
                    }
                });
            }
        </script>
</div>