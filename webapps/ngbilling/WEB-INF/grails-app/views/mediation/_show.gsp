_%{--
  JBILLING CONFIDENTIAL
  _____________________

  [2003] - [2012] Enterprise jBilling Software Ltd.
  All Rights Reserved.

  NOTICE:  All information contained herein is, and remains
  the property of Enterprise jBilling Software.
  The intellectual and technical concepts contained
  herein are proprietary to Enterprise jBilling Software
  and are protected by trade secret or copyright law.
  Dissemination of this information or reproduction of this material
  is strictly forbidden.
  --}%

<%@ page import="com.sapienter.jbilling.common.CommonConstants; org.joda.time.Period; com.sapienter.jbilling.server.util.ServerConstants;" %>

<%--
    @author Vikas Bodani
    @since 18 Feb 2011
 --%>

<div class="column-hold">
    <div class="heading">
        <strong><g:message code="mediation.process.title"/> <em>${selected.id}</em>
        </strong>
    </div>
 
    <div class="box">

        <!-- mediation process info -->
        <table cellspacing="0" cellpadding="0" class="dataTable">
            <tbody>
                <tr>
                    <td><g:message code="mediation.label.id"/></td>
                    <td class="value">${selected.id}</td>
                </tr>
                <tr>
                    <td><g:message code="mediation.label.config"/></td>
                    <td class="value">${selected.configuration.name}</td>
                </tr>
                <tr>
                    <td><g:message code="mediation.label.start.time"/></td>
                    <td class="value"><g:formatDate date="${selected.startDatetime}" formatName="date.timeSecsAMPM.format"/></td>
                </tr>
                <tr>
                    <td><g:message code="mediation.label.end.time"/></td>
                    <td class="value"><g:formatDate date="${selected.endDatetime}" formatName="date.timeSecsAMPM.format"/></td>
                </tr>
                <tr>
                    <td><g:message code="mediation.label.total.runtime"/></td>
                    <td class="value">
                        <g:if test="${selected.startDatetime && selected.endDatetime}">
                            <g:set var="runtime" value="${new Period(selected.startDatetime?.time, selected.endDatetime?.time)}"/>
                            <g:message code="mediation.runtime.format" args="[runtime.getHours(), runtime.getMinutes(), runtime.getSeconds()]"/>
                        </g:if>
                        <g:else>
                            -
                        </g:else>
                    </td>
                </tr>
            </tbody>
        </table>


        <!-- separator -->
        <div>
            <hr/>
        </div>


        <!-- mediation process stats -->
        <table cellspacing="0" cellpadding="0" class="dataTable">
            <tbody>
                <tr>
                    <td><g:message code="mediation.label.records"/></td>
                    <td class="value">${recordCount}</td>
                </tr>
                <tr>
                    <td><g:message code="mediation.label.orders.affected"/></td>
                    <td class="value">${selected.ordersAffected}</td>
                </tr>

                %{
                    def doneBillable = 0;
                    def doneNotBillable = 0;
                    def errorDetected = 0;
                    def errorDeclared = 0;

                    selected.records?.each {
                        if (it.recordStatus.id == CommonConstants.MEDIATION_RECORD_STATUS_DONE_AND_BILLABLE) doneBillable++;
                        if (it.recordStatus.id == CommonConstants.MEDIATION_RECORD_STATUS_DONE_AND_NOT_BILLABLE) doneNotBillable++;
                        if (it.recordStatus.id == CommonConstants.MEDIATION_RECORD_STATUS_ERROR_DETECTED) errorDetected++;
                        if (it.recordStatus.id == CommonConstants.MEDIATION_RECORD_STATUS_ERROR_DECLARED) errorDeclared++;
                    }
                }%

                <tr>
                    <td><g:message code="mediation.label.done.billable"/></td>
                    <td class="value">${doneBillable}</td>
                </tr>
                <tr>
                    <td><g:message code="mediation.label.done.not.billable"/></td>
                    <td class="value">${doneNotBillable}</td>
                </tr>
                <tr>
                    <td><g:message code="mediation.label.errors.detected"/></td>
                    <td class="value">${errorDetected}</td>
                </tr>
                <tr>
                    <td><g:message code="mediation.label.errors.declared"/></td>
                    <td class="value">${errorDeclared}</td>
                </tr>
            </tbody>
        </table>

    </div>
    <div class="btn-box"></div>
</div>
