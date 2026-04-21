# Written by Synplify Pro version map202309act, Build 395R. Synopsys Run ID: sid1772714878 
# Top Level Design Parameters 

# Clocks 
create_clock -period 6.734 -waveform {0.000 3.367} -name {REF_CLK_PAD_P} [get_ports {REF_CLK_PAD_P}] 
create_clock -period 469.480 -waveform {0.000 234.740} -name {osc_rc2mhz} [get_pins {CLOCKS_AND_RESETS_inst_0/PF_OSC_C0_0/PF_OSC_C0_0/I_OSC_2/CLK}] 

# Virtual Clocks 

# Generated Clocks 
create_generated_clock -name {CLOCKS_AND_RESETS_inst_0/PF_CCC_C0_0/PF_CCC_C0_0/pll_inst_0/OUT0} -multiply_by {841751} -divide_by {1000000} -source [get_pins {CLOCKS_AND_RESETS_inst_0/PF_CCC_C0_0/PF_CCC_C0_0/pll_inst_0/REF_CLK_0}]  [get_pins {CLOCKS_AND_RESETS_inst_0/PF_CCC_C0_0/PF_CCC_C0_0/pll_inst_0/OUT0}] 
create_generated_clock -name {CLOCKS_AND_RESETS_inst_0/PF_CCC_C0_0/PF_CCC_C0_0/pll_inst_0/OUT1} -multiply_by {841751} -divide_by {2500000} -source [get_pins {CLOCKS_AND_RESETS_inst_0/PF_CCC_C0_0/PF_CCC_C0_0/pll_inst_0/REF_CLK_0}]  [get_pins {CLOCKS_AND_RESETS_inst_0/PF_CCC_C0_0/PF_CCC_C0_0/pll_inst_0/OUT1}] 

# Paths Between Clocks 

# Multicycle Constraints 

# Point-to-point Delay Constraints 

# False Path Constraints 

# Output Load Constraints 

# Driving Cell Constraints 

# Input Delay Constraints 

# Output Delay Constraints 

# Wire Loads 

# Other Constraints 

# syn_hier Attributes 

# set_case Attributes 

# Clock Delay Constraints 

# syn_mode Attributes 

# Cells 

# Port DRC Rules 

# Input Transition Constraints 

# Unused constraints (intentionally commented out) 


# Non-forward-annotatable constraints (intentionally commented out) 

# Block Path constraints 

