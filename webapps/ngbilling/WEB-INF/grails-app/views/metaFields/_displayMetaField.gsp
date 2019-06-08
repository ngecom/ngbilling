<%@ page import="com.sapienter.jbilling.server.metafields.DataType" %>
<g:if test="${!metaField.field.disabled}">
    <g:set var="fieldValue" value="${metaField.getValue()}"/>

    <g:applyLayout name="form/text">
        <content tag="label">${metaField.field.name}</content>
        <span title="${metaField.field.name}">
            <g:if test="${metaField.field.getDataType() == DataType.DATE}">
                <g:formatDate date="${fieldValue}" formatName="date.pretty.format"/>
            </g:if>
            <g:elseif test="${metaField.field.getDataType() == DataType.LIST}">
                ${fieldValue?.join(', ')}
            </g:elseif>
            <g:else>
                ${fieldValue}
            </g:else>
        </span>
    </g:applyLayout>

</g:if>