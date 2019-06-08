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

<%@ page import="org.apache.commons.lang.StringEscapeUtils; jbilling.FilterType; com.sapienter.jbilling.server.user.db.CompanyDTO; jbilling.FilterSet" %>

<%--
  Filter side panel template. Prints all filters contained in the "filters" page variable.

  @author Brian Cowdery
  @since  03-12-2010
--%>

<g:set var="company" value="${CompanyDTO.get(session['company_id'])}"/>
<g:set var="filters" value="${filters.sort{ it?.field }}"/>
<g:set var="filtersets" value="${FilterSet.findAllByUserId(session['user_id'])}"/>

<%
    filtersets = filtersets?.findAll{ filterset->
        !filterset.filters.find{ it.type != FilterType.ALL && it.type != session['current_filter_type'] }
    }
%>


%{--
    filtersets = filtersets?.findAll{ filterset->
        filterset.filters
        if (filterset.filters && filterset.filters.asList().first().type != session['current_filter_type']) {
            return false
        }
        return true
    }
--}%



<div id="filters">
    <div class="heading">
        <strong><g:message code="filters.title"/></strong>
    </div>

    <!-- hidden filters -->
    <%
      def hiddenFilters = [:]
    %>
    <g:set var="hiddenIdx" value="1" />
    <g:while test="${params['fhn'+hiddenIdx] || this['filter_hidden_'+hiddenIdx]}">
        <g:set var="hiddenFilterName" value="${params['fhn'+hiddenIdx]?:this['filter_hidden_'+hiddenIdx]}" />
        <g:set var="hiddenFilterValue" value="${params[hiddenFilterName]?:this[hiddenFilterName]}" />

        <g:hiddenField name="fhn${hiddenIdx}" value="${hiddenFilterName}" />
        <g:hiddenField name="${hiddenFilterName}" value="${hiddenFilterValue}" />

        <%
            hiddenFilters += [('fhn'+hiddenIdx) : hiddenFilterName,
                    (hiddenFilterName): hiddenFilterValue ]
        %>
        <g:set var="hiddenIdx" value="${hiddenIdx+1}" />
    </g:while>

    <!-- filters -->
    <ul class="accordion">
        <g:each var="filter" in="${filters}">
            <g:if test="${filter.visible}">
                <li>

                    <g:render template="/filter/${filter.template}" model="[filter: filter, company: company, hiddenFilters: hiddenFilters]"/>
                </li>
            </g:if>
        </g:each>
    </ul>

    <!-- filter controls -->
    <div class="btn-hold">
        <!-- apply filters -->
        <a class="submit apply" onclick="submitApply();">
            <span><g:message code="filters.apply.button"/></span>
        </a>

        <!-- add another filter -->
        <g:if test="${filters.find { !it.visible }}">
            <div class="dropdown">
                <a class="submit add open"><span><g:message code="filters.add.button"/></span></a>
                <div class="drop">
                    <ul>
                        <g:each var="filter" in="${filters}">
                            <g:if test="${!filter.visible}">
                                <li>
                                    <g:remoteLink controller="filter" action="add" params="${[name: filter.name] + hiddenFilters}" update="filters">
                                        <g:message code="filters.${StringEscapeUtils.escapeHtml(filter?.field)}.title"/>
                                    </g:remoteLink>
                                </li>
                            </g:if>
                        </g:each>
                    </ul>
                </div>
            </div>
        </g:if>

        <!-- save current filter set-->
        <a class="submit2 save" onclick="$('#filter-save-dialog').dialog('open');">
            <span><g:message code="filters.save.button"/></span>
        </a>

        <!-- load saved filter set -->
        <div class="dropdown">
            <a class="submit2 load open"><span><g:message code="filters.load.button"/></span></a>
            <g:if test="${filtersets}">
                <div class="drop">
                    <ul>
                        <g:each var="filterset" in="${filtersets.sort{ it.id }}">
                            <li>
                                <g:remoteLink controller="filter" action="load" id="${filterset.id}" update="filters">
                                    ${StringEscapeUtils.escapeHtml(filterset?.name)}
                                </g:remoteLink>
                            </li>
                        </g:each>
                    </ul>
                </div>
            </g:if>
        </div>

        <script type="text/javascript">
            $(function() {
                // reset popups and validations
                setTimeout(
                    function() {
                        initPopups();
                        initScript();

                        var validator = $('#filters-form').validate();
                        validator.init();
                        validator.hideErrors();
                    }, 500);

                // highlight active filters
                $('body').delegate('#filters-form', 'submit', function() {
                    $(this).find('li').each(function() {
                        var title = $(this).find('.title');

                        if ($(this).find(':input[value!=""]').not(':checkbox').length > 0) {
                            title.addClass('active');
                        } else if ($(this).find(':checkbox:checked').length > 0) {
                            title.addClass('active');
                        } else {
                            title.removeClass('active');
                        }
                    });
                });
            });

            function submitApply () {
                if ($('#filters-form .error').size() < 1) {
                    $('#filters-form').submit();
                }
            }
        </script>
    </div>
</div>