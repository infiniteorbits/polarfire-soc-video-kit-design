//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Tue Jun 30 14:58:16 2026
// Version: 2025.1 2025.1.0.14
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

//////////////////////////////////////////////////////////////////////
// Component Description (Tcl) 
//////////////////////////////////////////////////////////////////////
/*
# Exporting Component Description of CLK_GEN_C2 to TCL
# Family: PolarFireSoC
# Part Number: MPFS250TS-1FCG1152I
# Create and Configure the core component CLK_GEN_C2
create_and_configure_core -core_vlnv {Actel:Simulation:CLK_GEN:1.0.1} -component_name {CLK_GEN_C2} -params {\
"CLK_PERIOD:20000"  \
"DUTY_CYCLE:50"   }
# Exporting Component Description of CLK_GEN_C2 to TCL done
*/

// CLK_GEN_C2
module CLK_GEN_C2(
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
CLK_GEN_C2_0(
        // Outputs
        .CLK ( CLK_net_0 ) 
        );


endmodule
