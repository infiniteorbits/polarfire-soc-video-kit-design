# Creating SmartDesign "top_ddr_write_read"
set sd_name {top_ddr_write_read}
create_smartdesign -sd_name ${sd_name}

# Disable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 0

# Create top level Scalar Ports
sd_create_scalar_port -sd_name ${sd_name} -port_name {APBslave_psel} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {APBslave_pwrite} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_arready_0} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_awready_0} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_bvalid_0} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_rlast_0} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_rvalid_0} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_wready_0} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {apb_pin} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {ddr_ctrl_ready_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {pclk} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {presetn} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {read_en_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {reset_i} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {sys_clk_i} -port_direction {IN}

sd_create_scalar_port -sd_name ${sd_name} -port_name {APBslave_pready} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {APBslave_pslverr} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_arvalid_0} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_awvalid_0} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_bready_0} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_rready_0} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_wlast_0} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_wvalid_0} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {frm_interrupt_o} -port_direction {OUT}


# Create top level Bus Ports
sd_create_bus_port -sd_name ${sd_name} -port_name {APBslave_paddr} -port_direction {IN} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {APBslave_pwdata} -port_direction {IN} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_bid_0} -port_direction {IN} -port_range {[3:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_bresp_0} -port_direction {IN} -port_range {[1:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_rdata_0} -port_direction {IN} -port_range {[63:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_rid_0} -port_direction {IN} -port_range {[3:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_rresp_0} -port_direction {IN} -port_range {[1:0]}

sd_create_bus_port -sd_name ${sd_name} -port_name {APBslave_prdata} -port_direction {OUT} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_araddr_0} -port_direction {OUT} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_arburst_0} -port_direction {OUT} -port_range {[1:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_arcache_0} -port_direction {OUT} -port_range {[3:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_arid_0} -port_direction {OUT} -port_range {[3:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_arlen_0} -port_direction {OUT} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_arlock_0} -port_direction {OUT} -port_range {[1:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_arprot_0} -port_direction {OUT} -port_range {[2:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_arsize_0} -port_direction {OUT} -port_range {[2:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_awaddr_0} -port_direction {OUT} -port_range {[31:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_awburst_0} -port_direction {OUT} -port_range {[1:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_awcache_0} -port_direction {OUT} -port_range {[3:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_awid_0} -port_direction {OUT} -port_range {[3:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_awlen_0} -port_direction {OUT} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_awlock_0} -port_direction {OUT} -port_range {[1:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_awprot_0} -port_direction {OUT} -port_range {[2:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_awsize_0} -port_direction {OUT} -port_range {[2:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_wdata_0} -port_direction {OUT} -port_range {[63:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4_wstrb_0} -port_direction {OUT} -port_range {[7:0]}


# Create top level Bus interface Ports
sd_create_bif_port -sd_name ${sd_name} -port_name {APBslave} -port_bif_vlnv {AMBA:AMBA2:APB:r0p0} -port_bif_role {slave} -port_bif_mapping {\
"PADDR:APBslave_paddr" \
"PSELx:APBslave_psel" \
"PWRITE:APBslave_pwrite" \
"PRDATA:APBslave_prdata" \
"PWDATA:APBslave_pwdata" \
"PREADY:APBslave_pready" \
"PSLVERR:APBslave_pslverr" } 

sd_create_bif_port -sd_name ${sd_name} -port_name {MIRRORED_SLAVE_AXI4} -port_bif_vlnv {AMBA:AMBA4:AXI4:r0p0_0} -port_bif_role {mirroredSlave} -port_bif_mapping {\
"AWID:MIRRORED_SLAVE_AXI4_awid_0" \
"AWADDR:MIRRORED_SLAVE_AXI4_awaddr_0" \
"AWLEN:MIRRORED_SLAVE_AXI4_awlen_0" \
"AWSIZE:MIRRORED_SLAVE_AXI4_awsize_0" \
"AWBURST:MIRRORED_SLAVE_AXI4_awburst_0" \
"AWLOCK:MIRRORED_SLAVE_AXI4_awlock_0" \
"AWCACHE:MIRRORED_SLAVE_AXI4_awcache_0" \
"AWPROT:MIRRORED_SLAVE_AXI4_awprot_0" \
"AWVALID:MIRRORED_SLAVE_AXI4_awvalid_0" \
"AWREADY:MIRRORED_SLAVE_AXI4_awready_0" \
"WDATA:MIRRORED_SLAVE_AXI4_wdata_0" \
"WSTRB:MIRRORED_SLAVE_AXI4_wstrb_0" \
"WLAST:MIRRORED_SLAVE_AXI4_wlast_0" \
"WVALID:MIRRORED_SLAVE_AXI4_wvalid_0" \
"WREADY:MIRRORED_SLAVE_AXI4_wready_0" \
"BID:MIRRORED_SLAVE_AXI4_bid_0" \
"BRESP:MIRRORED_SLAVE_AXI4_bresp_0" \
"BVALID:MIRRORED_SLAVE_AXI4_bvalid_0" \
"BREADY:MIRRORED_SLAVE_AXI4_bready_0" \
"ARID:MIRRORED_SLAVE_AXI4_arid_0" \
"ARADDR:MIRRORED_SLAVE_AXI4_araddr_0" \
"ARLEN:MIRRORED_SLAVE_AXI4_arlen_0" \
"ARSIZE:MIRRORED_SLAVE_AXI4_arsize_0" \
"ARBURST:MIRRORED_SLAVE_AXI4_arburst_0" \
"ARLOCK:MIRRORED_SLAVE_AXI4_arlock_0" \
"ARCACHE:MIRRORED_SLAVE_AXI4_arcache_0" \
"ARPROT:MIRRORED_SLAVE_AXI4_arprot_0" \
"ARVALID:MIRRORED_SLAVE_AXI4_arvalid_0" \
"ARREADY:MIRRORED_SLAVE_AXI4_arready_0" \
"RID:MIRRORED_SLAVE_AXI4_rid_0" \
"RDATA:MIRRORED_SLAVE_AXI4_rdata_0" \
"RRESP:MIRRORED_SLAVE_AXI4_rresp_0" \
"RLAST:MIRRORED_SLAVE_AXI4_rlast_0" \
"RVALID:MIRRORED_SLAVE_AXI4_rvalid_0" \
"RREADY:MIRRORED_SLAVE_AXI4_rready_0" } 

# Add DDR_AXI4_ARBITER_PF_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {DDR_AXI4_ARBITER_PF_C0} -instance_name {DDR_AXI4_ARBITER_PF_C0_0}
sd_create_pin_group -sd_name ${sd_name} -group_name {read_channel} -instance_name {DDR_AXI4_ARBITER_PF_C0_0} -pin_names {"r0_rstart_addr_i" "r0_ack_o" "r0_data_valid_o" "r0_done_o" "rdata_o" "r0_burst_size_i" "r0_req_i" }
sd_create_pin_group -sd_name ${sd_name} -group_name {write_channel} -instance_name {DDR_AXI4_ARBITER_PF_C0_0} -pin_names {"w0_burst_size_i" "w0_data_i" "w0_data_valid_i" "w0_req_i" "w0_wstart_addr_i" "w0_done_o" "w0_ack_o" }



# Add DDR_Read_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {DDR_Read_C0} -instance_name {DDR_Read_C0_0}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {DDR_Read_C0_0:line_gap_i} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {DDR_Read_C0_0:horz_resl_i} -value {0000000000000101}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {DDR_Read_C0_0:h_offset_i} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {DDR_Read_C0_0:v_offset_i} -value {GND}



# Add DDR_WRITE_JPEG_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {DDR_WRITE_JPEG} -instance_name {DDR_WRITE_JPEG_0}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {DDR_WRITE_JPEG_0:frame_ddr_addr_i} -value {0000000000}



# Add jpeg_top_1 instance
sd_instantiate_hdl_core -sd_name ${sd_name} -hdl_core_name {jpeg_top} -instance_name {jpeg_top_1}
# Exporting Parameters of instance jpeg_top_1
sd_configure_core_instance -sd_name ${sd_name} -instance_name {jpeg_top_1} -params {\
"ADDR_WIDTH:8" }\
-validate_rules 0
sd_save_core_instance_config -sd_name ${sd_name} -instance_name {jpeg_top_1}
sd_update_instance -sd_name ${sd_name} -instance_name {jpeg_top_1}



# Add ram8bit_input_0 instance
sd_instantiate_hdl_module -sd_name ${sd_name} -hdl_module_name {ram8bit_input} -hdl_file {/home/ahlemzenache/Documents/polarfire-soc-video-kit-reference-design(READ_WRITE)/script_support/hdl/JPEG_WRITE_READ/ram8bit_input.v} -instance_name {ram8bit_input_0}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {ram8bit_input_0:addr} -value {GND}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {ram8bit_input_0:dout}



# Add scalar net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_AXI4_ARBITER_PF_C0_0:ddr_ctrl_ready_i" "ddr_ctrl_ready_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_AXI4_ARBITER_PF_C0_0:r0_ack_o" "DDR_Read_C0_0:read_ackn_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_AXI4_ARBITER_PF_C0_0:r0_data_valid_o" "DDR_Read_C0_0:ddr_data_valid_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_AXI4_ARBITER_PF_C0_0:r0_done_o" "DDR_Read_C0_0:read_done_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_AXI4_ARBITER_PF_C0_0:r0_req_i" "DDR_Read_C0_0:read_req_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_AXI4_ARBITER_PF_C0_0:reset_i" "DDR_Read_C0_0:reset_i" "DDR_WRITE_JPEG_0:reset_i" "jpeg_top_1:resetn" "reset_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_AXI4_ARBITER_PF_C0_0:sys_clk_i" "DDR_Read_C0_0:ddr_clk_i" "DDR_Read_C0_0:pixel_clk_i" "DDR_WRITE_JPEG_0:ddr_clk_i" "DDR_WRITE_JPEG_0:sys_clk_i" "jpeg_top_1:clk_sys" "sys_clk_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_AXI4_ARBITER_PF_C0_0:w0_ack_o" "DDR_WRITE_JPEG_0:write_ackn_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_AXI4_ARBITER_PF_C0_0:w0_data_valid_i" "DDR_WRITE_JPEG_0:rdata_rdy_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_AXI4_ARBITER_PF_C0_0:w0_done_o" "DDR_WRITE_JPEG_0:write_done_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_AXI4_ARBITER_PF_C0_0:w0_req_i" "DDR_WRITE_JPEG_0:write_req_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Read_C0_0:data_valid_o" "jpeg_top_1:ram_data_valid" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Read_C0_0:frame_start_i" "jpeg_top_1:sof_flag" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Read_C0_0:read_en_i" "read_en_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_WRITE_JPEG_0:data_valid_i" "jpeg_top_1:o_e_pck" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_WRITE_JPEG_0:frame_end_i" "jpeg_top_1:eof_flag" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_WRITE_JPEG_0:frm_interrupt_o" "frm_interrupt_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_WRITE_JPEG_0:encoder_en_i" "jpeg_top_1:encoder_active_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"apb_pin" "jpeg_top_1:apb_pin" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"jpeg_top_1:pclk" "pclk" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"jpeg_top_1:presetn" "presetn" }

# Add bus net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_AXI4_ARBITER_PF_C0_0:r0_burst_size_i" "DDR_Read_C0_0:burst_size_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_AXI4_ARBITER_PF_C0_0:r0_rstart_addr_i" "DDR_Read_C0_0:read_start_addr_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_AXI4_ARBITER_PF_C0_0:rdata_o" "DDR_Read_C0_0:wdata_i" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_AXI4_ARBITER_PF_C0_0:w0_burst_size_i" "DDR_WRITE_JPEG_0:write_length_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_AXI4_ARBITER_PF_C0_0:w0_data_i" "DDR_WRITE_JPEG_0:rdata_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_AXI4_ARBITER_PF_C0_0:w0_wstart_addr_i" "DDR_WRITE_JPEG_0:write_start_addr_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Read_C0_0:data_o" "jpeg_top_1:ram_read_data" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_Read_C0_0:frame_start_addr_i" "jpeg_top_1:ram_read_addr" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_WRITE_JPEG_0:data_i" "jpeg_top_1:o_data_pck" }

# Add bus interface net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"APBslave" "jpeg_top_1:APBslave" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DDR_AXI4_ARBITER_PF_C0_0:MIRRORED_SLAVE_AXI4" "MIRRORED_SLAVE_AXI4" }

# Re-enable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 1
# Save the SmartDesign 
save_smartdesign -sd_name ${sd_name}
# Generate SmartDesign "top_ddr_write_read"
generate_component -component_name ${sd_name}
