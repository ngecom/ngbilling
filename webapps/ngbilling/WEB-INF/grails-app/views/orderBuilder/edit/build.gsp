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

<%@ page contentType="text/html;charset=UTF-8" %>

<%--
  Order builder view.

  This view doubles as a way to render partial page templates by setting the 'template' parameter. This
  is used as a workaround for rendering AJAX responses from within the web-flow.

  @author Brian Cowdery
  @since 25-Jan-2011
--%>

<g:if test="${params.template}">
    <!-- render the template -->
    <g:render template="${params.template}"/>
</g:if>

<g:else>
    <!-- render the main builder view -->
    <html>
    <head>
        <meta name="layout" content="builder"/>
        <r:require module="showtab"/>
        <r:script disposition="head">

            $(document).ready(function() {
                $('#builder-tabs ul.ui-tabs-nav li a').each(function(index, link) {
                    $(link).attr('title', $(link).text());
                });

                $('#review-tabs').tabs({active: ${displayEditChangesTab ? 1 : 0} });
                $('#review-tabs ul.ui-tabs-nav li a').each(function(index, link) {
                    $(link).attr('title', $(link).text());
                });
                $('#builder-tabs').tabs();

                // prevent the Save Changes button to be clicked more than once.
                $('.order-btn-box .submit.save').on('click', function (e) {
                    var saveInProgress = $('#saveInProgress').val();

                    if (saveInProgress == "true") {
                        e.preventDefault();
                    } else {
                        $('#saveInProgress').val("true");
                    }
                });
                $('#order-line-charges-dialog').dialog({
                    autoOpen: false,
                    height: 450,
                    width: 800,
                    modal: true,
                    buttons: [{
                        text: '<g:message code="button.close"/>',
                        click: function() {$(this).dialog('close');}}]
                });
            });
            
            function showOrderLineCharges(id) {
                <g:remoteFunction controller="orderBuilder" action="renderOrderLineCharges" update="order-line-charges" params="'lineId='+id"/>
                $('#order-line-charges-dialog').dialog('open');
            }
        </r:script>
    </head>
    <body>

    <content tag="top">
        <!-- rendering some html and js that should exists only once in the page -->
        <g:render template="assetDialogs"/>
        <g:render template="subscriptionDialog"/>
    </content>

    <content tag="builder">
        <g:render template="orderLineChargesDialog" />
        <div id="builder-tabs">
            <ul>
                <li aria-controls="ui-tabs-details"><a  href="${createLink(action: 'edit', event: 'details')}"><g:message code="builder.details.title"/></a></li>
                <li aria-controls="ui-tabs-suborders"><a  href="${createLink(action: 'edit', event: 'suborders')}"><g:message code="builder.suborders.title"/></a></li>
                <li aria-controls="ui-tabs-products"><a  href="${createLink(action: 'edit', event: 'products')}"><g:message code="builder.products.title"/></a></li>
                <li aria-controls="ui-tabs-discounts"><a href="${createLink(action: 'edit', event: 'discounts')}"><g:message code="builder.discounts.title"/></a></li>
                <li aria-controls="ui-tabs-changes"><a  href="${createLink(action: 'edit', event: 'orderChanges')}"><g:message code="builder.changes.title"/></a></li>
            </ul>
        </div>
    </content>

    <content tag="review">
        <div id="review-tabs">
            <ul>
                <li aria-controls="ui-tabs-review"><a href="${createLink(action: 'edit', event: 'review')}"><g:message code="builder.review.title"/></a></li>
                <li aria-controls="ui-tabs-edit-changes"><a href="${createLink(action: 'edit', event: 'editOrderChanges')}"><g:message code="builder.edit.changes.title"/></a></li>
            </ul>
        </div>
    </content>

    </body>
    </html>
</g:else>
