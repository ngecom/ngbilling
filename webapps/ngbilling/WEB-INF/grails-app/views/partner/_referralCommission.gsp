<tr id = ${hidden ? "referrer_commissions_template" : ''}>
    <td class="medium">
        <g:applyLayout name="form/text">
            <content tag="label.for">referrer.referralId</content>
            <input type="text" name="referrer.referralId"
                   value="${referrerCommission?.referralId}" ${hidden ? 'id="referrerIdTemplate" disabled="disabled"' : ''}/>
        </g:applyLayout>
    </td>

    <td class="medium">
        <g:applyLayout name="form/date">
            <content tag="label.for">referrer.startDate</content>
            <input type="text" name="referrer.startDate" 
                   value="${formatDate(date: referrerCommission?.startDate, formatName: 'datepicker.format')}" ${hidden ? 'id="referrerStartDateTemplate" disabled="disabled"' : ''}/>
        </g:applyLayout>
    </td>

    <td class="medium">
        <g:applyLayout name="form/date">
            <content tag="label.for">referrer.endDate</content>
            <input type="text" name="referrer.endDate"
                   value="${formatDate(date: referrerCommission?.endDate, formatName: 'datepicker.format')}" ${hidden ? 'id="referrerEndDateTemplate" disabled="disabled"' : ''}/>
        </g:applyLayout>
    </td>

    <td class="medium">
        <g:applyLayout name="form/input">
            <content tag="label.for">referrer.percentage</content>
            <input type="text" name="referrer.percentage"
                   value="${formatNumber(number: referrerCommission?.percentageAsDecimal, formatName: 'money.format')}" ${hidden ? 'id="referrerPercentageDateTemplate" disabled="disabled"' : ''}/>
        </g:applyLayout>
    </td>

    <td style="width: 20px;${idx == 0 ? 'display:none;' : ''}">
        <a class="removeReferralButton" href="#" onclick="removeReferralCommission(this);
        return false;">
            <img name="remove" src="${resource(dir: 'images', file: 'remove.png')}" alt="Remove"/>
        </a>
    </td>

    <td>
        <a class="addReferralButton" href="#" onclick="addReferralCommission(this);
        return false;">
            <img name="add" src="${resource(dir: 'images', file: 'add.png')}" alt="Add"/>
        </a>
    </td>
</tr>
