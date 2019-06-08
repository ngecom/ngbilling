
/*
 * jBilling - The Enterprise Open Source Billing System
 * Copyright (C) 2003-2011 Enterprise jBilling Software Ltd. and Emiliano Conde
 * 
 * This file is part of jbilling.
 * 
 * jbilling is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * jbilling is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 * 
 * You should have received a copy of the GNU Affero General Public License
 * along with jbilling.  If not, see <http://www.gnu.org/licenses/>.

 This source was modified by Web Data Technologies LLP (www.webdatatechnologies.in) since 15 Nov 2015.
 You may download the latest source from webdataconsulting.github.io.

 */


function moveLeftUp(msId) {
    var $sel = $("#"+msId+"-group-left :selected");
    if($sel.length == 1) $sel.prev().before($sel);
}

function moveLeftDown(msId) {
    var $sel = $("#"+msId+"-group-left :selected");
    if($sel.length == 1) $sel.next().after($sel);
}

function moveSelectedLeft(msId) {
    var $sel = $("#"+msId+"-group-right :selected");
    if($sel.length) $sel.appendTo("#"+msId+"-group-left");
}

function moveSelectedRight(msId) {
    var $sel = $("#"+msId+"-group-left :selected");
    if($sel.length) $sel.appendTo("#"+msId+"-group-right");
}

function moveAllLeft(msId) {
    var $sel = $("#"+msId+"-group-right option");
    if($sel.length) $sel.appendTo("#"+msId+"-group-left");
}

function moveAllRight(msId) {
    var $sel = $("#"+msId+"-group-left option");
    if($sel.length) $sel.appendTo("#"+msId+"-group-right");
}

function updateDLValues(msId) {
    var $ord = $("#"+msId+"-left-order");
    $ord.val("")
    $("#"+msId+"-group-left option").each( function(i, elm) {
        $ord.val( $ord.val() +","+elm.value);
    });

    $ord = $("#"+msId+"-right-order");
    $ord.val("")
    $("#"+msId+"-group-right option").each( function(i, elm) {
        $ord.val($ord.val()+","+elm.value);
    });
}

function registerDisjointListbox() {
    $(".disjoint-listbox").each( function(i, elm) {
        var msId = elm.id;
        if($("#"+msId+"-left-up").length) $("#"+msId+"-left-up").click(function(evtObj) { moveLeftUp(msId); });
        if($("#"+msId+"-left-down").length) $("#"+msId+"-left-down").click(function(evtObj) { moveLeftDown(msId); });
        $("#"+msId+"-to-left").click(function(evtObj) { moveSelectedLeft(msId); });
        $("#"+msId+"-to-left-all").click(function(evtObj) { moveAllLeft(msId); });
        $("#"+msId+"-to-right").click(function(evtObj) { moveSelectedRight(msId); });
        $("#"+msId+"-to-right-all").click(function(evtObj) { moveAllRight(msId); });
        if($("#"+msId+"-form").length) $("#"+msId+"-form").submit(function(evtObj) { updateDLValues(msId); });
    });
}

$(function(){
    registerDisjointListbox();
});