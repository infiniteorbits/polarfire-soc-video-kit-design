quietly set ACTELLIBNAME PolarFireSoC
quietly set PROJECT_DIR "/home/ahlemzenache/Documents/polarfire-soc-video-kit-reference-design_READ_WRITE/VKPFSOC_JPEG_WRITE_READ"
onerror { quit -f }
onbreak { quit -f }

if {[file exists presynth/_info]} {
   echo "INFO: Simulation library presynth already exists"
} else {
   file delete -force presynth 
   vlib presynth
}
vmap presynth presynth
vmap polarfire "/home/ahlemzenache/microchip/Libero_SoC_2025.1/Libero_SoC/Designer/lib/modelsimpro/precompiled/vlog/polarfire"
vmap PolarFire "/home/ahlemzenache/microchip/Libero_SoC_2025.1/Libero_SoC/Designer/lib/modelsimpro/precompiled/vlog/polarfire"
if {[file exists COREAPB3_LIB/_info]} {
   echo "INFO: Simulation library COREAPB3_LIB already exists"
} else {
   file delete -force COREAPB3_LIB 
   vlib COREAPB3_LIB
}
vmap COREAPB3_LIB "COREAPB3_LIB"

vlog -sv -work presynth "${PROJECT_DIR}/component/Microchip/SolutionCore/DDR_AXI4_ARBITER_PF/2.2.0/RTL/AXI4_M_M_IF.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/Microchip/SolutionCore/DDR_AXI4_ARBITER_PF/2.2.0/RTL/AXI4_S_IF.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/Microchip/SolutionCore/DDR_AXI4_ARBITER_PF/2.2.0/RTL/axi_lbus_corefifo_NstagesSync.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/Microchip/SolutionCore/DDR_AXI4_ARBITER_PF/2.2.0/RTL/axi_lbus_corefifo_grayToBinConv.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/Microchip/SolutionCore/DDR_AXI4_ARBITER_PF/2.2.0/RTL/axi_lbus_corefifo_async.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/Microchip/SolutionCore/DDR_AXI4_ARBITER_PF/2.2.0/RTL/axi_lbus_corefifo_resetSync.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/Microchip/SolutionCore/DDR_AXI4_ARBITER_PF/2.2.0/RTL/axi_lbus_corefifo_sync.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/Microchip/SolutionCore/DDR_AXI4_ARBITER_PF/2.2.0/RTL/axi_lbus_corefifo_fwft.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/Microchip/SolutionCore/DDR_AXI4_ARBITER_PF/2.2.0/RTL/axi_lbus_corefifo_sync_scntr.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/Microchip/SolutionCore/DDR_AXI4_ARBITER_PF/2.2.0/RTL/axi_lbus_LSRAM_top.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/Microchip/SolutionCore/DDR_AXI4_ARBITER_PF/2.2.0/RTL/axi_lbus_ram_wrapper.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/Microchip/SolutionCore/DDR_AXI4_ARBITER_PF/2.2.0/RTL/video_axi_fifo.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/Microchip/SolutionCore/DDR_AXI4_ARBITER_PF/2.2.0/RTL/ddr_rw_arbiter.v"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/Microchip/SolutionCore/DDR_AXI4_ARBITER_PF/2.2.0/RTL/write_mux.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/Microchip/SolutionCore/DDR_AXI4_ARBITER_PF/2.2.0/RTL/request_scheduler.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/Microchip/SolutionCore/DDR_AXI4_ARBITER_PF/2.2.0/RTL/write_demux.vhd"
vlog -sv -work presynth "${PROJECT_DIR}/component/Microchip/SolutionCore/DDR_AXI4_ARBITER_PF/2.2.0/RTL/write_top.v"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/Microchip/SolutionCore/DDR_AXI4_ARBITER_PF/2.2.0/RTL/read_demux.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/component/Microchip/SolutionCore/DDR_AXI4_ARBITER_PF/2.2.0/RTL/read_mux.vhd"
vlog -sv -work presynth "${PROJECT_DIR}/component/Microchip/SolutionCore/DDR_AXI4_ARBITER_PF/2.2.0/RTL/read_top.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/Microchip/SolutionCore/DDR_AXI4_ARBITER_PF/2.2.0/RTL/DDR_AXI4_ARBITER_PF_Native.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/Microchip/SolutionCore/DDR_AXI4_ARBITER_PF/2.2.0/RTL/DDR_AXI4_ARBITER_PF.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/DDR_AXI4_ARBITER_PF_C0/DDR_AXI4_ARBITER_PF_C0.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/Microchip/SolutionCore/DDR_Read/1.2.0/RTL/AXI4S_ddr_read_initiator_IF.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/Microchip/SolutionCore/DDR_Read/1.2.0/RTL/Arbiter_Initiator_Rd_IF.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/Microchip/SolutionCore/DDR_Read/1.2.0/RTL/DDR_read_controller.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/Microchip/SolutionCore/DDR_Read/1.2.0/RTL/data_unpacker.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/Microchip/SolutionCore/DDR_Read/1.2.0/RTL/ram2port_ddr_read.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/Microchip/SolutionCore/DDR_Read/1.2.0/RTL/video_fifo_ddr_read.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/Microchip/SolutionCore/DDR_Read/1.2.0/RTL/synchronizer_circuit_ddr_read.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/Microchip/SolutionCore/DDR_Read/1.2.0/RTL/DDR_Read_Native.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/Microchip/SolutionCore/DDR_Read/1.2.0/RTL/DDR_Read.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/DDR_Read_C0/DDR_Read_C0.v"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/data_packer.vhd"
vlog -sv -work presynth "${PROJECT_DIR}/hdl/ddr_write_controller_enc.v"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/ram2port.vhd"
vcom -2008 -explicit  -work presynth "${PROJECT_DIR}/hdl/video_fifo.vhd"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/DDR_WRITE_JPEG/DDR_WRITE_JPEG.v"
vlog -sv -work presynth "/home/ahlemzenache/Documents/polarfire-soc-video-kit-reference-design_READ_WRITE/script_support/hdl/JPEG_WRITE_READ/apb_wrapper.v"
vlog -sv -work presynth "/home/ahlemzenache/Documents/polarfire-soc-video-kit-reference-design_READ_WRITE/script_support/hdl/JPEG_WRITE_READ/jpeg_control_fsm.v"
vlog -sv -work presynth "/home/ahlemzenache/Documents/polarfire-soc-video-kit-reference-design_READ_WRITE/script_support/hdl/JPEG_WRITE_READ/jls_encoder.v"
vlog -sv -work presynth "${PROJECT_DIR}/hdl/jpeg_top.v"
vlog -sv -work presynth "/home/ahlemzenache/Documents/polarfire-soc-video-kit-reference-design_READ_WRITE/script_support/hdl/JPEG_WRITE_READ/ram8bit_input.v"
vlog -sv -work presynth "${PROJECT_DIR}/component/work/top_ddr_write_read/top_ddr_write_read.v"
vlog "+incdir+${PROJECT_DIR}/stimulus" -sv -work presynth "${PROJECT_DIR}/stimulus/tb_top.v"

vsim -L polarfire -L presynth -L COREAPB3_LIB  -t 1ps -pli /home/ahlemzenache/microchip/Libero_SoC_2025.1/Libero_SoC/Designer/lib/modelsimpro/pli/pf_crypto_lin_me_pli.so presynth.tb_top_system
add wave /tb_top_system/*
run 1000ns
log /tb_top_system/*
exit
