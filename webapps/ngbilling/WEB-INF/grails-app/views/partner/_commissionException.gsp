<tr id = ${hidden ? "commission_exceptions_template" : ''}>
    <td class="medium">
        <g:applyLayout name="form/text">
            <content tag="label.for">exception.itemId</content>
            <input type="text" name="exception.itemId"
                   value="${commissionException?.itemId}" ${hidden ? 'id="exceptionIdTemplate" disabled="disabled"' : ''}/>
        </g:applyLayout>
    </td>

    <td class="medium">
        <g:applyLayout name="form/date">
            <content tag="label.for">exception.startDate</content>
            <input type="text" name="exception.startDate" 
                   value="${formatDate(date: commissionException?.startDate, formatName: 'datepicker.format')}" ${hidden ? 'id="exceptionStartDateTemplate" disabled="disabled"' : ''}/>
        </g:applyLayout>
    </td>

    <td class="medium">
        <g:applyLayout name="form/date">
            <content tag="label.for">exception.endDate</content>
            <input type="text" name="exception.endDate"
                   value="${formatDate(date: commissionException?.endDate, formatName: 'datepicker.format')}" ${hidden ? 'id="exceptionEndDateTemplate" disabled="disabled"' : ''}/>
        </g:applyLayout>
    </td>

    <td class="medium">
        <g:applyLayout name="form/input">
            <content tag="label.for">exception.percentage</content>
            <input type="text" name="exception.percentage"
                   value="${formatNumber(number: commissionException?.percentageAsDecimal, formatName: 'money.format')}"
                ${hidden ? 'id="exceptionPercentageTemplate" disabled="disabled"' : ''}/>
        </g:applyLayout>
    </td>

    <td style="width: 20px;${idx == 0 ? 'display:none;' : ''}">
        <a class="removeButton" href="#" onclick="removeCommissionException(this);
        return false;">
            <img name="remove" src="${resource(dir: 'images', file: 'remove.png')}" alt="Remove"/>
        </a>
    </td>

    <td>
        <a class="addButton" href="#" onclick="addCommissionException(this);
        return false;">
            <img name="add" src="${resource(dir: 'images', file: 'add.png')}" alt="Add"/>
        </a>
    </td>
</tr>
