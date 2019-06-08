<%@ page import="com.sapienter.jbilling.server.metafields.EntityType" %>
<div id="review-box">

    <div id="messages">
        <g:if test="${errorMessages}">
            <div class="msg-box error">
                <ul>
                    <g:each var="message" in="${errorMessages}">
                        <li>${message}</li>
                    </g:each>
                </ul>
            </div>

            <g:set var="errorMessages" value=""/>
            <ul></ul>
        </g:if>
    </div>

    <div class="box no-heading">
        <div class="sub-box">

            <div class="header">
                <div class="column">
                    <h1><g:message code="paymentMethod.metafields.label"/></h1>
                </div>

                <div style="clear: both;"></div>
            </div>

            <hr/>

            <ul id="metafield-ait">
                <g:each var="metaField" status="index" in="${paymentMethod?.metaFields}">
                    <g:set var="editable" value="${index == params.int('newLineIndex')}"/>
                    <g:formRemote name="mf-${index}-update-form" url="[action: 'editPM']"
                                  update="column2" method="GET">

                        <fieldset>

                            <g:hiddenField name="_eventId" value="updateMetaField"/>
                            <g:hiddenField name="execution" value="${flowExecutionKey}"/>

                            <li id="mf-${index}" class="mf ${editable ? 'active' : ''}">
                                <span class="description">${metaField.name? metaField.name : "-"}</span>
                                <span class="data-type">${metaField.dataType? metaField.dataType : "-"}</span>
                                <span class="mandatory">${metaField.mandatory?'Mandatory':'Not Mandatory'}</span>
                            </li>

                            <li id="mf-${index}-editor" class="editor ${editable ? 'open' : ''}">

                                <div class="box">
                                    <% params.entityType = com.sapienter.jbilling.server.metafields.EntityType.PAYMENT_METHOD_TYPE.name(); %>
                                    <g:render template="/metaFields/editMetafield"
                                              model="[metaField: metaField,
                                                      entityType: params.entityType,
                                                      metaFieldType:metaField.dataType,
                                                      parentId: 'mf-'+index+'-update-form',
                                                      metaFieldIdx:index
                                              ]" />

                                    <g:hiddenField name="index" value="${index}"/>
                                </div>

                                <div class="btn-box">
                                    <a class="submit save" onclick="$('#mf-${index}-update-form').submit();"><span><g:message
                                            code="button.update"/></span></a>
                                    <g:remoteLink class="submit cancel" action="editPM" params="[_eventId: 'removeMetaField', index: index]"
                                                  update="column2" method="GET">
                                        <span><g:message code="button.remove"/></span>
                                    </g:remoteLink>
                                </div>

                            </li>

                        </fieldset>

                    </g:formRemote>
                </g:each>

                <g:if test="${!paymentMethod?.metaFields}">
                    <li><em><g:message code="paymentMethod.no.metafields"/></em></li>
                </g:if>
            </ul>
        </div>
    </div>

    <div class="btn-box ait-btn-box">
        <g:link class="submit save" action="editPM" params="[_eventId: 'save']">
            <span><g:message code="button.save"/></span>
            <g:hiddenField name="saveInProgress" value="false"/>
        </g:link>

        <g:link class="submit cancel" action="editPM" params="[_eventId: 'cancel']">
            <span><g:message code="button.cancel"/></span>
        </g:link>
    </div>

    <script type="text/javascript">
        $('#metafield-ait li.mf').click(function() {
            var id = $(this).attr('id');
            $('#' + id).toggleClass('active');
            $('#' + id + '-editor').toggle('blind');
        });
    </script>


</div>