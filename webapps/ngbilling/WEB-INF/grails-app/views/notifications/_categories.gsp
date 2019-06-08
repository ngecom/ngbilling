<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
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

<div class="table-box">
    <table cellpadding="0" cellspacing="0" id="categories">
        <thead>
            <th><g:message code="title.notification.category" />
            </th>
        </thead>
        <tbody>
            <g:each in="${lst}" status="idx" var="dto">
                <tr class="${selectedCategoryId == dto.id ? 'active' : ''}" >
                    <td><g:remoteLink breadcrumb="id" class="cell"
                            action="list" id="${dto.id}"
                            params="['template': 'list', categoryId:dto.id]"
                            before="register(this);"
                            onSuccess="render1('${dto.id}',data, next);"
                        >
                            <strong> ${StringEscapeUtils.escapeHtml(dto?.getDescription(session['language_id']))}
                            </strong>
                            <em><g:message code="table.id.format" args="[dto.id as String]"/></em>
                        </g:remoteLink>
                    </td>
                </tr>
            </g:each>
        </tbody>
    </table>
</div>
<div class="pager-box">
    <div class="row">
        <div class="results">
            <g:render template="/layouts/includes/pagerShowResults" model="[steps: [10, 20, 50], update: 'column1']"/>
        </div>
    </div>

    <div class="row">
        <util:remotePaginate controller="notifications" action="${action ?: 'list'}"
                             params="${sortableParams(params: [partial: true])}"
                             total="${lst?.totalCount ?: 0}" update="column1"/>
    </div>
</div>
<div class="btn-box">
        <g:link controller="notifications" action="editCategory" class="submit add" params="${[add: true]}"><span><g:message code="button.create.notification.category"/></span></g:link>

        <a href="#" onclick="return editCategory();" class="submit edit"><span><g:message code="button.edit.notification.category"/></span></a>
</div>

<!-- edit category control form -->
<g:form name="category-edit-form" controller="notifications" action="editCategory">
    <g:hiddenField name="categoryId" value="${selectedCategoryId}"/>
</g:form>

<script type="text/javascript">
    function render1(id, data, next){
        $('input[name="categoryId"]').attr('value',id);

        render(data, next);
    }

    function editCategory() {
        $('#category-edit-form input#id').val(getSelectedId('#categories'));
        $('#category-edit-form').submit();

        return false;
    }
</script>
