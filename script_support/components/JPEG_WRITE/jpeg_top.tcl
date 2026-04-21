# Exporting core jpeg_top to TCL
# Exporting Create HDL core command for module jpeg_top
create_hdl_core -file {hdl/jpeg_top.v} -module {jpeg_top} -library {work} -package {}
# Exporting BIF information of  HDL core command for module jpeg_top
hdl_core_add_bif -hdl_core_name {jpeg_top} -bif_definition {APB:AMBA:AMBA2:slave} -bif_name {APBslave} -signal_map {\
"PADDR:paddr" \
"PWRITE:pwrite" \
"PRDATA:prdata" \
"PWDATA:pwdata" \
"PREADY:pready" \
"PSLVERR:pslverr" \
"PSELx:psel" }
