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

%{--In metafields group we need to send additional params to action to identify the type of metafields group and
 response was missing when we use generic pagerShowResultTemplate so added showResults function to render response.
--}%
<g:message code="pager.show.max.results"/>

<g:each var="max" in="${steps}">
    <g:if test="${params.max == max}">
        <span>${max}</span>
    </g:if>
    <g:else>
        <g:remoteLink onSuccess="showResults(data);" action="${action ?: 'list'}" id="${entityType}"  params="${sortableParams(params: [template:'list',partial: true, max: max,id:id, contactFieldTypes: contactFieldTypes ?: null])}" update="${update}">${max}</g:remoteLink>
    </g:else>
</g:each>

<script type="text/javascript">
    function showResults(data){
        $('#column2').html(data);
    }
</script>
