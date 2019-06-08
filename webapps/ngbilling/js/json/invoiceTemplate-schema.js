var cif_schemas = (function ($) {

    var HavingID = {
            properties: {
                "id": { "type": "string"}
            }
        },
        HavingName = {
            properties: $.extend(true, {}, HavingID.properties, {
                "name": { "type": "string", "title": "Name", "required": true }
            })
        },
        DocElement = {
            properties: $.extend(true, {}, HavingName.properties, {
                "left": {"type": "integer", "minimum": 0, "maximum": 1000, "title": "Left", "required": true, "default": 100},
                "top": {"type": "integer", "minimum": 0, "maximum": 1000, "title": "Top", "required": true, "default": 100},
                "width": {"type": "integer", "minimum": 0, "maximum": 1000, "title": "Width", "required": true, "default": 100},
                "height": {"type": "integer", "minimum": 0, "maximum": 1000, "title": "Height", "required": true, "default": 100}
            }),
            stub: {
                "name": "New Doc Element",
                "left": 0,
                "top": 0,
                "width": 0,
                "height": 0
            }
        },
        TextElement = {
            properties: $.extend(true, {}, DocElement.properties, {
                "expr": {"type": "string", "title": "Expression"},
                "alignment": {"type": "string", "title": "Alignment", "enum": ["LEFT", "CENTER", "RIGHT", "JUSTIFIED"], "default": "LEFT", "required": true},
                "borderColor": {"type": "string", "title": "Border Color", "required": true, "default": "#606060"},
                "thickness": {"type": "integer", "minimum": 0, "maximum": 100, "title": "Border Thickness", "required": true, "default": 0},
                "padding": {"type": "integer", "minimum": 0, "maximum": 1000, "title": "Padding", "required": true, "default": 0},
                "bgColor": {"type": "string", "title": "Background Color", "required": true, "default": "#FFFFFF"},
                "transparent": {"type": "boolean", "title": "Transparent", "required": false, "default": false},
                "font": {
                    "title": "Font",
                    "type": "object",
                    "properties": {
                        "face": { "type": "string", "title": "Font", "enum": ["SansSerif", "Serif", "Monospaced"], "default": "SansSerif", "required": true },
                        "size": {"type": "integer", "minimum": 5, "maximum": 1000, "title": "Size", "required": true, "default": 16},
                        "bold": {"type": "boolean", "title": "Bold", "required": true, "default": false},
                        "italic": {"type": "boolean", "title": "Italic", "required": true, "default": false},
                        "color": {"type": "string", "title": "Color", "required": true, "default": "#000000"}
                    }
                }
            }),
            stub: {
                "thickness": 0,
                "font": {
                    "face": "SansSerif",
                    "size": 16,
                    "bold": false,
                    "italic": false,
                    "color": "#000000"
                },
                "transparent": false,
                "borderColor": "#808080",
                "bgColor": "#A0A0A0",
                "alignment": "LEFT"
            }
        },
        CommonLines = {
            properties: $.extend(true, {}, HavingName.properties, {}),
            stub: {}
        },
        TableLines = {
            properties: $.extend(true, {}, CommonLines.properties, {
                "font": {
                    "title": "Content Font",
                    "type": "object",
                    "properties": {
                        "face": { "type": "string", "title": "Font", "enum": ["SansSerif", "Serif", "Monospaced"], "default": "SansSerif", "required": true },
                        "size": {"type": "integer", "minimum": 5, "maximum": 1000, "title": "Size", "required": true, "default": 16},
                        "bold": {"type": "boolean", "title": "Bold", "required": true, "default": false},
                        "italic": {"type": "boolean", "title": "Italic", "required": true, "default": false},
                        "color": {"type": "string", "title": "Color", "required": true, "default": "#000000"}
                    }
                },
                "headerFont": {
                    "title": "Header Font",
                    "type": "object",
                    "properties": {
                        "face": { "type": "string", "title": "Font", "enum": ["SansSerif", "Serif", "Monospaced"], "default": "SansSerif", "required": true },
                        "size": {"type": "integer", "minimum": 5, "maximum": 1000, "title": "Size", "required": true, "default": 16},
                        "bold": {"type": "boolean", "title": "Bold", "required": true, "default": false},
                        "italic": {"type": "boolean", "title": "Italic", "required": true, "default": false},
                        "color": {"type": "string", "title": "Color", "required": true, "default": "#000000"}
                    }
                },
                "headerBgColor": {"type": "string", "title": "Header Background Color", "required": true, "default": "#FFFFFF"},
                "groupHeaderFont": {
                    "title": "Group Header Font",
                    "type": "object",
                    "properties": {
                        "face": { "type": "string", "title": "Font", "enum": ["SansSerif", "Serif", "Monospaced"], "default": "SansSerif", "required": true },
                        "size": {"type": "integer", "minimum": 5, "maximum": 1000, "title": "Size", "required": true, "default": 16},
                        "bold": {"type": "boolean", "title": "Bold", "required": true, "default": false},
                        "italic": {"type": "boolean", "title": "Italic", "required": true, "default": false},
                        "color": {"type": "string", "title": "Color", "required": true, "default": "#000000"}
                    }
                },
                "groupBgColor": {"type": "string", "title": "Group Header Background Color", "required": true, "default": "#FFFFFF"},
                "addGroupHeaderFont": {
                    "title": "Add. Group Header Font",
                    "type": "object",
                    "properties": {
                        "face": { "type": "string", "title": "Font", "enum": ["SansSerif", "Serif", "Monospaced"], "default": "SansSerif", "required": true },
                        "size": {"type": "integer", "minimum": 5, "maximum": 1000, "title": "Size", "required": true, "default": 16},
                        "bold": {"type": "boolean", "title": "Bold", "required": true, "default": false},
                        "italic": {"type": "boolean", "title": "Italic", "required": true, "default": false},
                        "color": {"type": "string", "title": "Color", "required": true, "default": "#000000"}
                    }
                },
                "addGroupBgColor": {"type": "string", "title": "Add. Group Header Background Color", "required": true, "default": "#FFFFFF"},
                "recordSeparation": { "type": "string", "title": "Records Separator Type", "enum": ["None", "Box", "Line"], "default": "None", "required": true },
                "recordSeparationThickness": {"type": "integer", "minimum": 0, "maximum": 100, "title": "Record Separator Thickness", "required": true, "default": 0},
                "recordSeparationColor": {"type": "string", "title": "Color of Records Separator", "required": true, "default": "#FFFFFF"}
            }),
            stub: $.extend(true, {}, CommonLines.stub, {
                "font": {
                    "face": "SansSerif",
                    "size": 16,
                    "bold": false,
                    "italic": false,
                    "color": "#000000"
                },
                "headerFont": {
                    "face": "SansSerif",
                    "size": 16,
                    "bold": false,
                    "italic": false,
                    "color": "#000000"
                },
                "sortCriterion": null,
                "groupCriteria": null,
                "addGroupCriteria": null,
                "groupHeaderFont": {
                    "face": "SansSerif",
                    "size": 16,
                    "bold": false,
                    "italic": false,
                    "color": "#000000"
                },
                "addGroupHeaderFont": {
                    "face": "SansSerif",
                    "size": 16,
                    "bold": false,
                    "italic": false,
                    "color": "#000000"
                },
                "recordSeparationThickness": 0,
                "minimalTotal": -1.7976931348623157E308
            })
        };
    return {
        "DocDesign": {
            "schema": {
                "title": "Invoice Design",
                "type": "object",
                "properties": $.extend(true, {}, HavingID.properties, {
                    "name": { "type": "string", "title": "Invoice Design Name", "required": true},
                    "format": { "type": "string", "title": "Page Format", "enum": ["A4", "Letter", "Legal"], "default": "A4", "required": true },
                    "marginLeft": {"type": "integer", "minimum": 0, "maximum": 1000, "title": "Left Margin", "required": true, "default": 30},
                    "marginRight": {"type": "integer", "minimum": 0, "maximum": 1000, "title": "Right Margin", "required": true, "default": 30},
                    "marginTop": {"type": "integer", "minimum": 0, "maximum": 1000, "title": "Top Margin", "required": true, "default": 30},
                    "marginBottom": {"type": "integer", "minimum": 0, "maximum": 1000, "title": "Bottom Margin", "required": true, "default": 30},
                    "landscape": {"type": "boolean", "title": "Landscape", "required": true, "default": false}
                })
            },
            "stub": {
                "name": "New Design",
                "format": "A4",
                "marginLeft": 30,
                "marginRight": 30,
                "marginTop": 30,
                "marginBottom": 30,
                "landscape": false
            }
        },
        "Text": {
            "schema": {
                "title": "Text Box",
                "type": "object",
                "properties": $.extend(true, {}, TextElement.properties, {})
            },
            ignoredProperties: ["left", "top", "width", "height"],
            "stub": $.extend(true, {}, TextElement.stub, {
                "name": "New Text",
                "kind": "Text"
            })
        },
        "SQLField": {
            "schema": {
                "title": "SQL Field",
                "type": "object",
                "properties": $.extend(true, {}, HavingName.properties, {"expr": {"type": "string", "title": "SQL Query"}})
            },
            "stub": {
                "name": "New SQL Field",
                "expr": "select now()",
                "kind": "SQLField"
            }
        },
        "TextBox": {
            "schema": {
                "title": "Text Box",
                "type": "object",
                "properties": $.extend(true, {}, TextElement.properties, {
                    "roundCornerRadius": {"type": "integer", "minimum": 0, "maximum": 1000, "title": "Border Corner Radius", "required": true, "default": 0},
                    "evaluationTime": {"type": "string", "title": "Evaluation Time", "enum": ["NOW", "REPORT", "PAGE", "COLUMN", "GROUP", "BAND", "AUTO"], "default": "AUTO", "required": true}
                })
            },
            "stub": $.extend(true, {}, TextElement.stub, {
                "name": "New Text Box",
                "roundCornerRadius": 0,
                "evaluationTime": "AUTO",
                "kind": "TextBox"
            })
        },
        "List": {
            "schema": {
                "title": "List",
                "type": "object",
                "properties": $.extend(true, {}, DocElement.properties, CommonLines.properties, {
                    "source": {"type": "string", "title": "Items Source", "enum": ["InvoiceLines", "CDREvents", "Assets"], "default": "InvoiceLines", "required": true},
                    "orientation": {"type": "string", "title": "Orientation", "enum": ["Horizontal", "Vertical"], "default": "Vertical", "required": true},
                    "ignoreWidth": {"type": "boolean", "title": "Ignore Width", "required": false, "default": false},
                    "sortBy": {"type": "string", "title": "Sort By", "required": false},
                    "filterExpr": {"type": "string", "title": "Filter Criteria", "required": false},
                    "borderColor": {"type": "string", "title": "Border Color", "required": true, "default": "#606060"},
                    "thickness": {"type": "integer", "minimum": 0, "maximum": 100, "title": "Border Thickness", "required": true, "default": 0},
                    "padding": {"type": "integer", "minimum": 0, "maximum": 1000, "title": "Padding", "required": true, "default": 0},
                    "transparent": {"type": "boolean", "title": "Transparent", "required": false, "default": false},
                    "bgColor": {"type": "string", "title": "Background Color", "required": true, "default": "#FFFFFF"}
                })
            },
            "stub": $.extend(true, {}, DocElement.stub, CommonLines.stub, {
                "name": "New List",
                "source": "InvoiceLines",
                "orientation": "Vertical",
                "ignoreWidth": false,
                "elements": [],
                "kind": "List",
                "sortBy": null,
                "filterExpr": null,
                "thickness": 0,
                "roundCornerRadius": 0,
                "borderColor": "#808080",
                "bgColor": "#A0A0A0",
                "transparent": false,
                "noDataText": $.extend(true, {}, TextElement.stub, {
                    "name": "No Data Text",
                    "kind": "Text"
                })
            })
        },
        "Image": {
            "schema": {
                "title": "Image",
                "type": "object",
                "properties": $.extend(true, {}, DocElement.properties, {
                    "imageSource": {"type": "string", "title": "Image Source", "enum": ["URL", "File"], "required": true, "default": "URL"},
                    "imageUrl": {"type": "string", "dependencies": "imageSource" },
                    "imageFile": {"type": "string", "dependencies": "imageSource" }
                })
            },
            "stub": $.extend(true, {}, DocElement.stub, {
                "name": "New Image",
                "format": "PNG",
                "kind": "Image"
            })
        },
        "Section": {
            "schema": {
                "title": "Section",
                "type": "object",
                "properties": $.extend(true, {}, HavingID.properties, HavingName.properties, {
                    "pageBreakBefore": {"type": "boolean", "title": "Start with new page", "required": true, "default": false},
                    "columns": { "type": "number", "title": "Num of Columns", "required": true, "default": 1, "minimum": 1, "maximum": 8 }
                })
            },
            "stub": {
                "name": "New Section",
                "pageBreakBefore": false,
                "columns": 1,
                "header": {
                    "elements": []
                },
                "footer": {
                    "elements": []
                },
                "pageHeader": {
                    "elements": []
                },
                "pageFooter": {
                    "elements": []
                },
                "left": 0,
                "top": 0,
                "width": 0,
                "height": 0,
                "kind": "Section"
            }
        },
        "SubReport": {
            "schema": {
                "title": "Sub Report",
                "type": "object",
                "properties": $.extend(true, {}, HavingID.properties, HavingName.properties, {
                    "left": {"type": "integer", "minimum": 0, "maximum": 1000, "title": "Left", "required": true, "default": 100},
                    "top": {"type": "integer", "minimum": 0, "maximum": 1000, "title": "Top", "required": true, "default": 100},
                    "subReportDataSourceType": {"type": "string", "title": "Data Source", "enum": ["EMPTY", "JBILLING", "XML", "CSV"], "default": "EMPTY", "required": true},
                    "subReportDataSourcePath": {"type": "string", "title": "Path (csv,xml) or Query", "required": false, "default": ""},
                    "fileName": {"type": "string", "title": "Filename", "required": true, "default": ""}
                })
            },
            "stub": {
                "name": "New Sub Report",
                "pageBreakBefore": false,
                "subReportDataSourceType": "EMPTY",
                "left": 0,
                "top": 0,
                "kind": "SubReport"
            }
        },
        "InvoiceLines": {
            "schema": {
                "title": "Invoice Lines",
                "type": "object",
                "properties": $.extend(true, {}, HavingID.properties, HavingName.properties, TableLines.properties, {})
            },
            "stub": $.extend(true, {}, TableLines.stub, {
                "name": "New Invoice Lines",
                "kind": "InvoiceLines"
            })
        },
        "EventLines": {
            "schema": {
                "title": "Event Lines",
                "type": "object",
                "properties": $.extend(true, {}, HavingID.properties, HavingName.properties, TableLines.properties, {})
            },
            "stub": $.extend(true, {}, TableLines.stub, {
                "name": "New Event Lines",
                "kind": "EventLines"
            })
        }
    }
})(jQuery);
var cif_formats = [
    {
        types: [
            'java.lang.Number', 'java.lang.Integer', 'java.lang.Short', 'java.lang.Long', 'java.lang.Float',
            'java.lang.Double', 'java.math.BigInteger', 'java.math.BigDecimal'
        ],
        variants: ['#0.##', '#0.00', '$CS #0.00', '$ #0.00', '£ #0.00', '€ #0.00', 'UL_MONEY', 'UL_PCNT', 'UL_DEC']
    },
    {
        types: ['java.util.Date'],
        variants: ['yyyy-MM-dd HH:mm', 'M/d/yy HH:mm', 'yyyy-MM-dd', 'M/d/yy', 'dd.MM.yyyy', 'dd.MM', 'HH:mm', 'HH:mm:ss', 'UL_DATE']
    },
    {
        types: ['java.lang.String'],
        variants: ['PLAIN TEXT']
    }
];
