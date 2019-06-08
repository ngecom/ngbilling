
%{--
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

<%@page import="java.lang.System"%>
<html>
<head>
    <meta name="layout" content="main" />

    <style type="text/css">
        tr.highlight {
            font-weight: bold;
            background-color: #C6CFFF;
        }
        td.field { width: 30%; }
        td.value { width: 70%; }
        td.latest { width: 25%; }
        td.event { width: 15%; }
        td.desc { width: 45%; }
        td.id { width: 15%; }
    </style>


    <r:script disposition="head">
        $(document).ready(function() {
            $('select.version-selector').change(function() {
                var timestamp = $(this).val();
                var record = $(this).attr('id');

                $('.historical .table-area[name=' + record + ']:visible').hide();
                $('.historical #' + timestamp + '[name=' + record + ']').show();

                diff(record);
            });
        });

        function diff(record) {
            var latest = $(".current .table-area[name='" + record +"'] table");
            var historical = $(".historical .table-area[name='" + record + "'] table:visible");

            latest.find('tbody tr').each(function() {
                var current = $(this);
                var history = historical.find("tbody tr[name='" + current.attr('name') + "']");

                var highlight = (current.find('.value').text() != history.find('.value').text());
                current.toggleClass('highlight', highlight);
                history.toggleClass('highlight', highlight);
            });
        }

    </r:script>
</head>

<body>
    <g:each var="record" in="${records}">
        <g:set var="current" value="${record.current}"/>
        <g:set var="versions" value="${record.versions.sort{ a, b -> return b.timestamp <=> a.timestamp }}"/>

        <div class="form-columns wide">

        <!-- current version -->
        <div class="current column-50 first">
            <div class="table-info">
                <em><strong><g:message code="header.current.version" args="[record.name]"/></strong></em>
            </div>
            <div class="table-area" name="${record.name}">
                <table>
                    <thead>
                    <tr>
                        <td colspan="2"><g:message code="th.history.now"/></td>
                    </tr>
                    </thead>
                    <tbody>
                    <tr class="bg">
                        <td class="field"><strong><g:message code="th.history.field"/></strong></td>
                        <td class="value"><strong><g:message code="th.history.value"/></strong></td>
                    </tr>
                    <g:each var="row" in="${current.entrySet()}">
                        <tr name="${row.key}">
                            <td class="col02">${row.key}</td>
                            <td class="value">${row.value}</td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>

            </div>
        </div> <!-- end .column -->

        <!-- historical version -->
        <div class="historical column-50">
            <g:if test="${versions}">

            <g:form name="${record.name}-form" action="restore" params="[ record: record.name, id: record.id, historyid: historyid ]">

            <div class="table-info">
                <em><strong><g:message code="header.historical.version" args="[record.name]"/></strong></em>
                <span style="float: right; margin-top: 11px;">
                    <g:select id="${record.name}"
                              name="timestamp"
                              class="version-selector"
                              from="${versions}"
                              optionKey="timestamp"
                              optionValue="${{it.columns.keySet()[0].toString() + " " + it.event + " - " + formatDate(date: new Date(it.timestamp), formatName: 'default.date.format')}}"
                                style="width: 250px"/>

                    <g:if test="${!(record.name.equals('order') || record.name.equals('invoice') || record.name.equals('payment'))}">
                    	<a onclick="$('#${record.name}-form').submit()" class="submit save" style="margin-left: 7px;"><span>Restore</span></a>
                    </g:if>
                </span>
            </div>

            </g:form>

            <g:each var="version" status="i" in="${versions}">
                <g:set var="display" value="${i > 0 ? 'display: none;' : ''}"/>
                <div class="table-area" id="${version.timestamp}" style="${display}" name="${record.name}">
                <table>
                    <thead>
                        <tr>
                            <td colspan="2">
                                <g:formatDate date="${new Date(version.timestamp)}" formatName="default.date.format"/> - ${version.event}
                            </td>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="bg">
                            <td class="field"><strong><g:message code="th.history.field"/></strong></td>
                            <td class="value"><strong><g:message code="th.history.value"/></strong></td>
                        </tr>
                        <g:each var="row" in="${version.columns.entrySet()}">
                            <tr name="${row.key}">
                                <td class="col02">${row.key}</td>
                                <td class="value">${row.value}</td>
                            </tr>
                        </g:each>
                    </tbody>
                </table>
                </div>
            </g:each>
            </g:if>
            <g:else>
                <div class="table-info">
                    <em><g:message code="message.no.history"/></em>
                </div>
            </g:else>
        </div> <!-- end .column -->
        </div> <!-- end .form-columns -->

    </g:each>

    <g:if test="${lines}">
        <div>
            <br/>&nbsp;
        </div>

        <div class="table-area">
            <table>
                <thead>
                <tr>
                    <td colspan="4"><g:message code="th.history.lines"/></td>
                </tr>
                </thead>
                <tbody>
                    <tr class="bg">
                        <td class="latest"><strong><g:message code="th.history.latest"/></strong></td>
                        <td class="event"><strong><g:message code="th.history.event"/></strong></td>
                        <td class="desc"><strong><g:message code="th.history.description"/></strong></td>
                        <td class="id"><strong><g:message code="th.history.id"/></strong></td>
                    </tr>
                    <g:each var="line" in="${lines}">
                    <tr>
                        <td class="col02">
                            <g:formatDate date="${new Date(line.timestamp)}" formatName="default.date.format"/>
                        </td>
                        <td>
                            ${line.event}
                        </td>
                        <td>
                            ${line.columns.get("description")}
                        </td>
                        <td>
                            <g:set var="id" value="${line.columns.get("id")}"/>
                            <g:link controller="${linecontroller}" action="${lineaction}" id="${id}">${id}</g:link>
                        </td>
                    </tr>
                    </g:each>
                </tbody>
            </table>
        </div>
    </g:if>

</body>
</html>
