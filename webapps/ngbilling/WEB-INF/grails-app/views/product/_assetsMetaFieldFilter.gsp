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

<%@ page import="com.sapienter.jbilling.server.util.db.EnumerationDTO; com.sapienter.jbilling.server.metafields.DataType; com.sapienter.jbilling.server.item.db.ItemDTO; com.sapienter.jbilling.server.user.db.CompanyDTO; com.sapienter.jbilling.server.item.db.AssetStatusDTO;  com.sapienter.jbilling.server.item.db.AssetDTO" %>

<%--
  Meta Field filter used for asset filtering.

  @author Gerhard Maree
  @since 24-April-2013
--%>


<g:set var="dateValue" value="${ (params['filterByMetaFieldId'+metaFieldIdx] != null && params['filterByMetaFieldId'+metaFieldIdx].contains(DataType.DATE.toString())) ? params['filterByMetaFieldValue'+metaFieldIdx] : null}" />

<div id="mf-row-${metaFieldIdx}" class="row">
    <span class="select6"><g:select id="mf-id-${metaFieldIdx}" name="filterByMetaFieldId${metaFieldIdx}" from="${assetMetaFields}" class="mf-input"
                    optionKey="${{it.id+":"+it.dataType}}" optionValue="name"
                    value="${params['filterByMetaFieldId' + metaFieldIdx]}"/></span>

    <%-- Default control is a textfield --%>
    <div id="mf-val-div-${metaFieldIdx}" class="inp-bg valuemarker-div-${metaFieldIdx}">
        <g:textField id="mf-val-${metaFieldIdx}" name="filterByMetaFieldValue${metaFieldIdx}" class="field default mf-input valuemarker-${metaFieldIdx}"
            value="${params['filterByMetaFieldValue'+metaFieldIdx]}"/>
    </div>

    <g:each in="${assetMetaFields}" var="mf">
        <%-- Display a select with options if the meta field is a list or enumeration--%>
        <g:if test="${mf.dataType in [DataType.ENUMERATION, DataType.LIST]}">
            <g:set var="mfEnum" value="${EnumerationDTO.findByNameAndEntity(mf.name, mf.entity)}" />

            <g:set var="enumValues" value="${mfEnum.values.collect {it.value}}"/>

            <div id="mf-val-${mf.id}-div-${metaFieldIdx}" class="inp-bg-inv valuemarker-div-${metaFieldIdx}">
                <g:select id="mf-val-${mf.id}-${metaFieldIdx}"
                    class="field mf-input valuemarker-${metaFieldIdx}"
                    name="filterByMetaFieldValue${metaFieldIdx}"
                    from="${enumValues}"
                    value="${params['filterByMetaFieldValue'+metaFieldIdx]}"
                    optionKey=""
                    noSelection="['':'Please select a value']" />
            </div>
        </g:if>

        <%-- Display a checkbox if the meta field is a boolean --%>
        <g:if test="${mf.dataType in [DataType.BOOLEAN]}">
            <g:checkBox id="mf-val-${mf.id}-${metaFieldIdx}" class="cb checkbox mf-input valuemarker-${metaFieldIdx}" name="filterByMetaFieldValue${metaFieldIdx}" checked="${'on' == params['filterByMetaFieldValue'+metaFieldIdx]}"/>
        </g:if>

        <%-- Display a date picker if the meta field is a date --%>
        <g:if test="${mf.dataType in [DataType.DATE]}">
            <div id="mf-val-${mf.id}-div-${metaFieldIdx}" class="inp-bg valuemarker-div-${metaFieldIdx}">
                <g:textField id="mf-val-${mf.id}-${metaFieldIdx}"
                         class="field mf-input valuemarker-${metaFieldIdx} mfdate-${metaFieldIdx}"
                         name="filterByMetaFieldValue${metaFieldIdx}"
                         value="${dateValue}"/>
            </div>
            <g:if test="${initDatePicker}">
            <script type="text/javascript">
                // wait to initialize the date picker if it's not visible
                setTimeout(
                        function() {
                            var options = $.datepicker.regional['${session.locale.language}'];
                            if (options == null) options = $.datepicker.regional[''];

                            options.dateFormat = "${message(code: 'datepicker.jquery.ui.format')}";
                            options.buttonImage = "";

                            $(".mfdate-${metaFieldIdx}").datepicker(options);
                        },
                        $('.mfdate-${metaFieldIdx}').is(":visible") ? 0 : 500
                );
            </script>
            </g:if>
        </g:if>
    </g:each>


    <g:if test="${addButton}">
        <a onclick="addMetafieldFilter()">
            <img src="${resource(dir: 'images', file: 'add.png')}" alt="add"/>
        </a>
    </g:if>
    <g:if test="${removeButton}">
        <a onclick="$('#mf-row-${metaFieldIdx}').remove();removeMetafieldFilter();">
            <img src="${resource(dir: 'images', file: 'cross.png')}" alt="add"/>
        </a>
    </g:if>

</div>

