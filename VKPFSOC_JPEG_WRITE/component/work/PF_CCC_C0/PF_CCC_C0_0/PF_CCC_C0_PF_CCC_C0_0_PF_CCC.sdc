set_component PF_CCC_C0_PF_CCC_C0_0_PF_CCC
# Microchip Technology Inc.
# Date: 2026-Jun-23 13:37:44
#

# Base clock for PLL #0
create_clock -period 6.73401 [ get_pins { pll_inst_0/REF_CLK_0 } ]
create_generated_clock -multiply_by 2693603 -divide_by 3200000 -source [ get_pins { pll_inst_0/REF_CLK_0 } ] -phase 0 [ get_pins { pll_inst_0/OUT0 } ]
create_generated_clock -multiply_by 2693603 -divide_by 8000000 -source [ get_pins { pll_inst_0/REF_CLK_0 } ] -phase 0 [ get_pins { pll_inst_0/OUT1 } ]
create_generated_clock -multiply_by 2693603 -divide_by 3600000 -source [ get_pins { pll_inst_0/REF_CLK_0 } ] -phase 0 [ get_pins { pll_inst_0/OUT2 } ]
