# Microchip Technology Inc.
# Date: 2026-Apr-28 11:33:33
# This file was generated based on the following SDC source files:
#   /home/ahlemzenache/Documents/polarfire-soc-video-kit-reference-design(READ_WRITE) (Copie)/VKPFSOC_JPEG_WRITE_READ/component/work/PF_CCC_C0/PF_CCC_C0_0/PF_CCC_C0_PF_CCC_C0_0_PF_CCC.sdc
#   /home/ahlemzenache/Documents/polarfire-soc-video-kit-reference-design(READ_WRITE) (Copie)/VKPFSOC_JPEG_WRITE_READ/component/work/PF_CLK_DIV_C0/PF_CLK_DIV_C0_0/PF_CLK_DIV_C0_PF_CLK_DIV_C0_0_PF_CLK_DIV.sdc
#   /home/ahlemzenache/Documents/polarfire-soc-video-kit-reference-design(READ_WRITE) (Copie)/VKPFSOC_JPEG_WRITE_READ/component/work/MSS_VIDEO_KIT_H264/MSS_VIDEO_KIT_H264.sdc
#   /home/ahlemzenache/microchip/Libero_SoC_2025.1/Libero_SoC/Designer/data/aPA5M/cores/constraints/IND/osc_rc2mhz.sdc
# *** Any modifications to this file will be lost if derived constraints is re-run. ***
#

create_clock -name {REF_CLK_PAD_P} -period 6.73401 [ get_ports { REF_CLK_PAD_P } ]
create_clock -name {osc_rc2mhz} -period 469.48 [ get_pins { CLOCKS_AND_RESETS_inst_0/PF_OSC_C0_0/PF_OSC_C0_0/I_OSC_2/CLK } ]
create_generated_clock -name {CLOCKS_AND_RESETS_inst_0/PF_CCC_C0_0/PF_CCC_C0_0/pll_inst_0/OUT0} -multiply_by 841751 -divide_by 1000000 -source [ get_pins { CLOCKS_AND_RESETS_inst_0/PF_CCC_C0_0/PF_CCC_C0_0/pll_inst_0/REF_CLK_0 } ] -phase 0 [ get_pins { CLOCKS_AND_RESETS_inst_0/PF_CCC_C0_0/PF_CCC_C0_0/pll_inst_0/OUT0 } ]
create_generated_clock -name {CLOCKS_AND_RESETS_inst_0/PF_CCC_C0_0/PF_CCC_C0_0/pll_inst_0/OUT1} -multiply_by 841751 -divide_by 2500000 -source [ get_pins { CLOCKS_AND_RESETS_inst_0/PF_CCC_C0_0/PF_CCC_C0_0/pll_inst_0/REF_CLK_0 } ] -phase 0 [ get_pins { CLOCKS_AND_RESETS_inst_0/PF_CCC_C0_0/PF_CCC_C0_0/pll_inst_0/OUT1 } ]
