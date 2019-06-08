<div class="row">
    <div>
        <span>
            <u><g:message code="breadcrumb.payment.list.id" args="[g.message(code: 'prompt.tokens')]"/></u>
        </span>
    </div>
</div>

<div class="row">
    <div>
        <a href="javascript:void(0)"
           onclick="testfunc('$method');" class="">
            <span><g:message code="payment.th.method" />
            </span>
        </a>
    </div>
    <div>
        <a href="javascript:void(0)"
           onclick="testfunc('$total');" class="">
            <span><g:message code="label.token.ageing.total" default="Total" />
            </span>
        </a>
    </div>
    <div>
        <a href="javascript:void(0)"
           onclick="testfunc('$payment');" class="">
            <span><g:message code="payment.payment.title" default="payment"/>
            </span>
        </a>
    </div>
    <div>
        <a href="javascript:void(0)"
           onclick="testfunc('$invoice_number');" class="">
            <span><g:message code="label.token.invoice.number" default="Invoice Number"/>
            </span>
        </a>
    </div>
    <div>
        <a href="javascript:void(0)"
           onclick="testfunc('$invoice');" class="">
            <span><g:message code="invoice.label.details" default="Invoice" />
            </span>
        </a>
    </div>
</div>