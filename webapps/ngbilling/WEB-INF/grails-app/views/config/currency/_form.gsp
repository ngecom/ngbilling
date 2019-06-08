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

<%@ page import="org.apache.commons.lang.StringEscapeUtils; com.sapienter.jbilling.common.CommonConstants; com.sapienter.jbilling.server.item.CurrencyBL; com.sapienter.jbilling.server.util.ServerConstants" %>
<%@ page import="com.sapienter.jbilling.server.user.db.CompanyDTO" %>

<g:set var="startDate" value="${startDate ?: new Date()}"/>
%{--<g:set var="timePoints" value="${CurrencyBL.getUsedTimePoints(session['company_id'])}"/>--}%

<script type="text/javascript">
    function addDate() {
        $.ajax({
            type: 'POST',
            url: '${createLink(action: 'addDatePoint')}',
            data: $('#currList > * > form').serialize(),
            success: function(data) {
                $('#currList').replaceWith(data);
            }
        });
    }

    function editDate(date) {
        $('#startDate').val(date);

        $.ajax({
            type: 'POST',
            url: '${createLink(action: 'editDatePoint')}',
            data: $('#currList > * > form').serialize(),
            success: function(data) {
                $('#currList').replaceWith(data);
            }
        });
    }

    function removeDate() {
        $.ajax({
            type: 'POST',
            url: '${createLink(action: 'removeDatePoint')}',
            data: $('#currList > * > form').serialize(),
            success: function(data) {
                $('#currList').replaceWith(data);
            }
        });
    }
//show confirmation dialog  when use 'delete currency' action
    function prepareConfirmDlg(currencyId,  currencyCode, url, message){
		
		$("#confirm-dialog-deleteCurrency-0 form").attr("action", url);
		$("#confirm-dialog-deleteCurrency-0 form input[name='id']").attr('value', currencyId);
		$("#confirm-dialog-deleteCurrency-0 form input[name='code']").attr('value', currencyCode);
		$("#confirm-dialog-deleteCurrency-0-msg").html(message);
		showConfirm('deleteCurrency-0');
	}
</script>

