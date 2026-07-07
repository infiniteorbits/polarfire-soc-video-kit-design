//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Tue Jun 23 14:30:39 2026
// Version: 2025.1 2025.1.0.14
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

//////////////////////////////////////////////////////////////////////
// Component Description (Tcl) 
//////////////////////////////////////////////////////////////////////
/*
# Exporting Component Description of CLK_GEN_C1 to TCL
# Family: PolarFireSoC
# Part Number: MPFS250TS-1FCG1152I
# Create and Configure the core component CLK_GEN_C1
create_and_configure_core -core_vlnv {Actel:Simulation:CLK_GEN:1.0.1} -component_name {CLK_GEN_C1} -params {\
"CLK_PERIOD:20000"  \
"DUTY_CYCLE:50"   }
# Exporting Component Description of CLK_GEN_C1 to TCL done
*/

// CLK_GEN_C1
module CLK_GEN_C1(
    // Outputs
    CLK
);

//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output CLK;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire   CLK_net_0;
wire   CLK_net_1;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign CLK_net_1 = CLK_net_0;
assign CLK       = CLK_net_1;
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------CLK_GEN   -   Actel:Simulation:CLK_GEN:1.0.1
CLK_GEN #( 
        .CLK_PERIOD ( 20000 ),
        .DUTY_CYCLE ( 50 ) )
CLK_GEN_C1_0(
        // Outputs
        .CLK ( CLK_net_0 ) 
        );


endmodule
