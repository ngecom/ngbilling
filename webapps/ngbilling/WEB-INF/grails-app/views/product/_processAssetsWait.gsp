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

<%@ page import="com.sapienter.jbilling.server.item.batch.AssetImportConstants"%>

<%--
   Wait screen while asset import job runs.

  @author Gerhard Maree
  @since  14-May-2013
--%>

<g:if test="${'busy' == jobStatus}">
    <g:message code="asset.upload.label.busy"/>
    <g:formRemote name="asset-job-status-form" url="[controller: 'batchJob', action:'jobStatus', id: jobId]" update="asset-upload-box">
        <g:hiddenField name="template" value="/product/processAssetsWait"/>
    </g:formRemote>
    <script type="text/javascript">
        <%-- Reload the page every 3 seconds, until the import job is finished --%>
        window.setInterval(submitJobStatusForm, 3000);

        var jobStatusFormSubmitted = false;

        function submitJobStatusForm() {
            if(!jobStatusFormSubmitted) {
                jobStatusFormSubmitted = true;
                $('#asset-job-status-form').submit();
            }
        }
    </script>
</g:if>
<g:elseif test="${'done' == jobStatus}">
    <div><g:message code="asset.upload.label.done"/></div>
    
    <div>
        <g:if test="${executionParams?.getInt(AssetImportConstants.JOB_PARM_ERROR_LINE_COUNT, 0) > 0}">
            <g:message code="asset.upload.label.error.occurred"/>
            <g:link controller="batchJob" action="jobFile" id="${jobId}" params="[key: 'error_file']" >
                <g:message code="asset.upload.label.errorfile"/></g:link>
        </g:if>
    </div>

    <table class="dataTable" cellspacing="0" cellpadding="0">
        <tbody>
        <tr>
            <td><g:message code="asset.upload.label.total.count"/></td>
            <td class="value">${executionParams?.getInt(AssetImportConstants.JOB_PARM_TOTAL_LINE_COUNT, 0)}</td>
        </tr>
        <tr>
            <td><g:message code="asset.upload.label.error.count"/></td>
            <td class="value">${executionParams?.getInt(AssetImportConstants.JOB_PARM_ERROR_LINE_COUNT, 0)}</td>
        </tr>
        </tbody>
    </table>
</g:elseif>
<g:else>
    <div><g:message code="asset.upload.label.error"/></div>
    <g:link controller="batchJob" action="jobFile" id="${jobId}" params="[key: 'error_file']" ><g:message code="asset.upload.label.errorfile"/></g:link>
</g:else>
