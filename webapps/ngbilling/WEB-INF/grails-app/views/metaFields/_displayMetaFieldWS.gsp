<%@ page import="com.sapienter.jbilling.server.metafields.DataType" %>
<g:if test="${!metaField.disabled}">
    <g:set var="fieldValue" value="${metaField.getValue()}"/>

    <g:applyLayout name="form/text">
        <content tag="label">${metaField.fieldName}</content>
        <span title="${metaField.fieldName}">
            <g:if test="${metaField.getDataType() == DataType.DATE}">
                <g:formatDate date="${fieldValue}" formatName="date.pretty.format"/>
            </g:if>
            <g:else>
                ${fieldValue}
            </g:else>
        </span>
    </g:applyLayout>

</g:if>