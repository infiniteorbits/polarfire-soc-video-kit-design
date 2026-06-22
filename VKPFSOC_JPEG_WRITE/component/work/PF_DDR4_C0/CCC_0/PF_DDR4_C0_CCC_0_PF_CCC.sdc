set_component PF_DDR4_C0_CCC_0_PF_CCC
# Microchip Technology Inc.
# Date: 2026-Jun-22 13:35:41
#

# Base clock for PLL #0
create_clock -period 5 [ get_pins { pll_inst_0/REF_CLK_0 } ]
create_generated_clock -multiply_by 4 -source [ get_pins { pll_inst_0/REF_CLK_0 } ] -phase 0 [ get_pins { pll_inst_0/OUT0 } ]
create_generated_clock -divide_by 1 -source [ get_pins { pll_inst_0/REF_CLK_0 } ] -phase 0 [ get_pins { pll_inst_0/OUT1 } ]
create_generated_clock -multiply_by 4 -source [ get_pins { pll_inst_0/REF_CLK_0 } ] -phase 0 [ get_pins { pll_inst_0/OUT2 } ]
create_generated_clock -multiply_by 4 -source [ get_pins { pll_inst_0/REF_CLK_0 } ] -phase 0 [ get_pins { pll_inst_0/OUT3 } ]
