#This Tcl file sources other Tcl files to build the design(on which recursive export is run) in a bottom-up fashion

#Sourcing the Tcl file in which all the HDL source files used in the design are imported or linked
source hdl_source.tcl
build_design_hierarchy

#Sourcing the Tcl files in which HDL+ core definitions are created for HDL modules
source components/video_fifo.tcl 
source components/jpeg_top.tcl 
build_design_hierarchy

#Sourcing the Tcl files for creating individual components under the top level
source components/CORERESET.tcl 
source components/CORERESET_PF_C5.tcl 
source components/CORERESET_PF_DDR4.tcl 
source components/INIT_MONITOR.tcl 
source components/PF_CCC_C0.tcl 
source components/PF_CLK_DIV_C0.tcl 
source components/PF_OSC_C0.tcl 
source components/PF_XCVR_REF_CLK_C0.tcl 
source components/CLOCKS_AND_RESETS.tcl 
source components/CoreAPB3_C0.tcl 
source components/FIC_CONVERTER.tcl 
source components/PF_DDR4_C0.tcl 
source components/DDR_AXI4_ARBITER_PF_C0.tcl 
source components/DDR_Read_C0.tcl 
source components/DDR_WRITE_JPEG.tcl 
source components/top_ddr_write_read.tcl 
source components/VKPFSOC_TOP.tcl 
build_design_hierarchy
