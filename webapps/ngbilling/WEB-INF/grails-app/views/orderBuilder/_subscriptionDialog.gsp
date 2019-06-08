<div id="subscription-dialog-add">
    <div id="subscription-box-add">
    </div>
</div>

<script type="text/javascript">
    $( "#subscription-dialog-add" ).dialog({
        title: "${g.message([code: 'subscription.item.subscribe'])}" ,
        autoOpen: false,
        width: 580,
        modal: true,
        dialogClass: "no-close"
    });

    <%-- Close the dialog. Function gets called by the close button in the dialog --%>
    function closeSubscriptionDialog(event) {
        event.preventDefault();
        $( '#subscription-dialog-add' ).dialog( "close" );
    }

    //this function is broken and prevents script running after it from executing
    placeholder();
</script>