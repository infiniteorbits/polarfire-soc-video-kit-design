# Exporting Component Description of DDR_Write_C0 to TCL
# Family: PolarFire
# Part Number: MPF300T-1FCG1152E
# Create and Configure the core component DDR_Write_C0
create_and_configure_core -core_vlnv {Microchip:SolutionCore:DDR_Write:1.3.0} -component_name {DDR_Write_C0} -params {\
"g_AXI4S_FORMAT:0"  \
"g_DDR_AXI_DWIDTH_I:32"  \
"g_DDR_AXI_DWIDTH_O:512"  \
"g_FORMAT:1"  \
"g_FRAME_GAP:1"  \
"g_HORIZ_RESOL:1920"  \
"g_NO_OF_PIXEL:1"   }
# Exporting Component Description of DDR_Write_C0 to TCL done


# Exporting Component Description of DDR_Read_C0 to TCL
# Family: PolarFire
# Part Number: MPF300T-1FCG1152E
# Create and Configure the core component DDR_Read_C0
create_and_configure_core -core_vlnv {Microchip:SolutionCore:DDR_Read:1.2.0} -component_name {DDR_Read_C0} -params {\
"g_AXI4S_FORMAT:0"  \
"g_DDR_AXI_DWIDTH_I:512"  \
"g_DDR_AXI_DWIDTH_O:32"  \
"g_FORMAT:1"  \
"g_FRAME_GAP:1"  \
"g_HORIZ_RESOL:1920"  \
"g_NO_OF_PIXEL:1"   }
# Exporting Component Description of DDR_Read_C0 to TCL done

# Exporting Component Description of DDR_AXI4_ARBITER_PF_C0 to TCL
# Family: PolarFire
# Part Number: MPF300T-1FCG1152E
# Create and Configure the core component DDR_AXI4_ARBITER_PF_C0
create_and_configure_core -core_vlnv {Microchip:SolutionCore:DDR_AXI4_ARBITER_PF:2.2.0} -component_name {DDR_AXI4_ARBITER_PF_C0} -params {\
"AXI4_SELECTION:2"  \
"AXI_ADDR_WIDTH:32"  \
"AXI_DATA_WIDTH:512"  \
"AXI_ID_WIDTH:4"  \
"FORMAT:1"  \
"NO_OF_READ_CHANNELS:1"  \
"NO_OF_WRITE_CHANNELS:1"   }
# Exporting Component Description of DDR_AXI4_ARBITER_PF_C0 to TCL done


# Creating SmartDesign "DDR_READ_WRITE"
set sd_name {DDR_READ_WRITE}
create_smartdesign -sd_name ${sd_name}

# Disable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 0

# Create top level Scalar Ports
sd_create_scalar_port -sd_name ${sd_name} -port_name {DDR_READ_frame_start_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {DDR_WRITE_frame_start_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_arready} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_awready} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_bvalid} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_rlast} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_rvalid} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_wready} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {data_valid_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {ddr_clk_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {ddr_clk_rstn_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {ddr_ctrl_ready_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {pixel_clk_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {read_en_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {rstn_i} -port_direction {IN}

sd_create_scalar_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_arvalid} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_awvalid} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_bready} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_rready} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_wlast} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_wvalid} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {data_valid_o} -port_direction {OUT}


