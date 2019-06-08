<%@ page import="com.sapienter.jbilling.server.metafields.EntityType; com.sapienter.jbilling.server.metafields.MetaFieldWS" %>
%{--
  JBILLING CONFIDENTIAL
  _____________________

  [2003] - [2014] Enterprise jBilling Software Ltd.
  All Rights Reserved.

  NOTICE:  All information contained herein is, and remains
  the property of Enterprise jBilling Software.
  The intellectual and technical concepts contained
  herein are proprietary to Enterprise jBilling Software
  and are protected by trade secret or copyright law.
  Dissemination of this information or reproduction of this material
  is strictly forbidden.
  --}%

<%--
  Edit a list of meta fields. Used by editOrderChangeType

  @author Alexander Aksenov
--%>
<g:set var="offset" value="${startIdx ?: 0}" />

<g:each var="metaField" status="index" in="${metaFields}">
    <g:render template="editOrderChangeMetaField"   model="[metaField: metaField,
            metaFieldIdx: index + offset ]" />
</g:each>

