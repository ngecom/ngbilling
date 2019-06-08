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


<%@ page import="jbilling.TabConfigurationTab; jbilling.Tab" contentType="text/html;charset=UTF-8" %>

<r:require module="disjointlistbox"/>
%{--
  Allows the user to edit the order of the tabs across the top of the screen

  @author Gerhard Maree
  @since  25-Apr-2013
--}%

<div class="form-hold">
<div class="form-edit">
    <div class="heading"><strong><g:message code="tabs.organize.title"/></strong></div>
    <g:form id="vis-cols-multi-sel-form" name="tab-config-form" url="[action:'save',controller:'tabConfig']" >
        %{
            def hiddenTabs = [];
            def visibleTabs = []
        }%
        <g:each in="${tabConfigurationTabs}" var="tabConfig">
            <jB:userCanAccessTab tab="${tabConfig.tab}">
                <g:if test="${tabConfig.visible}">
                    %{  visibleTabs.add([value: tabConfig.tab.id, message: tabConfig.tab.messageCode])
                    }%
                </g:if>
                <g:else>
                    %{  hiddenTabs.add([value: tabConfig.tab.id, message: tabConfig.tab.messageCode])
                    }%
                </g:else>
            </jB:userCanAccessTab>
        </g:each>

        <jB:disjointListbox id="vis-cols-multi-sel" left="${visibleTabs}" right="${hiddenTabs}"
                            left-input="visible-order" right-input="hidden-order"
                            left-header="tabs.head.visible" right-header="tabs.head.hidden" />

    </g:form>
    <div class="buttons">
        <ul>
            <li>
                <a onclick="updateDLValues('vis-cols-multi-sel');$('#vis-cols-multi-sel-form').submit()" class="submit save"><span><g:message code="button.save"/></span></a>
            </li>
            <li>
                <g:link controller="myAccount" class="submit cancel"><span><g:message code="button.cancel"/></span></g:link>
            </li>

        </ul>
    </div>
</div>
</div>