# Create top level Bus Ports
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_bid} -port_direction {IN} -port_range {[3:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_bresp} -port_direction {IN} -port_range {[1:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_rdata} -port_direction {IN} -port_range {[511:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_rid} -port_direction {IN} -port_range {[3:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_rresp} -port_direction {IN} -port_range {[1:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {data_i} -port_direction {IN} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {frame_ddr_addr_i} -port_direction {IN} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {horz_resl_i} -port_direction {IN} -port_range {[15:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {line_gap_i} -port_direction {IN} -port_range {[15:0]}

sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_araddr} -port_direction {OUT} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_arburst} -port_direction {OUT} -port_range {[1:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_arcache} -port_direction {OUT} -port_range {[3:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_arid} -port_direction {OUT} -port_range {[3:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_arlen} -port_direction {OUT} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_arlock} -port_direction {OUT} -port_range {[1:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_arprot} -port_direction {OUT} -port_range {[2:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_arsize} -port_direction {OUT} -port_range {[2:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_awaddr} -port_direction {OUT} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_awburst} -port_direction {OUT} -port_range {[1:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_awcache} -port_direction {OUT} -port_range {[3:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_awid} -port_direction {OUT} -port_range {[3:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_awlen} -port_direction {OUT} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_awlock} -port_direction {OUT} -port_range {[1:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_awprot} -port_direction {OUT} -port_range {[2:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_awsize} -port_direction {OUT} -port_range {[2:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_wdata} -port_direction {OUT} -port_range {[511:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_wstrb} -port_direction {OUT} -port_range {[63:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {data_o} -port_direction {OUT} -port_range {[31:0]}


# Create top level Bus interface Ports
sd_create_bif_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4} -port_bif_vlnv {AMBA:AMBA4:AXI4:r0p0_0} -port_bif_role {mirroredSlave} -port_bif_mapping {\
"AWID:MIRRORED_SLAVE_AXI4_awid" \
"AWADDR:MIRRORED_SLAVE_AXI4_awaddr" \
"AWLEN:MIRRORED_SLAVE_AXI4_awlen" \
"AWSIZE:MIRRORED_SLAVE_AXI4_awsize" \
"AWBURST:MIRRORED_SLAVE_AXI4_awburst" \
"AWLOCK:MIRRORED_SLAVE_AXI4_awlock" \
"AWCACHE:MIRRORED_SLAVE_AXI4_awcache" \
"AWPROT:MIRRORED_SLAVE_AXI4_awprot" \
"AWVALID:MIRRORED_SLAVE_AXI4_awvalid" \
"AWREADY:MIRRORED_SLAVE_AXI4_awready" \
"WDATA:MIRRORED_SLAVE_AXI4_wdata" \
"WSTRB:MIRRORED_SLAVE_AXI4_wstrb" \
"WLAST:MIRRORED_SLAVE_AXI4_wlast" \
"WVALID:MIRRORED_SLAVE_AXI4_wvalid" \
"WREADY:MIRRORED_SLAVE_AXI4_wready" \
"BID:MIRRORED_SLAVE_AXI4_bid" \
"BRESP:MIRRORED_SLAVE_AXI4_bresp" \
"BVALID:MIRRORED_SLAVE_AXI4_bvalid" \
"BREADY:MIRRORED_SLAVE_AXI4_bready" \
"ARID:MIRRORED_SLAVE_AXI4_arid" \
"ARADDR:MIRRORED_SLAVE_AXI4_araddr" \
"ARLEN:MIRRORED_SLAVE_AXI4_arlen" \
"ARSIZE:MIRRORED_SLAVE_AXI4_arsize" \
"ARBURST:MIRRORED_SLAVE_AXI4_arburst" \
"ARLOCK:MIRRORED_SLAVE_AXI4_arlock" \
"ARCACHE:MIRRORED_SLAVE_AXI4_arcache" \
"ARPROT:MIRRORED_SLAVE_AXI4_arprot" \
"ARVALID:MIRRORED_SLAVE_AXI4_arvalid" \
"ARREADY:MIRRORED_SLAVE_AXI4_arready" \
"RID:MIRRORED_SLAVE_AXI4_rid" \
"RDATA:MIRRORED_SLAVE_AXI4_rdata" \
"RRESP:MIRRORED_SLAVE_AXI4_rresp" \
"RLAST:MIRRORED_SLAVE_AXI4_rlast" \
"RVALID:MIRRORED_SLAVE_AXI4_rvalid" \
"RREADY:MIRRORED_SLAVE_AXI4_rready" } 

# Add DDR_AXI4_ARBITER_PF_test instance
sd_instantiate_component -sd_name ${sd_name} -component_name {DDR_AXI4_ARBITER_PF_C0} -instance_name {DDR_AXI4_ARBITER_PF_test}



# Add DDR_Read_test instance
sd_instantiate_component -sd_name ${sd_name} -component_name {DDR_Read_C0} -instance_name {DDR_Read_test}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {DDR_Read_test:h_offset_i} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {DDR_Read_test:v_offset_i} -value {GND}



# Add DDR_Write_test instance
sd_instantiate_component -sd_name ${sd_name} -component_name {DDR_Write_C0} -instance_name {DDR_Write_test}



# Add scalar net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_AXI4_ARBITER_PF_test:ddr_ctrl_ready_i" "ddr_ctrl_ready_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_AXI4_ARBITER_PF_test:reset_i" "DDR_Read_test:reset_i" "DDR_Write_test:ddr_clk_rstn_i" "ddr_clk_rstn_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_AXI4_ARBITER_PF_test:sys_clk_i" "DDR_Read_test:ddr_clk_i" "DDR_Write_test:ddr_clk_i" "ddr_clk_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_READ_frame_start_i" "DDR_Read_test:frame_start_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Read_test:data_valid_o" "data_valid_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Read_test:pixel_clk_i" "DDR_Write_test:pixel_clk_i" "pixel_clk_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Read_test:read_en_i" "read_en_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_WRITE_frame_start_i" "DDR_Write_test:frame_start_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_test:data_valid_i" "data_valid_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_test:rstn_i" "rstn_i" }

# Add bus net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Read_test:data_o" "data_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Read_test:frame_start_addr_i" "DDR_Write_test:display_frame_addr_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Read_test:horz_resl_i" "horz_resl_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Read_test:line_gap_i" "DDR_Write_test:line_gap_i" "line_gap_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_test:data_i" "data_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Write_test:frame_ddr_addr_i" "frame_ddr_addr_i" }

# Add bus interface net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_AXI4_ARBITER_PF_test:MIRRORED_SLAVE_AXI4" "MIRRORED_SLAVE_AXI4" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_AXI4_ARBITER_PF_test:Read_channel_0" "DDR_Read_test:Read_channel" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_AXI4_ARBITER_PF_test:Write_channel_0" "DDR_Write_test:Write_channel" }

# Re-enable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 1
# Save the SmartDesign 
save_smartdesign -sd_name ${sd_name}
# Generate SmartDesign "DDR_READ_WRITE"
generate_component -component_name ${sd_name}
