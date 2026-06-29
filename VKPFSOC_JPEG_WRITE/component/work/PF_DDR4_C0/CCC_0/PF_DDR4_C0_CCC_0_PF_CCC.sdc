set_component PF_DDR4_C0_CCC_0_PF_CCC
# Microchip Technology Inc.
# Date: 2026-Jun-29 10:00:03
#

# Base clock for PLL #0
create_clock -period 9.00009 [ get_pins { pll_inst_0/REF_CLK_0 } ]
create_generated_clock -multiply_by 6 -source [ get_pins { pll_inst_0/REF_CLK_0 } ] -phase 0 [ get_pins { pll_inst_0/OUT0 } ]
create_generated_clock -multiply_by 3 -divide_by 2 -source [ get_pins { pll_inst_0/REF_CLK_0 } ] -phase 0 [ get_pins { pll_inst_0/OUT1 } ]
create_generated_clock -multiply_by 6 -source [ get_pins { pll_inst_0/REF_CLK_0 } ] -phase 0 [ get_pins { pll_inst_0/OUT2 } ]
create_generated_clock -multiply_by 6 -source [ get_pins { pll_inst_0/REF_CLK_0 } ] -phase 0 [ get_pins { pll_inst_0/OUT3 } ]
