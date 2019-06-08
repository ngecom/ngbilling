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

<div class="content" id="commission_exceptions">
    <table id="commission_exceptions_table" class="dataTable" cellspacing="0" cellpadding="0" style="width: 50%">
        <thead>
        <tr>
            <th style="width: 165px"><g:message code="product.id"/></th>
            <th style="width: 165px"><g:message code="start_date"/></th>
            <th style="width: 165px"><g:message code="end_date"/></th>
            <th style="width: 165px"><g:message code="partner.commission.exception.percentage"/></th>
            <th>
                <a id="commission_exceptions_add_button" class="addButton" href="#"
                   onclick="addCommissionException(this);
                   return false;"
                   style="${partner?.commissionExceptions?.size() > 0 ? 'display: none;' : ''}">
                    <img name="add" src="${resource(dir: 'images', file: 'add.png')}" alt="Add"/>
                </a>
            </th>
        </tr>
        </thead>
        <tbody>
        <g:if test="${partner?.commissionExceptions}">
            <g:each in="${partner?.commissionExceptions}" var="commissionException" status="idx">
                <g:render template="commissionException" model="[commissionException: commissionException]"/>
            </g:each>
        </g:if>
        </tbody>
    </table>

    <div class="optionsDivInvisible">
        <table>
            <tbody>
            <g:render template="commissionException" model="[hidden: true]"/>
            </tbody>
        </table>
    </div>

    <script type="text/javascript">

        $(function () {
            // If the Partner has Commission Exceptions defined we open the container so they are visible.
            if (${partner?.commissionExceptions?.size() > 0}) {
                toggleSlide($('#commission-exception.box-cards'));
            }

            // Create jQuery UI datepickers in "exception.endDate" inputs.
            var commissionsExceptionsTable = $("#commission_exceptions_table");
            var startDateInputs = commissionsExceptionsTable.find('input[name="exception.startDate"]');
            var endDateInputs = commissionsExceptionsTable.find('input[name="exception.endDate"]');
            var options = getCommissionExceptionDatePickerOptions();
            startDateInputs.removeAttr("id").datepicker(options);
            endDateInputs.removeAttr("id").datepicker(options);
            addCommissionExceptionButtons();
        });

        function getCommissionExceptionDatePickerOptions() {
            var options = $.datepicker.regional['${session.locale.language}'];
            if (options == null) {
                options = $.datepicker.regional[''];
            }
            options.dateFormat = "${message(code: 'datepicker.jquery.ui.format')}";
            options.showOn = "both";
            options.buttonImage = "${resource(dir:'images', file:'icon04.gif')}";
            options.buttonImageOnly = true;
            return options;
        }

        function addCommissionException(button) {
            var $tr = $("#commission_exceptions_template");
            var $clone = $tr.clone();
            $clone.find(':text').prop('disabled', false);
            $clone.removeAttr('id');

            $('#commission_exceptions').find('.dataTable').find('tbody').append($clone);

            var options = getCommissionExceptionDatePickerOptions();

            $clone.find('input[name="exception.referralId"]').removeAttr('id').val('');
            $clone.find('input[name="exception.startDate"]').removeAttr("id").datepicker(options);
            $clone.find('input[name="exception.endDate"]').removeAttr("id").datepicker(options);
            $clone.find('input[name="exception.percentage"]').removeAttr('id').val('');

            addCommissionExceptionButtons();
        }

        function removeCommissionException(button) {
            $(button).closest('tr').remove();
            addCommissionExceptionButtons()
        }

        function addCommissionExceptionButtons() {
            var $commissionExceptionsTable = $('#commission_exceptions_table');
            var $addButtons = $commissionExceptionsTable.find('.addButton');
            if ($addButtons.length == 0) {
                $('#commission_exceptions_add_button').show();
            } else {
                $addButtons.hide();
                $commissionExceptionsTable.find('tr').last().find('.addButton').show();
            }
        }
    </script>
</div>
