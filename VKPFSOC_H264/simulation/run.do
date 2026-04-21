quietly set ACTELLIBNAME PolarFireSoC
quietly set PROJECT_DIR "/home/ahlemzenache/Documents/polarfire-soc-video-kit-reference-design (Copie)/VKPFSOC_H264"
quietly set ROOTDIR_DDR_Read_C0 "/home/ahlemzenache/Documents/polarfire-soc-video-kit-reference-design (Copie)/VKPFSOC_H264/component/work/DDR_Read_C0"
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
if {[file exists CORERXIODBITALIGN_LIB/_info]} {
   echo "INFO: Simulation library CORERXIODBITALIGN_LIB already exists"
} else {
   file delete -force CORERXIODBITALIGN_LIB 
   vlib CORERXIODBITALIGN_LIB
}
vmap CORERXIODBITALIGN_LIB "CORERXIODBITALIGN_LIB"

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
vlog "+incdir+${PROJECT_DIR}/stimulus" -sv -work presynth "${PROJECT_DIR}/stimulus/tb_ddr_read_ip.v"

vsim -L polarfire -L presynth -L COREAPB3_LIB -L CORERXIODBITALIGN_LIB  -t 1ps -pli /home/ahlemzenache/microchip/Libero_SoC_2025.1/Libero_SoC/Designer/lib/modelsimpro/pli/pf_crypto_lin_me_pli.so presynth.tb_ddr_read_ip
add wave /tb_ddr_read_ip/*
run 1000ns
log /tb_ddr_read_ip/*
exit
