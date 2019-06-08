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
				<%@ page import="com.sapienter.jbilling.common.Util" %>
                <ul class="list">
                	
                	<!-- Menu items, 'All' being first, remaining in alphabetical order -->
                    <li class="${pageProperty(name: 'page.menu.item') == 'all' ? 'active' : ''}"> <!-- All -->
                        <g:link controller="config">
                            <g:message code="configuration.menu.all"/>
                        </g:link>
                    </li>
                    <li class="${pageProperty(name: 'page.menu.item') == 'accountType' ? 'active' : ''}"><!-- Account Types -->
                        <g:link controller="accountType" action="list">
                            <g:message code="configuration.menu.accountType"/>
                         </g:link>
                    </li>
                    <li class="${pageProperty(name: 'page.menu.item') == 'partner' ? 'active' : ''}"><!-- Agent Commission -->
                        <div id="process-${Util.getSysProp('process.run_commission')}"></div>
                        <g:link controller="config" action="partnerCommission">
                            <g:message code="configuration.menu.partner"/>
                        </g:link>
                    </li>
                    <li class="${pageProperty(name: 'page.menu.item') == 'billing' ? 'active' : ''}"><!-- Billing Process -->
                        <div id="process-${Util.getSysProp('process.run_billing')}"></div>
                        <g:link controller="billingconfiguration" action="index">
                            <g:message code="configuration.menu.billing"/>
                        </g:link>
                    </li>
                    <li class="${pageProperty(name: 'page.menu.item') == 'blacklist' ? 'active' : ''}"><!-- Blacklist -->
                        <g:link controller="blacklist" action="list">
                            <g:message code="configuration.menu.blacklist"/>
                        </g:link>
                    </li>
                    <li class="${pageProperty(name: 'page.menu.item') == 'aging' ? 'active' : ''}"> <!-- Collections -->
                        <div id="process-${Util.getSysProp('process.run_ageing')}"></div>
                        <g:link controller="config" action="aging">
                            <g:message code="configuration.menu.collections"/>
                        </g:link>
                        
                    </li>
                    <li class="${pageProperty(name: 'page.menu.item') == 'company' ? 'active' : ''}"><!-- Company -->
                        <g:link controller="config" action="company">
                            <g:message code="configuration.menu.company"/>
                        </g:link>
                    </li>
                    <li class="${pageProperty(name: 'page.menu.item') == 'currency' ? 'active' : ''}"><!-- Currencies -->
                        <g:link controller="config" action="currency">
                            <g:message code="configuration.menu.currencies"/>
                        </g:link>
                    </li>
                    <li class="${pageProperty(name: 'page.menu.item') == 'email' ? 'active' : ''}"><!-- Email -->
                        <g:link controller="config" action="email">
                            <g:message code="configuration.menu.email"/>
                        </g:link>
                    </li>
                    <li class="${pageProperty(name: 'page.menu.item') == 'enumerations' ? 'active' : ''}"><!-- Enumerations -->
                        <g:link controller="enumerations">
                            <g:message code="configuration.menu.enumerations"/>
                        </g:link>
                    </li>
                    <li class="${pageProperty(name: 'page.menu.item') == 'invoices' ? 'active' : ''}"><!-- Invoice Display -->
                        <g:link controller="config" action="invoice">
                            <g:message code="configuration.menu.invoices"/>
                        </g:link>
                    </li>
                    <li class="${pageProperty(name: 'page.menu.item') == 'languages' ? 'active' : ''}"><!-- Languages -->
                        <g:link controller="language" action="list">
                            <g:message code="configuration.menu.languages"/>
                        </g:link>
                    </li>
                    <li class="${pageProperty(name: 'page.menu.item') == 'mediation' ? 'active' : ''}"> <!-- Mediation -->
                        <div id="process-${Util.getSysProp('process.run_mediation')}"></div>
                        <g:link controller="mediationConfig" action="list">
                            <g:message code="configuration.menu.mediation"/>
                        </g:link>
                    </li>
                    <li class="${pageProperty(name: 'page.menu.item') == 'metaFields' ? 'active' : ''}"> <!-- Meta Fields -->
                        <g:link controller="metaFields">
                            <g:message code="configuration.menu.metaFields"/>
                        </g:link>
                    </li>
                    <li class="${pageProperty(name: 'page.menu.item') == 'metaFieldGroups' ? 'active' : ''}"><!-- Meta Field groups -->
                        <g:link controller="metaFieldGroup" action="listCategories">
                            <g:message code="configuration.menu.metaFieldGroups"/>
                        </g:link>
                    </li>
                    <li class="${pageProperty(name: 'page.menu.item') == 'notification' ? 'active' : ''}"><!-- Notification -->
                        <g:link controller="notifications">
                            <g:message code="configuration.menu.notification"/>
                        </g:link>
                    </li>
                    <li class="${pageProperty(name: 'page.menu.item') == 'orderChangeStatuses' ? 'active' : ''}"><!-- Order Change Statuses -->
                        <g:link controller="config" action="orderChangeStatuses">
                            <g:message code="configuration.menu.orderChangeStatuses"/>
                        </g:link>
                    </li>
                    <li class="${pageProperty(name: 'page.menu.item') == 'orderChangeTypes' ? 'active' : ''}"><!-- Order Change Types -->
                        <g:link controller="orderChangeType" action="list">
                            <g:message code="configuration.menu.orderChangeTypes"/>
                        </g:link>
                    </li>
                    <li class="${pageProperty(name: 'page.menu.item') == 'periods' ? 'active' : ''}"><!-- Order Periods -->
                        <g:link controller="orderPeriod" action="list">
                            <g:message code="configuration.menu.order.periods"/>
                        </g:link>
                    </li>
                    <li class="${pageProperty(name: 'page.menu.item') == 'orderStatus' ? 'active' : ''}"><!-- Order Statuses -->
                        <g:link controller="orderStatus" action="index">
                            <g:message code="configuration.menu.orderStatus"/>
                        </g:link>
                    </li>
                    <li class="${pageProperty(name: 'page.menu.item') == 'paymentMethod' ? 'active' : ''}"><!-- Payment Methods -->
                        <g:link controller="paymentMethodType" action="list">
                            <g:message code="configuration.menu.paymentMethod"/>
						</g:link>
					</li>
                    <li class="${pageProperty(name: 'page.menu.item') == 'plugins' ? 'active' : ''}"><!-- Plugins -->
                        <g:link controller="plugin">
                            <g:message code="configuration.menu.plugins"/>
                        </g:link>
                    </li>
                    <li class="${pageProperty(name: 'page.menu.item') == 'roles' ? 'active' : ''}"><!-- Roles -->
                        <g:link controller="role" action="list">
                            <g:message code="configuration.menu.roles"/>
                        </g:link>
                    </li>
                    <li class="${pageProperty(name: 'page.menu.item') == 'users' ? 'active' : ''}"><!-- Users -->
                        <g:link controller="user" action="list">
                            <g:message code="configuration.menu.users"/>
                        </g:link>
                    </li>
                    
                </ul>
