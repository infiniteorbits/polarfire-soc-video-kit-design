# Microchip Technology Inc.
# Date: 2026-Mar-05 13:52:57
# This file was generated based on the following SDC source files:
#   /home/ahlemzenache/Documents/polarfire-soc-video-kit-reference-design (Copie)/VKPFSOC_H264/constraint/VKPFSOC_TOP_derived_constraints.sdc
#   /home/ahlemzenache/Documents/polarfire-soc-video-kit-reference-design (Copie)/VKPFSOC_H264/constraint/user.sdc
#

create_clock -name {REF_CLK_PAD_P} -period 6.73401 [ get_ports { REF_CLK_PAD_P } ]
create_clock -name {osc_rc2mhz} -period 469.48 [ get_pins { CLOCKS_AND_RESETS_inst_0/PF_OSC_C0_0/PF_OSC_C0_0/I_OSC_2/CLK } ]
create_generated_clock -name {CLOCKS_AND_RESETS_inst_0/PF_CCC_C0_0/PF_CCC_C0_0/pll_inst_0/OUT0} -multiply_by 841751 -divide_by 1000000 -source [ get_pins { CLOCKS_AND_RESETS_inst_0/PF_CCC_C0_0/PF_CCC_C0_0/pll_inst_0/REF_CLK_0 } ] -phase 0 [ get_pins { CLOCKS_AND_RESETS_inst_0/PF_CCC_C0_0/PF_CCC_C0_0/pll_inst_0/OUT0 } ]
create_generated_clock -name {CLOCKS_AND_RESETS_inst_0/PF_CCC_C0_0/PF_CCC_C0_0/pll_inst_0/OUT1} -multiply_by 841751 -divide_by 2500000 -source [ get_pins { CLOCKS_AND_RESETS_inst_0/PF_CCC_C0_0/PF_CCC_C0_0/pll_inst_0/REF_CLK_0 } ] -phase 0 [ get_pins { CLOCKS_AND_RESETS_inst_0/PF_CCC_C0_0/PF_CCC_C0_0/pll_inst_0/OUT1 } ]
set_clock_uncertainty 0.135 [ get_clocks { CLOCKS_AND_RESETS_inst_0/PF_CCC_C0_0/PF_CCC_C0_0/pll_inst_0/OUT0 } ]
set_clock_uncertainty -hold 0 -rise_from [ get_clocks { CLOCKS_AND_RESETS_inst_0/PF_CCC_C0_0/PF_CCC_C0_0/pll_inst_0/OUT0 } ] -rise_to [ get_clocks { CLOCKS_AND_RESETS_inst_0/PF_CCC_C0_0/PF_CCC_C0_0/pll_inst_0/OUT0 } ]
set_clock_uncertainty -hold 0 -fall_from [ get_clocks { CLOCKS_AND_RESETS_inst_0/PF_CCC_C0_0/PF_CCC_C0_0/pll_inst_0/OUT0 } ] -fall_to [ get_clocks { CLOCKS_AND_RESETS_inst_0/PF_CCC_C0_0/PF_CCC_C0_0/pll_inst_0/OUT0 } ]
set_clock_uncertainty 0.135 [ get_clocks { CLOCKS_AND_RESETS_inst_0/PF_CCC_C0_0/PF_CCC_C0_0/pll_inst_0/OUT1 } ]
set_clock_uncertainty -hold 0 -rise_from [ get_clocks { CLOCKS_AND_RESETS_inst_0/PF_CCC_C0_0/PF_CCC_C0_0/pll_inst_0/OUT1 } ] -rise_to [ get_clocks { CLOCKS_AND_RESETS_inst_0/PF_CCC_C0_0/PF_CCC_C0_0/pll_inst_0/OUT1 } ]
set_clock_uncertainty -hold 0 -fall_from [ get_clocks { CLOCKS_AND_RESETS_inst_0/PF_CCC_C0_0/PF_CCC_C0_0/pll_inst_0/OUT1 } ] -fall_to [ get_clocks { CLOCKS_AND_RESETS_inst_0/PF_CCC_C0_0/PF_CCC_C0_0/pll_inst_0/OUT1 } ]
set_clock_uncertainty 0.00150744 [ get_clocks { REF_CLK_PAD_P } ]
set_clock_uncertainty -hold 0 -rise_from [ get_clocks { REF_CLK_PAD_P } ] -rise_to [ get_clocks { REF_CLK_PAD_P } ]
set_clock_uncertainty -hold 0 -fall_from [ get_clocks { REF_CLK_PAD_P } ] -fall_to [ get_clocks { REF_CLK_PAD_P } ]
set_clock_uncertainty 10 [ get_clocks { osc_rc2mhz } ]
set_clock_uncertainty -hold 0 -rise_from [ get_clocks { osc_rc2mhz } ] -rise_to [ get_clocks { osc_rc2mhz } ]
set_clock_uncertainty -hold 0 -fall_from [ get_clocks { osc_rc2mhz } ] -fall_to [ get_clocks { osc_rc2mhz } ]
set_clock_groups -name {clk_grp_fic1} -asynchronous -group [ get_clocks { CLOCKS_AND_RESETS_inst_0/PF_CCC_C0_0/PF_CCC_C0_0/pll_inst_0/OUT0 } ]
set_clock_groups -name {clk_grp_fab_apb} -asynchronous -group [ get_clocks { CLOCKS_AND_RESETS_inst_0/PF_CCC_C0_0/PF_CCC_C0_0/pll_inst_0/OUT1 } ]
set_clock_groups -name {clk_grp_i2c} -asynchronous -group [ get_clocks { osc_rc2mhz } ]