<div class="form-edit" id="currList">
    <div class="heading">
        <strong><g:message code="currency.config.title"/></strong>
    </div>

    <div class="form-hold">
        <g:form name="save-currencies-form" url="[action: 'saveCurrencies']">
            <fieldset>
                <div class="form-columns single">
                    <g:applyLayout name="form/select">
                        <content tag="label"><g:message code="currency.config.label.default"/></content>
                        <content tag="label.for">defaultCurrencyId</content>
                         <g:select name="defaultCurrencyId" from="${CompanyDTO.get(session['company_id'] as Integer)?.currencies.sort{it.getDescription(session['language_id'])}}"
                                  optionKey="id"
                                  optionValue="${{ it.getDescription(session['language_id']) }}"
                                  value="${entityCurrency}"/>

                        <div style="margin-left: 390px;">
                            <g:remoteLink controller="config" action="editCurrency" class="submit add"
                                          before="register(this);"
                                          onSuccess="render(data, next);">
                                <span><g:message code="button.create"/></span>
                            </g:remoteLink>
                        </div>
                    </g:applyLayout>
                </div>

                <div class="form-columns single">
                    <div class="column single">
                        <div id="timeline">
                            <ul>
                                <g:each var="dateEntry" in="${timePoints}">
                                    <g:if test="${startDate.equals(dateEntry)}">
                                        <li class="current">
                                            <g:set var="date" value="${formatDate(date: startDate)}"/>
                                            <a onclick="editDate('${date}')">${date}</a>
                                        </li>
                                    </g:if>
                                    <g:else>
                                        <li>
                                            <g:set var="date" value="${formatDate(date: dateEntry)}"/>
                                            <a onclick="editDate('${date}')">${date}</a>
                                        </li>
                                    </g:else>
                                </g:each>

                                %{--<g:if test="${!models.containsKey(startDate)}">--}%
                                    %{--<li class="current">--}%
                                        %{--<g:set var="date" value="${formatDate(date: startDate)}"/>--}%
                                        %{--<a onclick="editDate('${date}')">${date}</a>--}%
                                    %{--</li>--}%
                                %{--</g:if>--}%


                                <li class="new">
                                    <a onclick="addDate()"><g:message code="button.add.price.date"/></a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>

                <div class="form-columns single">
                    <g:applyLayout name="form/date">
                        <content tag="label"><g:message code="currency.config.label.date"/></content>
                        <content tag="label.for">startDate</content>
                        <g:textField class="field" name="startDate"
                                     value="${formatDate(date: startDate, formatName: 'datepicker.format')}"/>
                    </g:applyLayout>
                </div>

                <div class="form-columns single">
                    <table cellpadding="0" cellspacing="0" class="innerTable" width="100%">
                        <thead class="innerHeader">
                        <tr>
                            <th class=""></th>
                            <th class="left tiny2"><g:message code="currency.config.th.symbol"/></th>
                            <th class="left tiny2"><g:message code="currency.config.th.active"/></th>
                            <th class="left medium"><g:message code="currency.config.th.rate"/></th>
                            <th class="left medium"><g:message code="currency.config.th.sysRate"/></th>
                        </tr>
                        </thead>
                        <tbody>

                        <g:each var="currency" in="${currencies.sort{ it.description }}">
                            <tr>
                                <td class="innerContent">
                                    ${currency.getDescription(session['language_id'])}
                                    <g:hiddenField name="currencies.${currency.id}.id" value="${currency.id}"/>
                                </td>
                                <td class="innerContent">
                                    ${StringEscapeUtils.unescapeHtml(currency?.symbol)}
                                    <g:hiddenField name="currencies.${currency.id}.symbol" value="${currency.symbol}"/>
                                    <g:hiddenField name="currencies.${currency.id}.code" value="${currency.code}"/>
                                    <g:hiddenField name="currencies.${currency.id}.countryCode"
                                                   value="${currency.countryCode}"/>
                                </td>
                                <td class="innerContent">
                                    <g:checkBox class="cb checkbox" name="currencies.${currency.id}.inUse"
                                                checked="${currency.inUse}"/>
                                </td>
                                <td class="innerContent">
                                    <div class="inp-bg inp4">
                                        <g:textField name="currencies.${currency.id}.rate" class="field" value="${formatNumber(number: currency.rate, formatName: 'exchange.format')}"/>
                                    </div>
                                </td>
                                <td class="innerContent" style="text-align: left;">
                                    <g:if test="${currency.id != 1}">
                                    %{-- editable rate --}%
                                        <div class="inp-bg inp4" style="width: 100px;">
                                            <g:textField name="currencies.${currency.id}.sysRate" class="field" value="${formatNumber(number: currency.sysRate, formatName: 'exchange.format')}"/>
                                            <a onclick="prepareConfirmDlg('${currency.id}','${currency.code}', 
	                                            '${createLink(controller:'config', action:'deleteCurrency', id:currency.id)}',
	                                            '${message(code:'currency.delete.confirm', args:[currency.getDescription(session['language_id'])]) }'
	                                            );">
            									<img src="${resource(dir:'images', file:'cross.png')}" alt="remove"/>
        									</a>
		                                 </div>
                                        
                                    </g:if>
                                    <g:else>
                                    %{-- USD always has a rate of 1.00 --}%
                                        <strong>
                                            <g:formatNumber number="${currency.sysRate}" type="currency" currencySymbol="${currency.symbol}"/>
                                            <g:hiddenField name="currencies.${currency.id}.sysRate" value="${currency.sysRate}"/>
                                        </strong>
                                    </g:else>

                                </td>
                            </tr>
                        </g:each>

                        </tbody>
                    </table>
                </div>

                <!-- spacer -->
                <div>
                    <br/>&nbsp;
                </div>

            </fieldset>
        </g:form>
    </div>
    <div class="btn-box">
        <div class="row">
            <a onclick="$('#save-currencies-form').submit();" class="submit save"><span><g:message
                    code="button.save"/></span></a>
            <g:if test="${!CommonConstants.EPOCH_DATE.equals(startDate)}">
                <a class="submit delete" onclick="removeDate()"><span><g:message code="button.delete"/></span></a>
            </g:if>
            <g:link controller="config" action="index" class="submit cancel"><span><g:message
                    code="button.cancel"/></span></g:link>
        </div>
    </div>
   <g:render template="/confirm"
              model="[
                      'controller': 'config',
                      'action': 'deleteCurrency',
                      'id': 0,
                      'formParams': ['code': '']
                    ]"/>
    
</div>