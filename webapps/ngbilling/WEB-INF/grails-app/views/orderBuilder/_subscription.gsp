<div id="form-div-${assetFlow}" class="form-columns asset-dialog-filters">
    <div id="impersonation-text"><g:message code="subscription.item.new.prompt"/></div>
	<div>
        <br/>&nbsp;
    </div>
</div>
<div class="btn-box" id="buttons-id-subscription">
    <g:remoteLink class="submit add" action="edit"
                  params="[_eventId: 'initAssets', id : productId, execution : flowExecutionKey, isAssetMgmt:true, itemId:params.itemId, isPlan:params.isPlan]"
                  update="assets-box-add"
                  after="closeSubscriptionDialog(event);"
                  method="GET">
        <span><g:message code="button.add"/></span>
    </g:remoteLink>

    <a id="subscription-dialog-cancel" class="submit cancel" onclick="closeSubscriptionDialog(event);">
        <span><g:message code="button.cancel"/></span>
    </a>
</div>
<script type="text/javascript">
$('#subscription-dialog-add').dialog("open");
    placeholder();
</script>