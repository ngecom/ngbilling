<div id="assets-dialog-add">
    <div id="assets-box-add">
    </div>
</div>
<script type="text/javascript">
    <%-- Create a dialog --%>
    $( "#assets-dialog-add" ).dialog({
        title: "${g.message([code: 'assets.dialog.choose.title'])}" ,
        autoOpen: false,
        width: 580,
        modal: true,
        dialogClass: "no-close",
        open: function () {
            if ($('#selected-assets-add > ul li').length > 1) {
                showButtonToAddProductWithAsset();
            }
        }
    });

    <%-- Close the dialog. Function gets called by the close button in the dialog --%>
    function closeAssetsaddDialog(event) {
        event.preventDefault();
        $( '#assets-dialog-add' ).dialog( "close" );
        $( '#assets-box-add').empty();
    }

    //this function is broken and prevents script running after it from executing
    placeholder();
</script>

<div id="assets-dialog-update">
    <div id="assets-box-update">
    </div>
</div>

<script type="text/javascript">
    <%-- Create a dialog --%>
    $( "#assets-dialog-update" ).dialog({
        title: "${g.message([code: 'assets.dialog.choose.title'])}" ,
        autoOpen: false,
        width: 580,
        modal: true,
        dialogClass: "no-close"
    });

    <%-- Close the dialog. Function gets called by the close button in the dialog --%>
    function closeAssetsupdateDialog(event) {
        event.preventDefault();
        $( '#assets-dialog-update' ).dialog( "close" );
        $( '#assets-box-update').empty();
    }
    //this function is broken and prevents script running after it from executing
    placeholder();
</script>